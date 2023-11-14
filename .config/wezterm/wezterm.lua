-- Pull in the wezterm API
local wezterm = require 'wezterm'
local helpers = require 'helpers'

-- This table will hold the configuration.
local config = {}

if wezterm.config_builder then
  config = wezterm.config_builder()
end

helpers.apply_config(config)

-- and finally, return the configuration to wezterm
return config

