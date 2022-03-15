local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system {
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/wbthomason/packer.nvim",
    install_path,
  }
  print "Installing packer close and reopen Neovim..."
  vim.cmd [[packadd packer.nvim]]
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
-- TODO: this may be replaced with nvim_create_autocmd() in 0.7.x
vim.cmd [[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]]

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
  return
end

-- Have packer use a popup window instead of a split
packer.init {
  display = {
    open_fn = function()
      return require("packer.util").float { border = "rounded" }
    end,
  },
}

-- Install your plugins here
return packer.startup(function(use)
  use "wbthomason/packer.nvim" -- Have packer manage itself
  use "nvim-lua/plenary.nvim" -- lua functions
  use "nvim-lua/popup.nvim" -- lua functions for popup API from vim


  use "neovim/nvim-lspconfig" -- A collection of common configurations for nvim LSP.
  -- use "williamboman/nvim-lsp-installer"
  -- use "tamago324/nlsp-settings.nvim"
  -- use "ray-x/lsp-signature.nvim" -- function signature hint/hover
  --
  -- use "simrat39/symbols-outline.nvim"
  -- use "rmagatti/goto-preview" -- preview function definitions in popups
  -- use "jose-elias-alvarez/null-ls.nvim"
  -- use "ahmedkhalf/project.nvim" -- project directory management
  --
  -- use "ray-x/navigator.lua"
  -- use "RishabhRD/nvim-lsputils"

  -- completion-related --
  -- use "hrsh7th/nvim-cmp" -- A completion engine
  -- use "hrsh7th/cmp-buffer" -- words completion from buffer
  -- use "hrsh7th/cmp-path" -- file path completion
  -- use "hrsh7th/cmp-nvim-lua" -- neovim lua-api completion
  -- use "hrsh7th/cmp-nvim-lsp" -- completion from lsp
  -- use "hrsh7th/cmp-nvim-lsp-document-symbol" -- completion from lsp
  -- use "hrsh7th/cmp-cmdline" -- completion for cmdline
  -- use "lukas-reineke/cmp-under-comparator" -- better sort on completion times
  -- use "tzachar/cmp-tabnine" -- tabNine completion engine
  -- use "onsails/lspkind-nvim" -- adds vscode-like devicons besides completion items

  -- Snippets --
  -- use "L3MON4D3/LuaSnip" -- Snippet engine
  -- use "rafamadriz/friendly-snippets" -- Snippet supplier
  -- use "saadparwaiz1/cmp_luasnip" -- luasnip completion source for nvim-cmp

  -- telescope --
  use {
    "nvim-telescope/telescope.nvim",
    requires = { "nvim-lua/plenary.nvim" }
  }

  use {
    "nvim-telescope/telescope-fzf-native.nvim",
    run = "make"
  }
  use { "nvim-telescope/telescope-file-browser.nvim" }

  use {
    "nvim-treesitter/nvim-treesitter",
    run = ":TSUpdate"
  }
  -- use "nvim-treesitter/playground"

  -- colorschemes --
  use "ellisonleao/gruvbox.nvim"
  use "luisiacc/gruvbox-baby"


  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require("packer").sync()
  end
end)

-- 
-- folke/trouble.nvim
--   A pretty list fro showing diagnostics, references, telescope, qf, loclist
-- nvim-bqf
-- nvim-pqf
-- 
-- mfussenegger/nvim-dap
--   Debug Adapter Protocol client implemetentation
-- rcarriga/nvim-dap-ui
-- theHamsta/nvim-dap-virtual-text
-- mfussenegger/nvim-dap-python
-- nvim-telescope/telescope-dap.nvim
-- 
-- numToStr/Comment.nvim
--   Even better than tpope's vim-commentary
-- 
-- kyazdani42/nvim-tree.lua
--   A File Explorer
-- 
-- 
-- nvim-autopairs
--   automatic closing of brackets
-- 
-- gitsigns.nvim
--   visual indicator for which lines have chagned since the last commit
-- ThePrimeagen/git-worktree.nvim
-- ruifm/gitlinker.nvim
--   generate shareable file permalinks, :GBrowse
-- TimUntersberger/neogit
--   magit of neovim
-- sindrets/diffview.nvim
--   vimdiff for all modified files in a diffsplit.
-- 
-- folke/which-key.nvim
--   popup with possible key binds
-- 
-- barbar.nvim
-- 
-- lualine
--   statusline plugin
-- 
-- toggleterm.nvim
--   persist and toggle multiple terminals during an editing session
-- 
-- dashboard-nvim
--   start screen with useful options
-- 
-- andymass/vim-matchup
-- 
-- nvim-base16.lua
--   manages syntax colorscheme
-- nvim-colorizer.lua
--   highlight the colorcode text with the corresponding color
-- nvim-web-devicons
--   Icons fro use with some plugins
-- 
-- better-escape.nvim
-- 
-- bufferline.nvim
--   topbar bufferline
-- 
-- feline.nvim
--   statusline
-- 
-- lukas-reineke/indent-blankline.nvim
--   Indentation guide to all lines
-- 
-- neuron
-- neorg
-- iamcco/markdown-preview.nvim
-- folke/todo-comments.nvim
-- 
-- akinsho/nvim-bufferline.lua
-- 
-- akinsho/toggleterm.nvim
-- voldikss/vim-floaterm
-- kdheepak/lazygit.nvim
--   plugin for calling lazygit from within neovim (lazygit must be installed)
