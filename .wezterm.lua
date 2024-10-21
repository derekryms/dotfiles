local wezterm = require 'wezterm'
local config = wezterm.config_builder()
local act = wezterm.action

config = {
	automatically_reload_config = true,
	color_scheme = 'tokyonight_night',
	font = wezterm.font("JetBrainsMono Nerd Font", {weight="Regular", stretch="Normal", style="Normal"}),
	font_size = 16.0,
	use_fancy_tab_bar = false,
	tab_bar_at_bottom = true,
	-- window_background_opacity = 0.9,
	window_padding = {
		left = 5,
		right = 5,
		top = 0,
		bottom = 0,
	},
	window_close_confirmation = "NeverPrompt",
	window_decorations = "RESIZE",
	default_cursor_style = "BlinkingBar",
	keys = {
		{
			key = 'W',
			mods = 'CMD',
			action = act.CloseCurrentTab { confirm = false },
		},
		{
			key = 'K',
			mods = 'CTRL|SHIFT',
			action = act.Multiple {
				act.ClearScrollback 'ScrollbackAndViewport',
				act.SendKey { key = 'L', mods = 'CTRL' },
				act.SendKey { key = 'U', mods = 'CTRL' },
			},

		}
	}
}

return config
