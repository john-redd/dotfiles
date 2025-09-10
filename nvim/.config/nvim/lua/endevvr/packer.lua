local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
    vim.cmd([[packadd packer.nvim]])
    return true
  end
  return false
end

local packer_bootstrap_ok = pcall(ensure_packer)

if not packer_bootstrap_ok then
  return
end

return require("packer").startup(function(use)
  -- Packer can manage itself
  use("wbthomason/packer.nvim")

  -- Telescope
  use({
    "nvim-telescope/telescope.nvim",
    tag = "0.1.8",
    requires = { { "nvim-lua/plenary.nvim" } },
  })
  use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make", cond = vim.fn.executable("make") == 1 })

  -- Colorchemes
  use("shaunsingh/nord.nvim")
  use("sainnhe/gruvbox-material")
  use("luisiacc/gruvbox-baby")
  use("folke/tokyonight.nvim")
  use("ellisonleao/gruvbox.nvim")
  use("tanvirtin/monokai.nvim")
  use("rebelot/kanagawa.nvim")

  -- use({
  --   "catppuccin/nvim",
  --   as = "cappuccin",
  --   run = ":CatppuccinCompile",
  -- })
  use("sainnhe/everforest")

  -- Treesitter
  use({ "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" })
  use("nvim-treesitter/playground")
  use({
    "nvim-treesitter/nvim-treesitter-textobjects",
    after = "nvim-treesitter",
  })
  use("nvim-treesitter/nvim-treesitter-context")

  -- Git
  use("kdheepak/lazygit.nvim")
  use("lewis6991/gitsigns.nvim")
  -- use("ThePrimeagen/git-worktree.nvim")
  use("pwntester/octo.nvim")
  use("tpope/vim-fugitive")

  use("numToStr/Comment.nvim")

  -- LSP
  use({ "neovim/nvim-lspconfig" })
  use({ "williamboman/mason.nvim" })
  use({ "williamboman/mason-lspconfig.nvim" })
  use({ "dense-analysis/ale" })
  use({ "folke/lazydev.nvim" })

  -- Autocompletion
  use({ 'saghen/blink.cmp' }, {
    requires = {
      dependencies = { 'rafamadriz/friendly-snippets' }
    }
  })

  -- DAP
  use({ "mfussenegger/nvim-dap" })
  use({ "rcarriga/nvim-dap-ui", requires = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" } })
  use("theHamsta/nvim-dap-virtual-text")
  use("leoluz/nvim-dap-go")
  use({ "mxsdev/nvim-dap-vscode-js", requires = { "mfussenegger/nvim-dap" } })

  -- GoLang
  use({ 'ray-x/go.nvim' })
  use({ 'ray-x/guihua.lua', run = 'cd lua/fzy && make' })

  -- Rust
  use({ 'mrcjkb/rustaceanvim' })
  use({ 'saecki/crates.nvim' })

  -- Utility
  use("folke/todo-comments.nvim")
  use("folke/snacks.nvim")
  use("theprimeagen/harpoon")
  use("mbbill/undotree")
  use({ "windwp/nvim-autopairs" })
  use({
    "Pocco81/true-zen.nvim",
  })
  use("moll/vim-bbye")
  use("stevearc/oil.nvim")
  use({
    "nvim-tree/nvim-tree.lua",
    requires = {
      "nvim-tree/nvim-web-devicons",
    },
  })
  use({
    'nvim-lualine/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true }
  })
  use("tpope/vim-dadbod")
  use("kristijanhusak/vim-dadbod-ui")
  use("kristijanhusak/vim-dadbod-completion")
  use("stevearc/aerial.nvim")

  -- use("github/copilot.vim")
  use("zbirenbaum/copilot.lua")

  -- Misc
  use("renerocksai/telekasten.nvim")
  use("chrisbra/csv.vim")
  use("goolord/alpha-nvim")
  use("ahmedkhalf/project.nvim")
  use('xiyaowong/nvim-transparent')
  use({ 'toppair/peek.nvim', run = 'deno task --quiet build:fast' })
  use('christoomey/vim-tmux-navigator')
  use("Canop/nvim-bacon")
end)
