local status_ok, null_ls = pcall(require, "null-ls")
if not status_ok then
  return
end

local null_fmt = null_ls.builtins.formatting
local null_diag = null_ls.builtins.diagnostics
local null_act = null_ls.builtins.code_actions
local sources = {
  -- lua
  null_fmt.stylua,

  -- shell
  null_fmt.shfmt,
  null_diag.shellcheck,

  -- python
  null_fmt.black,
  null_fmt.isort,
  null_diag.flake8,

  -- nix
  null_diag.statix,
  null_act.statix,

  -- english writing (tex, markdown)
  null_act.proselint,
  null_diag.proselint,
  null_diag.write_good,
  null_diag.chktex,
  -- null_fmt.latexindent,

  -- etc
  null_fmt.trim_newlines.with({
    disabled_filetypes = { "rust" }, -- use rustfmt
  }),
  null_fmt.trim_whitespace.with({
    disabled_filetypes = { "rust" }, -- use rustfmt
  }),
  null_fmt.prettier.with({
    filetypes = { "html", "css", "yaml", "markdown", "json" },
  }),
}

local M = {}
M.setup = function (on_attach)
  null_ls.setup({
    sources = sources,
    on_attach = on_attach,
  })
end

return M
