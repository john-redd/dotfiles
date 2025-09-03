local lsp_module = require('endevvr.lsp_helpers')

local links = {
  ["@lsp.type.variable.rust"] = "@variable",
}

for newgroup, oldgroup in pairs(links) do
  vim.api.nvim_set_hl(0, newgroup, { link = oldgroup, default = true })
end

vim.g.rustaceanvim = {
  server = {
    on_attach = function(client, bufnr)
      lsp_module.on_attach(client, bufnr)
    end,
    default_settings = {
      -- rust-analyzer language server configuration
      ['rust-analyzer'] = {
        inlayHints = {
          typeHints = { enable = false },
          parameterHints = { enable = false },
          chainingHints = { enable = false },
          closingBraceHints = { enable = false },
        },
        checkOnSave = {
          enable = true,
        },
        check = {
          command = "clippy",
        },
        imports = {
          group = {
            enable = false,
          },
        },
      },
    },
  },
}
