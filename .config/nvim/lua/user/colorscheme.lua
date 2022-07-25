-- local colorscheme = "tokyonight"
-- local colorscheme = "darkplus"

-- Gruvbox --

local colorscheme = "gruvbox"
vim.o.background = "dark" -- or "light" for light mode
local gruvbox_status_ok, gruvbox = pcall(require, "gruvbox")
if not gruvbox_status_ok then
	return
end

gruvbox.setup({
	contrast = "soft",
	italic = false,
})

-- Monokai --

-- local colorscheme = "monokai_pro"
-- local monokai_status_ok, monokai = pcall(require, "monokai")
-- if not monokai_status_ok then
--   return
-- end

-- monokai.setup({})

local status_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
if not status_ok then
	return
end
