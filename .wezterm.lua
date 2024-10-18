local wezterm = require 'wezterm'
local config = wezterm.config_builder()
local act = wezterm.action

-- https://github.com/wez/wezterm/issues/256
local cache_dir = os.getenv('HOME') .. '/.cache/wezterm/'
local window_size_cache_path = cache_dir .. 'window_size_cache.txt'
local mux = wezterm.mux

wezterm.on("gui-startup", function()
	os.execute("mkdir " .. cache_dir)

	local window_size_cache_file = io.open(window_size_cache_path, "r")
	local window
	if window_size_cache_file ~= nil then
		_, _, width, height = string.find(window_size_cache_file:read(), "(%d+),(%d+)")
		_, _, window = mux.spawn_window({ width = tonumber(width), height = tonumber(height) })
		window_size_cache_file:close()
	else
		_, _, window = mux.spawn_window({})
		window:gui_window():maximize()
	end
end)

wezterm.on("window-resized", function(_, pane)
	local tab_size = pane:tab():get_size()
	local cols = tab_size["cols"]
	local rows = tab_size["rows"] + 2 -- Without adding the 2 here, the window doesn't maximize
	local contents = string.format("%d,%d", cols, rows)

	local window_size_cache_file = io.open(window_size_cache_path, "w")
	-- Check if the file was successfully opened
	if window_size_cache_file then
		window_size_cache_file:write(contents)
		window_size_cache_file:close()
	else
		print("Error: Could not open file for writing: " .. window_size_cache_path)
	end
end)

config = {
	automatically_reload_config = true,
	color_scheme = 'tokyonight_night',
	font = wezterm.font("JetBrainsMono Nerd Font", {weight="Regular", stretch="Normal", style="Normal"}),
	font_size = 16.0,
	use_fancy_tab_bar = false,
	tab_bar_at_bottom = true,
	window_background_opacity = 0.9,
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
