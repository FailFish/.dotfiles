-- local signs = {
--   { name = "DiagnosticSignError", text = "" },
--   { name = "DiagnosticSignWarn", text = "" },
--   { name = "DiagnosticSignHint", text = "" },
--   { name = "DiagnosticSignInfo", text = "" },
-- }
--
-- for _, sign in ipairs(signs) do
--   vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
-- end

local config = {
  virtual_text = {
    source = "if_many",
    -- prefix = "·", -- 00b7
    -- prefix = "⋅", -- 22c5
    prefix = "⚫",
    -- prefix = "●",
  },
  severity_sort = true,
  float = {
    -- border = "rounded",
    -- source = "always",
  },
}

vim.diagnostic.config(config)
