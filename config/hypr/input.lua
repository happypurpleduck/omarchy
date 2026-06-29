-- Control your input devices.
-- See https://wiki.hypr.land/Configuring/Basics/Variables/#input
hl.config({
  input = {
    kb_layout = "us,ara",
    kb_options = "compose:caps,grp:alt_shift_toggle",

    repeat_rate = 40,
    repeat_delay = 250,

    numlock_by_default = true,

    sensitivity = -1,

    touchpad = {
      clickfinger_behavior = true,
      scroll_factor = 0.4,
    },
  },
})

o.window("(Alacritty|kitty|foot)", { scroll_touchpad = 1.5 })
o.window("com.mitchellh.ghostty", { scroll_touchpad = 0.2 })
