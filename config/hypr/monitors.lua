-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
-- List current monitors and resolutions possible: hyprctl monitors all

local omarchy_gdk_scale = 1
local omarchy_monitor_scale = "1.6"

-- Optimized for retina-class 2x displays, like 13" 2.8K, 27" 5K, 32" 6K.
-- local omarchy_gdk_scale = 2
-- local omarchy_monitor_scale = "auto"

-- Good compromise for 27" or 32" 4K monitors (but fractional!): monitor scale 1.6, GDK scale 1.75.
-- local omarchy_gdk_scale = 1.75
-- local omarchy_monitor_scale = 1.6

-- Straight 1x setup for low-resolution displays like 1080p, 1440p, or ultrawides: both 1.
-- local omarchy_gdk_scale = 1
-- local omarchy_monitor_scale = 1

hl.env("GDK_SCALE", tostring(omarchy_gdk_scale))

-- Monitor variables -- swap to flip sides or change ports
local monitor_left  = "DP-1"      -- ASUS VG27AQL1A
local monitor_right = "HDMI-A-1"  -- Galax / General Info Systems VI-01

-- ASUS (left side) -- isolated workspace 10
hl.monitor({
    output = monitor_left,
    mode = "highres highrr",
    position = "0x0",
    scale = omarchy_monitor_scale,
})

-- Galax (right side) -- workspaces 1-9 (auto positions adjacent)
hl.monitor({
    output = monitor_right,
    mode = "highres highrr",
    position = "auto",
    scale = omarchy_monitor_scale,
})

-- Fallback auto-detect for any unmatched monitors
hl.monitor({
    output = "",
    mode = "highres highrr",
    position = "auto",
    scale = omarchy_monitor_scale,
})

-- Right monitor gets workspaces 1-9
for i = 1, 9 do
    hl.workspace_rule({ workspace = tostring(i), monitor = monitor_right })
end

-- Left monitor gets workspace 10, kept alive when empty (SUPER+0)
hl.workspace_rule({ workspace = "10", monitor = monitor_left, persistent = true })

-- Portrait/rotated secondary monitor (transform: 1 = 90°, 3 = 270°)
-- hl.monitor({ output = "DP-2", mode = "preferred", position = "auto", scale = 1, transform = 1 })

-- Example for Framework 13 w/ 6K XDR Apple display.
-- hl.monitor({ output = "DP-5", mode = "6016x3384@60", position = "auto", scale = 2 })
-- hl.monitor({ output = "eDP-1", mode = "2880x1920@120", position = "auto", scale = 2 })

-- Disable the second ghost monitor on an Apple 6K XDR over Thunderbolt.
-- hl.monitor({ output = "DP-2", disabled = true })
