
-- app-specific terminals
-- local Terminal  = require('toggleterm.terminal').Terminal
--
-- local lazygit = Terminal:new({
--   cmd = "lazygit",
--   -- dir = "git_dir",
--   direction = "float",
--   float_opts = {
--     border = "double",
--   },
--   -- function to run on opening the terminal
--   on_open = function(term)
--     vim.cmd("startinsert!")
--     -- vim.api.nvim_buf_set_keymap( term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
--     vim.keymap.set("n", "q", "<cmd>close<CR>", { noremap = true, silent = true, buffer = term.bufnr })
--   end,
--   hidden = true,
--   -- function to run on closing the terminal
--   -- on_close = function(term)
--   --   vim.cmd("startinsert!")
--   -- end,
-- })

-- vim.keymap.set("n", "<leader>G", function()
--   lazygit:toggle()
-- end, { noremap = true, silent = true })

-- keybinds
function _G.set_terminal_keymaps()
  local opts = { buffer = 0 }
  vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], opts)
  -- vim.keymap.set('t', 'jk', [[<C-\><C-n>]], opts)
  vim.keymap.set("t", "<C-h>", [[<C-\><C-n><C-W>h]], opts)
  vim.keymap.set("t", "<C-j>", [[<C-\><C-n><C-W>j]], opts)
  vim.keymap.set("t", "<C-k>", [[<C-\><C-n><C-W>k]], opts)
  vim.keymap.set("t", "<C-l>", [[<C-\><C-n><C-W>l]], opts)
end

vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")
