local M = {}

-- sumneko_lua runtime path setting
local runtime_path = vim.split(package.path, ";")
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

-- rust specific setting (rust-tools.nvim + project local)
-- return true if you don't want this server to be setup with lspconfig
M.setup = {
  -- example to setup with typescript.nvim
  -- tsserver = function(_, opts)
  --   require("typescript").setup({ server = opts })
  --   return true
  -- end,
  -- Specify * to use this function as a fallback for any server
  -- ["*"] = function(server, opts) end,
  clangd = function(_, opts)
    require("clangd_extensions").setup({ server = opts })
    return true
  end,
  rust_analyzer = function(_, opts)
    local extension_path = vim.fn.expand("~/.vscode/extensions/sadge-vscode/extension/")
    local codelldb_path = extension_path .. "adapter/codelldb"
    local liblldb_path = extension_path .. "lldb/lib/liblldb.so"

    local rust_tools_opt = vim.tbl_deep_extend("force", opts, {
      server = {
        init = function(client)
          local path = client.workspace_folders[1].name
          if path == vim.fs.normalize("~/rust") then
            client.config.settings["rust_analyzer"].checkOnSave.overrideCommand =
            { "python3", "x.py", "check", "--json-output" }
          else
            client.config.settings["rust_analyzer"].checkOnSave.overrideCommand = { "cargo", "check" }
          end

          client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
        end,

        on_attach = function(_, buffer)
          vim.keymap.set(
          "n",
          "K",
          "<cmd>RustHoverActions<cr>",
          { buffer = buffer, desc = "Hover Actions (Rust)" }
          )
          vim.keymap.set(
          "n",
          "<leader>cR",
          "<cmd>RustCodeAction<cr>",
          { buffer = buffer, desc = "Code Action (Rust)" }
          )
        end,

        settings = {
          ["rust-analyzer"] = {
            cargo = {
              features = "all",
            },
            -- Add clippy lints for Rust.
            check = {
              features = "all",
              command = "clippy",
              extraArgs = { "--no-deps" },
            },
            procMacro = {
              enable = true,
              ignored = {
                ["async-trait"] = { "async_trait" },
                ["napi-derive"] = { "napi" },
                ["async-recursion"] = { "async_recursion" },
              },
            },
          },
        },
      },

      tools = {
        inlay_hints = {
          auto = true,
        },
      },

      dap = {
        adapter = require("rust-tools.dap").get_codelldb_adapter(codelldb_path, liblldb_path),
      },
    })
    require("rust-tools").setup(rust_tools_opt)
    -- rust-tools recommends to avoid interacting nvim-lspconfig manually
    -- true: skips the nvim-lspconfig
    return true
  end,
}

M.servers = {
  -- server = config pair
  rust_analyzer = {},
  cmake = {},
  bashls = {},
  pyright = {},
  vimls = {},
  texlab = {},
  ltex = {},
  gopls = {},
  jsonls = {
    settings = {
      json = {
        format = {
          enable = true,
        },
        validate = { enable = true },
      },
    },
  },
  -- nixd = {},
  rnix = {},
  nil_ls = {
    settings = {
      ["nil"] = {
        formatting = {
          command = { "nixpkgs-fmt" },
        },
      },
    },
  },
  lua_ls = {
    -- look folke/lua-lsp.lua https://gist.github.com/folke/fe5d28423ea5380929c3f7ce674c41d8
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
}

return M
