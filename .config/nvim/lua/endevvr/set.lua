vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = true
vim.opt.ignorecase = true
vim.opt.incsearch = true
vim.opt.smartcase = true -- smart case

vim.opt.termguicolors = true
vim.opt.guifont = "monospace:h17" -- the font used in graphical neovim applications

vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.colorcolumn = "100"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

vim.opt.clipboard = "unnamedplus" -- allows neovim to access the system clipboard
vim.opt.mouse = "a" -- allow the mouse to be used in neovim
vim.opt.splitbelow = true -- force all horizontal splits to go below current window
vim.opt.splitright = true -- force all vertical splits to go to the right of current window
vim.opt.completeopt = { "menuone", "noselect" } -- mostly just for cmp
vim.opt.fileencoding = "utf-8" -- the encoding written to a file
vim.opt.nf = { "bin", "hex", "alpha" }
