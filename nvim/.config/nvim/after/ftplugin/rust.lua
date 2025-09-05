local bufnr = vim.api.nvim_get_current_buf()
vim.highlight.priorities.semantic_tokens = 95 -- Or any number lower than 100, treesitter's priority level
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
