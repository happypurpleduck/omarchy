
# CachyOS: skip upstream post-install pacman overwrite (handled by omitting run_logged in post-install/all.sh).

echo "Skipping post-install pacman.conf overwrite (CachyOS personal overlay)"

if [[ -f $OMARCHY_PATH/config/omarchy/fork.conf ]]; then
  # shellcheck disable=SC1091
  source "$OMARCHY_PATH/install/personal/helpers/fork-git.sh"
  omarchy_fork_git_bootstrap "$OMARCHY_PATH"
fi
