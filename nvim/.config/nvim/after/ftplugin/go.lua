-- %w and %t conflict with C-style size modifiers in the printf tree-sitter
-- grammar (both appear in `size: token(prec(1, ...))`) which prevents the
-- parser from recognizing them as format verbs. This covers that gap.
vim.api.nvim_set_hl(0, "GoFmtVerbW", { link = "@character.printf" })

local function apply()
  for _, m in ipairs(vim.fn.getmatches()) do
    if m.group == "GoFmtVerbW" then return end
  end
  -- In Vim regex magic mode, %[wt] is literal % followed by char class [wt]
  vim.fn.matchadd("GoFmtVerbW", "%[wt]", 110)
end

apply()

vim.api.nvim_create_autocmd("BufWinEnter", {
  buffer = vim.api.nvim_get_current_buf(),
  callback = apply,
})
