require("Comment").setup()
require("symbols-outline").setup({})
vim.keymap.set("n", "<space>st", ":SymbolsOutline<CR>", { desc = "SymbolTree", silent = true })
require("lsp_signature").setup({})
require("trouble").setup({
  auto_preview = false,
  -- auto_fold = true,
})

require("alpha").setup(require("alpha.themes.startify").config)

require("neorg").setup({
  load = {
    ["core.defaults"] = {},
    ["core.norg.completion"] = {
      config = {
        engine = "nvim-cmp",
      }
    },
    ["core.norg.concealer"] = {},
  }
})

-- vim-matchup
vim.g.matchup_surround_enabled = 1
vim.g.matchup_override_vimtex = 1
vim.g.matchup_matchparen_deferred = 1
vim.g.matchup_matchparen_offscreen = {}
-- vim.g.matchup_matchparen_enabled = 0

-- require("nnn").setup {
--   replace_netrw = "explorer",
-- }
