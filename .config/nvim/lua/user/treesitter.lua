local ok, tsconfig = pcall(require, "nvim-treesitter.configs")
if not ok then
  return
end

local parser_install_dir = vim.fn.stdpath("data") .. "/treesitters"
vim.fn.mkdir(parser_install_dir, "p")
vim.opt.runtimepath:append(parser_install_dir)

tsconfig.setup({
  parser_install_dir = parser_install_dir,
  ensure_installed = {
    "bash",
    "c",
    "cpp",
    "cmake",
    "fish",
    -- "latex",
    "llvm",
    "lua",
    "make",
    "nix",
    "norg",
    "python",
    "rust",
    "zig",
  },
  sync_install = false,
  ignore_install = { "" }, -- List of parsers to ignore installing
  highlight = {
    enable = true, -- false will disable the whole extension
    disable = { "" }, -- list of language that will be disabled
    additional_vim_regex_highlighting = true,
  },
  matchup = {
    enable = true,
    disable = { "" },
  },
})
