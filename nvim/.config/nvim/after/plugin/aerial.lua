local aerial_ok, aerial = pcall(require, "aerial")

if aerial_ok then
  aerial.setup({
    backends = { "lsp", "treesitter", "markdown", "asciidoc", "man" },
  })
  vim.keymap.set("n", "<leader>a", "<cmd>AerialToggle!<CR>")
end
