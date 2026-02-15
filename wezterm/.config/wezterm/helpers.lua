local wezterm = require 'wezterm'

local function add_font_settings(config)
  config.font = wezterm.font 'MesloLGS NF'
  config.font_size = 16
  -- config.font = wezterm.font 'Departure Mono'
  -- config.font_size = 22
end

local function add_background_settings(config)
  config.window_background_opacity = 0.90
  config.macos_window_background_blur = 40
end

local function add_color_scheme_settings(config)
  -- config.color_scheme = 'Gruvbox dark, hard (base16)'
  -- config.color_scheme = 'GruvboxDarkHard'
    config.force_reverse_video_cursor = true
    config.colors = {
      foreground = "#dcd7ba",
      background = "#1f1f28",

      cursor_bg = "#c8c093",
      cursor_fg = "#c8c093",
      cursor_border = "#c8c093",

      selection_fg = "#c8c093",
      selection_bg = "#2d4f67",

      scrollbar_thumb = "#16161d",
      split = "#16161d",

      ansi = { "#090618", "#c34043", "#76946a", "#c0a36e", "#7e9cd8", "#957fb8", "#6a9589", "#c8c093" },
      brights = { "#727169", "#e82424", "#98bb6c", "#e6c384", "#7fb4ca", "#938aa9", "#7aa89f", "#dcd7ba" },
      indexed = { [16] = "#ffa066", [17] = "#ff5d62" },
    }
end

local function add_key_binding_settings(config)
  config.keys = {
    {
      key = 'Tab',
      mods = 'ALT',
      action = wezterm.action.DisableDefaultAssignment,
    },
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

local function apply_config(config)
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
