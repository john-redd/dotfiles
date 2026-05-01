local claudecode_ok, claudecode = pcall(require, "claudecode")

if claudecode_ok then
  claudecode.setup({
    terminal = {
      provider = "none",
    },
  })

  local key_maps = {
    -- { "<leader>a", nil, desc = "AI/Claude Code" },
    { "<leader>ac", "<cmd>ClaudeCode<cr>",            desc = "[A]I [C]laude" },
    { "<leader>af", "<cmd>ClaudeCodeFocus<cr>",       desc = "[A]I [F]ocus Claude" },
    { "<leader>ar", "<cmd>ClaudeCode --resume<cr>",   desc = "[A]I [R]esume Claude" },
    { "<leader>aC", "<cmd>ClaudeCode --continue<cr>", desc = "[A]I [C]ontinue Claude" },
    { "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", desc = "[A]I Select Claude [m]odel" },
    { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>",       desc = "[A]I Add current [b]uffer" },
    { "<leader>as", "<cmd>ClaudeCodeSend<cr>",        mode = "v",                         desc = "[A]I [S]end to Claude" },
    -- Diff management
    { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>",  desc = "[A]I [A]ccept diff" },
    { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>",    desc = "[A]I [D]eny diff" },
  }

  for _, value in pairs(key_maps) do
    local mode = "n"
    if value.mode ~= nil then
      mode = value.mode
    end

    vim.keymap.set(mode, value[1], value[2], { desc = value.desc })
  end

  vim.api.nvim_create_autocmd("FileType", {
    pattern = { "NvimTree", "neo-tree", "oil", "minifiles", "netrw" }, -- Target filetype
    callback = function()
      -- Use buffer = true so the mapping is local to the current buffer
      vim.keymap.set("n", "<leader>as", "<cmd>ClaudeCodeTreeAdd<cr>", { buffer = true, desc = "Add file" })
    end,
  })
end
