local wezterm = require("wezterm")

local config = wezterm.config_builder()

config.font = wezterm.font("Fira Code", { weight = "Bold" })

config.font_size = 14.0

config.color_scheme = "Catppuccin Frappe"

config.enable_tab_bar = false

local action = wezterm.action

config.keys = {
	-- Natural text editing
	{ mods = "CMD", key = "Backspace", action = action.SendKey({ mods = "CTRL", key = "u" }) },
	{ mods = "OPT", key = "LeftArrow", action = action.SendKey({ mods = "ALT", key = "b" }) },
	{ mods = "OPT", key = "RightArrow", action = action.SendKey({ mods = "ALT", key = "f" }) },
	{ mods = "CMD", key = "LeftArrow", action = action.SendKey({ mods = "CTRL", key = "a" }) },
	{ mods = "CMD", key = "RightArrow", action = action.SendKey({ mods = "CTRL", key = "e" }) },
}
-- Hyperlinks
--
config.hyperlink_rules = wezterm.default_hyperlink_rules()
return config
