local wezterm = require 'wezterm'

local config = wezterm.config_builder()

config.color_scheme = 'tokyonight_night'
config.font = wezterm.font 'JetBrains Mono'
config.font_size = 16.0
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true
config.window_background_opacity = 0.9
config.window_padding = {
  left = 5,
  right = 5,
  top = 5,
  bottom = 5,
}

return config
