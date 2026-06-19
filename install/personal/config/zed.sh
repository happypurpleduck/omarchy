
mkdir -p ~/.config/zed

for file in settings.json keymap.json; do
  if [[ -f $OMARCHY_PATH/config/zed/$file ]]; then
    cp -f "$OMARCHY_PATH/config/zed/$file" ~/.config/zed/$file
  fi
done

omarchy-theme-set-zed

if omarchy-cmd-present omazed; then
  omazed setup
fi
