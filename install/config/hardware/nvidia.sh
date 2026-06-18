if lspci | grep -qi 'nvidia'; then
  # CachyOS ships NVIDIA modules via kernel meta packages — skip conflicting DKMS drivers
  CACHYOS_NVIDIA_KERNEL=false
  if pacman -Qqs 'linux-cachyos.*nvidia' &>/dev/null; then
    CACHYOS_NVIDIA_KERNEL=true
    echo "CachyOS NVIDIA kernel meta package detected — skipping DKMS driver install"
  fi

  # Check which kernel is installed and set appropriate headers package
  KERNEL_HEADERS="$(pacman -Qqs '^linux(-zen|-lts|-hardened|-cachyos)?$' | head -1)-headers"

  if omarchy-hw-nvidia-gsp; then
    if [[ $CACHYOS_NVIDIA_KERNEL = true ]]; then
      PACKAGES=(nvidia-utils lib32-nvidia-utils libva-nvidia-driver)
    else
      PACKAGES=(nvidia-open-dkms nvidia-utils lib32-nvidia-utils libva-nvidia-driver)
    fi
    GPU_ARCH="turing_plus"
  elif omarchy-hw-nvidia-without-gsp; then
    if [[ $CACHYOS_NVIDIA_KERNEL = true ]]; then
      PACKAGES=(nvidia-utils lib32-nvidia-utils)
    else
      PACKAGES=(nvidia-580xx-dkms nvidia-580xx-utils lib32-nvidia-580xx-utils)
    fi
    GPU_ARCH="maxwell_pascal_volta"
  fi
  # Bail if no supported GPU
  if [[ -z ${PACKAGES+x} ]]; then
    echo "No compatible driver for your NVIDIA GPU. See: https://wiki.archlinux.org/title/NVIDIA"
    exit 0
  fi

  if [[ $CACHYOS_NVIDIA_KERNEL = true ]]; then
    omarchy-pkg-add "${PACKAGES[@]}"
  else
    omarchy-pkg-add "$KERNEL_HEADERS" "${PACKAGES[@]}"
  fi

  # Configure modprobe for early KMS
  sudo tee /etc/modprobe.d/nvidia.conf <<EOF >/dev/null
options nvidia_drm modeset=1
EOF

  # Configure mkinitcpio for early loading
  sudo tee /etc/mkinitcpio.conf.d/nvidia.conf <<EOF >/dev/null
MODULES+=(nvidia nvidia_modeset nvidia_uvm nvidia_drm)
EOF

  # Add NVIDIA environment variables based on GPU architecture
  if [[ $GPU_ARCH = "turing_plus" ]]; then
    cat >>"$HOME/.config/hypr/envs.lua" <<'EOF'

-- NVIDIA (Turing+ with GSP firmware)
hl.env("NVD_BACKEND", "direct")
hl.env("LIBVA_DRIVER_NAME", "nvidia")
hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")
EOF
  elif [[ $GPU_ARCH = "maxwell_pascal_volta" ]]; then
    cat >>"$HOME/.config/hypr/envs.lua" <<'EOF'

-- NVIDIA (Maxwell/Pascal/Volta without GSP firmware)
hl.env("NVD_BACKEND", "egl")
hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")
EOF
  fi
fi
