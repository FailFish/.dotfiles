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

gitsigns.setup({
  numhl = true,
})

gitlinker.setup()

local keymap = vim.keymap.set
local opts = { silent = true }

neogit.setup({
  integrations = {
    diffview = true,
  },
})

keymap("n", "<space>Do", "<cmd>DiffviewOpen<CR>", opts)
keymap("n", "<space>G", "<cmd>Neogit<CR>", opts)
keymap("n", "<space>C", "<cmd>Neogit commit<CR>", opts)
