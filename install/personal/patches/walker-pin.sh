
# Pin walker to omarchy repo so CachyOS doesn't override with an incompatible version.
if ! grep -q "^IgnorePkg.*walker" /etc/pacman.conf 2>/dev/null; then
  if grep -q "^IgnorePkg" /etc/pacman.conf; then
    sudo sed -i 's/^IgnorePkg = \(.*\)/IgnorePkg = \1 walker/' /etc/pacman.conf
  else
    sudo sed -i '/^\[options\]/a IgnorePkg = walker' /etc/pacman.conf
  fi
fi
