local ok, tsconfig = pcall(require, "nvim-treesitter.configs")
if not ok then
  return
end

tsconfig.setup {
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
}
