# Install all base packages
export PATH="$OMARCHY_INSTALL/personal/bin:$PATH"
mapfile -t packages < <(grep -v '^#' "$OMARCHY_INSTALL/omarchy-base.packages" | grep -v '^$')
omarchy-pkg-add "${packages[@]}"
[[ -f $OMARCHY_INSTALL/personal/packaging/base.sh ]] && source $OMARCHY_INSTALL/personal/packaging/base.sh
