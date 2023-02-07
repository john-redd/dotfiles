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
    tag = "0.1.0",
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
  use("folke/tokyonight.nvim")
  use({
    "rose-pine/neovim",
    as = "rose-pine",
  })
  use({
    "catppuccin/nvim",
    as = "cappuccin",
    run = ":CatppuccinCompile",
  })

  -- Treesitter
  use({ "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" })
  use("nvim-treesitter/playground")
  use({
    "nvim-treesitter/nvim-treesitter-textobjects",
    after = "nvim-treesitter",
  })

  -- Git
  use("tpope/vim-fugitive")
  use("kdheepak/lazygit.nvim")
  use("lewis6991/gitsigns.nvim")

  use("numToStr/Comment.nvim")

  -- LSP
  use({
    "VonHeikemen/lsp-zero.nvim",
    requires = {
      -- LSP Support
      { "neovim/nvim-lspconfig" },
      { "williamboman/mason.nvim" },
      { "williamboman/mason-lspconfig.nvim" },

      -- Formatters
      { "jose-elias-alvarez/null-ls.nvim" },

      -- Autocompletion
      { "hrsh7th/nvim-cmp" },
      { "hrsh7th/cmp-buffer" },
      { "hrsh7th/cmp-path" },
      { "saadparwaiz1/cmp_luasnip" },
      { "hrsh7th/cmp-nvim-lsp" },
      { "hrsh7th/cmp-nvim-lua" },

      -- Snippets
      { "L3MON4D3/LuaSnip" },
      { "rafamadriz/friendly-snippets" },
    },
  })

  -- Utility
  use("theprimeagen/harpoon")
  use("mbbill/undotree")
  use({ "windwp/nvim-autopairs" })
  use("folke/zen-mode.nvim")
  use("moll/vim-bbye")
  use({
    "nvim-tree/nvim-tree.lua",
    requires = {
      "nvim-tree/nvim-web-devicons",
    },
    tag = "nightly",
  })
  -- use("github/copilot.vim")

  -- Misc
  use("renerocksai/telekasten.nvim")
  use("chrisbra/csv.vim")
  use("goolord/alpha-nvim")
  use("ahmedkhalf/project.nvim")
end)
