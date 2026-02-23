local lsp_module = require("endevvr.lsp_helpers")
require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = {
    "lua_ls",
    "gopls",
    "tailwindcss",
    "ts_ls",
    "docker_compose_language_service",
    "dockerls",
    "html",
  },
  automatic_enable = {
    exclude = {
      "denols",
      "rust_analyzer"
    }
  }
})

-- Install manually
-- prettierd
-- eslint_d
-- codelldb
-- delve

vim.diagnostic.config({
  virtual_text = true,
})

vim.lsp.config('*', {
  on_attach = lsp_module.on_attach,
})
