if not pcall(require, "feline") then
  return
end

local background = vim.opt.background:get()
local configuration = vim.fn['gruvbox_material#get_configuration']()
local palette = vim.fn['gruvbox_material#get_palette'](background, configuration.palette)

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
  NONE = colors.yellow
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

local lsp = require "feline.providers.lsp"
local vi_mode_utils = require "feline.providers.vi_mode"

local comps = {
  vi_mode = {
    left = {
      provider = function()
        return --[["  " ]] " " .. vi_mode_utils.get_vim_mode()
      end,
      hl = function()
        local val = {
          name = vi_mode_utils.get_mode_highlight_name(),
          fg = vi_mode_utils.get_mode_color(),
          -- fg = colors.bg
        }
        return val
      end,
      right_sep = " "
    },
  },
  file = {
    info = {
      provider = {
        name = "file_info",
        opts = {
          type = "relative-short",
          file_readonly_icon = "  ",
          -- file_readonly_icon = "  ",
          -- file_readonly_icon = "  ",
          -- file_readonly_icon = "  ",
          -- file_modified_icon = "",
          -- file_modified_icon = "",
          file_modified_icon = "ﱐ",
          -- file_modified_icon = "",
          -- file_modified_icon = "",
          -- file_modified_icon = "",
        }
      },
      hl = {
        fg = colors.blue,
        style = "bold"
      }
    },
    encoding = {
      provider = "file_encoding",
      left_sep = " ",
      hl = {
        fg = colors.violet,
        style = "bold"
      }
    },
    type = {
      provider = "file_type"
    },
    os = {
      provider = file_osinfo,
      left_sep = " ",
      hl = {
        fg = colors.violet,
        style = "bold"
      }
    },
    position = {
      provider = "position",
      left_sep = " ",
      hl = {
        fg = colors.cyan,
        -- style = "bold"
      }
    },
  },
  left_end = {
    provider = function() return "" end,
    hl = {
      fg = colors.bg,
      bg = colors.blue,
    }
  },
  line_percentage = {
    provider = "line_percentage",
    left_sep = " ",
    hl = {
      style = "bold"
    }
  },
  scroll_bar = {
    provider = "scroll_bar",
    left_sep = " ",
    hl = {
      fg = colors.blue,
      style = "bold"
    }
  },
  diagnos = {
    err = {
      provider = "diagnostic_errors",
      -- left_sep = " ",
      enabled = function() return lsp.diagnostics_exist("Error") end,
      hl = {
        fg = colors.red
      }
    },
    warn = {
      provider = "diagnostic_warnings",
      -- left_sep = " ",
      enabled = function() return lsp.diagnostics_exist("Warn") end,
      hl = {
        fg = colors.yellow
      }
    },
    info = {
      provider = "diagnostic_info",
      -- left_sep = " ",
      enabled = function() return lsp.diagnostics_exist("Info") end,
      hl = {
        fg = colors.blue
      }
    },
    hint = {
      provider = "diagnostic_hints", -- lsp.diagnostic_hints(),
      -- left_sep = " ",
      enabled = function() return lsp.diagnostics_exist("Hint") end,
      hl = {
        fg = colors.cyan
      },
      icon = "  ",
    },
  },
  lsp = {
    name = {
      provider = "lsp_client_names",
      left_sep = " ",
      right_sep = " ",
      icon = "  ",
      -- icon = "慎",
      hl = {
        fg = colors.yellow
      }
    }
  },
  git = {
    branch = {
      provider = "git_branch",
      icon = " ",
      -- icon = " ",
      left_sep = " ",
      hl = {
        fg = colors.violet,
        style = "bold"
      },
    },
    add = {
      provider = "git_diff_added",
      hl = {
        fg = colors.green
      }
    },
    change = {
      provider = "git_diff_changed",
      hl = {
        fg = colors.orange
      }
    },
    remove = {
      provider = "git_diff_removed",
      hl = {
        fg = colors.red
      }
    }
  }
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
    { },
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
    { },
    {
      comps.file.position,
    },
  },
}

-- require"feline".setup {}
require"feline".setup {
  theme = { bg = colors.bg, fg = colors.fg },
  components = components,
  vi_mode_colors = vi_mode_colors,
  force_inactive = {
    filetypes = {
      "^packer$",
      "^Neogit",
      "^help$",
    },
    buftypes = {"terminal"},
    bufnames = {}
  }
}
