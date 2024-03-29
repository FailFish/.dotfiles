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
    -- [types.insertNode] = {
    --   active = {
    --     virt_text = {{"[I]", "Blue"}}
    --   }
    -- }
  },
}

-- load vscode-type snippets
require("luasnip/loaders/from_vscode").lazy_load()

-- vim.keymap is added 0.7 version --
-- equivalent of vim.cmd line right above.

-- this will expand the current item or jump to the next item within the snippet.
-- Snippet Node Jump Forward
vim.keymap.set({ "i", "s" }, "<c-j>", function()
  if ls.expand_or_jumpable() then
    ls.expand_or_jump()
  end
end, { silent = true, desc = "LuaSnip: snippetNode jump forward" })

-- Snippet Node Jump Backward
vim.keymap.set({ "i", "s" }, "<c-k>", function()
  if ls.jumpable(-1) then
    ls.jump(-1)
  end
end, { silent = true, desc = "LuaSnip: snippetNode jump backward" })

-- -- <c-l> is selecting within a list of options.
-- -- This is useful for choice nodes (introduced in the forthcoming episode 2)
vim.keymap.set("i", "<c-l>", function()
  if ls.choice_active() then
    ls.change_choice(1)
  end
end, { desc = "LuaSnip: change choices for the choiceNode" })

-- shorcut to source my luasnips file again, which will reload my snippets
-- vim.keymap.set("n", "<leader><leader>s", "<cmd>source ~/.config/nvim/after/plugin/luasnip.lua<CR>")
