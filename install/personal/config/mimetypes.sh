#!/bin/bash

omarchy-default-browser helium || true

# GUI text editing via Zed when available
if command -v zeditor &>/dev/null || command -v zed &>/dev/null; then
  xdg-mime default zed.desktop text/plain
  xdg-mime default zed.desktop text/x-c
  xdg-mime default zed.desktop text/x-c++
  xdg-mime default zed.desktop application/xml
  xdg-mime default zed.desktop text/xml
fi
