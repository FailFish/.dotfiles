require "user.options"
require "user.keymaps"
-- require "user.plugins"
require "user.colorscheme"
require "user.completion"
require "user.diagnostic"
require "user.lsp"
require "user.dap"
require "user.snip"
require "user.telescope"
require "user.git"
require "user.treesitter"
require "user.terminal"
require "user.disable_builtin"
require "user.feline"

require "impatient".enable_profile()


require("Comment").setup()
require("symbols-outline").setup {}
require("lsp_signature").setup {}
require("trouble").setup {
  auto_preview = false,
  -- auto_fold = true,
}
require'alpha'.setup(require'alpha.themes.startify'.config)
-- require("nnn").setup {
--   replace_netrw = "explorer",
-- }
require("project_nvim").setup {
  exclude_dirs = { "~/.dotfiles/*" },
  silent_chdir = false, -- verbose directory changing
}
require("user.latex")
