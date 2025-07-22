local lsp_module = require("endevvr.lsp_helpers")
require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = {
    "lua_ls",
    "rust_analyzer",
    "gopls",
    "tailwindcss",
  },
  automatic_enable = {
    exclude = {
      "denols"
    }
  }
})

vim.diagnostic.config({
  virtual_text = true,
})

vim.lsp.config('*', {
  on_attach = lsp_module.on_attach,
})

