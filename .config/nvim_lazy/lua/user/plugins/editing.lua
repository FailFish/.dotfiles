return {
  {
    "andymass/vim-matchup",
    init = function()
      vim.g.matchup_surround_enabled = 1
      vim.g.matchup_override_vimtex = 1
      vim.g.matchup_matchparen_deferred = 1
      vim.g.matchup_matchparen_offscreen = {}
      -- vim.g.matchup_matchparen_enabled = 0
    end,
  },

  {
    "numToStr/Comment.nvim",
    config = function()
      require("Comment").setup()
    end,
  },

  { "AndrewRadev/splitjoin.vim" },
  { "tpope/vim-abolish" },
  { "tpope/vim-surround" },

  {
    "L3MON4D3/LuaSnip",
    build = (not jit.os:find("Windows"))
        and "echo -e 'NOTE: jsregexp is optional, so not a big deal if it fails to build\n'; make install_jsregexp"
      or nil,
    dependencies = {
      "rafamadriz/friendly-snippets",
      config = function()
        require("luasnip.loaders.from_vscode").lazy_load()
      end,
    },
    keys = {
        {
          "<c-j>",
          function()
            if require("luasnip").expand_or_jumpable() then
              require("luasnip").expand_or_jump()
            end
          end,
          mode = { "i", "s" },
          desc = "LuaSnip: snippetNode jump forward",
          silent = true,
        },
        {
          "<c-k>",
          function()
            if require("luasnip").jumpable(-1) then
              require("luasnip").jump(-1)
            end
          end,
          mode = { "i", "s" },
          desc = "LuaSnip: snippetNode jump backward",
          silent = true,
        },
        {
          "<c-l>",
          function()
            if require("luasnip").choice_active() then
              require("luasnip").change_choice(1)
            end
          end,
          mode = "i",
          desc = "LuaSnip: change choices for the choiceNode",
        },
        -- {
        --   "<leader><leader>s",
        --   "<cmd>source ~/.config/nvim/after/plugin/luasnip.lua<CR>",
        --   desc = "LuaSnip: Reload my snippets"
        -- },
      },
    opts = function()
      local types = require("luasnip.util.types")
      return {
        history = true,
        update_events = { "TextChanged", "TextChangedI" },
        ext_opts = {
          [types.choiceNode] = {
            active = {
              virt_text = { { "<-", "Error" } },
            },
          },
        },
      }
    end,
  },

  {
    "hrsh7th/nvim-cmp",
    version = false, -- last release is way too old
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-nvim-lsp-document-symbol",
      "hrsh7th/cmp-nvim-lua",
      "hrsh7th/cmp-path",
      "onsails/lspkind-nvim",
      "saadparwaiz1/cmp_luasnip",
    },
    opts = function()
      local cmp = require("cmp")
      return {
        -- completion = {
        --   completeopt = "menu,menuone,noinsert",
        -- },
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping({
            i = cmp.mapping.abort(),
            c = cmp.mapping.close(),
          }),
          ["<C-y>"] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace, -- default is Insert
            select = true,
          }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
          ["<tab>"] = cmp.config.disable,
        }),
        sources = cmp.config.sources({
          { name = "nvim_lua" },
          { name = "nvim_lsp" },
          { name = "path" },
          { name = "luasnip" },
          { name = "buffer", keyword_length = 5 },
        }),
        formatting = {
          format = require("lspkind").cmp_format({
            with_text = true,
            menu = {
              buffer = "[B]",
              nvim_lsp = "[LSP]",
              nvim_lua = "[API]",
              path = "[Path]",
              luasnip = "[Snip]",
              omni = "[Omni]",
              -- tn = "[T9]",
            },
          }),
        },
        sorting = {
          comparators = {
            cmp.config.compare.offset,
            cmp.config.compare.exact,
            cmp.config.compare.score,
            -- copied from luka-reineke/cmp-under-comparator
            function(entry1, entry2)
              local _, entry1_under = entry1.completion_item.label:find("^_+")
              local _, entry2_under = entry2.completion_item.label:find("^_+")
              entry1_under = entry1_under or 0
              entry2_under = entry2_under or 0
              if entry1_under > entry2_under then
                return false
              elseif entry1_under < entry2_under then
                return true
              end
            end,
            cmp.config.compare.kind,
            cmp.config.compare.sort_text,
            cmp.config.compare.length,
            cmp.config.compare.order,
          },
        },
        experimental = {
          native_menu = false,
          ghost_text = {
            hl_group = "LspCodeLens",
          },
        },
      }
    end,

    config = function(_, opts)
      local cmp = require("cmp")
      cmp.setup(opts)

      -- Set configuration for specific filetype.
      -- cmp.setup.filetype("gitcommit", {
      --   sources = cmp.config.sources(
      --     { { name = "cmp_git" } },
      --     { { name = "buffer" } }
      --   ),
      -- })

      -- Use buffer source for `/` (if you enabled `native_menu`, this won"t work anymore).
      cmp.setup.cmdline("/", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "buffer" },
        },
      })

      -- Use cmdline & path source for ":" (if you enabled `native_menu`, this won"t work anymore).
      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({ { name = "path" } }, { { name = "cmdline" } }),
      })
    end,
  },
}
