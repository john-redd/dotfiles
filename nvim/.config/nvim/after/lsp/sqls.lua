local lsp_module = require("endevvr.lsp_helpers")

return {
  on_attach = function (client, bufnr)
    lsp_module.on_attach(client, bufnr)
  end,
  settings = {},
}
