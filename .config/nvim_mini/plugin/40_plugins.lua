-- ┌─────────────────────────┐
-- │ Plugins outside of MINI │
-- └─────────────────────────┘

local add = vim.pack.add
local now_if_args, later = Config.now_if_args, Config.later

-- Tree-sitter ================================================================
-- Add these plugins now if file (and not 'mini.starter') is shown after startup.
now_if_args(function()
  -- Define hook to update tree-sitter parsers after plugin is updated
  local ts_update = function() vim.cmd('TSUpdate') end
  Config.on_packchanged('nvim-treesitter', { 'update' }, ts_update, ':TSUpdate')

  add({
    'https://github.com/nvim-treesitter/nvim-treesitter',
    'https://github.com/nvim-treesitter/nvim-treesitter-textobjects',
    'https://github.com/nvim-treesitter/nvim-treesitter-context',
  })

  local languages = {
    -- These are already pre-installed with Neovim. Used as an example.
    'lua',
    'vimdoc',
    'markdown',
    -- Ported from old config
    'bash',
    'c',
    'cmake',
    'cpp',
    'fish',
    'json',
    'markdown_inline',
    'nix',
    'python',
    'query',
    'rust',
    'toml',
    'vim',
    'zig',
    -- To see available languages:
    -- - Execute `:=require('nvim-treesitter').get_available()`
    -- - Visit 'SUPPORTED_LANGUAGES.md' file at
    --   https://github.com/nvim-treesitter/nvim-treesitter/blob/main
  }
  local isnt_installed = function(lang)
    return #vim.api.nvim_get_runtime_file('parser/' .. lang .. '.*', false) == 0
  end
  local to_install = vim.tbl_filter(isnt_installed, languages)
  if #to_install > 0 then require('nvim-treesitter').install(to_install) end

  -- Enable tree-sitter after opening a file for a target language
  local filetypes = {}
  for _, lang in ipairs(languages) do
    for _, ft in ipairs(vim.treesitter.language.get_filetypes(lang)) do
      table.insert(filetypes, ft)
    end
  end
  local ts_start = function(ev) vim.treesitter.start(ev.buf) end
  Config.new_autocmd('FileType', filetypes, ts_start, 'Start tree-sitter')

  require('treesitter-context').setup()
end)

-- Language servers ===========================================================

now_if_args(function()
  add({
    'https://github.com/neovim/nvim-lspconfig',
    -- JSON schema catalog, used by 'after/lsp/jsonls.lua'
    'https://github.com/b0o/SchemaStore.nvim',
    -- TODO: replace fidget with mini.notify?
    'https://github.com/j-hui/fidget.nvim',
    'https://github.com/aznhe21/actions-preview.nvim',
    'https://github.com/p00f/clangd_extensions.nvim',
  })

  require('fidget').setup()
  require('actions-preview').setup()

  vim.lsp.enable({
    'bashls',
    'clangd',
    'cmake',
    'gopls',
    'jsonls',
    'lua_ls',
    'nixd',
    'pyright',
    'rust_analyzer',
    'texlab',
    'vimls',
    'zls',
  })
end)

-- Formatting =================================================================
later(function()
  add({ 'https://github.com/stevearc/conform.nvim' })

  require('conform').setup({
    default_format_opts = {
      -- Allow formatting from LSP server if no dedicated formatter is available
      lsp_format = 'fallback',
    },
    -- Map of filetype to formatters. Make sure each CLI tool is on PATH.
    -- Ported from old config's 'lua/user/plugins/lsp.lua'.
    formatters_by_ft = {
      c = { 'clang-format' },
      cpp = { 'clang-format' },
      lua = { 'stylua' },
      -- Conform runs multiple formatters sequentially
      rust = { 'rustfmt', lsp_format = 'fallback' },
      python = { 'isort', 'black' },
      go = { 'goimports', 'gofmt' },
      bash = { 'shfmt' },
      nix = { 'alejandra' },
      -- Filetypes without any formatter specified
      ['_'] = { 'trim_whitespace' },
    },
  })
end)

-- Linting =====================================================================

later(function()
  add({ 'https://github.com/mfussenegger/nvim-lint' })

  require('lint').linters_by_ft = {
    bash = { 'shellcheck' },
    nix = { 'statix' },
    python = { 'flake8' },
  }

  local lint_cmd = function() require('lint').try_lint() end
  Config.new_autocmd({ 'BufWritePost', 'BufReadPost', 'InsertLeave' }, nil, lint_cmd, 'Run linters')
end)

-- Snippets ===================================================================

-- See `:h MiniSnippets.gen_loader.from_lang()`.
later(function() add({ 'https://github.com/rafamadriz/friendly-snippets' }) end)

-- Language extras =============================================================

later(function()
  -- Smarter `%` matching (works together with 'mini.surround'-style pairs)
  add({ 'https://github.com/andymass/vim-matchup' })
  vim.g.matchup_surround_enabled = 1
  vim.g.matchup_matchparen_deferred = 1
  vim.g.matchup_matchparen_offscreen = {}
end)

-- Case coercion: `crs`/`crc`/`crm`/etc to switch between snake_case, camelCase,
-- MixedCase, and more. Also provides `:Subvert`/`:S` for substitution across cases.
later(function() add({ 'https://github.com/tpope/vim-abolish' }) end)

-- Filetype-gated plugins below rely on their own 'ftplugin/' files, which only
-- get sourced when the `FileType` event fires. Since `add()` only updates the
-- runtime path (it doesn't retroactively apply to the buffer that triggered
-- this callback), re-fire `FileType` once after adding the plugin.
local reload_ftplugin = function() vim.cmd('doautocmd FileType ' .. vim.bo.filetype) end

-- Nix filetype detection/indent/syntax
Config.on_filetype('nix', function()
  add({ 'https://github.com/LnL7/vim-nix' })
  reload_ftplugin() -- vim plugin
end)

-- LaTeX editing.
Config.on_filetype('tex', function()
  add({ 'https://github.com/lervag/vimtex' })
  vim.g.vimtex_view_forward_search_on_start = 0
  vim.g.vimtex_view_method = 'sioyek'
  vim.g.vimtex_compiler_latexmk = { build_dir = 'build' }
  reload_ftplugin() -- vim plugin
end)

Config.on_filetype('markdown', function()
  add({ 'https://github.com/MeanderingProgrammer/render-markdown.nvim' })
  require('render-markdown').setup({
    sign = { enabled = false },
    file_types = { 'markdown' },
    code = { width = 'block', right_pad = 4, position = 'right' },
  })
end)
