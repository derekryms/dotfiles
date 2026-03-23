local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- Detect OS
local is_windows = wezterm.target_triple:find("windows") ~= nil
local is_mac = wezterm.target_triple:find("apple") ~= nil

-- =====================
-- Font
-- =====================
config.font = wezterm.font("JetBrains Mono", { weight = "Regular" })
config.font_size = 14
config.line_height = 1.0

-- =====================
-- Appearance
-- =====================
config.color_scheme = "Tokyo Night"
config.window_background_opacity = 0.95
config.macos_window_background_blur = 20 -- mac only, ignored on windows

config.window_padding = {
	left = 10,
	right = 10,
	top = 10,
	bottom = 10,
}

-- Hide the tab bar if only one tab is open
config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = false -- simpler, more minimal tab bar

-- =====================
-- Shell
-- =====================
if is_windows then
	config.default_prog = { "pwsh.exe", "-NoLogo" } -- PowerShell 7
else
	config.default_prog = { "/bin/zsh", "-l" }
end

-- =====================
-- Keybindings
-- =====================
local act = wezterm.action

-- Smart Ctrl+H/J/K/L: pass through to Neovim if it's the foreground process,
-- otherwise navigate WezTerm panes
local direction_keys = { h = "Left", j = "Down", k = "Up", l = "Right" }

local function split_nav(key)
	return {
		key = key,
		mods = "CTRL",
		action = wezterm.action_callback(function(win, pane)
			local proc = pane:get_foreground_process_info()
			local name = proc and proc.name or ""
			if name == "nvim" or name == "vim" then
				win:perform_action({ SendKey = { key = key, mods = "CTRL" } }, pane)
			else
				win:perform_action({ ActivatePaneDirection = direction_keys[key] }, pane)
			end
		end),
	}
end

config.keys = {
	-- Split panes
	-- { key = 'd', mods = 'CMD',       action = act.SplitHorizontal { domain = 'CurrentPaneDomain' } },
	-- { key = 'd', mods = 'CMD|SHIFT', action = act.SplitVertical { domain = 'CurrentPaneDomain' } },

	-- Smart Ctrl+H/J/K/L navigation (Neovim windows or WezTerm panes)
	split_nav("h"),
	split_nav("j"),
	split_nav("k"),
	split_nav("l"),

	-- Navigate panes (Vim-style, kept as fallback with CMD+SHIFT)
	{ key = "h", mods = "CMD|SHIFT", action = act.ActivatePaneDirection("Left") },
	{ key = "l", mods = "CMD|SHIFT", action = act.ActivatePaneDirection("Right") },
	{ key = "k", mods = "CMD|SHIFT", action = act.ActivatePaneDirection("Up") },
	{ key = "j", mods = "CMD|SHIFT", action = act.ActivatePaneDirection("Down") },

	-- Tabs
	{ key = "t", mods = "CMD", action = act.SpawnTab("CurrentPaneDomain") },
	{ key = "w", mods = "CMD", action = act.CloseCurrentTab({ confirm = false }) },

	-- Copy mode (Vim motions in scrollback)
	{ key = "f", mods = "CMD|SHIFT", action = act.ActivateCopyMode },

	-- Clear scrollback
	{ key = "k", mods = "CMD", action = act.ClearScrollback("ScrollbackAndViewport") },
}

-- =====================
-- Scrollback
-- =====================
config.scrollback_lines = 10000

-- =====================
-- Performance
-- =====================
config.animation_fps = 60
config.max_fps = 60

-- =====================
-- Bell
-- =====================
config.audible_bell = "Disabled"

-- =====================
-- Startup (maximize with padding)
-- =====================
wezterm.on("gui-startup", function(cmd)
	local tab, pane, window = wezterm.mux.spawn_window(cmd or {})
	local gui_win = window:gui_window()
	local screen = wezterm.gui.screens().active

	wezterm.sleep_ms(100) -- wait for window to finish initializing

	local h_padding = 10
	local v_padding = 10
	local mac_menu_bar_height = is_mac and 60 or 0

	gui_win:set_position(screen.x + h_padding, screen.y + v_padding + mac_menu_bar_height)
	gui_win:set_inner_size(screen.width - (h_padding * 2), screen.height - (v_padding * 2) - mac_menu_bar_height)
end)

return config
