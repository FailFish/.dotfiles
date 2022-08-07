local ok1, lspconfig = pcall(require, "lspconfig")
if not ok1 then
  return
end

local ok2, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not ok2 then
  return
end

-- require("user.lsp.lsp-installer")
-- require("user.lsp.handlers").setup()

-- Mappings.
-- TODO: uapi/util functions and expose nmap and imap?
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
-- <space>{_,f,q,l}{_,w,W}{object:reference, diagnostic, ...}
local opts = { silent=true } -- remap = false in default
vim.keymap.set("n", "<space>d", function ()
  vim.diagnostic.open_float(0, { scope = "line" })
end, opts)
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
vim.keymap.set("n", "<space>ld", vim.diagnostic.setloclist, opts) -- current buffer diagnostic
vim.keymap.set("n", "<space>qd", vim.diagnostic.setqflist, opts) -- workspace(all opened buffer) diagnostic

vim.keymap.set("n", "<space>fwd", require("telescope.builtin").diagnostics, opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(_, bufnr)
  local opts = { buffer = bufnr }
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  -- JUMP commands
  vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
  vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
  vim.keymap.set("n", "<space>gt", vim.lsp.buf.type_definition, opts)

  -- LIST commands (uses qflist)
  vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
  vim.keymap.set("n", "<space>gi", vim.lsp.buf.implementation, opts)
  vim.keymap.set("n", "<space>qs", vim.lsp.buf.document_symbol, opts) -- list all symbols in the current buffer
  -- LIST command (uses telescope)
  vim.keymap.set("n", "<space>fi", require("telescope.builtin").lsp_implementations, opts)
  vim.keymap.set("n", "<space>fs", require("telescope.builtin").lsp_document_symbols, opts)
  vim.keymap.set("n", "<space>fws", require("telescope.builtin").lsp_workspace_symbols, opts)
  vim.keymap.set("n", "<space>fWs", require("telescope.builtin").lsp_dynamic_workspace_symbols, opts)

  -- DISPLAY commands (uses float menu)
  vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
  vim.keymap.set("n", "<space>sh", vim.lsp.buf.signature_help, opts)
  -- vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, opts) -- i_<C-S> for Isurround

  -- ACTION commands
  vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, opts)
  vim.keymap.set("n", "<space>ca", vim.lsp.buf.code_action, opts)
  -- vim.keymap.set("n", "<space>ca", require("telescope.builtin").lsp_code_action, opts)
  vim.api.nvim_create_user_command("Format", function () vim.lsp.buf.formatting() end, {})
  -- vim.keymap.set("n", "<space>lf", vim.lsp.buf.formatting, opts)

  -- TODO: do i need this? what is this for project.nvim user?
  vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, opts)
  vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, opts)
  vim.keymap.set("n", "<space>wl", function ()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, opts)
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
  rust_analyzer = true,
  cmake = true,
  bashls = true,
  pyright = true,
  vimls = true,
  sumneko_lua = { -- look folke/lua-lsp.lua https://gist.github.com/folke/fe5d28423ea5380929c3f7ce674c41d8
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
          maxPrelaod = 2000,
          preloadFileSize = 50000,
        },
        completion = { callSnippet = "Both" },
        -- Do not send telemetry data containing a randomized but unique identifier
        telemetry = {
          enable = false,
        },
      },
    },
  },
  clangd = {
    cmd = {
      "clangd",
      "--background-index",
      "--suggest-missing-includes",
      "--clang-tidy",
      "--header-insertion=iwyu",
      "--completion-style=detailed",
      "--malloc-trim",
      -- "-j=5",
    },
    -- Required for lsp-status
    -- init_options = {
    --   clangdFileStatus = true,
    -- },
    -- handlers = nvim_status.extensions.clangd.setup(),
  },
  -- grammarly = true,
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
