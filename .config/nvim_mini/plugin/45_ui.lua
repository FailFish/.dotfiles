-- ┌──────────────────────────┐
-- │ UI: colorscheme + finder │
-- └──────────────────────────┘

local add = vim.pack.add
local now, later = Config.now, Config.later

-- Colorscheme =================================================================
now(function()
  add({
    'https://github.com/sainnhe/gruvbox-material',
    -- 'https://github.com/sainnhe/everforest',
  })

  vim.g.gruvbox_material_enable_italic = 1
  vim.g.gruvbox_material_sign_column_background = 'none'
  vim.g.gruvbox_material_palette = 'mix'
  vim.g.gruvbox_material_diagnostic_virtual_text = 'colored'
  vim.cmd('colorscheme gruvbox-material')
end)

-- Statusline (heirline) =======================================================
now(function()
  add({ 'https://github.com/rebelot/heirline.nvim' })

  local heirline = require('heirline')
  local conditions = require('heirline.conditions')
  local utils = require('heirline.utils')

  local configuration = vim.fn['gruvbox_material#get_configuration']()
  local palette = vim.fn['gruvbox_material#get_palette'](
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
    init = function(self) self.mode = vim.api.nvim_get_mode().mode end,
    static = {
      mode_names = {
        ['n'] = { 'NORMAL', 'normal' },
        ['no'] = { 'OP', 'normal' },
        ['nov'] = { 'OP', 'normal' },
        ['noV'] = { 'OP', 'normal' },
        ['niI'] = { 'NORMAL', 'normal' },
        ['niR'] = { 'NORMAL', 'normal' },
        ['niV'] = { 'NORMAL', 'normal' },
        ['i'] = { 'INSERT', 'insert' },
        ['ic'] = { 'INSERT', 'insert' },
        ['ix'] = { 'INSERT', 'insert' },
        ['t'] = { 'TERM', 'terminal' },
        ['nt'] = { 'TERM', 'terminal' },
        ['v'] = { 'VISUAL', 'visual' },
        ['vs'] = { 'VISUAL', 'visual' },
        ['V'] = { 'LINES', 'visual' },
        ['Vs'] = { 'LINES', 'visual' },
        [''] = { 'BLOCK', 'visual' },
        ['s'] = { 'SELECT', 'visual' },
        ['S'] = { 'SELECT', 'visual' },
        ['R'] = { 'REPLACE', 'replace' },
        ['Rc'] = { 'REPLACE', 'replace' },
        ['Rx'] = { 'REPLACE', 'replace' },
        ['Rv'] = { 'V-REPLACE', 'replace' },
        ['c'] = { 'COMMAND', 'command' },
        ['cv'] = { 'COMMAND', 'command' },
        ['ce'] = { 'COMMAND', 'command' },
        ['r'] = { 'PROMPT', 'inactive' },
        ['rm'] = { 'MORE', 'inactive' },
        ['r?'] = { 'CONFIRM', 'inactive' },
        ['!'] = { 'SHELL', 'inactive' },
        ['null'] = { 'null', 'inactive' },
      },
      mode_colors = {
        ['normal'] = colors.green,
        ['insert'] = colors.red,
        ['terminal'] = colors.cyan,
        ['visual'] = colors.blue,
        ['replace'] = colors.violet,
        ['command'] = colors.orange,
        ['inactive'] = colors.yellow,
      },
    },
    provider = function(self)
      local entry = self.mode_names[self.mode]
      return ' ' .. (entry and entry[1] or '??') .. ' '
    end,
    hl = function(self)
      local entry = self.mode_names[self.mode]
      local key = entry and entry[2] or 'inactive'
      return { fg = self.mode_colors[key] or colors.fg }
    end,
  }

  local FileNameBlock = {
    init = function(self) self.filename = vim.api.nvim_buf_get_name(0) end,
  }
  local WorkDir = {
    init = function(self)
      self.icon = (vim.fn.haslocaldir(0) == 1 and 'l' or 'g') .. '  '
      local cwd = vim.fn.getcwd(0)
      self.cwd = vim.fn.fnamemodify(cwd, ':~')
    end,
    hl = { fg = colors.blue },
    flexible = 1,
    {
      provider = function(self)
        local trail = self.cwd:sub(-1) == '/' and '' or '/'
        return self.icon .. self.cwd .. trail .. ' '
      end,
    },
    {
      provider = function(self)
        local cwd = vim.fn.pathshorten(self.cwd)
        local trail = self.cwd:sub(-1) == '/' and '' or '/'
        return self.icon .. cwd .. trail .. ' '
      end,
    },
    { provider = '' },
  }
  local FileName = {
    init = function(self)
      self.lfilename = vim.fn.fnamemodify(self.filename, ':.')
      if self.lfilename == '' then self.lfilename = '[No Name]' end
    end,
    hl = { fg = colors.blue, bold = true },
    flexible = 2,
    { provider = function(self) return self.lfilename end },
    { provider = function(self) return vim.fn.pathshorten(self.lfilename) end },
  }
  local FileIcon = {
    init = function(self)
      local filename = self.filename
      local ext = vim.fn.fnamemodify(filename, ':e')
      -- `MiniIcons.get()`'s second return value is a highlight *group name*
      -- (e.g. 'MiniIconsGreen'), not a color - use it as `hl` directly rather
      -- than as a `fg` color value.
      self.icon, self.icon_hl = MiniIcons.get('file', filename ~= '' and filename or ext)
    end,
    provider = function(self) return self.icon and (self.icon .. ' ') end,
    hl = function(self) return self.icon_hl end,
  }
  local FileFlags = {
    {
      condition = function() return vim.bo.modified end,
      provider = '  ',
      hl = { fg = colors.blue },
    },
    {
      condition = function() return not vim.bo.modifiable or vim.bo.readonly end,
      provider = '  ',
      hl = { fg = colors.blue },
    },
  }
  FileNameBlock = utils.insert(FileNameBlock, WorkDir, FileIcon, FileName, FileFlags, { provider = '%<' })

  -- Git branch (from 'mini.git') + hunk counts (from 'mini.diff'). Both modules
  -- set their buffer-local summary tables on every relevant buffer event.
  local Git = {
    condition = function() return vim.b.minigit_summary ~= nil end,
    init = function(self)
      self.head_name = vim.b.minigit_summary and vim.b.minigit_summary.head_name
      self.diff = vim.b.minidiff_summary or {}
      self.has_changes = (self.diff.add or 0) > 0 or (self.diff.change or 0) > 0 or (self.diff.delete or 0) > 0
    end,
    hl = { fg = colors.orange },
    {
      provider = function(self) return self.head_name and (' ' .. self.head_name) end,
      hl = { fg = colors.violet, bold = true },
    },
    { condition = function(self) return self.has_changes end, provider = '(' },
    {
      provider = function(self)
        local n = self.diff.add or 0
        return n > 0 and ('+' .. n)
      end,
      hl = { fg = colors.green },
    },
    {
      provider = function(self)
        local n = self.diff.delete or 0
        return n > 0 and ('-' .. n)
      end,
      hl = { fg = colors.red },
    },
    {
      provider = function(self)
        local n = self.diff.change or 0
        return n > 0 and ('~' .. n)
      end,
      hl = { fg = colors.orange },
    },
    { condition = function(self) return self.has_changes end, provider = ')' },
  }

  local Diagnostics = {
    condition = conditions.has_diagnostics,
    static = {
      error_icon = '',
      warn_icon = '',
      info_icon = ' ',
      hint_icon = '󰌵',
    },
    init = function(self)
      self.count = {}
      local levels = { errors = 'ERROR', warnings = 'WARN', info = 'INFO', hints = 'HINT' }
      for k, level in pairs(levels) do
        self.count[k] = vim.tbl_count(vim.diagnostic.get(0, { severity = vim.diagnostic.severity[level] }))
      end
    end,
    update = { 'DiagnosticChanged', 'BufEnter' },
    {
      provider = function(self)
        return self.count.errors > 0 and (self.error_icon .. ' ' .. self.count.errors .. ' ')
      end,
      hl = { fg = colors.red },
    },
    {
      provider = function(self)
        return self.count.warnings > 0 and (self.warn_icon .. ' ' .. self.count.warnings .. ' ')
      end,
      hl = { fg = colors.yellow },
    },
    {
      provider = function(self)
        return self.count.info > 0 and (self.info_icon .. ' ' .. self.count.info .. ' ')
      end,
      hl = { fg = colors.blue },
    },
    {
      provider = function(self)
        return self.count.hints > 0 and (self.hint_icon .. ' ' .. self.count.hints)
      end,
      hl = { fg = colors.cyan },
    },
  }

  local LSPActive = {
    condition = conditions.lsp_attached,
    update = { 'LspAttach', 'LspDetach' },
    provider = function()
      local names = {}
      for _, server in pairs(vim.lsp.get_clients({ bufnr = 0 })) do
        table.insert(names, server.name)
      end
      return '  [' .. table.concat(names, ' ') .. ']'
    end,
    hl = { fg = colors.yellow },
  }

  local CursorPos = { provider = ' %l:%c', hl = { fg = colors.cyan } }
  local LinePercentage = { provider = ' %P', hl = { bold = true } }
  local Space = { provider = ' ' }
  local Align = { provider = '%=' }

  local DefaultStatusLine = {
    hl = { fg = colors.fg, bg = colors.bg },
    ViMode,
    FileNameBlock,
    Space,
    Git,
    Align,
    Diagnostics,
    Space,
    LSPActive,
    CursorPos,
    LinePercentage,
  }

  local InactiveStatusLine = {
    condition = conditions.is_not_active,
    hl = { bg = colors.bg, fg = utils.get_highlight('Comment').fg },
    FileNameBlock,
    Align,
    LinePercentage,
  }

  local FileType = {
    provider = function() return string.upper(vim.bo.filetype) end,
    hl = { fg = utils.get_highlight('Type').fg, bold = true },
  }

  local HelpFileName = {
    condition = function() return vim.bo.filetype == 'help' end,
    provider = function() return vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ':t') end,
    hl = { fg = colors.blue },
  }

  local SpecialStatusline = {
    condition = function()
      return conditions.buffer_matches({
        buftype = { 'nofile', 'prompt', 'help', 'quickfix' },
        filetype = { '^git.*', 'fugitive', 'Outline' },
      })
    end,
    FileType,
    Space,
    HelpFileName,
    Align,
  }

  local StatusLines = {
    hl = function() return conditions.is_active() and 'StatusLine' or 'StatusLineNC' end,
    fallthrough = false,
    SpecialStatusline,
    InactiveStatusLine,
    DefaultStatusLine,
  }

  heirline.setup({ statusline = StatusLines })
end)

-- Fuzzy finder (fzf-lua) =======================================================
later(function()
  add({ 'https://github.com/ibhagwan/fzf-lua', 'https://github.com/nvim-tree/nvim-web-devicons' })

  require('fzf-lua').setup({
    winopts = {
      -- disable backdrop
      backdrop = 100,
    },
    previewers = {
      builtin = {
        -- Don't syntax highlight files bigger than 100KB
        syntax_limit_b = 1024 * 100,
      },
    },
    keymap = {
      fzf = {
        ['ctrl-z'] = 'abort',
        ['ctrl-d'] = 'half-page-down',
        ['ctrl-u'] = 'half-page-up',
        ['ctrl-a'] = 'toggle-all',
        ['ctrl-q'] = 'accept', -- send to quickfix list
      },
    },
  })

  -- Find files at the Git root if inside a repo, else at 'opts.cwd' (default cwd).
  -- Used by '<Leader>ff'/'<Leader>fF' in 'plugin/20_keymaps.lua'.
  Config.picker = function(command, opts)
    return function()
      opts = opts or {}
      local fzf_lua = require('fzf-lua')
      local git_root = require('fzf-lua.path').git_root({})
      local search_dir = opts.cwd == true and vim.uv.cwd() or git_root
      if command == 'files' and git_root then command = 'git_files' end
      return fzf_lua[command]({ cwd = search_dir })
    end
  end

  -- Live grep, but first pick which (sub)directory to search from, without
  -- touching Neovim's actual cwd.
  Config.live_grep_cwd = function(cwd)
    cwd = cwd or vim.uv.cwd()
    local fzf_lua = require('fzf-lua')
    fzf_lua.fzf_exec('{ echo .; fd --type d; }', {
      cwd = cwd,
      prompt = vim.fn.fnamemodify(cwd, ':~') .. '> ',
      actions = {
        ['default'] = function(selected) fzf_lua.live_grep({ cwd = vim.fs.joinpath(cwd, selected[1]) }) end,
        ['ctrl-g'] = function() Config.live_grep_cwd(vim.fs.dirname(cwd)) end,
      },
    })
  end
end)

-- Git extras ===================================================================
later(function()
  add({ 'https://github.com/sindrets/diffview.nvim' })
  require('diffview').setup()
end)

later(function() add({ 'https://github.com/linrongbin16/gitlinker.nvim' }) end)

-- File explorer (oil.nvim) =====================================================
later(function()
  add({ 'https://github.com/stevearc/oil.nvim' })

  Config.oil_winbar = function()
    local path = vim.fn.expand('%'):gsub('^oil://', '')
    return '  ' .. vim.fn.fnamemodify(path, ':.')
  end

  require('oil').setup({
    columns = { 'icon' },
    keymaps = {
      ['<C-h>'] = false,
      ['<C-l>'] = false,
      ['<C-k>'] = false,
      ['<C-j>'] = false,
      ['<C-v>'] = { 'actions.select', opts = { vertical = true }, desc = 'Open in vertical split' },
      ['<C-s>'] = { 'actions.select', opts = { horizontal = true }, desc = 'Open in horizontal split' },
      ['<CR>'] = 'actions.select',
    },
    win_options = { winbar = '%{v:lua.Config.oil_winbar()}' },
    view_options = { show_hidden = true },
  })
end)

-- Terminal (toggleterm.nvim) ===================================================
later(function()
  add({ 'https://github.com/akinsho/toggleterm.nvim' })

  require('toggleterm').setup({
    size = 20,
    open_mapping = [[<c-\>]],
    hide_numbers = true,
    shade_terminals = true,
    start_in_insert = true,
    insert_mappings = true,
    terminal_mappings = true,
    persist_size = true,
    direction = 'float',
    close_on_exit = true,
    float_opts = { border = 'curved', winblend = 5 },
  })
end)
