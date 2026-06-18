#!/bin/bash

# Merge primary vconsole layout with Arabic; preserve Alt+Shift toggle.
conf="/etc/vconsole.conf"
hyprlua="$HOME/.config/hypr/input.lua"

if [[ ! -f $hyprlua ]]; then
  exit 0
fi

layout="us"
if [[ -f $conf ]] && grep -q '^XKBLAYOUT=' "$conf"; then
  layout=$(grep '^XKBLAYOUT=' "$conf" | cut -d= -f2 | tr -d '"')
fi

# Append Arabic if not already present
if [[ $layout != *"ara"* ]]; then
  layout="${layout},ara"
fi

if grep -q 'kb_layout' "$hyprlua"; then
  sed -i "s/^[[:space:]]*kb_layout = .*/    kb_layout = \"$layout\",/" "$hyprlua"
else
  sed -i "/^[[:space:]]*kb_options *=/i\    kb_layout = \"$layout\"," "$hyprlua"
fi

if grep -q 'kb_options' "$hyprlua"; then
  if grep -q 'grp:alt_shift_toggle' "$hyprlua"; then
    :
  elif grep -q 'grp:' "$hyprlua"; then
    sed -i 's/kb_options = "\([^"]*\)"/kb_options = "\1,grp:alt_shift_toggle"/' "$hyprlua"
  else
    sed -i 's/kb_options = "\([^"]*\)"/kb_options = "\1,grp:alt_shift_toggle"/' "$hyprlua"
  fi
else
  sed -i "/^[[:space:]]*kb_layout/a\    kb_options = \"compose:caps,grp:alt_shift_toggle\"," "$hyprlua"
fi

# Update vconsole for consistency
if [[ -f $conf ]]; then
  sudo sed -i "s/^XKBLAYOUT=.*/XKBLAYOUT=$layout/" "$conf"
fi
