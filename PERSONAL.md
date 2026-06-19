# Omarchy Personal — decision log

Personal overlay on [basecamp/omarchy](https://github.com/basecamp/omarchy) **dev** (4.0 alpha), rebased periodically. Keeps **omarchy naming**; ~35 intentional file divergences (not a full rebrand).

**Upstream:** `upstream` → `basecamp/omarchy`, branch `dev`  
**Origin:** `origin` → `happypurpleduck/omarchy`

## Target platform

This fork is **CachyOS-only in practice**. Install hooks listed below are skipped **unconditionally** (not gated on `/etc/cachyos-release`). `install/preflight/guard.sh` warns on non-CachyOS Arch but proceeds.

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
| Integration | In-repo overlay (`install/personal/` + config templates); **`boot.sh`** rsyncs local clone to `~/.local/share/omarchy` (no curl/git clone) |
| AUR helper | **paru** + `install/personal/bin/yay` wrapper for upstream scripts |
| Omarchy pacman repo | **Keep** — added in personal preflight (skip upstream pacman overwrite) |
| Browser | **Helium** (`helium-browser-bin`) |
| Editors | **Zed** (`VISUAL_EDITOR`) + **omarchy-nvim** / `EDITOR=nvim` |
| Network | **impala + iwd** + NM **iwd backend** patch (omarchy-on-cachyos) |
| Terminal | **Foot only** (upstream dev) |
| Wallpaper | swaybg + Quickshell (no hyprpaper) |
| Walker | omarchy-walker + **IgnorePkg** pin |
| Theme default | **Catppuccin** |
| Keyboard | **us,ara** + `grp:alt_shift_toggle` (Alt+Shift); HJKL focus remap, Walker on Super+Return, menu on Super+Space, scratchpad on Super+grave (see keybind table below) |
| Fonts | Noto Arabic rules in fontconfig; monospace **assign** override for JetBrainsMono Nerd Font |
| Webapps | Teams + YouTube Music preinstall; Discord binding; YouTube Music replaces Spotify keybind |
| Login stage | **Skip** entire `login/all.sh` (unconditional) |

## Package sidecars

- **remove:** chromium, yay, signal-desktop, spotify
- **add:** helium-browser-bin, paru, cursor-bin, noto-fonts-extra (Arabic)
- **on-demand:** signal-desktop, spotify (Install → Service in omarchy menu)

## Keybind overrides

Personal overrides live in `config/hypr/bindings.lua` (see `.personal-files`).

| Binding | Action |
|---------|--------|
| Super + `\` | Terminal (cwd-aware) |
| Super + Return | Launch Walker |
| Super + Space | Omarchy menu |
| Super + Shift + K | Show key bindings |
| Super + H/J/K/L | Focus left/down/up/right |
| Super + S | Toggle split orientation |
| Super + C | Close window |
| Super + ` | Toggle scratchpad |
| Super + Alt + ` | Move window to scratchpad |
| Super + Shift + C/V/X | Universal copy/paste/cut |
| Super + Shift + M | YouTube Music (webapp) |
| Super + Shift + G | Discord (webapp) |
| Super + Shift + T | Teams (webapp) |

## Desktop tweaks

- **Updates**: waybar `custom/update` module and mako "Update System" handler enabled; `omarchy update` pulls from fork (`happypurpleduck/omarchy`, branch `dev`) via `config/omarchy/fork.conf`
- **Waybar**: omarchy tooltip shows `Super + Space`
- **Shell**: standard `zoxide init` in `default/bash/aliases` and `config/fish/conf.d/omarchy.fish`
- **mise**: bash + fish activation in `config/uwsm/env`

## Hardware exceptions

`install/config/hardware/nvidia.sh` includes a CachyOS kernel-meta guard that skips conflicting DKMS drivers when `linux-cachyos.*nvidia` is installed. This is an intentional `.personal-files` divergence.

## Skipped (high maintenance or superseded)

Full omarchy→hachy rebrand, Lua migration, migration wipe, hyprpaper, Ghostty/Alacritty extras, LazyVim bootstrap, inline trim of vendor hardware scripts (except NVIDIA CachyOS kernel-meta guard in `nvidia.sh`).

## Install hooks skipped (unconditional)

- `install/preflight/pacman.sh`, `disable-mkinitcpio.sh`
- `install/post-install/pacman.sh`
- `install/config/all.sh`: `sudoless-asdcontrol.sh`, `usb-autosuspend.sh`
- `install/login/all.sh` (entire stage)

## Item review summary (119 items)

All items reviewed in migration plan. Port: Tier A CachyOS core + Tier B personal prefs. Skip: rebrand, Lua migration, migration wipe, hyprpaper, extra terminals, LazyVim.
