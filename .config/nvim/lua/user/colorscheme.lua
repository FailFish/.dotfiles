local colorscheme = "gruvbox-material"

-- if colorscheme == "gruvbox" then
--   vim.g.gruvbox_sign_column = "bg0"
-- end

if colorscheme == "gruvbox-material" then
  vim.g.gruvbox_material_enable_italic = 1
  vim.g.gruvbox_material_sign_column_background = "none"
  vim.g.gruvbox_material_palette = "mix"
  vim.g.gruvbox_material_diagnostic_virtual_text = "colored"
end

local status_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
if not status_ok then
  vim.notify("colorscheme " .. colorscheme .. " not found!")
  return
end
-- italic test
