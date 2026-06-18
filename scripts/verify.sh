#!/bin/bash
# Pre-install checks — run from the omarchy-personal repo before ./boot.sh

set -euo pipefail

ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
export PATH="$ROOT/bin:$ROOT/install/personal/bin:$PATH"
FAIL=0

pass() { echo -e "\e[32m✓\e[0m $1"; }
fail() { echo -e "\e[31m✗\e[0m $1"; FAIL=1; }
warn() { echo -e "\e[33m!\e[0m $1"; }

echo "Omarchy Personal pre-install verification"
echo "Repo: $ROOT"
echo

if [[ -f /etc/arch-release ]]; then pass "Arch-based system"; else fail "Missing /etc/arch-release"; fi
if [[ -f /etc/cachyos-release ]]; then pass "CachyOS detected"; else warn "CachyOS release file not found (ok on other Arch systems)"; fi
if (( EUID != 0 )); then pass "Running as user ($USER)"; else fail "Do not run boot.sh as root"; fi
if pacman -Q hyprland &>/dev/null || command -v Hyprland &>/dev/null; then pass "Hyprland available"; else fail "Hyprland not installed"; fi
if command -v paru &>/dev/null; then pass "paru AUR helper available"; else fail "paru not installed (required on CachyOS)"; fi
if sudo -n true 2>/dev/null; then pass "Passwordless sudo"; else warn "sudo will prompt for your password during ./boot.sh"; fi

if "$ROOT/bin/omarchy" --help &>/dev/null; then pass "omarchy CLI responds"; else fail "omarchy CLI broken"; fi
if "$ROOT/bin/omarchy" commands --check &>/dev/null; then pass "omarchy command metadata valid"; else fail "omarchy command metadata errors"; fi

for f in boot.sh PERSONAL.md .personal-files install/personal/preflight/all.sh install/personal/bin/yay config/hypr/bindings.lua; do
  if [[ -f $ROOT/$f ]]; then pass "Found $f"; else fail "Missing $f"; fi
done

if grep -q 'personal/preflight/all.sh' "$ROOT/install/preflight/all.sh"; then
  pass "Preflight personal hook present"
else
  fail "Preflight personal hook missing"
fi

if grep -q '# source.*login/all.sh' "$ROOT/install.sh"; then
  pass "Login stage skipped in install.sh"
else
  fail "install.sh still sources login/all.sh"
fi

if [[ -x $ROOT/install/personal/bin/yay ]]; then
  pass "yay→paru wrapper is executable"
else
  fail "yay wrapper missing or not executable"
fi

if git -C "$ROOT" remote get-url upstream &>/dev/null; then
  pass "upstream remote configured"
else
  warn "upstream remote not configured (run: git remote add upstream git@github.com:basecamp/omarchy.git)"
fi

echo
if (( FAIL == 0 )); then
  echo -e "\e[32mAll checks passed.\e[0m Ready to install:"
  echo "  cd $ROOT && ./boot.sh"
else
  echo -e "\e[31mSome checks failed.\e[0m Fix issues before running ./boot.sh"
  exit 1
fi
