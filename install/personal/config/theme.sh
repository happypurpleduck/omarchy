
# Override upstream Tokyo Night default with Catppuccin; sync Chromium flags.

omarchy-theme-set "Catppuccin"

if [[ -f $OMARCHY_PATH/config/chromium-flags.conf ]]; then
  cp -f "$OMARCHY_PATH/config/chromium-flags.conf" ~/.config/chromium-flags.conf
fi

omarchy-theme-set-browser

# Generate Zed theme now that the theme is applied (omazed runs during packaging
# but the theme isn't set yet at that stage, so no config gets generated).
if omarchy-cmd-present omazed; then
  omazed sync
fi
