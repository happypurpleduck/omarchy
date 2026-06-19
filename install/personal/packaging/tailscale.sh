
if ! omarchy-pkg-present tailscale; then
  omarchy-pkg-add tailscale
fi

echo "Starting Tailscale..."
sudo systemctl enable --now tailscaled.service
sudo tailscale up --accept-routes

omarchy-webapp-install "Tailscale" "https://login.tailscale.com/admin/machines" https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/tailscale-light.png
