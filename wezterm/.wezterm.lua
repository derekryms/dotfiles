local wezterm = require 'wezterm'
local config = wezterm.config_builder()

wezterm.on('gui-startup', function(cmd)
  local tab, pane, window = wezterm.mux.spawn_window(cmd or {})
  local gui_win = window:gui_window()
  local screen = wezterm.gui.screens().active

  local padding = 8
  local macBarHeight = 50

  gui_win:set_position(screen.x + padding, screen.y + padding + macBarHeight)
  gui_win:set_inner_size(
    screen.width - (padding * 2),
    screen.height - (padding * 2) - macBarHeight
  )
end)

config.font_size = 16
config.color_scheme = 'Tokyo Night'

config.font = wezterm.font 'JetBrains Mono'

return config
