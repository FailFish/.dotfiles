if vim.g.snippets ~= "luasnip" then
  return
end

local ls = require "luasnip"
local types = require "luasnip.util.types"

ls.config.set_config {
  -- This tells LuaSnip to remember to keep around the last snippet.
  -- You can jump back into it even if you move outside of the selection
  -- history = true,

  -- This one is cool cause if you have dynamic snippets, it updates as you type!
  updateevents = "TextChanged,TextChangedI",

  -- Autosnippets:
  -- enable_autosnippets = true,

  -- Crazy highlights!!
  ext_opts = {
    [types.choiceNode] = {
      active = {
        virt_text = { { "<-", "Error" } },
      },
    },
    [types.insertNode] = {
      active = {
        virt_text = {{"●", "GruvboxBlue"}}
      }
    }
  },
}

vim.cmd [[
  imap <silent><expr> <c-k> luasnip#expand_or_jumpable() ? '<Plug>luasnip-expand-or-jump' : ''
  inoremap <silent> <c-j> <cmd>lua require('luasnip').jump(-1)<CR>
  imap <silent><expr> <C-l> luasnip#choice_active() ? '<Plug>luasnip-next-choice' : '<C-l>'
  snoremap <silent> <c-k> <cmd>lua require('luasnip').jump(1)<CR>
  snoremap <silent> <c-j> <cmd>lua require('luasnip').jump(-1)<CR>
]]

-- vim.keymap is added 0.7 version --
-- equivalent of vim.cmd line right above.

-- <c-k> is my expansion key
-- this will expand the current item or jump to the next item within the snippet.
-- vim.keymap.set({ "i", "s" }, "<c-k>", function()
--   if ls.expand_or_jumpable() then
--     ls.expand_or_jump()
--   end
-- end, { silent = true })
--
-- -- <c-j> is my jump backwards key.
-- -- this always moves to the previous item within the snippet
-- vim.keymap.set({ "i", "s" }, "<c-j>", function()
--   if ls.jumpable(-1) then
--     ls.jump(-1)
--   end
-- end, { silent = true })
--
-- -- <c-l> is selecting within a list of options.
-- -- This is useful for choice nodes (introduced in the forthcoming episode 2)
-- vim.keymap.set("i", "<c-l>", function()
--   if ls.choice_active() then
--     ls.change_choice(1)
--   end
-- end)

-- shorcut to source my luasnips file again, which will reload my snippets
-- vim.keymap.set("n", "<leader><leader>s", "<cmd>source ~/.config/nvim/after/plugin/luasnip.lua<CR>")
