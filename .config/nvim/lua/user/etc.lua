require("Comment").setup()
require("symbols-outline").setup({})
require("lsp_signature").setup({})
require("trouble").setup({
  auto_preview = false,
  -- auto_fold = true,
})

require("alpha").setup(require("alpha.themes.startify").config)

require("project_nvim").setup({
  exclude_dirs = { "~/.dotfiles/*" },
  silent_chdir = false, -- verbose directory changing
})

-- vim-matchup
vim.g.matchup_surround_enabled = 1
vim.g.matchup_override_vimtex = 1
vim.g.matchup_matchparen_deferred = 1
-- vim.g.matchup_matchparen_enabled = 0

-- require("nnn").setup {
--   replace_netrw = "explorer",
-- }
