local wezterm = require 'wezterm'

local function add_font_settings(config)
  config.font = wezterm.font 'MesloLGS NF'
  config.font_size = 15
end

local function add_background_settings(config)
  config.window_background_opacity = 0.65
  config.macos_window_background_blur = 40
end

local function add_color_scheme_settings(config)
  -- config.color_scheme = 'Gruvbox dark, hard (base16)'
  config.color_scheme = 'GruvboxDarkHard'
end

local function add_key_binding_settings(config)
  config.keys = {
    {
      key = 'm',
      mods = 'CMD',
      action = wezterm.action.DisableDefaultAssignment,
    },
    {
      key = 'h',
      mods = 'CMD',
      action = wezterm.action.DisableDefaultAssignment,
    },
    {
      key = 'f',
      mods = 'CMD',
      action = wezterm.action.DisableDefaultAssignment,
    },
    {
      key = 'z',
      mods = 'CTRL',
      action = wezterm.action.DisableDefaultAssignment,
    },
  }
end

local function add_general_settings(config)
  config.enable_tab_bar = false
end

local function apply_config (config)
  add_general_settings(config)
  add_font_settings(config)
  add_background_settings(config)
  add_color_scheme_settings(config)
  add_key_binding_settings(config)
end

local Module = {
  apply_config = apply_config,
}

return Module
