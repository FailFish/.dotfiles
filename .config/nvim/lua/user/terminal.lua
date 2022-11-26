local ok, toggleterm = pcall(require, "toggleterm")
if not ok then
  return
end

toggleterm.setup({
  -- size can be a number or function which is passed the current terminal
  size = 20,
  -- size = function(term)
  --   if term.direction == "horizontal" then
  --     return 15
  --   elseif term.direction == "vertical" then
  --     return vim.o.columns * 0.4
  --   end
  -- end,
  open_mapping = [[<c-\>]],
  hide_numbers = true, -- hide the number column in toggleterm buffers
  shade_filetypes = {},
  shade_terminals = true,
  start_in_insert = true,
  insert_mappings = true, -- whether or not the open mapping applies in insert mode
  terminal_mappings = true, -- whether or not the open mapping applies in the opened terminals
  persist_size = true,
  direction = "float",
  close_on_exit = true, -- close the terminal window when the process exits
  shell = vim.o.shell, -- change the default shell
  -- This field is only relevant if direction is set to 'float'
  float_opts = {
    border = "curved",
    -- border = 'single' | 'double' | 'shadow' | 'curved' | ... other options supported by win open
    winblend = 5,
  },
})

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
