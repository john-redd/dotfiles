vim.g.mapleader = " "

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- next greatest remap ever : asbjornHaland
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])

-- This is going to get me cancelled
vim.keymap.set("i", "<C-c>", "<Esc>")
vim.keymap.set({ "n", "i" }, "<Esc>", "<Esc>")

vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")

-- vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
-- vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

vim.keymap.set("n", "<S-q>", "<cmd>Bdelete!<CR>")

vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

-- vim.keymap.set("n", "<C-J>", vim.cmd.cnext, { silent = true, remap = false })
-- vim.keymap.set("n", "<C-K>", vim.cmd.cprevious, { silent = true, remap = false })

vim.keymap.set("n", "<leader>C", CopyFilePathAbsolute, { silent = true, remap = false })
vim.keymap.set("n", "<leader>c", CopyFilePathRelative, { silent = true, remap = false })

vim.keymap.set("n", "<leader>lg", "<cmd>LazyGit<CR>", { silent = true, remap = false })
vim.keymap.set("n", "<leader>lf", "<cmd>LazyGitFilterCurrentFile<CR>", { silent = true, remap = false })

vim.keymap.set("n", "<leader>sdb", "<cmd>DBUIToggle<CR>", { silent = true, remap = false })

vim.keymap.set("n", "<leader>tl", "<cmd>lua require('telescope').extensions.git_worktree.git_worktrees()<CR>", { silent = true, remap = false })
vim.keymap.set("n", "<leader>ta", "<cmd>lua require('telescope').extensions.git_worktree.create_git_worktree()<CR>", { silent = true, remap = false })

