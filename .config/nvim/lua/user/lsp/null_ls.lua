local status_ok, null_ls = pcall(require, "null-ls")
if not status_ok then
  return
end

local sources = {

  -- lua
  null_ls.builtins.formatting.stylua,

  -- shell
  null_ls.builtins.formatting.shfmt,
  null_ls.builtins.diagnostics.shellcheck,

  -- python
  null_ls.builtins.formatting.black,
  null_ls.builtins.diagnostics.flake8,

  -- english writing (tex, markdown)
  -- null_ls.builtins.code_actions.proselint,
  -- null_ls.builtins.diagnostics.proselint,
  null_ls.builtins.diagnostics.chktex,
  null_ls.builtins.formatting.latexindent,

  -- etc
  null_ls.builtins.formatting.trim_newlines.with({
    disabled_filetypes = { "rust" }, -- use rustfmt
  }),
  null_ls.builtins.formatting.trim_whitespace.with({
    disabled_filetypes = { "rust" }, -- use rustfmt
  }),
  null_ls.builtins.formatting.prettier.with({
    filetypes = { "html", "css", "yaml", "markdown", "json" },
  }),
}
--
-- null_ls.setup({ sources = sources })

return sources
