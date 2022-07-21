local null_ls_status_ok, null_ls = pcall(require, "null-ls")
if not null_ls_status_ok then
  return
end

-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins
local formatting = null_ls.builtins.formatting
local code_actions = null_ls.builtins.code_actions
local diagnostics = null_ls.builtins.diagnostics

null_ls.setup {
  debug = false,
  sources = {
    formatting.gofmt,
    formatting.goimports,
    formatting.pint.with({
      command = "pint"
    }),
    formatting.prettierd,
    -- formatting.eslint_d,
    formatting.prismaFmt,
    formatting.stylua,

    code_actions.eslint_d,
    code_actions.refactoring,

    -- diagnostics.codespell, -- needs to be installed with pip
    diagnostics.eslint_d,
    -- diagnostics.phpstan.with({
    --   args = { "analyze", "--level", "6", "--error-format", "json", "--no-progress", "$FILENAME" }
    -- }),
  },
}
