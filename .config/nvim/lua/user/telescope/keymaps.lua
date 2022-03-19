local map_tele = function(key, f, buffer)

  local mode = "n"
  local rhs = string.format('<cmd>lua require("telescope.builtin")["%s"]()<CR>', f)

  local map_options = {
    noremap = true,
    silent = true,
  }

  if not buffer then
    vim.api.nvim_set_keymap(mode, key, rhs, map_options)
  else
    vim.api.nvim_buf_set_keymap(0, mode, key, rhs, map_options)
  end
end

vim.api.nvim_set_keymap("c", "<c-r><c-r>", "<Plug>(TelescopeFuzzyCommandSearch)", { noremap = false, nowait = true })
vim.api.nvim_set_keymap("n", "<space>fe", ":Telescope file_browser<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<space>fp", ":Telescope projects<CR>", { noremap = true })

-- Dotfiles
-- map_tele("<leader>en", "edit_neovim")
-- map_tele("<leader>ez", "edit_zsh")

-- Search
-- grep_string: word under the cursor
-- live_grep: grep as you type
map_tele("<space>fgw", "grep_string")
map_tele("<space>flg", "live_grep")
map_tele("<space>fc", "current_buffer_fuzzy_find")

-- Files
-- fd == find_files
map_tele("<space>ff", "find_files")
map_tele("<space>fo", "oldfiles")

-- Git
map_tele("<space>gf", "git_files")
map_tele("<space>gs", "git_status")
map_tele("<space>gc", "git_commits")

-- Nvim
map_tele("<space>fb", "buffers")
map_tele("<space>fh", "help_tags")
map_tele("<space>fvo", "vim_options")
map_tele("<space>ft", "treesitter")
map_tele("<space>fT", "tags")

-- Telescope Meta
map_tele("<space>f<space>", "builtin")
map_tele("<space>f/", "keymaps")

return map_tele
