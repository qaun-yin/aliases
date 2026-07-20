#!/usr/bin/env bash
# Locate and launch a USB-hosted Local-Hermes-Portable install.
# Designed for Samsung BAR Plus 128GB USB drives, but works with any mounted
# drive containing Local-Hermes-Portable/{linux.sh,mac.sh,hermes/launch.sh}.
#
# v2.0 — Dynamic USB detection via lsblk/findmnt; no longer relies on
# hardcoded drive labels. Works on any Linux or macOS system regardless
# of the USB drive's volume name.

set -Eeuo pipefail

SCRIPT_NAME="$(basename "$0")"
VERSION="2.0.0"

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

Locates a mounted Local-Hermes-Portable USB drive, verifies the portable Hermes
launcher is present, prints a terminal banner, optionally sends a Telegram
health report, then starts portable Hermes.

Options:
  --find-only                 Print the detected Local-Hermes-Portable root and exit.
  --verify-only               Locate and verify, send health report if configured, do not launch.
  --launcher                  Run the platform launcher (linux.sh/mac.sh) instead of hermes/launch.sh.
  --root PATH                 Use a known Local-Hermes-Portable root path.
  --no-telegram               Do not attempt Telegram notification.
  --quiet                     Reduce terminal output.
  -h, --help                  Show this help.

Environment:
  HERMES_PORTABLE_ROOT        Known Local-Hermes-Portable root path.
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
  # realpath is not guaranteed on older macOS; Python is usually available on
  # systems that can run Hermes. Fall back to a physical cd/pwd combination.
  if command -v realpath >/dev/null 2>&1; then
    realpath "$1" 2>/dev/null && return 0
  fi
  if command -v python3 >/dev/null 2>&1; then
    python3 -c 'import os,sys; print(os.path.abspath(sys.argv[1]))' "$1" && return 0
  fi
  if [ -d "$1" ]; then
    (cd "$1" && pwd -P) 2>/dev/null && return 0
  fi
  # Last resort: resolve relative to parent
  local dir
  dir="$(dirname "$1" 2>/dev/null)"
  local base
  base="$(basename "$1" 2>/dev/null)"
  if [ -d "$dir" ]; then
    (cd "$dir" && pwd -P 2>/dev/null) && printf '/%s\n' "$base" && return 0
  fi
  printf '%s\n' "$1"
}

is_portable_root() {
  local root="$1"
  [ -d "$root" ] || return 1
  { [ -f "$root/linux.sh" ] || [ -f "$root/mac.sh" ]; } || return 1
  [ -d "$root/hermes" ] || return 1
}

# --- Dynamic USB mountpoint discovery ---

# Strategy 1: lsblk (Linux) — find mounted USB block devices.
lsblk_usb_mounts() {
  command -v lsblk >/dev/null 2>&1 || return 1
  # TRAN=usb catches USB-attached drives (including NVMe/USB enclosures).
  # TYPE=part ensures we only check partition mountpoints, not the raw disk.
  lsblk -o MOUNTPOINT,TRAN,TYPE --noheadings --list 2>/dev/null | \
    awk '$2 == "usb" && $3 == "part" && $1 != "" {print $1}' | \
    sort -u
}

# Strategy 2: findmnt (Linux) — alternative when lsblk is unavailable.
findmnt_usb_mounts() {
  command -v findmnt >/dev/null 2>&1 || return 1
  # Match mountpoints under /media/ or /mnt/ that are on /dev/sd* or /dev/nvme*
  findmnt -o TARGET,SOURCE --noheadings --list 2>/dev/null | \
    awk '$2 ~ /^\/dev\/(sd|nvme)/ && $1 ~ /^\/(media|mnt|run\/media)/ {print $1}' | \
    sort -u
}

# Strategy 3: diskutil (macOS) — list mounted external volumes.
diskutil_usb_mounts() {
  command -v diskutil >/dev/null 2>&1 || return 1
  diskutil list -plist external 2>/dev/null | \
    grep -o '<string>/Volumes/[^<]*</string>' | \
    sed 's/<[^>]*>//g' | sort -u
}

# Strategy 4: scan common mount roots (fallback for systems without any of the above).
common_mount_roots() {
  [ -n "${USER:-}" ] && printf '/media/%s\n/run/media/%s\n' "$USER" "$USER"
  printf '/media\n/mnt\n/Volumes\n'
}

# --- Core detection ---

candidate_mount_roots() {
  [ -n "${HERMES_PORTABLE_ROOT:-}" ] && printf '%s\n' "$HERMES_PORTABLE_ROOT"
  [ -n "${PWD:-}" ] && parent_candidates_from_path "$PWD"

  # Dynamic USB detection — works regardless of drive label.
  local mounts
  mounts="$(lsblk_usb_mounts || findmnt_usb_mounts || diskutil_usb_mounts || true)"
  if [ -n "$mounts" ]; then
    printf '%s\n' "$mounts"
  fi

  # Static fallback paths (kept for systems without lsblk/findmnt/diskutil).
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

parent_candidates_from_path() {
  local path="$1"
  local dir
  dir="$(abs_path "$path")"
  [ -f "$dir" ] && dir="$(dirname "$dir")"
  while [ "$dir" != "/" ] && [ -n "$dir" ]; do
    printf '%s\n' "$dir"
    dir="$(dirname "$dir")"
  done
}

find_portable_root() {
  local candidate found base

  while IFS= read -r candidate; do
    [ -n "$candidate" ] || continue
    candidate="${candidate%/}"
    [ -e "$candidate" ] || continue

    if is_portable_root "$candidate"; then
      abs_path "$candidate"
      return 0
    fi
    if is_portable_root "$candidate/Local-Hermes-Portable"; then
      abs_path "$candidate/Local-Hermes-Portable"
      return 0
    fi
  done < <(candidate_mount_roots | awk '!seen[$0]++')

  # Last resort: search only removable-media roots, not the whole filesystem.
  # Check both the root directory AND Local-Hermes-Portable subdirectory.
  while IFS= read -r base; do
    [ -d "$base" ] || continue
    found="$(find "$base" \( -name .Spotlight-V100 -o -name .Trashes -o -name .fseventsd \) -prune -o \( -type f \( -name linux.sh -o -name mac.sh \) -path '*/Local-Hermes-Portable/*' -o -type f \( -name linux.sh -o -name mac.sh \) -maxdepth 2 \) -print 2>/dev/null | head -n 1 || true)"
    if [ -n "$found" ]; then
      # Found a launcher script — return its parent directory
      abs_path "$(dirname "$found")"
      return 0
    fi
  done < <(common_mount_roots | awk '!seen[$0]++')

  return 1
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
  local root="$1" launcher="$2" os host arch uptime_text disk_text usb_disk mem_text ip_text
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
- Launcher: $launcher
- Hermes launch.sh: $([ -f "$root/hermes/launch.sh" ] && printf present || printf missing)
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
QUIET=0
ROOT_ARG=""
EXTRA_ARGS=()

while [ $# -gt 0 ]; do
  case "$1" in
    --find-only) FIND_ONLY=1 ;;
    --verify-only) VERIFY_ONLY=1 ;;
    --launcher) USE_PLATFORM_LAUNCHER=1 ;;
    --root) shift; ROOT_ARG="${1:-}" ;;
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

ROOT="$(find_portable_root)" || fail "Local-Hermes-Portable USB root was not found. Plug in the Samsung BAR Plus drive or pass --root PATH."
[ "$FIND_ONLY" = "1" ] && { printf '%s\n' "$ROOT"; exit 0; }

is_portable_root "$ROOT" || fail "Detected path is not a valid Local-Hermes-Portable root: $ROOT"
LAUNCHER="$(platform_launcher "$ROOT")" || fail "No platform launcher found under $ROOT"
HERMES_LAUNCH="$ROOT/hermes/launch.sh"

if [ ! -f "$HERMES_LAUNCH" ]; then
  fail "Hermes launcher missing: $HERMES_LAUNCH"
fi

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
