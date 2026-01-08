local aerial_ok, aerial = pcall(require, "aerial")

if aerial_ok then
  aerial.setup({
    backends = { "lsp", "treesitter", "markdown", "asciidoc", "man" },
    filter_kind = {
      ["_"] = {
        "Class",
        "Constructor",
        "Enum",
        "Function",
        "Interface",
        "Module",
        "Method",
        "Struct",
      },
      markdown = false
    },
  })
  vim.keymap.set("n", "<leader>a", "<cmd>AerialToggle!<CR>")
end
