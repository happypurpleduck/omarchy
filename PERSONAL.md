# Omarchy Personal — decision log

Personal overlay on [basecamp/omarchy](https://github.com/basecamp/omarchy) **dev** (4.0 alpha), rebased periodically. Keeps **omarchy naming**; ~35 intentional file divergences (not a full rebrand).

**Upstream:** `upstream` → `basecamp/omarchy`, branch `dev`  
**Origin:** `origin` → `happypurpleduck/omarchy`

## Rebase workflow

```bash
git fetch upstream
git rebase upstream/dev
# Conflicts: see .personal-files — prefer personal side for listed paths
./scripts/verify.sh
```

## Confirmed decisions

| Topic | Choice |
|-------|--------|
| Integration | In-repo overlay (`install/personal/` + config templates) |
| AUR helper | **paru** + `install/personal/bin/yay` wrapper for upstream scripts |
| Omarchy pacman repo | **Keep** — added in personal preflight (skip upstream pacman overwrite) |
| Browser | **Helium** (`helium-browser-bin`) |
| Editors | **Zed** (`VISUAL_EDITOR`) + **omarchy-nvim** / `EDITOR=nvim` |
| Network | **impala + iwd** + NM **iwd backend** patch (omarchy-on-cachyos) |
| Terminal | **Foot only** (upstream dev) |
| Wallpaper | swaybg + Quickshell (no hyprpaper) |
| Walker | omarchy-walker + **IgnorePkg** pin |
| Theme default | **Catppuccin** |
| Keyboard | **us,ara** + `grp:alt_shift_toggle` (Alt+Shift) |
| Fonts | Noto Arabic rules in fontconfig |
| Webapps | Teams + YouTube Music preinstall |
| Login stage | **Skip** entire `login/all.sh` on CachyOS |

## Package sidecars

- **remove:** chromium, yay, signal-desktop, spotify
- **add:** helium-browser-bin, paru, cursor-bin, noto-fonts-extra (Arabic)
- **on-demand:** signal-desktop, spotify (install via menu when wanted)

## Skipped (high maintenance or superseded)

Full omarchy→hachy rebrand, Lua migration, migration wipe, hyprpaper, Ghostty/Alacritty extras, LazyVim bootstrap, inline trim of vendor hardware scripts.

## Install hooks skipped on CachyOS

- `install/preflight/pacman.sh`, `disable-mkinitcpio.sh`
- `install/post-install/pacman.sh`
- `install/config/all.sh`: `sudoless-asdcontrol.sh`, `usb-autosuspend.sh`
- `install/login/all.sh` (entire stage)

## Item review summary (119 items)

All items reviewed in migration plan. Port: Tier A CachyOS core + Tier B personal prefs. Skip: rebrand, Lua migration, migration wipe, hyprpaper, extra terminals, LazyVim.
