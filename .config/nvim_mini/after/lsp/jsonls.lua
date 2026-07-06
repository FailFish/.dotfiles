-- Ported from old config's 'lua/user/configs/servers.lua' `jsonls` entry.
-- Uses 'b0o/SchemaStore.nvim' (added in 'plugin/40_plugins.lua') for a large
-- catalog of JSON schemas (package.json, tsconfig.json, etc.).
return {
  settings = {
    json = {
      schemas = require('schemastore').json.schemas(),
      format = { enable = true },
      validate = { enable = true },
    },
  },
}
