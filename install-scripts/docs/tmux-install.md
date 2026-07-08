# TMUX Installation Script Documentation

## Overview

This script automates the installation and configuration of TMUX terminal multiplexer using the popular gpakosz/.tmux configuration. It clones the repository and sets up the configuration files for an enhanced TMUX experience.

## Features

- Automated installation of gpakosz/.tmux configuration
- Enhanced TMUX experience with sensible defaults
- Easy setup with minimal user interaction
- Customizable configuration options

## Requirements

- Linux-based system (Ubuntu/Debian, CentOS/RHEL, etc.)
- Git installed
- Internet connectivity
- User home directory access

## Usage

```bash
chmod +x tmux-install.sh
./tmux-install.sh
```

## What the Script Does

1. **Directory Navigation**
   - Changes to the user's home directory

2. **Repository Cloning**
   - Clones the gpakosz/.tmux repository from GitHub
   - Downloads all configuration files and scripts

3. **Configuration Setup**
   - Creates a symbolic link to the main configuration file
   - Copies the local configuration file for customization

## Configuration Files

### .tmux.conf

The main TMUX configuration file that:
- Sets up key bindings
- Configures status bar
- Enables mouse support
- Sets up pane and window management

### .tmux.conf.local

The local configuration file for customization that:
- Allows user-specific settings
- Preserves customizations during updates
- Provides override options for default settings

## Customization Options

After installation, you can customize TMUX by editing `.tmux.conf.local`:

### Key Bindings
```bash
# Change prefix key
unbind C-b
set -g prefix C-a
```

### Status Bar
```bash
# Customize status bar appearance
set -g status-bg colour235
set -g status-fg colour136
```

### Theme
```bash
# Enable powerline theme
set -g @plugin 'sebastienvas/tmux-powerline'
```

## Post-Installation Usage

### Starting TMUX
```bash
tmux
```

### Basic Commands
- **Prefix key**: `Ctrl + b` (default)
- **Create new window**: `Prefix + c`
- **Switch windows**: `Prefix + n` (next) or `Prefix + p` (previous)
- **Split pane horizontally**: `Prefix + "`
- **Split pane vertically**: `Prefix + %`
- **Navigate panes**: `Prefix + arrow keys`

## Troubleshooting

### Git Clone Issues

If the repository fails to clone:
- Check internet connectivity
- Verify Git is installed: `git --version`
- Manually clone the repository:
  ```bash
  git clone https://github.com/gpakosz/.tmux.git
  ```

### Symbolic Link Issues

If the symbolic link fails:
- Check file permissions
- Verify the target directory is the home directory
- Manually create the link:
  ```bash
  ln -s -f .tmux/.tmux.conf .tmux.conf
  ```

### TMUX Not Found

If TMUX is not installed:
- Install TMUX manually:
  ```bash
  # Ubuntu/Debian
  sudo apt-get install tmux
  
  # CentOS/RHEL
  sudo yum install tmux
  ```

## Updating Configuration

To update the gpakosz configuration:
```bash
cd ~/.tmux
git pull origin master
```

## Advanced Configuration

### Plugin Management

The configuration supports TPM (TMUX Plugin Manager):
1. Install TPM:
   ```bash
   git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
   ```
2. Add plugins to `.tmux.conf.local`:
   ```bash
   set -g @plugin 'tmux-plugins/tmux-sensible'
   ```
3. Install plugins with `Prefix + I`

### Custom Scripts

You can add custom scripts in the `.tmux/` directory:
- Place scripts in `.tmux/scripts/`
- Reference them in configuration files
- Use them in key bindings or status bar

## Verification

To verify the installation:

1. Check configuration files exist:
   ```bash
   ls -la ~/.tmux.conf ~/.tmux.conf.local
   ```

2. Start TMUX and check configuration:
   ```bash
   tmux
   # In TMUX: Prefix + ?
   ```

3. Verify the repository is properly cloned:
   ```bash
   ls -la ~/.tmux/
   ```