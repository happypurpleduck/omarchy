#!/bin/bash

set -e

export OMARCHY_ONLINE_INSTALL=false

ansi_art='                 ▄▄▄
 ▄█████▄    ▄███████████▄    ▄███████   ▄███████   ▄███████   ▄█   █▄    ▄█   █▄
███   ███  ███   ███   ███  ███   ███  ███   ███  ███   ███  ███   ███  ███   ███
███   ███  ███   ███   ███  ███   ███  ███   ███  ███   █▀   ███   ███  ███   ███
███   ███  ███   ███   ███ ▄███▄▄▄███ ▄███▄▄▄██▀  ███       ▄███▄▄▄███▄ ███▄▄▄███
███   ███  ███   ███   ███ ▀███▀▀▀███ ▀███▀▀▀▀    ███      ▀▀███▀▀▀███  ▀▀▀▀▀▀███
███   ███  ███   ███   ███  ███   ███ ██████████  ███   █▄   ███   ███  ▄██   ███
███   ███  ███   ███   ███  ███   ███  ███   ███  ███   ███  ███   ███  ███   ███
 ▀█████▀    ▀█   ███   █▀   ███   █▀   ███   ███  ███████▀   ███   █▀    ▀█████▀
                                       ███   █▀                                  '

clear 2>/dev/null || true
echo -e "\n$ansi_art\n"
echo -e "\e[32mOmarchy Personal — CachyOS Hyprland setup\e[0m\n"

SOURCE_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
TARGET_DIR="$HOME/.local/share/omarchy"

if [[ $SOURCE_DIR != "$TARGET_DIR" ]]; then
  echo "Installing Omarchy to $TARGET_DIR ..."
  mkdir -p "$(dirname "$TARGET_DIR")"
  if [[ -d $TARGET_DIR/.git ]]; then
    echo "Updating existing install from $SOURCE_DIR"
    rsync -a --delete --exclude .git "$SOURCE_DIR/" "$TARGET_DIR/"
  else
    rm -rf "$TARGET_DIR"
    cp -a "$SOURCE_DIR" "$TARGET_DIR"
  fi
fi

if [[ -f $TARGET_DIR/config/omarchy/fork.conf ]]; then
  # shellcheck disable=SC1091
  source "$TARGET_DIR/install/personal/helpers/fork-git.sh"
  omarchy_fork_git_bootstrap "$TARGET_DIR"
fi

export PATH="$TARGET_DIR/bin:$PATH"

if ! grep -q 'omarchy/bin' "$HOME/.bashrc" 2>/dev/null; then
  cat >>"$HOME/.bashrc" <<'EOF'

# Omarchy
export PATH="$HOME/.local/share/omarchy/bin:$PATH"
EOF
  echo "Added Omarchy to PATH in ~/.bashrc"
fi

echo -e "\nInstallation starting..."
source "$TARGET_DIR/install.sh"
