#!/usr/bin/env bash
# Locate, bootstrap, verify, and launch a USB-hosted Local-Hermes-Portable install.
# Works on Linux and macOS. Intended command aliases: sentinel and hermes-usb.

set -Eeuo pipefail

SCRIPT_NAME="$(basename "$0")"
VERSION="3.0.0"
PORTABLE_REPO_URL="${HERMES_PORTABLE_REPO_URL:-https://github.com/techjarves/Local-Hermes-Portable.git}"
PORTABLE_ARCHIVE_URL="${HERMES_PORTABLE_ARCHIVE_URL:-https://github.com/techjarves/Local-Hermes-Portable/archive/refs/heads/main.tar.gz}"
PORTABLE_DIR_NAME="${HERMES_PORTABLE_DIR_NAME:-Local-Hermes-Portable}"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

usage() {
  cat <<'USAGE'
Usage: hermes-portable-usb.sh [options] [-- extra hermes args]

Finds a mounted Local-Hermes-Portable USB on Linux/macOS. If the USB is mounted
but Local-Hermes-Portable is missing, it bootstraps it from:
  https://github.com/techjarves/Local-Hermes-Portable

Then it verifies the portable Hermes launcher, prints the SENTINEL ONLINE /
Welcome Back Sir banner, optionally sends a Telegram health report, and starts
portable Hermes via hermes/launch.sh. That launch.sh performs first-run Hermes
runtime setup inside the portable folder.

Options:
  --find-only                 Print detected Local-Hermes-Portable root and exit.
  --verify-only               Locate/bootstrap and verify, but do not launch Hermes.
  --launcher                  Run platform launcher linux.sh/mac.sh instead of hermes/launch.sh.
  --root PATH                 Use known Local-Hermes-Portable root, or a USB mount root
                              where Local-Hermes-Portable should be installed.
  --target PATH               USB mount root to bootstrap into if portable root is missing.
  --no-bootstrap              Do not clone/download Local-Hermes-Portable when absent.
  --no-telegram               Do not attempt Telegram notification.
  --quiet                     Reduce terminal output.
  -h, --help                  Show this help.

Aliases expected in bash_aliases:
  sentinel
  hermes-usb
  hermesusb       legacy compatibility

Environment:
  HERMES_PORTABLE_ROOT        Known Local-Hermes-Portable root or USB mount root.
  HERMES_USB_TARGET           USB mount root for bootstrapping.
  HERMES_USB_MOUNT_ROOTS      Colon-separated extra mount roots to scan, useful for tests.
  HERMES_PORTABLE_REPO_URL    Override git repo URL.
  HERMES_PORTABLE_ARCHIVE_URL Override fallback tar.gz archive URL.
  HERMES_USB_TELEGRAM_BOT_TOKEN / TELEGRAM_BOT_TOKEN
  HERMES_USB_TELEGRAM_CHAT_ID  / TELEGRAM_CHAT_ID
  HERMES_USB_NOTIFY=0         Disable Telegram notification.

Telegram credentials may also live on the USB in one of:
  .telegram.env, telegram.env, hermes/.env
using TELEGRAM_BOT_TOKEN and TELEGRAM_CHAT_ID style key names.
USAGE
}

log() { [ "${QUIET:-0}" = "1" ] || printf '%b\n' "$*"; }
warn() { printf '%b\n' "${YELLOW}[warn]${NC} $*" >&2; }
fail() { printf '%b\n' "${RED}[error]${NC} $*" >&2; exit 1; }

abs_path() {
  if command -v realpath >/dev/null 2>&1; then
    realpath "$1" 2>/dev/null && return 0
  fi
  if command -v python3 >/dev/null 2>&1; then
    python3 -c 'import os,sys; print(os.path.abspath(sys.argv[1]))' "$1" && return 0
  fi
  if [ -d "$1" ]; then
    (cd "$1" && pwd -P) 2>/dev/null && return 0
  fi
  local dir base resolved
  dir="$(dirname "$1" 2>/dev/null)"
  base="$(basename "$1" 2>/dev/null)"
  if [ -d "$dir" ]; then
    resolved="$(cd "$dir" && pwd -P 2>/dev/null)" && printf '%s/%s\n' "$resolved" "$base" && return 0
  fi
  printf '%s\n' "$1"
}

is_portable_root() {
  local root="$1"
  [ -d "$root" ] || return 1
  { [ -f "$root/linux.sh" ] || [ -f "$root/mac.sh" ]; } || return 1
  [ -d "$root/hermes" ] || return 1
  [ -f "$root/hermes/launch.sh" ] || return 1
}

split_extra_mount_roots() {
  [ -n "${HERMES_USB_MOUNT_ROOTS:-}" ] || return 0
  printf '%s' "$HERMES_USB_MOUNT_ROOTS" | tr ':' '\n' | awk 'NF'
}

lsblk_usb_mounts() {
  command -v lsblk >/dev/null 2>&1 || return 1
  lsblk -o MOUNTPOINT,TRAN,TYPE --noheadings --list 2>/dev/null | \
    awk '$2 == "usb" && ($3 == "part" || $3 == "disk") && $1 != "" {print $1}' | sort -u
}

findmnt_usb_mounts() {
  command -v findmnt >/dev/null 2>&1 || return 1
  findmnt -o TARGET,SOURCE --noheadings --list 2>/dev/null | \
    awk '$2 ~ /^\/dev\/(sd|nvme|disk)/ && $1 ~ /^\/(media|mnt|run\/media)/ {print $1}' | sort -u
}

diskutil_usb_mounts() {
  command -v diskutil >/dev/null 2>&1 || return 1
  diskutil list -plist external 2>/dev/null | \
    grep -o '<string>/Volumes/[^<]*</string>' | sed 's/<[^>]*>//g' | sort -u
}

common_mount_roots() {
  [ -n "${USER:-}" ] && printf '/media/%s\n/run/media/%s\n' "$USER" "$USER"
  printf '/media\n/mnt\n/Volumes\n'
}

parent_candidates_from_path() {
  local path="$1" dir
  dir="$(abs_path "$path")"
  [ -f "$dir" ] && dir="$(dirname "$dir")"
  while [ "$dir" != "/" ] && [ -n "$dir" ]; do
    printf '%s\n' "$dir"
    dir="$(dirname "$dir")"
  done
}

usb_mount_roots() {
  split_extra_mount_roots
  [ -n "${HERMES_USB_TARGET:-}" ] && printf '%s\n' "$HERMES_USB_TARGET"
  lsblk_usb_mounts || true
  findmnt_usb_mounts || true
  diskutil_usb_mounts || true

  [ -n "${USER:-}" ] && {
    printf '/media/%s/Samsung USB\n' "$USER"
    printf '/media/%s/SAMSUNG\n' "$USER"
    printf '/media/%s/BAR PLUS\n' "$USER"
    printf '/run/media/%s/Samsung USB\n' "$USER"
    printf '/run/media/%s/SAMSUNG\n' "$USER"
    printf '/run/media/%s/BAR PLUS\n' "$USER"
  }
  printf '/Volumes/Samsung USB\n/Volumes/SAMSUNG\n/Volumes/BAR PLUS\n'
}

candidate_roots_for_existing_install() {
  [ -n "${HERMES_PORTABLE_ROOT:-}" ] && printf '%s\n' "$HERMES_PORTABLE_ROOT"
  [ -n "${PWD:-}" ] && parent_candidates_from_path "$PWD"
  usb_mount_roots
}

portable_root_under() {
  local candidate="$1"
  candidate="${candidate%/}"
  if is_portable_root "$candidate"; then
    abs_path "$candidate"
    return 0
  fi
  if is_portable_root "$candidate/$PORTABLE_DIR_NAME"; then
    abs_path "$candidate/$PORTABLE_DIR_NAME"
    return 0
  fi
  return 1
}

find_portable_root() {
  local candidate found base

  while IFS= read -r candidate; do
    [ -n "$candidate" ] || continue
    [ -e "$candidate" ] || continue
    portable_root_under "$candidate" && return 0
  done < <(candidate_roots_for_existing_install | awk '!seen[$0]++')

  while IFS= read -r base; do
    [ -d "$base" ] || continue
    found="$(find "$base" \
      \( -name .Spotlight-V100 -o -name .Trashes -o -name .fseventsd -o -name .git \) -prune -o \
      -type f \( -name linux.sh -o -name mac.sh \) \
      -path "*/$PORTABLE_DIR_NAME/*" -print 2>/dev/null | head -n 1 || true)"
    if [ -n "$found" ]; then
      portable_root_under "$(dirname "$found")" && return 0
    fi
  done < <(common_mount_roots | awk '!seen[$0]++')

  return 1
}

bootstrap_target_root() {
  local candidate

  if [ -n "${HERMES_USB_TARGET:-}" ]; then
    printf '%s\n' "$HERMES_USB_TARGET"
    return 0
  fi

  if [ -n "${HERMES_PORTABLE_ROOT:-}" ]; then
    if [ "$(basename "${HERMES_PORTABLE_ROOT%/}")" = "$PORTABLE_DIR_NAME" ]; then
      dirname "${HERMES_PORTABLE_ROOT%/}"
    else
      printf '%s\n' "$HERMES_PORTABLE_ROOT"
    fi
    return 0
  fi

  while IFS= read -r candidate; do
    [ -n "$candidate" ] || continue
    [ -d "$candidate" ] || continue
    [ -w "$candidate" ] || continue
    printf '%s\n' "$candidate"
    return 0
  done < <(usb_mount_roots | awk '!seen[$0]++')

  return 1
}

bootstrap_portable_root() {
  [ "${NO_BOOTSTRAP:-0}" = "1" ] && return 1

  local target install_dir tmp_archive extracted
  target="$(bootstrap_target_root)" || return 1
  target="$(abs_path "$target")"
  [ -d "$target" ] || fail "Bootstrap target is not a directory: $target"
  [ -w "$target" ] || fail "Bootstrap target is not writable: $target"

  if [ "$(basename "${target%/}")" = "$PORTABLE_DIR_NAME" ]; then
    install_dir="$target"
  else
    install_dir="$target/$PORTABLE_DIR_NAME"
  fi

  if [ -e "$install_dir" ] && ! is_portable_root "$install_dir"; then
    fail "Refusing to overwrite existing non-portable path: $install_dir"
  fi
  if is_portable_root "$install_dir"; then
    abs_path "$install_dir"
    return 0
  fi

  printf '%b\n' "${YELLOW}[setup]${NC} Local-Hermes-Portable not found; installing into $install_dir" >&2

  if command -v git >/dev/null 2>&1; then
    git clone --depth 1 "$PORTABLE_REPO_URL" "$install_dir"
  elif command -v curl >/dev/null 2>&1 && command -v tar >/dev/null 2>&1; then
    tmp_archive="$(mktemp)"
    curl -fsSL "$PORTABLE_ARCHIVE_URL" -o "$tmp_archive"
    mkdir -p "$install_dir"
    tar -xzf "$tmp_archive" -C "$install_dir" --strip-components=1
    rm -f "$tmp_archive"
  else
    fail "Need git, or curl+tar, to install Local-Hermes-Portable. Install one of those or pre-load the USB."
  fi

  is_portable_root "$install_dir" || fail "Install completed but $install_dir does not look like Local-Hermes-Portable."
  abs_path "$install_dir"
}

platform_launcher() {
  local root="$1"
  case "$(uname -s 2>/dev/null || printf unknown)" in
    Darwin*) [ -f "$root/mac.sh" ] && printf '%s\n' "$root/mac.sh" && return 0 ;;
    Linux*) [ -f "$root/linux.sh" ] && printf '%s\n' "$root/linux.sh" && return 0 ;;
  esac
  [ -f "$root/linux.sh" ] && printf '%s\n' "$root/linux.sh" && return 0
  [ -f "$root/mac.sh" ] && printf '%s\n' "$root/mac.sh" && return 0
  return 1
}

ensure_executable_bits() {
  local root="$1"
  chmod +x "$root/linux.sh" "$root/mac.sh" "$root/hermes/launch.sh" 2>/dev/null || true
}

load_telegram_env() {
  local root="$1" env_file line key value
  for env_file in "$root/.telegram.env" "$root/telegram.env" "$root/hermes/.env"; do
    [ -f "$env_file" ] || continue
    while IFS= read -r line || [ -n "$line" ]; do
      case "$line" in ''|'#'*) continue ;; esac
      key="${line%%=*}"
      value="${line#*=}"
      value="${value%\"}"; value="${value#\"}"
      value="${value%\'}"; value="${value#\'}"
      case "$key" in
        HERMES_USB_TELEGRAM_BOT_TOKEN|TELEGRAM_BOT_TOKEN|TELEGRAM_TOKEN)
          TELEGRAM_TOKEN="${TELEGRAM_TOKEN:-$value}"
          ;;
        HERMES_USB_TELEGRAM_CHAT_ID|TELEGRAM_CHAT_ID)
          TELEGRAM_CHAT="${TELEGRAM_CHAT:-$value}"
          ;;
      esac
    done < "$env_file"
  done
}

health_report() {
  local root="$1" launcher="$2" os host arch uptime_text disk_text usb_disk mem_text ip_text ready_flag config_file
  os="$(uname -s 2>/dev/null || printf unknown)"
  host="$(hostname 2>/dev/null || scutil --get ComputerName 2>/dev/null || printf unknown)"
  arch="$(uname -m 2>/dev/null || printf unknown)"
  uptime_text="$(uptime 2>/dev/null | sed 's/^ *//' || printf unknown)"
  disk_text="$(df -h / 2>/dev/null | awk 'NR==2 {print $4 " free on / (" $5 " used)"}' || printf unknown)"
  usb_disk="$(df -h "$root" 2>/dev/null | awk 'NR==2 {print $4 " free on USB (" $5 " used)"}' || printf unknown)"
  if command -v free >/dev/null 2>&1; then
    mem_text="$(free -h | awk '/^Mem:/ {print $7 " available / " $2 " total"}')"
  elif command -v vm_stat >/dev/null 2>&1; then
    mem_text="$(vm_stat | awk '/Pages free/ {gsub("\\.","",$3); print $3 " pages free"}')"
  else
    mem_text="unknown"
  fi
  ip_text="$( (hostname -I 2>/dev/null || ipconfig getifaddr en0 2>/dev/null || ipconfig getifaddr en1 2>/dev/null || printf unknown) | awk '{print $1}' )"
  ready_flag="$(find "$root/hermes/.cache/runtimes" -name ready.flag -print 2>/dev/null | head -n 1 || true)"
  config_file="$root/hermes/data/config.yaml"

  cat <<REPORT
SENTINEL ONLINE
Welcome Back Sir

Portable Hermes health status:
- Host: $host
- OS/Arch: $os $arch
- Local IP: $ip_text
- Uptime: $uptime_text
- Memory: $mem_text
- Disk: $disk_text
- USB: $usb_disk
- Portable root: $root
- Platform launcher: $launcher
- Hermes launch.sh: $([ -f "$root/hermes/launch.sh" ] && printf present || printf missing)
- Hermes config: $([ -f "$config_file" ] && printf present || printf missing)
- Runtime ready flag: $([ -n "$ready_flag" ] && printf 'present (%s)' "$ready_flag" || printf 'not built yet')
REPORT
}

print_banner() {
  [ "${QUIET:-0}" = "1" ] && return 0
  printf '%b\n' "${PURPLE}╔════════════════════════════════════════════════════════════╗${NC}"
  printf '%b\n' "${PURPLE}║${NC} ${BOLD}${CYAN}███████╗███████╗███╗   ██╗████████╗██╗███╗   ██╗███████╗██╗${NC} ${PURPLE}║${NC}"
  printf '%b\n' "${PURPLE}║${NC} ${BOLD}${CYAN}██╔════╝██╔════╝████╗  ██║╚══██╔══╝██║████╗  ██║██╔════╝██║${NC} ${PURPLE}║${NC}"
  printf '%b\n' "${PURPLE}║${NC} ${BOLD}${CYAN}███████╗█████╗  ██╔██╗ ██║   ██║   ██║██╔██╗ ██║█████╗  ██║${NC} ${PURPLE}║${NC}"
  printf '%b\n' "${PURPLE}║${NC} ${BOLD}${CYAN}╚════██║██╔══╝  ██║╚██╗██║   ██║   ██║██║╚██╗██║██╔══╝  ██║${NC} ${PURPLE}║${NC}"
  printf '%b\n' "${PURPLE}║${NC} ${BOLD}${CYAN}███████║███████╗██║ ╚████║   ██║   ██║██║ ╚████║███████╗███████╗${NC}"
  printf '%b\n' "${PURPLE}╚════════════════════════════════════════════════════════════╝${NC}"
  printf '%b\n' "${BOLD}${GREEN}SENTINEL ONLINE${NC}"
  printf '%b\n' "${BOLD}${CYAN}Welcome Back Sir${NC}"
}

send_telegram() {
  local root="$1" message="$2" token chat api_url
  [ "${NO_TELEGRAM:-0}" = "1" ] && return 0
  [ "${HERMES_USB_NOTIFY:-1}" = "0" ] && return 0
  command -v curl >/dev/null 2>&1 || { warn "curl not found; skipping Telegram notification."; return 0; }

  TELEGRAM_TOKEN="${HERMES_USB_TELEGRAM_BOT_TOKEN:-${TELEGRAM_BOT_TOKEN:-${TELEGRAM_TOKEN:-}}}"
  TELEGRAM_CHAT="${HERMES_USB_TELEGRAM_CHAT_ID:-${TELEGRAM_CHAT_ID:-${TELEGRAM_CHAT:-}}}"
  load_telegram_env "$root"
  token="$TELEGRAM_TOKEN"
  chat="$TELEGRAM_CHAT"

  if [ -z "$token" ] || [ -z "$chat" ]; then
    warn "Telegram credentials not found; set HERMES_USB_TELEGRAM_BOT_TOKEN and HERMES_USB_TELEGRAM_CHAT_ID or add .telegram.env on the USB."
    return 0
  fi

  api_url="https://api.telegram.org/bot${token}/sendMessage"
  if curl -fsS -X POST "$api_url" --data-urlencode "chat_id=$chat" --data-urlencode "text=$message" >/dev/null; then
    log "${GREEN}[ok]${NC} Telegram health report sent."
  else
    warn "Telegram notification failed. Hermes launch will continue."
  fi
}

VERIFY_ONLY=0
FIND_ONLY=0
USE_PLATFORM_LAUNCHER=0
NO_TELEGRAM=0
NO_BOOTSTRAP=0
QUIET=0
ROOT_ARG=""
EXTRA_ARGS=()

while [ $# -gt 0 ]; do
  case "$1" in
    --find-only) FIND_ONLY=1 ;;
    --verify-only) VERIFY_ONLY=1 ;;
    --launcher|--platform-launcher|--platform-setup) USE_PLATFORM_LAUNCHER=1 ;;
    --root) shift; ROOT_ARG="${1:-}" ;;
    --target) shift; HERMES_USB_TARGET="${1:-}" ;;
    --no-bootstrap) NO_BOOTSTRAP=1 ;;
    --no-telegram) NO_TELEGRAM=1 ;;
    --quiet) QUIET=1 ;;
    -h|--help) usage; exit 0 ;;
    --version) printf '%s %s\n' "$SCRIPT_NAME" "$VERSION"; exit 0 ;;
    --) shift; EXTRA_ARGS=("$@"); break ;;
    *) EXTRA_ARGS+=("$1") ;;
  esac
  shift || true
done

if [ -n "$ROOT_ARG" ]; then
  HERMES_PORTABLE_ROOT="$ROOT_ARG"
fi

ROOT="$(find_portable_root || bootstrap_portable_root)" || fail "Local-Hermes-Portable was not found and could not be bootstrapped. Plug in the USB, pass --root/--target, or pre-load the drive."
[ "$FIND_ONLY" = "1" ] && { printf '%s\n' "$ROOT"; exit 0; }

is_portable_root "$ROOT" || fail "Detected path is not a valid Local-Hermes-Portable root: $ROOT"
ensure_executable_bits "$ROOT"
LAUNCHER="$(platform_launcher "$ROOT")" || fail "No linux.sh/mac.sh launcher found under $ROOT"
HERMES_LAUNCH="$ROOT/hermes/launch.sh"
[ -f "$HERMES_LAUNCH" ] || fail "Hermes launcher missing: $HERMES_LAUNCH"

print_banner
REPORT="$(health_report "$ROOT" "$LAUNCHER")"
log "${BLUE}$REPORT${NC}"
send_telegram "$ROOT" "$REPORT"

if [ "$VERIFY_ONLY" = "1" ]; then
  log "${GREEN}[ok]${NC} Verification complete; launch skipped because --verify-only was set."
  exit 0
fi

if [ "$USE_PLATFORM_LAUNCHER" = "1" ]; then
  log "${GREEN}[ok]${NC} Starting platform launcher: $LAUNCHER"
  cd "$ROOT"
  exec bash "$LAUNCHER" "${EXTRA_ARGS[@]}"
fi

log "${GREEN}[ok]${NC} Starting portable Hermes: $HERMES_LAUNCH"
cd "$ROOT/hermes"
exec bash "$HERMES_LAUNCH" "${EXTRA_ARGS[@]}"
