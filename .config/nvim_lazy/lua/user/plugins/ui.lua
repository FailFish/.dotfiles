return {
  { "nvim-tree/nvim-web-devicons", lazy = true },
  {
    "stevearc/oil.nvim",
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {},
    -- Optional dependencies
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      CustomOilBar = function()
        local path = vim.fn.expand("%")
        path = path:gsub("oil://", "")

        return "  " .. vim.fn.fnamemodify(path, ":.")
      end

      require("oil").setup({
        columns = { "icon" },
        keymaps = {
          ["<C-h>"] = false,
          ["<C-l>"] = false,
          ["<C-k>"] = false,
          ["<C-j>"] = false,
          -- "<C-t>" for a new tab
          ["<C-v>"] = {
            "actions.select",
            opts = { vertical = true },
            desc = "Open the entry in a vertical split",
          },
          ["<C-s>"] = {
            "actions.select",
            opts = { horizontal = true },
            desc = "Open the entry in a horizontal split",
          },
          ["<CR>"] = "actions.select",
        },
        win_options = {
          winbar = "%{v:lua.CustomOilBar()}",
        },
        view_options = {
          show_hidden = true,
        },
      })

      -- Open parent directory in current window
      vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

      -- Open parent directory in floating window
      vim.keymap.set("n", "<space>-", require("oil").toggle_float)
    end,
  },
  {
    "ray-x/lsp_signature.nvim",
    config = function()
      require("lsp_signature").setup({})
    end,
  },
  {
    "goolord/alpha-nvim",
    config = function()
      require("alpha").setup(require("alpha.themes.startify").config)
    end,
  },
  {
    "folke/twilight.nvim",
    cmd = { "Twilight", "TwilightEnable" },
    config = function()
      require("twilight").setup({})
    end,
  },
  {
    "folke/zen-mode.nvim",
    cmd = { "ZenMode" },
    config = function()
      require("zen-mode").setup({})
    end,
  },
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    -- FIXME: autocmd?
    -- keys = {
    --   { "<esc>", [[<C-\><C-n>]], "t", buffer = 0 },
    --   -- { "jk", [[<C-\><C-n>]], "t", buffer = 0 },
    --   { "<C-h>", [[<C-\><C-n><C-W>h]], "t", buffer = 0 },
    --   { "<C-j>", [[<C-\><C-n><C-W>j]], "t", buffer = 0 },
    --   { "<C-k>", [[<C-\><C-n><C-W>k]], "t", buffer = 0 },
    --   { "<C-l>", [[<C-\><C-n><C-W>l]], "t", buffer = 0 },
    -- },
    opts = {
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
    },
  },
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      numhl = true,
    },
    config = function(_, opts)
      require("gitsigns").setup(opts)
    end,
  },
  {
    "ruifm/gitlinker.nvim",
    config = function()
      require("gitsigns").setup()
    end,
  },
  {
    "rhysd/git-messenger.vim",
    cmd = { "GitMessenger" },
    keys = { { "<leader>gm", "<cmd>GitMessenger<cr>", desc = "Git Messenger" } },
  },
  { "rhysd/committia.vim" }, -- TODO

  {
    "TimUntersberger/neogit",
    keys = {
      { "<space>G", "<cmd>Neogit<CR>", silent = true },
      -- { "<space>C", "<cmd>DiffviewOpen<CR>", silent = true },
    },
    opts = {
      integration = {
        diffview = true,
      },
    },
    config = function(_, opts)
      require("neogit").setup(opts)
    end,
  },
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles" },
    config = true, -- FIXME
    keys = { { "<leader>Do", "<cmd>DiffviewOpen<cr>", desc = "DiffView" } },
  },

  {
    "simrat39/symbols-outline.nvim",
    keys = {
      { "<space>st", "<cmd>SymbolsOutline<CR>", desc = "SymbolTree" },
    },
    config = function()
      require("symbols-outline").setup()
    end,
  },
  {
    "famiu/feline.nvim",
    event = "VeryLazy",
    opts = function()
      local configuration = vim.fn["gruvbox_material#get_configuration"]()
      local palette = vim.fn["gruvbox_material#get_palette"](
        configuration.background,
        configuration.foreground,
        configuration.colors_override
      )

      local colors = {
        bg = palette.bg_statusline1[1],
        fg = palette.fg0[1],
        yellow = palette.yellow[1],
        green = palette.green[1],
        red = palette.red[1],
        orange = palette.orange[1],
        blue = palette.blue[1],
        violet = palette.purple[1],
        cyan = palette.aqua[1],
      }

      local vi_mode_colors = {
        NORMAL = colors.green,
        OP = colors.green,
        INSERT = colors.red,
        VISUAL = colors.blue,
        BLOCK = colors.blue,
        REPLACE = colors.violet,
        ["V-REPLACE"] = colors.violet,
        ENTER = colors.cyan,
        MORE = colors.cyan,
        SELECT = colors.orange,
        COMMAND = colors.green,
        SHELL = colors.green,
        TERM = colors.green,
        NONE = colors.yellow,
      }

      local function file_osinfo()
        local os = vim.bo.fileformat:upper()
        local icon
        if os == "UNIX" then
          icon = " "
        elseif os == "MAC" then
          icon = " "
        else
          icon = " "
        end
        return icon .. os
      end

      local lsp = require("feline.providers.lsp")
      local vi_mode_utils = require("feline.providers.vi_mode")

      local comps = {
        vi_mode = {
          left = {
            provider = function()
              return  --[["  " ]]" " .. vi_mode_utils.get_vim_mode()
            end,
            hl = function()
              local val = {
                name = vi_mode_utils.get_mode_highlight_name(),
                fg = vi_mode_utils.get_mode_color(),
                -- fg = colors.bg
              }
              return val
            end,
            right_sep = " ",
          },
        },
        file = {
          info = {
            provider = {
              name = "file_info",
              opts = {
                type = "relative-short",
                file_readonly_icon = "  ",
                file_modified_icon = "",
                -- file_modified_icon = "",
              },
            },
            hl = {
              fg = colors.blue,
              style = "bold",
            },
          },
          encoding = {
            provider = "file_encoding",
            left_sep = " ",
            hl = {
              fg = colors.violet,
              style = "bold",
            },
          },
          type = {
            provider = "file_type",
          },
          os = {
            provider = file_osinfo,
            left_sep = " ",
            hl = {
              fg = colors.violet,
              style = "bold",
            },
          },
          position = {
            provider = "position",
            left_sep = " ",
            hl = {
              fg = colors.cyan,
              -- style = "bold"
            },
          },
        },
        left_end = {
          provider = function()
            return ""
          end,
          hl = {
            fg = colors.bg,
            bg = colors.blue,
          },
        },
        line_percentage = {
          provider = "line_percentage",
          left_sep = " ",
          hl = {
            style = "bold",
          },
        },
        scroll_bar = {
          provider = "scroll_bar",
          left_sep = " ",
          hl = {
            fg = colors.blue,
            style = "bold",
          },
        },
        diagnos = {
          err = {
            provider = "diagnostic_errors",
            -- left_sep = " ",
            enabled = function()
              return lsp.diagnostics_exist("Error")
            end,
            hl = {
              fg = colors.red,
            },
            icon = " ",
          },
          warn = {
            provider = "diagnostic_warnings",
            -- left_sep = " ",
            enabled = function()
              return lsp.diagnostics_exist("Warn")
            end,
            hl = {
              fg = colors.yellow,
            },
            icon = " ",
          },
          info = {
            provider = "diagnostic_info",
            -- left_sep = " ",
            enabled = function()
              return lsp.diagnostics_exist("Info")
            end,
            hl = {
              fg = colors.blue,
            },
            icon = " ",
          },
          hint = {
            provider = "diagnostic_hints", -- lsp.diagnostic_hints(),
            -- left_sep = " ",
            enabled = function()
              return lsp.diagnostics_exist("Hint")
            end,
            hl = {
              fg = colors.cyan,
            },
            icon = " ",
          },
        },
        lsp = {
          name = {
            provider = "lsp_client_names",
            left_sep = " ",
            right_sep = " ",
            icon = "  ",
            hl = {
              fg = colors.yellow,
            },
          },
        },
        git = {
          branch = {
            provider = "git_branch",
            icon = " ",
            -- icon = " ",
            left_sep = " ",
            hl = {
              fg = colors.violet,
              style = "bold",
            },
          },
          add = {
            provider = "git_diff_added",
            hl = {
              fg = colors.green,
            },
          },
          change = {
            provider = "git_diff_changed",
            hl = {
              fg = colors.orange,
            },
            icon = " 󰝤 ",
          },
          remove = {
            provider = "git_diff_removed",
            hl = {
              fg = colors.red,
            },
          },
        },
      }

      local components = {
        active = {
          {
            comps.vi_mode.left,
            comps.file.info,
            comps.git.branch,
            comps.git.add,
            comps.git.change,
            comps.git.remove,
          },
          {},
          {
            comps.diagnos.err,
            comps.diagnos.warn,
            comps.diagnos.hint,
            comps.diagnos.info,
            comps.lsp.name,
            -- comps.file.os,
            comps.file.position,
            comps.line_percentage,
            -- comps.scroll_bar,
            comps.vi_mode.right,
          },
        },
        inactive = {
          {
            comps.file.info,
          },
          {},
          {
            comps.file.position,
          },
        },
      }

      return {
        theme = { bg = colors.bg, fg = colors.fg },
        components = components,
        vi_mode_colors = vi_mode_colors,
        force_inactive = {
          filetypes = {
            "^packer$",
            "^Neogit",
            "^help$",
          },
          buftypes = { "terminal" },
          bufnames = {},
        },
      }
    end,
  },
}
