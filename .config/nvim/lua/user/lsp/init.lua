local status_ok, lspconfig = pcall(require, "lspconfig")
if not status_ok then
  return
end

local status_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not status_ok then
  return
end

-- require("user.lsp.lsp-installer")
-- require("user.lsp.handlers").setup()

-- Mappings.
-- TODO: uapi/util functions and expose nmap and imap?
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap=true, silent=true }
vim.api.nvim_set_keymap("n", "<space>dl", '<cmd>lua vim.diagnostic.open_float(0, { scope = "line" })<CR>', opts)
vim.api.nvim_set_keymap("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts)
vim.api.nvim_set_keymap("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts)
vim.api.nvim_set_keymap("n", "<space>ld", "<cmd>lua vim.diagnostic.setloclist()<CR>", opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  -- JUMP commands
  vim.api.nvim_buf_set_keymap(bufnr, "n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "<space>gT", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)

  -- LIST commands (uses qflist)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "<space>qr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "<space>qi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "<space>qs", "<cmd>lua vim.lsp.buf.document_symbol()<CR>", opts) -- list all symbols in the current buffer
  -- LIST command (uses telescope)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "<space>fi", [[<cmd>lua require("telescope.builtin").lsp_implemenetations()<CR>]], opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "<space>fs", [[<cmd>lua require("telescope.builtin").lsp_document_symbols()<CR>]], opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "<space>ws", [[<cmd>lua require("telescope.builtin").lsp_workspace_symbols()<CR>]], opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "<space>Ws", [[<cmd>lua require("telescope.builtin").lsp_dynamic_workspace_symbols()<CR>]], opts)

  -- DISPLAY commands (uses float menu)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "<space>sh", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
  -- vim.api.nvim_buf_set_keymap(bufnr, "i", "<C-h>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts) -- i_<C-S> for Isurround

  -- ACTION commands
  vim.api.nvim_buf_set_keymap(bufnr, "n", "<space>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "<space>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
  -- vim.api.nvim_buf_set_keymap(bufnr, "n", "<space>ca", [[<cmd>lua require("telescope.builtin").lsp_code_action()<CR>]], opts)
  vim.cmd [[ command! Format execute "lua vim.lsp.buf.formatting()" ]]
  -- vim.api.nvim_buf_set_keymap(bufnr, "n", "<space>lf", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)

  -- TODO: do i need this? what is this for project.nvim user?
  vim.api.nvim_buf_set_keymap(bufnr, "n", "<space>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "<space>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "<space>wl", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>", opts)
end

-- Add addtional capabilities supported by nvim-cmp
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = cmp_nvim_lsp.update_capabilities(capabilities)

-- sumneko_lua runtime path setting
local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

-- lspserver specific configuration
-- :h lspconfig-server-configuration
local servers = {
  -- server = config pair
  clangd = true,
  rust_analyzer = true,
  cmake = true,
  bashls = true,
  pyright = true,
  vimls = true,
  sumneko_lua = {
    settings = {
      Lua = {
        runtime = {
          -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
          version = 'LuaJIT',
          -- Setup your lua path
          path = runtime_path,
        },
        diagnostics = {
          -- Get the language server to recognize the `vim` global
          globals = {'vim'},
        },
        workspace = {
          -- Make the server aware of Neovim runtime files
          library = vim.api.nvim_get_runtime_file("", true),
        },
        -- Do not send telemetry data containing a randomized but unique identifier
        telemetry = {
          enable = false,
        },
      },
    },
  },
  --   grammarly = true,
  --   clangd = {
  --     cmd = {
  --       "clangd",
  --       "--background-index",
  --       "--suggest-missing-includes",
  --       "--clang-tidy",
  --       "--header-insertion=iwyu",
  --     },
  --     -- Required for lsp-status
  --     init_options = {
  --       clangdFileStatus = true,
  --     },
  --     handlers = nvim_status.extensions.clangd.setup(),
  --   },
  -- 
  --   rust_analyzer = {
  --     cmd = { "rustup", "run", "nightly", "rust-analyzer" },
  --   },
}

local lsp_installer = require("nvim-lsp-installer")

local setup_server = function(server, config)
  if not config then
    return
  end

  if type(config) ~= "table" then
    config = {}
  end

  -- retrieve Server object from lsp_installer
  local ok, server_instance = lsp_installer.get_server(server)
  if not ok then
    vim.api.nvim_echo({{"error", "Error"}}, true, {})
    return
  end

  -- merging server specific config with default config,
  config = vim.tbl_deep_extend("force", {
    -- on_init = custom_init,
    on_attach = on_attach,
    capabilities = capabilities,
    -- flags = {
    --   debounce_text_changes = nil,
    -- },
    cmd_env = server_instance:get_default_options().cmd_env,
  }, config)

  lspconfig[server].setup(config)
  -- server_instance:setup_lsp(config)
end

for server, config in pairs(servers) do
  setup_server(server, config)
end

return {
  on_attach = on_attach,
  capabilities = capabilities,
}
