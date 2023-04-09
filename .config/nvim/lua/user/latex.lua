vim.g.vimtex_view_forward_search_on_start = 0
vim.g.vimtex_view_method = "sioyek"
if vim.fn.has("macunix") == 1 then
  vim.g.vimtex_view_method = "sioyek"
end
-- if vim.fn.executable("pplatex") == 1 then -- error handling
--   vim.g.vimtex_quickfix_method = "pplatex"
-- end
vim.keymap.set("n", "<localleader>ld", "<plug>(vimtex-doc-package)", { buffer = true }) -- avoid overriding w/ lsp.hover

vim.g.vimtex_compiler_latexmk = {
  build_dir = "build",
}
