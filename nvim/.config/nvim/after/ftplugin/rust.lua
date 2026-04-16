local bufnr = vim.api.nvim_get_current_buf()
vim.highlight.priorities.semantic_tokens = 100 -- Or any number lower than 100, treesitter's priority level
vim.api.nvim_set_hl(0, "@lsp.type.string.rust", {})

-- Highlight {variable} placeholders in format strings as white
local fmt_hl_ns = vim.api.nvim_create_namespace("rust_format_vars")
vim.api.nvim_set_hl(0, "RustFormatVar", { link = "@lsp.type.variable.rust" })

local fmt_query = vim.treesitter.query.parse("rust", [[
  (macro_invocation
    macro: [
      (identifier) @_macro
      (scoped_identifier name: (identifier) @_macro)
    ]
    (token_tree (string_literal (string_content) @fmt_str))
    (#match? @_macro "^(format|println|print|eprintln|eprint|write|writeln|format_args|panic|assert|debug|info|warn|error|trace)$"))
]])

local function apply_format_hl(buf)
  vim.api.nvim_buf_clear_namespace(buf, fmt_hl_ns, 0, -1)
  local ok, parser = pcall(vim.treesitter.get_parser, buf, "rust")
  if not ok then return end
  local tree = parser:parse()[1]
  if not tree then return end

  for id, node in fmt_query:iter_captures(tree:root(), buf, 0, -1) do
    if fmt_query.captures[id] == "fmt_str" then
      local row1, col1, row2, col2 = node:range()
      local lines = vim.api.nvim_buf_get_lines(buf, row1, row2 + 1, false)
      for i, line in ipairs(lines) do
        local row = row1 + i - 1
        local sc = (i == 1) and col1 or 0
        local ec = (i == #lines) and col2 or #line
        local seg = line:sub(sc + 1, ec)
        local off = 0
        while true do
          local s, e = seg:find("{[%w_][%w_%d]*}", off + 1)
          if not s then break end
          -- s=position of `{`, e=position of `}` (1-based)
          -- skip braces: start at s+1, end before e, convert to 0-based
          vim.api.nvim_buf_set_extmark(buf, fmt_hl_ns, row, sc + s, {
            end_col = sc + e - 1,
            hl_group = "RustFormatVar",
            priority = 200,
          })
          off = e
        end
      end
    end
  end
end

apply_format_hl(bufnr)
vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI", "BufEnter" }, {
  buffer = bufnr,
  callback = function() apply_format_hl(bufnr) end,
})
vim.keymap.set(
  "n",
  "<leader>ca",
  function()
    vim.cmd.RustLsp('codeAction') -- supports rust-analyzer's grouping
    -- or vim.lsp.buf.codeAction() if you don't want grouping.
  end,
  { silent = true, buffer = bufnr }
)
vim.keymap.set(
  "n",
  "K",  -- Override Neovim's built-in hover keymap with rustaceanvim's hover actions
  function()
    vim.cmd.RustLsp({'hover', 'actions'})
  end,
  { silent = true, buffer = bufnr, noremap = true }
)
