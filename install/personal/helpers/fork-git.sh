
# Shared fork git helpers — sourced by boot.sh, post-install, and update scripts.

OMARCHY_PATH=${OMARCHY_PATH:-$HOME/.local/share/omarchy}

omarchy_fork_git_conf() {
  local root="${1:-$OMARCHY_PATH}"
  local conf="$root/config/omarchy/fork.conf"

  if [[ -f $conf ]]; then
    # shellcheck disable=SC1090
    source "$conf"
    return 0
  fi

  return 1
}

omarchy_fork_git_bootstrap() {
  local root="${1:-$OMARCHY_PATH}"

  omarchy_fork_git_conf "$root" || return 0

  if [[ ! -d $root/.git ]]; then
    echo "Initializing git in $root for fork updates..."
    git -C "$root" init -b "$OMARCHY_GIT_BRANCH"
    git -C "$root" remote add origin "$OMARCHY_GIT_REMOTE"
    git -C "$root" add -A
    git -C "$root" -c user.email=omarchy@local -c user.name=Omarchy commit -m "Local omarchy install" --allow-empty
    git -C "$root" fetch origin "$OMARCHY_GIT_BRANCH" --depth=1
    git -C "$root" reset --hard "origin/$OMARCHY_GIT_BRANCH"
  elif git -C "$root" remote get-url origin &>/dev/null; then
    git -C "$root" remote set-url origin "$OMARCHY_GIT_REMOTE"
  else
    git -C "$root" remote add origin "$OMARCHY_GIT_REMOTE"
  fi
}

omarchy_fork_git_pull() {
  omarchy_fork_git_conf || {
    git -C "$OMARCHY_PATH" pull --autostash
    return
  }

  omarchy_fork_git_bootstrap "$OMARCHY_PATH"
  git -C "$OMARCHY_PATH" fetch origin "$OMARCHY_GIT_BRANCH"
  git -C "$OMARCHY_PATH" merge --ff-only "origin/$OMARCHY_GIT_BRANCH"
}
