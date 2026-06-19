
# Personal config overlay — runs after upstream install/config/all.sh.

run_logged $OMARCHY_INSTALL/personal/config/fish.sh
run_logged $OMARCHY_INSTALL/personal/config/cachyos-pacman.sh
run_logged $OMARCHY_INSTALL/personal/config/keyboard-arabic.sh
run_logged $OMARCHY_INSTALL/personal/config/theme.sh
run_logged $OMARCHY_INSTALL/personal/config/mimetypes.sh
run_logged $OMARCHY_INSTALL/personal/patches/network-iwd.sh
run_logged $OMARCHY_INSTALL/personal/patches/walker-pin.sh
