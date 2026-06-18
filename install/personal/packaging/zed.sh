#!/bin/bash

# Official Zed install — https://zed.dev/docs/installation

if command -v zed &>/dev/null || command -v zeditor &>/dev/null; then
  echo "Zed already installed at $(command -v zed 2>/dev/null || command -v zeditor)"
else
  curl -f https://zed.dev/install.sh | sh
fi

if ! command -v zed &>/dev/null && ! command -v zeditor &>/dev/null; then
  echo "Zed install failed — install manually and run: omarchy default editor zed" >&2
  exit 1
fi
