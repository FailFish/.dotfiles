local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  -- bootstrap lazy.nvim
  -- stylua: ignore
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable",
    lazypath })
end
vim.opt.rtp:prepend(lazypath)

-- any lua file under "user/plugins" will be merged into the main plugin spec
require("lazy").setup("user.plugins", {
  defaults = { lazy = false },
  checker = { enabled = false }, -- option for plugin update autocheck
  performance = {
    cache = { enabled = true },
    reset_packpath = false,
    rtp = {
      reset = false,
      disabled_plugins = {
        "2html_plugin",
        "getscript",
        "getscriptPlugin",
        "gzip",
        "logipat",
        "matchit",
        "netrw",
        "netrwFileHandlers",
        "netrwPlugin",
        "netrwSettings",
        "rplugin",
        "rrhelper",
        "spellfile_plugin",
        "tar",
        "tarPlugin",
        "tutor",
        "vimball",
        "vimballPlugin",
        "zip",
        "zipPlugin",
        -- "matchparen", -- bug https://www.reddit.com/r/neovim/comments/sabd7x/need_to_press_keymap_twice_to_bring_up_hover/
      },
    },
  },
  install = {
    missing = true,
    colorscheme = { "gruvbox-material", "tokyonight", "catpuccin" }
  },
  -- dev = { path = "~/dev" },
  -- ui = { border = "rounded" },
})
