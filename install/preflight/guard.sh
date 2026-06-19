abort() {
  echo -e "\e[31mOmarchy install requires: $1\e[0m"
  echo
  gum confirm "Proceed anyway on your own accord and without assistance?" || exit 1
}

warn() {
  echo -e "\e[33mOmarchy install warning: $1\e[0m"
}

# Must be Arch or CachyOS
if [[ ! -f /etc/arch-release ]]; then
  abort "Arch-based distro (/etc/arch-release)"
fi

if [[ ! -f /etc/cachyos-release ]]; then
  warn "CachyOS not detected — this personal overlay is tuned for CachyOS but may work on other Arch derivatives"
fi

# Must not be running as root
if (( EUID == 0 )); then
  abort "Must not run as root (run as your user)"
fi

# Must be x86 only to fully work
if [[ $(uname -m) != "x86_64" ]]; then
  abort "x86_64 CPU"
fi

# Hyprland must be available
if ! pacman -Q hyprland &>/dev/null && ! command -v Hyprland &>/dev/null; then
  abort "Hyprland installed (install the CachyOS Hyprland edition or: sudo pacman -S hyprland)"
fi

# CachyOS uses paru as AUR helper
if ! command -v paru &>/dev/null; then
  abort "paru AUR helper (CachyOS: paru is in extra; install with pacman -S paru)"
fi

# Secure boot can block some boot tooling — warn only
if bootctl status 2>/dev/null | grep -q 'Secure Boot: enabled'; then
  warn "Secure Boot is enabled — some boot/login steps may be skipped"
fi

# Cleared all guards
echo "Guards: OK"
