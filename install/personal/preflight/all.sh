#!/bin/bash

# CachyOS: add omarchy repo without overwriting CachyOS pacman.conf via upstream hooks.

if ! grep -q '^\[omarchy\]' /etc/pacman.conf 2>/dev/null; then
  echo "Adding omarchy pacman repository..."
  sudo pacman-key --recv-keys F0134EE680CAC571
  sudo pacman-key --lsign-key F0134EE680CAC571
  echo -e "\n[omarchy]\nSigLevel = Optional TrustedOnly\nServer = https://pkgs.omarchy.org/\$arch" | sudo tee -a /etc/pacman.conf >/dev/null
else
  echo "Omarchy repository already present in pacman.conf"
fi

sudo pacman -Sy

# Ensure signing key is trusted on re-runs
sudo pacman-key --recv-keys F0134EE680CAC571 2>/dev/null || true
sudo pacman-key --lsign-key F0134EE680CAC571 2>/dev/null || true
