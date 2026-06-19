
# Ensure CachyOS pacman repositories stay configured on CachyOS systems.

OMARCHY_PATH=${OMARCHY_PATH:-$HOME/.local/share/omarchy}
CACHYOS_PACMAN_REPOS_FILE=/etc/pacman.d/cachyos-repos.conf
CACHYOS_PACMAN_REPOS_MARKER='Include = /etc/pacman.d/cachyos-repos.conf'
CACHYOS_PACMAN_KEY_ID=F3B607488DB35A47

omarchy_cachyos_pacman_repos_is_cachyos() {
  [[ -f /etc/cachyos-release ]] && return 0
  [[ -f /etc/os-release ]] && grep -q '^ID=cachyos$' /etc/os-release && return 0
  return 1
}

omarchy_cachyos_pacman_repos_tier() {
  if ! omarchy_cachyos_pacman_repos_is_cachyos; then
    return 1
  fi

  local pkg from sync
  for pkg in linux-cachyos linux-cachyos-lts linux-cachyos-bore linux-cachyos-rc; do
    from=$(pacman -Qi "$pkg" 2>/dev/null | awk -F': ' '/^Installed From/{print $2; exit}')
    if [[ -n $from ]]; then
      case $from in
        cachyos-znver4|cachyos-core-znver4|cachyos-extra-znver4) echo znver4; return 0 ;;
        cachyos-v4|cachyos-core-v4|cachyos-extra-v4) echo v4; return 0 ;;
        cachyos-v3|cachyos-core-v3|cachyos-extra-v3) echo v3; return 0 ;;
        cachyos) echo basic; return 0 ;;
      esac
    fi
  done

  for sync in /var/lib/pacman/sync/cachyos-znver4.db /var/lib/pacman/sync/cachyos-v4.db /var/lib/pacman/sync/cachyos-v3.db; do
    [[ -f $sync ]] || continue
    case $sync in
      *znver4*) echo znver4; return 0 ;;
      *-v4.db) echo v4; return 0 ;;
      *-v3.db) echo v3; return 0 ;;
    esac
  done

  if [[ -f /var/lib/pacman/sync/cachyos.db ]]; then
    echo basic
    return 0
  fi

  echo v3
  return 0
}

omarchy_cachyos_pacman_repos_write_snippet() {
  local tier=$1

  case $tier in
  znver4)
    cat <<'EOF'
# CachyOS optimized repositories (managed by omarchy)
[cachyos-znver4]
Include = /etc/pacman.d/cachyos-v4-mirrorlist

[cachyos-core-znver4]
Include = /etc/pacman.d/cachyos-v4-mirrorlist

[cachyos-extra-znver4]
Include = /etc/pacman.d/cachyos-v4-mirrorlist

[cachyos]
Include = /etc/pacman.d/cachyos-mirrorlist
EOF
    ;;
  v4)
    cat <<'EOF'
# CachyOS optimized repositories (managed by omarchy)
[cachyos-v4]
Include = /etc/pacman.d/cachyos-v4-mirrorlist

[cachyos-core-v4]
Include = /etc/pacman.d/cachyos-v4-mirrorlist

[cachyos-extra-v4]
Include = /etc/pacman.d/cachyos-v4-mirrorlist

[cachyos]
Include = /etc/pacman.d/cachyos-mirrorlist
EOF
    ;;
  v3)
    cat <<'EOF'
# CachyOS optimized repositories (managed by omarchy)
[cachyos-v3]
Include = /etc/pacman.d/cachyos-v3-mirrorlist

[cachyos-core-v3]
Include = /etc/pacman.d/cachyos-v3-mirrorlist

[cachyos-extra-v3]
Include = /etc/pacman.d/cachyos-v3-mirrorlist

[cachyos]
Include = /etc/pacman.d/cachyos-mirrorlist
EOF
    ;;
  basic)
    cat <<'EOF'
# CachyOS repository (managed by omarchy)
[cachyos]
Include = /etc/pacman.d/cachyos-mirrorlist
EOF
    ;;
  *)
    return 1
    ;;
  esac
}

omarchy_cachyos_pacman_repos_ensure() {
  if ! omarchy_cachyos_pacman_repos_is_cachyos; then
    return 0
  fi

  local tier
  tier=$(omarchy_cachyos_pacman_repos_tier) || return 0

  echo "Ensuring CachyOS pacman repositories ($tier)..."

  omarchy_cachyos_pacman_repos_write_snippet "$tier" | sudo tee "$CACHYOS_PACMAN_REPOS_FILE" >/dev/null
  sudo chmod 644 "$CACHYOS_PACMAN_REPOS_FILE"

  if grep -qxF "$CACHYOS_PACMAN_REPOS_MARKER" /etc/pacman.conf 2>/dev/null; then
    :
  elif grep -q '^\[cachyos' /etc/pacman.conf 2>/dev/null; then
    echo "CachyOS repositories already configured in pacman.conf"
  elif grep -q '^\[core\]' /etc/pacman.conf 2>/dev/null; then
    sudo sed -i "0,/^\[core\]/s||$CACHYOS_PACMAN_REPOS_MARKER\n\n[core]|" /etc/pacman.conf
  else
    echo -e "\n$CACHYOS_PACMAN_REPOS_MARKER" | sudo tee -a /etc/pacman.conf >/dev/null
  fi

  sudo pacman-key --recv-keys "$CACHYOS_PACMAN_KEY_ID" 2>/dev/null || true
  sudo pacman-key --lsign-key "$CACHYOS_PACMAN_KEY_ID" 2>/dev/null || true

  sudo pacman -Sy
}
