return {
  { "nvim-lua/plenary.nvim", lazy = true },
  { "nvim-lua/popup.nvim",   lazy = true },
  -- { "lewis6991/impatient.nvim", lazy = true },
  {
    "dstein64/vim-startuptime",
    cmd = "StartupTime",
    config = function()
      vim.g.startuptime_tries = 10
    end,
  },

  {
    "glacambre/firenvim",
    -- Lazy load firenvim
    -- Explanation: https://github.com/folke/lazy.nvim/discussions/463#discussioncomment-4819297
    cond = not not vim.g.started_by_firenvim,
    build = function()
      require("lazy").load({ plugins = "firenvim", wait = true })
      vim.fn["firenvim#install"](0)
    end,
  },

  {
    "nvim-neorg/neorg",
    ft = "norg",
    opts = {
      load = {
        ["core.defaults"] = {},
        ["core.norg.completion"] = {
          config = {
            engine = "nvim-cmp",
          },
        },
        ["core.norg.concealer"] = {},
      },
    },
    config = function(_, opts)
      require("neorg").setup(opts)
    end,
  },
  {
    "lervag/vimtex",
    ft = { "tex" },
    keys = {
      -- avoid overriding w/ lsp.hover
      { "<localleader>ld", "<plug>(vimtex-doc-package)", buffer = true },
    },
    config = function()
      vim.g.vimtex_view_forward_search_on_start = 0
      vim.g.vimtex_view_method = "sioyek"
      vim.g.vimtex_compiler_latexmk = {
        build_dir = "build",
      }
    end,
  },
  {
    "LnL7/vim-nix",
    ft = "nix",
  },
  {
    "saecki/crates.nvim",
    event = { "BufRead Cargo.toml" },
    keys = {
      -- stylua: ignore start
      { "<leader>ct", function() require("crates").toggle() end, desc = "Crates Toggle" },
      { "<leader>cr", function() require("crates").reload() end , desc = "Crates Reload" },
      { "<leader>cv", function() require("crates").show_versions_popup() end, desc = "Crates: Show Versions" },
      { "<leader>cd", function() require("crates").show_dependencies_popup() end, desc = "Crates: Show Dependencies" },
      { "<leader>cF", function() require("crates").show_features_popup() end, desc = "Crates: Show Features" },
      { "<leader>cR", function() require("crates").open_repository() end, desc = "Crates: Open Repo"   },
      { "<leader>cD", function() require("crates").open_documentation() end, desc = "Crates: Open Docs"   },
      { "<leader>cC", function() require("crates").open_crates_io() end, desc = "Crates: Open crates.io"   },
      -- Code Action: update/upgrade (single/multiple) crates
      -- stylua: ignore end
    },
    opts = {
      null_ls = {
        enabled = true,
        name = "crates.nvim",
      },
    },
    config = function(_, opts)
      local function show_documentation()
        local filetype = vim.bo.filetype
        if vim.tbl_contains({ "vim", "help" }, filetype) then
          vim.cmd("h " .. vim.fn.expand("<cword>"))
        elseif vim.tbl_contains({ "man" }, filetype) then
          vim.cmd("Man " .. vim.fn.expand("<cword>"))
        elseif vim.fn.expand("%:t") == "Cargo.toml" and require("crates").popup_available() then
          require("crates").show_popup()
        else
          vim.lsp.buf.hover()
        end
      end

      vim.keymap.set("n", "K", show_documentation, { noremap = true, silent = true }) -- TODO: how about 'keys'?

      vim.api.nvim_create_autocmd("BufRead Cargo.toml", {
        group = vim.api.nvim_create_augroup("CmpSourceCargo", { clear = true }),
        pattern = "Cargo.toml",
        callback = function()
          require("cmp").setup.buffer({ sources = { { name = "crates" } } })
        end,
      })

      require("crates").setup(opts)
    end,
  },
}
