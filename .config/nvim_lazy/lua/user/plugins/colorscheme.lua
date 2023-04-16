return {
  {
    "sainnhe/gruvbox-material",
    lazy = false, -- my default colorscheme
    config = function ()
      vim.g.gruvbox_material_enable_italic = 1
      vim.g.gruvbox_material_sign_column_background = "none"
      vim.g.gruvbox_material_palette = "mix"
      vim.g.gruvbox_material_diagnostic_virtual_text = "colored"
      vim.cmd([[colorscheme gruvbox-material]])
    end
  },
  {
    "folke/tokyonight.nvim",
    lazy = true,
    opts = { style = "moon" },
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = true,
  },
}
