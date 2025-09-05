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
    "rebelot/heirline.nvim",
    enabled = true,
    event = "VeryLazy",
    opts = function()
      local conditions = require("heirline.conditions")
      local utils = require("heirline.utils")

      --[[ 1. COLOR PALETTE ]]
      -- This section is copied directly from your feline config to get colors
      -- from gruvbox-material.
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

      local ViMode = {
        -- Use a dictionary to map mode names to colors and text
        init = function(self)
          self.mode = vim.api.nvim_get_mode().mode
        end,
        static = {
          -- from astronvim
          mode_names = {
            ["n"] = { "NORMAL", "normal" },
            ["no"] = { "OP", "normal" },
            ["nov"] = { "OP", "normal" },
            ["noV"] = { "OP", "normal" },
            ["no"] = { "OP", "normal" },
            ["niI"] = { "NORMAL", "normal" },
            ["niR"] = { "NORMAL", "normal" },
            ["niV"] = { "NORMAL", "normal" },
            ["i"] = { "INSERT", "insert" },
            ["ic"] = { "INSERT", "insert" },
            ["ix"] = { "INSERT", "insert" },
            ["t"] = { "TERM", "terminal" },
            ["nt"] = { "TERM", "terminal" },
            ["v"] = { "VISUAL", "visual" },
            ["vs"] = { "VISUAL", "visual" },
            ["V"] = { "LINES", "visual" },
            ["Vs"] = { "LINES", "visual" },
            [""] = { "BLOCK", "visual" },
            ["s"] = { "BLOCK", "visual" },
            ["R"] = { "REPLACE", "replace" },
            ["Rc"] = { "REPLACE", "replace" },
            ["Rx"] = { "REPLACE", "replace" },
            ["Rv"] = { "V-REPLACE", "replace" },
            ["s"] = { "SELECT", "visual" },
            ["S"] = { "SELECT", "visual" },
            [""] = { "BLOCK", "visual" },
            ["c"] = { "COMMAND", "command" },
            ["cv"] = { "COMMAND", "command" },
            ["ce"] = { "COMMAND", "command" },
            ["r"] = { "PROMPT", "inactive" },
            ["rm"] = { "MORE", "inactive" },
            ["r?"] = { "CONFIRM", "inactive" },
            ["!"] = { "SHELL", "inactive" },
            ["null"] = { "null", "inactive" },
          },
          mode_colors = {
            ["normal"] = colors.green,
            ["insert"] = colors.red,
            ["terminal"] = colors.cyan,
            ["visual"] = colors.blue,
            ["replace"] = colors.violet,
            ["command"] = colors.orange,
            ["inactive"] = colors.yellow,
          }
        },
        provider = function(self)
          return " " .. (self.mode_names[self.mode][1] or "??") .. " "
        end,
        hl = function(self)
          -- local mode = self.mode:sub(1, 1) -- get only the first mode character
          local key = self.mode_names[self.mode][2]
          return { fg = self.mode_colors[key] or colors.fg }
        end,
      }

      local FileNameBlock = {
        -- let's first set up some attributes needed by this component and its children
        init = function(self)
          self.filename = vim.api.nvim_buf_get_name(0)
        end,
      }
      -- We can now define some children separately and add them later
      local WorkDir = {
        init = function(self)
          self.icon = (vim.fn.haslocaldir(0) == 1 and "l" or "g") .. " " .. "  "
          local cwd = vim.fn.getcwd(0)
          self.cwd = vim.fn.fnamemodify(cwd, ":~")
        end,
        hl = { fg = colors.blue },

        flexible = 1,

        {
          -- evaluates to the full-lenth path
          provider = function(self)
            local trail = self.cwd:sub(-1) == "/" and "" or "/"
            return self.icon .. self.cwd .. trail .." "
          end,
        },
        {
          -- evaluates to the shortened path
          provider = function(self)
            local cwd = vim.fn.pathshorten(self.cwd)
            local trail = self.cwd:sub(-1) == "/" and "" or "/"
            return self.icon .. cwd .. trail .. " "
          end,
        },
        {
          -- evaluates to "", hiding the component
          provider = "",
        }
      }
      local FileName = {
        init = function(self)
          self.lfilename = vim.fn.fnamemodify(self.filename, ":.")
          if self.lfilename == "" then self.lfilename = "[No Name]" end
        end,
        hl = { fg = colors.blue, bold = true },

        flexible = 2,

        {
          provider = function(self)
            return self.lfilename
          end,
        },
        {
          provider = function(self)
            return vim.fn.pathshorten(self.lfilename)
          end,
        },
      }
      local FileIcon = {
        init = function(self)
          local filename = self.filename
          local extension = vim.fn.fnamemodify(filename, ":e")
          self.icon, self.icon_color =
            require("nvim-web-devicons").get_icon_color(filename, extension, { default = true })
        end,
        provider = function(self)
          return self.icon and (self.icon .. " ")
        end,
        hl = function(self)
          return { fg = self.icon_color, bold = true }
        end,
      }

      local FileFlags = {
        {
          condition = function()
            return vim.bo.modified
          end,
          provider = "  ",
          hl = { fg = colors.blue },
        },
        {
          condition = function()
            return not vim.bo.modifiable or vim.bo.readonly
          end,
          provider = "  ",
          hl = { fg = colors.blue },
        },
      }

      -- let's add the children to our FileNameBlock component
      FileNameBlock = utils.insert(
        FileNameBlock,
        WorkDir,
        FileIcon,
        FileName,
        FileFlags,
        { provider = "%<" } -- this means that the statusline is cut here when there's not enough space
      )

      local Git = {
        condition = conditions.is_git_repo,

        init = function(self)
          self.status_dict = vim.b.gitsigns_status_dict
          self.has_changes = self.status_dict.added ~= 0
            or self.status_dict.removed ~= 0
            or self.status_dict.changed ~= 0
        end,

        hl = { fg = colors.orange },

        { -- git branch name
          provider = function(self)
            return " " .. self.status_dict.head
          end,
          hl = { fg = colors.violet, bold = true },
        },
        -- You could handle delimiters, icons and counts similar to Diagnostics
        {
          condition = function(self)
            return self.has_changes
          end,
          provider = "(",
        },
        {
          provider = function(self)
            local count = self.status_dict.added or 0
            return count > 0 and ("+" .. count)
          end,
          hl = { fg = colors.green },
        },
        {
          provider = function(self)
            local count = self.status_dict.removed or 0
            return count > 0 and ("-" .. count)
          end,
          hl = { fg = colors.red },
        },
        {
          provider = function(self)
            local count = self.status_dict.changed or 0
            return count > 0 and ("~" .. count)
          end,
          hl = { fg = colors.orange },
        },
        {
          condition = function(self)
            return self.has_changes
          end,
          provider = ")",
        },
      }

      local Diagnostics = {
        condition = conditions.has_diagnostics,
        -- Fetching custom diagnostic icons
        static = {
          error_icon = "",
          warn_icon = "",
          info_icon = " ",
          hint_icon = "󰌵",
          -- icon = "▫"
        },
        init = function(self)
          self.count = {}
          local levels = {
            errors = "ERROR",
            warnings = "WARN",
            info = "INFO",
            hints = "HINT",
          }

          for k, level in pairs(levels) do
            self.count[k] =
              vim.tbl_count(vim.diagnostic.get(0, { severity = vim.diagnostic.severity[level] }))
          end
        end,

        update = { "DiagnosticChanged", "BufEnter" },

        {
          provider = function(self)
            -- 0 is just another output, we can decide to print it or not!
            return self.count.errors > 0 and (self.error_icon .. " " .. self.count.errors .. " ")
          end,
          hl = { fg = colors.red },
        },
        {
          provider = function(self)
            return self.count.warnings > 0 and (self.warn_icon .. " " .. self.count.warnings .. " ")
          end,
          hl = { fg = colors.yellow },
        },
        {
          provider = function(self)
            return self.count.info > 0 and (self.info_icon .. " " .. self.count.info .. " ")
          end,
          hl = { fg = colors.blue },
        },
        {
          provider = function(self)
            return self.count.hints > 0 and (self.hint_icon .. " " .. self.count.hints)
          end,
          hl = { fg = colors.cyan },
        },
      }

      local LSPActive = {
        condition = conditions.lsp_attached,
        update = { "LspAttach", "LspDetach" },

        provider = function()
          local names = {}
          for i, server in pairs(vim.lsp.get_clients({ bufnr = 0 })) do
            table.insert(names, server.name)
          end
          return "  [" .. table.concat(names, " ") .. "]"
        end,
        hl = { fg = colors.yellow },
      }

      local CursorPos = {
        provider = " %l:%c",
        hl = { fg = colors.cyan },
      }
      local LinePercentage = {
        -- %P = percentage through file of displayed window
        provider = " %P",
        hl = { bold = true },
      }
      local Space = { provider = " " }
      local Align = { provider = "%=" }

      local DefaultStatusLine = {
        -- Set the default background and foreground for the entire statusline
        hl = { fg = colors.fg, bg = colors.bg },
        -- Left side
        ViMode,
        FileNameBlock,
        Space,
        Git,
        -- Middle (aligns the next components to the right)
        Align,
        -- -- Right side
        Diagnostics,
        Space,
        LSPActive,
        CursorPos,
        LinePercentage,
      }

      local InactiveStatusLine = {
        -- An inactive statusline is simpler
        condition = conditions.is_not_active,
        hl = { bg = colors.bg, fg = utils.get_highlight("Comment").fg },
        FileNameBlock,
        Align,
        LinePercentage,
      }

      local FileType = {
        provider = function()
          return string.upper(vim.bo.filetype)
        end,
        hl = { fg = utils.get_highlight("Type").fg, bold = true },
      }

      local HelpFileName = {
        condition = function()
          return vim.bo.filetype == "help"
        end,
        provider = function()
          local filename = vim.api.nvim_buf_get_name(0)
          return vim.fn.fnamemodify(filename, ":t")
        end,
        hl = { fg = colors.blue },
      }

      local SpecialStatusline = {
        condition = function()
          return conditions.buffer_matches({
            buftype = { "nofile", "prompt", "help", "quickfix" },
            filetype = { "^git.*", "fugitive", "Outline" },
          })
        end,

        FileType, Space, HelpFileName, Align
      }

      local StatusLines = {
        hl = function()
          if conditions.is_active() then
            return "StatusLine"
          else
            return "StatusLineNC"
          end
        end,

        -- the first statusline with no condition, or which condition returns true is used.
        -- think of it as a switch case with breaks to stop fallthrough.
        fallthrough = false,

        SpecialStatusline, InactiveStatusLine, DefaultStatusLine,
      }

      return {
        statusline = StatusLines,
      }
    end,
  },
}
