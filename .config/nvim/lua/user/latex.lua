vim.g.vimtex_view_forward_search_on_start = 0
vim.g.vimtex_view_method = "zathura"
if not vim.fn.executable("pplatex") then -- error handling
  vim.g.vimtex_quickfix_method = "pplatex"
end

vim.g.vimtex_compiler_latexmk = {
  build_dir = 'build',
}
