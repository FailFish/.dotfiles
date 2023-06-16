-- local parser_install_dir = vim.fn.stdpath("data") .. "/treesitters"
-- vim.fn.mkdir(parser_install_dir, "p")
-- vim.opt.runtimepath:append(parser_install_dir)

return {
  {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      { "nvim-treesitter/nvim-treesitter-textobjects" },
      { "nvim-treesitter/nvim-treesitter-context" },
    },
    opts = {
      -- <lang>.so parser precedence issue: https://github.com/nvim-treesitter/nvim-treesitter/issues/3092
      -- neovim >8.0 bundles {c, lua, help, vim} ts parsers.
      -- If you set the your own parser path, then plugin's parsers are preceded by neovim's.
      -- parser_install_dir = parser_install_dir,
      ensure_installed = {
        "bash",
        "c",
        "cpp",
        "cmake",
        "fish",
        -- "latex",
        "llvm",
        "lua",
        "make",
        "nix",
        "norg",
        "python",
        "rust",
        "zig",
      },
      sync_install = false,
      ignore_install = { "" }, -- List of parsers to ignore installing
      highlight = {
        enable = true, -- false will disable the whole extension
        disable = { "" }, -- list of language that will be disabled
        additional_vim_regex_highlighting = true,
      },
      matchup = {
        enable = true,
        disable = { "" },
      },
      textobjects = {
        move = {
          enable = true,
          set_jumps = true,

          goto_next_start = {
            ["]p"] = "@parameter.inner",
            ["]m"] = "@function.outer",
            ["]]"] = "@class.outer",
          },
          goto_next_end = {
            ["]M"] = "@function.outer",
            ["]["] = "@class.outer",
          },
          goto_previous_start = {
            ["[p"] = "@parameter.inner",
            ["[m"] = "@function.outer",
            ["[["] = "@class.outer",
          },
          goto_previous_end = {
            ["[M"] = "@function.outer",
            ["[]"] = "@class.outer",
          },
        },
        select = {
          enable = true,
          lookahead = true,

          keymaps = {
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",

            ["ac"] = "@conditional.outer",
            ["ic"] = "@conditional.inner",

            ["aa"] = "@parameter.outer",
            ["ia"] = "@parameter.inner",

            ["av"] = "@variable.outer",
            ["iv"] = "@variable.inner",
          },
        },
        -- swap keybinds?
      },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  },
}
