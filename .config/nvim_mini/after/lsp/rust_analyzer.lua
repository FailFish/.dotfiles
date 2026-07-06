-- TODO: add mrcjkb/rustaceanvim
return {
  settings = {
    ['rust-analyzer'] = {
      cargo = { features = 'all' },
      -- Use clippy for on-save checks
      check = {
        features = 'all',
        command = 'clippy',
        extraArgs = { '--no-deps' },
      },
      procMacro = {
        enable = true,
        ignored = {
          ['async-trait'] = { 'async_trait' },
          ['napi-derive'] = { 'napi' },
          ['async-recursion'] = { 'async_recursion' },
        },
      },
    },
  },
}
