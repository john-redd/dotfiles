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
}
)

local ale_fix_file_types = {}

for filetype, fixers in pairs(vim.g.ale_fixers) do
  for _index, value in ipairs(fixers) do
    if value == 'prettier' then
      table.insert(ale_fix_file_types, filetype)
      goto continue
    end
    ::continue::
  end
end

vim.diagnostic.config({
  virtual_text = true,
})

vim.lsp.config('*', {
  on_attach = lsp_module.on_attach,
})

