-- LaTeX filetype config. Requires 'lervag/vimtex' (added lazily on first `.tex`
-- file in 'plugin/40_plugins.lua'). Ported from old config's
-- 'lua/user/plugins/etc.lua' `vimtex` keys.

-- Package documentation lookup, using `<localleader>` instead of `<Leader>` to
-- avoid clashing with the `<Leader>l` (Language/LSP) group's hover mapping.
vim.keymap.set('n', '<localleader>ld', '<Plug>(vimtex-doc-package)', { buffer = 0 })
