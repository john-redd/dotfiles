-- Configuration goes here.
local g = vim.g

g.ale_linters_explicit = 1
g.ale_fix_on_save = 1

g.ale_fixers = {
  typescript = { 'prettier' },
  javascript = { 'prettier' },
  css = { 'prettier' }
}
