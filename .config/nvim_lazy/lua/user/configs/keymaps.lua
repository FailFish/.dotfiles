local M = {}

function M.diagnostic_goto(next, severity)
  local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function()
    go({ severity = severity })
  end
end

-- filetype specific mappings
local filetype_attach = setmetatable({
  tex = function()
    vim.bo.omnifunc = "vimtex#complete#omnifunc"
  end,
}, {
  __index = function()
    return function() end
  end,
})

-- General LSP Mappings.

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer

function M.on_attach(client, bufnr)
  local opts = function (desc)
    return {
      noremap = true,
      silent = true,
      buffer = bufnr,
      desc = desc,
    }
  end
  -- This makes i_<c-x><c-o> also trigger completion provided lsp
  vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

  vim.keymap.set("n", "<space>d", vim.diagnostic.open_float, opts("Line Diagnostics"))
  vim.keymap.set("n", "]d", M.diagnostic_goto(true), opts("Next Diagnostic"))
  vim.keymap.set("n", "[d", M.diagnostic_goto(false), opts("Prev Diagnostic"))
  vim.keymap.set("n", "]e", M.diagnostic_goto(true, "ERROR"), opts("Next Error"))
  vim.keymap.set("n", "[e", M.diagnostic_goto(false, "ERROR"), opts("Prev Error"))
  vim.keymap.set("n", "]w", M.diagnostic_goto(true, "WARN"), opts("Next Warning"))
  vim.keymap.set("n", "[w", M.diagnostic_goto(false, "WARN"), opts("Prev Warning"))
  vim.keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<cr>", opts("Goto Definition"))
  vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts("Goto Declaration"))
  vim.keymap.set("n", "gr", "<cmd>Telescope lsp_references<cr>", opts("Goto References"))
  vim.keymap.set("n", "gI", "<cmd>Telescope lsp_implementations<cr>", opts("Goto Implementation"))
  vim.keymap.set("n", "<space>gt", "<cmd>Telescope lsp_type_definitions<cr>", opts("Goto Type Definition"))

  vim.keymap.set("n", "K", vim.lsp.buf.hover, opts("Hover"))
  vim.keymap.set("n", "gK", vim.lsp.buf.signature_help, opts("Signature Help"))
  vim.keymap.set("i", "<c-h>", vim.lsp.buf.signature_help, opts("Signature Help"))

  vim.api.nvim_create_user_command("Format", function()
    vim.lsp.buf.format({ async = true })
  end, {})
  vim.keymap.set({"n", "v"}, "<space>cf", function () vim.lsp.buf.format({async = true}) end, opts("Format Document"))

  -- ACTION commands
  vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, opts("Rename Symbol"))
  vim.keymap.set({"n", "v"}, "<space>ca", vim.lsp.buf.code_action, opts("Code Action"))
  vim.keymap.set("n", "<space>cA", function ()
    vim.lsp.buf.code_action({
      context = {
        only = {
          "source",
        },
        diagnostics = {},
      },
    })
  end, opts("Source Action"))

  local filetype = vim.api.nvim_buf_get_option(bufnr, "filetype")

  filetype_attach[filetype](client, bufnr)
end

return M
