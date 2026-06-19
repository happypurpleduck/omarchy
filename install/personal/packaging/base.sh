
# Personal package deltas — runs after upstream base package install.

export PATH="$OMARCHY_INSTALL/personal/bin:$PATH"

if [[ -f $OMARCHY_INSTALL/personal/packages.remove ]]; then
  mapfile -t remove_pkgs < <(grep -v '^#' "$OMARCHY_INSTALL/personal/packages.remove" | grep -v '^$' || true)
  if ((${#remove_pkgs[@]})); then
    omarchy-pkg-drop "${remove_pkgs[@]}" || true
  fi
fi

if [[ -f $OMARCHY_INSTALL/personal/packages.add ]]; then
  mapfile -t add_pkgs < <(grep -v '^#' "$OMARCHY_INSTALL/personal/packages.add" | grep -v '^$' || true)
  if ((${#add_pkgs[@]})); then
    omarchy-pkg-add "${add_pkgs[@]}"
  fi
fi
