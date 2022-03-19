local status_ok, gitsigns = pcall(require, "gitsigns")
if not status_ok then
  return
end

local status_ok, gitlinker = pcall(require, "gitlinker")
if not status_ok then
  return
end

local ok, neogit = pcall(require, "neogit")
if not ok then
  return
end

gitsigns.setup {
  numhl = true,
}

gitlinker.setup()

local keymap = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

neogit.setup {
  integrations = {
    diffview = true,
  },
}

keymap("n", "<space>Do", ":DiffviewOpen<CR>", opts)
keymap("n", "<space>G", ":Neogit<CR>", opts)
keymap("n", "<space>C", ":Neogit commit<CR>", opts)
