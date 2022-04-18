local opts = { silent = true }

local term_opts = { silent = true }

-- Shorten function name
local keymap = vim.keymap.set
-- nvim_set_keymap('n', ' <NL>', '', { nowait = true })
-- is equivalent to: nmap <nowait> <Space><NL> <Nop>

--Remap space as leader key
-- keymap("", "<Space>", "<Nop>", opts)
-- vim.g.mapleader = " "
-- vim.g.maplocalleader = " "

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

-- Better window navigation
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)

-- keymap("n", "<leader>e", ":Lex 30<cr>", opts)

-- navigation: 1D motions
keymap("n", "]b", ":bnext<CR>", opts)
keymap("n", "[b", ":bprev<CR>", opts)
keymap("n", "]q", ":cnext<CR>", opts)
keymap("n", "[q", ":cprev<CR>", opts)
keymap("n", "]l", ":lnext<CR>", opts)
keymap("n", "[l", ":lprev<CR>", opts)

keymap("n", "]e", ":move+<cr>", opts)
keymap("n", "[e", ":move-2<cr>", opts)
keymap("x", "]e", ":move'>+<cr>gv", opts)
keymap("x", "[e", ":move-2<cr>gv", opts)

-- break undo sequence before it erases a word/line; :h i_CTRL-G_U
keymap("i", "<C-W>", "<C-G>u<C-W>", opts)
keymap("i", "<C-U>", "<C-G>u<C-U>", opts)

-- Press jk fast to enter
-- keymap("i", "jk", "<ESC>", opts)

-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Indent without losing visual block
keymap("x", "<", "<gv", opts)
keymap("x", ">", ">gv", opts)

-- replacing text without overwriting the register
-- keymap("v", "p", '"_dP', opts)

-- Terminal --
-- Better terminal navigation
keymap("t", "<C-h>", "<C-\\><C-N><C-w>h", term_opts)
keymap("t", "<C-j>", "<C-\\><C-N><C-w>j", term_opts)
keymap("t", "<C-k>", "<C-\\><C-N><C-w>k", term_opts)
keymap("t", "<C-l>", "<C-\\><C-N><C-w>l", term_opts)


-- after you search the world, enter will clear the highlights
vim.cmd [[nnoremap <expr> <CR> {-> v:hlsearch ? ":nohl\<CR>" : "\<CR>"}() ]]
