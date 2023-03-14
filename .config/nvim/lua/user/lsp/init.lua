local ok1, lspconfig = pcall(require, "lspconfig")
if not ok1 then
  return
end

local ok2, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not ok2 then
  return
end

-- filetype specific mappings
local filetype_attach = setmetatable({
  tex = function()
    vim.bo.omnifunc = "vimtex#complete#omnifunc"
  end,
}, {
  __index = function()
    return function() end
  end,
})

-- General LSP Mappings.
-- TODO: uapi/util functions and expose nmap and imap?
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
-- <space>{_,f,q,l}{_,w,W}{object:reference, diagnostic, ...}
local opts = { silent = true } -- remap = false in default
vim.keymap.set("n", "<space>d", function()
  vim.diagnostic.open_float(0, { scope = "line" })
end, vim.tbl_extend("force", { desc = "lsp: diagnostics in a current line" }, opts))
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
vim.keymap.set("n", "<space>ld", vim.diagnostic.setloclist, opts) -- current buffer diagnostic
vim.keymap.set("n", "<space>qd", vim.diagnostic.setqflist, opts) -- workspace(all opened buffer) diagnostic

vim.keymap.set("n", "<space>fwd", require("telescope.builtin").diagnostics, opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  local bufopts = { noremap = true, silent = true, buffer = bufnr }
  -- This makes i_<c-x><c-o> also trigger completion provided lsp
  vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  -- JUMP commands
  vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
  vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
  vim.keymap.set("n", "<space>gt", vim.lsp.buf.type_definition, bufopts)

  -- LIST commands (uses qflist)
  vim.keymap.set("n", "gr", vim.lsp.buf.references, bufopts)
  vim.keymap.set("n", "<space>gi", vim.lsp.buf.implementation, bufopts)
  vim.keymap.set("n", "<space>qs", vim.lsp.buf.document_symbol, bufopts) -- list all symbols in the current buffer
  -- LIST command (uses telescope)
  vim.keymap.set("n", "<space>fi", require("telescope.builtin").lsp_implementations, bufopts)
  vim.keymap.set("n", "<space>fs", require("telescope.builtin").lsp_document_symbols, bufopts)
  vim.keymap.set("n", "<space>fws", require("telescope.builtin").lsp_workspace_symbols, bufopts)
  vim.keymap.set(
    "n",
    "<space>fWs",
    require("telescope.builtin").lsp_dynamic_workspace_symbols,
    bufopts
  )

  -- DISPLAY commands (uses float menu)
  vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
  vim.keymap.set("n", "<space>sh", vim.lsp.buf.signature_help, bufopts)
  -- vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, opts) -- i_<C-S> for Isurround

  -- ACTION commands
  vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, bufopts)
  vim.keymap.set("n", "<space>ca", vim.lsp.buf.code_action, bufopts)
  -- vim.keymap.set("n", "<space>ca", require("telescope.builtin").lsp_code_action, opts)
  vim.api.nvim_create_user_command("Format", function()
    vim.lsp.buf.format({ async = true })
  end, {})
  vim.keymap.set("n", "<space>cf", function () vim.lsp.buf.formatting({async = true}) end, opts)
  vim.keymap.set("v", "<space>cf", function () vim.lsp.buf.range_formatting({async = true}) end, opts)

  -- TODO: do i need this? what is this for project.nvim user?
  vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, bufopts)
  vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, bufopts)
  vim.keymap.set("n", "<space>wl", function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, vim.tbl_extend("force", { desc = "lsp: prompt a list of workspace folders" }, bufopts))

  local filetype = vim.api.nvim_buf_get_option(bufnr, "filetype")

  filetype_attach[filetype](client, bufnr)
end

-- Add addtional capabilities supported by nvim-cmp
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = cmp_nvim_lsp.default_capabilities(capabilities)

-- sumneko_lua runtime path setting
local runtime_path = vim.split(package.path, ";")
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

-- rust specific setting (rust-tools.nvim + project local)
local rust_analyzer = nil
local rust_analyzer_init = function(client)
  local path = client.workspace_folders[1].name
  if path == vim.fs.normalize("~/rust") then
    client.config.settings["rust_analyzer"].checkOnSave.overrideCommand =
      { "python3", "x.py", "check", "--json-output" }
  else
    client.config.settings["rust_analyzer"].checkOnSave.overrideCommand = { "cargo", "check" }
  end

  client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
end
local has_rt, rt = pcall(require, "rust-tools")
if has_rt then
  -- local extension_path = vim.fn.expand "~/.vscode/extensions/sadge-vscode/extension/"
  -- local codelldb_path = extension_path .. "adapter/codelldb"
  -- local liblldb_path = extension_path .. "lldb/lib/liblldb.so"

  rt.setup({
    server = {
      init = rust_analyzer_init,
      capabilities = capabilities,
      on_attach = on_attach,
      settings = {
        ["rust-analyzer"] = { checkOnSave = { overrideCommand = {} } }, -- explicit call out
      },
    },
    -- dap = {
    --   adapter = require("rust-tools.dap").get_codelldb_adapter(codelldb_path, liblldb_path),
    -- },
    tools = {
      inlay_hints = {
        auto = true,
      },
    },
  })
else
  rust_analyzer = {
    init = rust_analyzer_init,
  }
end

-- lspserver specific configuration
-- :h lspconfig-server-configuration
local servers = {
  -- server = config pair
  rust_analyzer = rust_analyzer,
  cmake = true,
  bashls = true,
  pyright = true,
  vimls = true,
  texlab = true,
  ltex = true,
  nil_ls = true,
  sumneko_lua = { -- look folke/lua-lsp.lua https://gist.github.com/folke/fe5d28423ea5380929c3f7ce674c41d8
    settings = {
      Lua = {
        runtime = {
          -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
          version = "LuaJIT",
          -- Setup your lua path
          path = runtime_path,
        },
        diagnostics = {
          -- Get the language server to recognize the `vim` global
          globals = { "vim" },
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
      "--clang-tidy",
      "--header-insertion=iwyu",
      "--completion-style=detailed",
      "--malloc-trim",
      "--offset-encoding=utf-16",
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

local setup_server = function(server, config)
  if not config then
    return
  end

  if type(config) ~= "table" then
    config = {}
  end

  -- merging server specific config with default config,
  config = vim.tbl_deep_extend("force", {
    -- on_init = custom_init,
    on_attach = on_attach,
    capabilities = capabilities,
    -- flags = {
    --   debounce_text_changes = nil,
    -- },
  }, config)

  lspconfig[server].setup(config)
end

for server, config in pairs(servers) do
  setup_server(server, config)
end

-- null-ls setup
require("user.lsp.null_ls").setup(on_attach)

return {
  on_attach = on_attach,
  capabilities = capabilities,
}
