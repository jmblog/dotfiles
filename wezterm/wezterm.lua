local wezterm = require 'wezterm'
local config = {}

-- Color
config.color_scheme = 'Tomorrow Night Bright'

-- Appearance
config.window_padding = {
  left = 10,
  right = 10,
  top = 10,
  bottom = 10,
}

config.window_background_opacity = 0.9

-- Font
config.font = wezterm.font_with_fallback {
  'Fira Code',
  'ヒラギノ角ゴシック',
  'Apple Color Emoji'
}
config.line_height = 1.1

-- Spawn
config.initial_cols = 150
config.initial_rows = 50

-- key bindings
config.keys = {
  {
    key = 't',
    mods = 'SUPER',
    action = wezterm.action.SpawnCommandInNewTab {
      cwd = wezterm.home_dir,
    }
  },
  {
    key = 'LeftArrow',
    mods = 'SUPER',
    action = wezterm.action.ActivateTabRelativeNoWrap(-1),
  },
  {
    key = 'RightArrow',
    mods = 'SUPER',
    action = wezterm.action.ActivateTabRelativeNoWrap(1),
  },
  { 
    key = '¥',
    action = wezterm.action({ SendString = "\\" })
  }
}

-- exit behavior
config.window_close_confirmation = 'NeverPrompt'

return config
