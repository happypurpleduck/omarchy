#!/bin/bash

# Override upstream Tokyo Night default with Catppuccin; sync Helium flags.

omarchy-theme-set "Catppuccin"

if [[ -f $OMARCHY_PATH/config/helium-browser-flags.conf ]]; then
  cp -f "$OMARCHY_PATH/config/helium-browser-flags.conf" ~/.config/helium-browser-flags.conf
fi

omarchy-theme-set-browser
