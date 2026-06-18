#!/bin/bash

# Disable wpa_supplicant to prevent conflict with iwd on CachyOS.
sudo systemctl disable --now wpa_supplicant.service 2>/dev/null || true

# Configure NetworkManager to use iwd as its WiFi backend.
if ! grep -q "wifi.backend=iwd" /etc/NetworkManager/NetworkManager.conf 2>/dev/null; then
  sudo tee -a /etc/NetworkManager/NetworkManager.conf >/dev/null <<'EOF'

[device]
wifi.backend=iwd
EOF
fi
