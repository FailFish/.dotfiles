local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  Packer_bootstrap = fn.system {
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
  use "lewis6991/impatient.nvim" -- cache/profiler for plugins in startup


  -- Editing Utilities --
  -- Even better than tpope's vim-commentary
  use {
    "numToStr/Comment.nvim",
    config = function()
        require("Comment").setup()
    end,
  }
  use "tpope/vim-surround"


  use "neovim/nvim-lspconfig" -- A collection of common configurations for nvim LSP.
  use "williamboman/nvim-lsp-installer"
  use "nvim-lua/lsp-status.nvim" -- statusline components from LSP

  use "simrat39/symbols-outline.nvim" -- Similar to Vista.vim, listing Tags

  use {
    "jose-elias-alvarez/null-ls.nvim",
    config = function ()
      require("null-ls").setup({ sources = require("user/lsp/null_ls") })
    end,
    requires = { "nvim-lua/plenary.nvim" },
  }
  -- use "rmagatti/goto-preview" -- preview function definitions in popups

  use {
    "ray-x/lsp_signature.nvim",
    config = function ()
      require("lsp_signature").setup {}
    end,
  } -- better function signature hint/hover
  -- use "ray-x/navigator.lua" -- better goto def, ref, overall navigation
  -- use "RishabhRD/nvim-lsputils"

  -- completion-related --
  use "hrsh7th/nvim-cmp" -- A completion engine
  use "hrsh7th/cmp-buffer" -- words completion from buffer
  use "hrsh7th/cmp-path" -- file path completion
  use "hrsh7th/cmp-nvim-lua" -- neovim lua-api completion
  use "hrsh7th/cmp-nvim-lsp" -- completion from lsp
  use "hrsh7th/cmp-nvim-lsp-document-symbol" -- completion from lsp
  use "hrsh7th/cmp-cmdline" -- completion for cmdline
  -- use "tzachar/cmp-tabnine" -- tabNine completion engine
  use "onsails/lspkind-nvim" -- adds vscode-like devicons besides completion items

  -- Snippets --
  use "L3MON4D3/LuaSnip" -- Snippet engine
  use "rafamadriz/friendly-snippets" -- Snippet supplier
  use "saadparwaiz1/cmp_luasnip" -- luasnip completion source for nvim-cmp

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

  -- git-related --
  use "TimUntersberger/neogit" -- magit of neovim
  use "sindrets/diffview.nvim" -- vimdiff for all modified files in a diffsplit.
  use "lewis6991/gitsigns.nvim" -- visual indicator for which lines have chagned since the last commit
  use "rhysd/git-messenger.vim"
  use "rhysd/committia.vim"
  use "ruifm/gitlinker.nvim" -- generate shareable file permalinks, :GBrowse
-- use "ThePrimeagen/git-worktree.nvim"


  -- colorschemes --
  use "sainnhe/gruvbox-material"
  -- use "folke/tokyonight.nvim"

  -- appearances --
  use "kyazdani42/nvim-web-devicons"
  -- use {
  --   "akinsho/bufferline.nvim",
  --   config = function ()
  --     require("bufferline").setup {
  --       mode = "tabs",
  --     }
  --   end,
  -- }
  -- use "romgrk/barbar.nvim"
  use { "feline-nvim/feline.nvim" }

  -- terminals --
  use "akinsho/toggleterm.nvim" -- persist and toggle multiple terminals during an editing session

  -- Workflows --
  use {
    "folke/trouble.nvim", -- A pretty list for showing diagnostics, references, telescope, qf, loclist
    config = function()
      require("trouble").setup {
        auto_preview = false,
        -- auto_fold = true,
      }
    end
  }

  use { "kevinhwang91/nvim-bqf", ft = "qf" } -- better quickfixes

  use {
    'goolord/alpha-nvim',
    requires = { 'kyazdani42/nvim-web-devicons' },
    config = function ()
        require'alpha'.setup(require'alpha.themes.startify'.config)
    end
  }

  use {
    "luukvbaal/nnn.nvim",
    config = function()
      require("nnn").setup {
        replace_netrw = "explorer",
      }
    end
  }

  use {
    "ahmedkhalf/project.nvim",
    config = function()
      require("project_nvim").setup {
        exclude_dirs = { "~/.dotfiles/*" },
        silent_chdir = false, -- verbose directory changing
      }
    end
  }

  use { "lervag/vimtex",
    config = function ()
      require("user/latex")
    end
  }



  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if Packer_bootstrap then
    require("packer").sync()
  end
end)

-- mfussenegger/nvim-dap
--   Debug Adapter Protocol client implemetentation
-- rcarriga/nvim-dap-ui
-- theHamsta/nvim-dap-virtual-text
-- mfussenegger/nvim-dap-python
-- nvim-telescope/telescope-dap.nvim
--
-- kyazdani42/nvim-tree.lua
--   A File Explorer
--
-- nvim-autopairs
--   automatic closing of brackets
--
-- folke/which-key.nvim
--   popup with possible key binds
--
-- andymass/vim-matchup
-- nvim-base16.lua
--   manages syntax colorscheme
-- nvim-colorizer.lua
--   highlight the colorcode text with the corresponding color
-- better-escape.nvim
-- lukas-reineke/indent-blankline.nvim
--   Indentation guide to all lines
-- neuron
-- neorg
-- iamcco/markdown-preview.nvim
-- folke/todo-comments.nvim

-- kdheepak/lazygit.nvim
--   plugin for calling lazygit from within neovim (lazygit must be installed)
