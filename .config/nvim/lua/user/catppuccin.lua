local catppuccin_status_ok, catppuccin = pcall(require, "catppuccin")

if not catppuccin_status_ok then
	return
end

vim.g.catppuccin_flavour = "frappe" -- latte, frappe, macchiato, mocha

catppuccin.setup({
	transparent_background = true,
	integrations = {
		cmp = true,
		gitsigns = true,
		telescope = true,
		treesitter = true,
		nvimtree = true,
	},
})
