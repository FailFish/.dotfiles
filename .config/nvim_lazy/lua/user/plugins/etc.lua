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
      { "<leader>ct", "<cmd>lua require(\"crates\").toggle()<cr>" },
      -- { "<leader>cr", require("crates").reload() },
      --
      -- { "<leader>cv", require("crates").show_versions_popup() },
      -- { "<leader>cf", require("crates").show_features_popup },
      -- { "<leader>cd", require("crates").show_dependencies_popup },
      --
      -- { "<leader>cu", require("crates").update_crate },
      -- { "<leader>cu", require("crates").update_crates },
      -- { "<leader>ca", require("crates").update_all_crates },
      -- { "<leader>cU", require("crates").upgrade_crate },
      -- { "<leader>cU", require("crates").upgrade_crates },
      -- { "<leader>cA", require("crates").upgrade_all_crates },
      --
      -- { "<leader>cH", require("crates").open_homepage },
      -- { "<leader>cR", require("crates").open_repository },
      -- { "<leader>cD", require("crates").open_documentation },
      -- { "<leader>cC", require("crates").open_crates_io },
    },
    opts = {
      null_ls = {
        enable = true,
        name = "Crates",
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

      vim.keymap.set("n", "K", show_documentation, { silent = true }) -- TODO: how about 'keys'?

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
