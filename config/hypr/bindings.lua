-- Personal keybind overrides. See PERSONAL.md.
-- Replaces waybar binds with quickshell bar binds.

hl.unbind("SUPER + RETURN")
hl.unbind("SUPER + SPACE")
hl.unbind("SUPER + backslash")
hl.unbind("SUPER + C")
hl.unbind("SUPER + V")
hl.unbind("SUPER + X")
hl.unbind("SUPER + S")
hl.unbind("SUPER + J")
hl.unbind("SUPER + K")
hl.unbind("SUPER + L")
hl.unbind("SUPER + W")
hl.unbind("SUPER + grave")
hl.unbind("SUPER + ALT + SPACE")
hl.unbind("SUPER + SHIFT + SPACE")
hl.unbind("SUPER + SHIFT + CTRL + UP")
hl.unbind("SUPER + SHIFT + CTRL + DOWN")
hl.unbind("SUPER + SHIFT + CTRL + LEFT")
hl.unbind("SUPER + SHIFT + CTRL + RIGHT")

hl.bind(
  "SUPER + backslash",
  hl.dsp.exec_cmd([[uwsm-app -- xdg-terminal-exec --dir="$(omarchy-cmd-terminal-cwd)"]]),
  { description = "Terminal" }
)
hl.bind("SUPER + RETURN", hl.dsp.exec_cmd("omarchy-launch-walker"), { description = "Launch apps" })
hl.bind("SUPER + SPACE", hl.dsp.exec_cmd("omarchy-menu"), { description = "Omarchy menu" })
hl.bind("SUPER + SHIFT + K", hl.dsp.exec_cmd("omarchy-menu-keybindings"), { description = "Show key bindings" })
hl.bind(
  "SUPER + SHIFT + CTRL + UP",
  hl.dsp.exec_cmd("omarchy-quickshell-bar-position top"),
  { description = "Move Quickshell bar to top" }
)
hl.bind(
  "SUPER + SHIFT + CTRL + DOWN",
  hl.dsp.exec_cmd("omarchy-quickshell-bar-position bottom"),
  { description = "Move Quickshell bar to bottom" }
)
hl.bind(
  "SUPER + SHIFT + CTRL + LEFT",
  hl.dsp.exec_cmd("omarchy-quickshell-bar-position left"),
  { description = "Move Quickshell bar to left" }
)
hl.bind(
  "SUPER + SHIFT + CTRL + RIGHT",
  hl.dsp.exec_cmd("omarchy-quickshell-bar-position right"),
  { description = "Move Quickshell bar to right" }
)

hl.bind("SUPER + H", hl.dsp.focus({ direction = "l" }), { description = "Focus left" })
hl.bind("SUPER + J", hl.dsp.focus({ direction = "d" }), { description = "Focus down" })
hl.bind("SUPER + K", hl.dsp.focus({ direction = "u" }), { description = "Focus up" })
hl.bind("SUPER + L", hl.dsp.focus({ direction = "r" }), { description = "Focus right" })

hl.bind("SUPER + S", hl.dsp.layout("togglesplit"), { description = "Toggle split orientation" })
hl.bind("SUPER + C", hl.dsp.window.close(), { description = "Close window" })

hl.bind("SUPER + grave", hl.dsp.workspace.toggle_special("scratchpad"), { description = "Toggle scratchpad" })
hl.bind(
  "SUPER + ALT + grave",
  hl.dsp.window.move({ workspace = "special:scratchpad", follow = false }),
  { description = "Move window to scratchpad" }
)

hl.bind(
  "SUPER + SHIFT + C",
  hl.dsp.send_shortcut({ mods = "CTRL", key = "Insert" }),
  { description = "Universal copy" }
)
hl.bind(
  "SUPER + SHIFT + V",
  hl.dsp.send_shortcut({ mods = "SHIFT", key = "Insert" }),
  { description = "Universal paste" }
)
hl.bind(
  "SUPER + SHIFT + SPACE",
  hl.dsp.exec_cmd("omarchy-quickshell-bar-toggle"),
  { description = "Toggle Quickshell bar" }
)
hl.bind("SUPER + SHIFT + X", hl.dsp.send_shortcut({ mods = "CTRL", key = "X" }), { description = "Universal cut" })

o.bind("SUPER + ALT + RETURN", "Tmux", { omarchy = "terminal-tmux" })
o.bind("SUPER + SHIFT + RETURN", "Browser", { omarchy = "browser" })
o.bind("SUPER + SHIFT + F", "File manager", { omarchy = "nautilus" })
o.bind("SUPER + ALT + SHIFT + F", "File manager (cwd)", { omarchy = "nautilus-cwd" })
o.bind("SUPER + SHIFT + B", "Browser", { omarchy = "browser" })
o.bind("SUPER + SHIFT + ALT + B", "Browser (private)", { omarchy = "browser --private" })
o.bind("SUPER + SHIFT + M", "YouTube Music", { webapp = "https://music.youtube.com" })
o.bind("SUPER + SHIFT + N", "Editor", { omarchy = "editor" })
o.bind("SUPER + SHIFT + D", "Docker", { tui = "lazydocker" })
o.bind("SUPER + SHIFT + G", "Discord", { webapp = "https://discord.com/channels/@me" })
o.bind("SUPER + SHIFT + T", "Teams", { webapp = "https://teams.microsoft.com" })
o.bind("SUPER + SHIFT + O", "Obsidian", { launch = "obsidian", focus = "^obsidian$" })
o.bind("SUPER + SHIFT + SLASH", "Passwords", { launch = "1password" })

o.bind("SUPER + SHIFT + A", "ChatGPT", { webapp = "https://chatgpt.com" })
o.bind("SUPER + SHIFT + Y", "YouTube", { webapp = "https://youtube.com/" })

hl.bind("SUPER + SHIFT + P", hl.dsp.window.pin(), { description = "Pin" })
