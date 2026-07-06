-- Ported from old config's 'lua/user/configs/servers.lua' `clangd` entry.
return {
  cmd = {
    'clangd',
    '--background-index',
    '--clang-tidy',
    '--header-insertion=iwyu',
    '--completion-style=detailed',
    '--malloc-trim',
    '--offset-encoding=utf-16',
    '--fallback-style=llvm',
  },
}
