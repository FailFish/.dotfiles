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
        -- neovim-bundled parsers
        "c",
        "lua",
        "vim",
        "vimdoc",
        "query",
        "markdown",
        "markdown_inline",
        -- non-bundled
        "bash",
        "cmake",
        "cpp",
        "fish",
        "json",
        -- "latex",
        "llvm",
        "make",
        "nix",
        "norg",
        "python",
        "rust",
        "toml",
        "zig",
      },
      sync_install = false,
      ignore_install = { "" }, -- List of parsers to ignore installing
      highlight = {
        enable = true, -- false will disable the whole extension
        disable = function(lang, buf)
          local max_filesize = 100 * 1024 -- 100 KB
          local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
          if ok and stats and stats.size > max_filesize then
            return true
          end
        end,
        additional_vim_regex_highlighting = false,
      },
      textobjects = { enable = false },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  },
}
