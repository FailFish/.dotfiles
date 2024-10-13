---@param on_attach fun(client, buffer)
local function register_on_attach(on_attach)
  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
      local buffer = args.buf
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      on_attach(client, buffer)
    end,
  })
end
local server_config = require("user.configs.servers")
return {
  -- lspconfig
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      {
        "folke/neoconf.nvim",
        cmd = "Neoconf",
        config = true,
      },
      {
        "folke/neodev.nvim",
        opts = { experimental = { pathStrict = true } },
      },
      { "hrsh7th/cmp-nvim-lsp" },
      { "ray-x/lsp_signature.nvim" },

      { "b0o/SchemaStore.nvim" },
      { "https://git.sr.ht/~whynothugo/lsp_lines.nvim" },

      { "j-hui/fidget.nvim", opts = {} },
      {
        "aznhe21/actions-preview.nvim",
      },
      { "p00f/clangd_extensions.nvim" },
      { "simrat39/rust-tools.nvim" },
    },
    ---@class PluginLspOpts
    opts = {
      -- options for vim.diagnostic.config()
      diagnostics = {
        virtual_text = {
          source = "if_many",
          -- prefix = "·", -- 00b7
          -- prefix = "⋅", -- 22c5
          prefix = "⚫",
          -- prefix = "●",
        },
        severity_sort = true,
        float = {
          -- border = "rounded",
          -- source = "always",
        },
      },
      -- LSP Server Settings
      servers = server_config.servers,
      -- External LSP Setting
      setup = server_config.setup,
    },
    ---@param opts PluginLspOpts
    config = function(_, opts)
      -- setup formatting and keymaps
      register_on_attach(function(client, buffer)
        require("user.configs.keymaps").on_attach(client, buffer)
      end)

      -- diagnostics
      vim.diagnostic.config(opts.diagnostics)

      local servers = opts.servers
      local capabilities =
        require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

      local function setup(server)
        local server_opts = vim.tbl_deep_extend("force", {
          capabilities = vim.deepcopy(capabilities),
        }, servers[server] or {})

        if opts.setup[server] then
          if opts.setup[server](server, server_opts) then
            return
          end
        elseif opts.setup["*"] then
          if opts.setup["*"](server, server_opts) then
            return
          end
        end
        require("lspconfig")[server].setup(server_opts)
      end

      for server, server_opts in pairs(servers) do
        if server_opts then
          server_opts = server_opts == true and {} or server_opts
          setup(server)
        end
      end

      vim.keymap.set({ "n", "v" }, "cp", require("actions-preview").code_actions)

      require("lsp_lines").setup()
      vim.diagnostic.config({ virtual_text = true, virtual_lines = false })
      vim.keymap.set("", "<leader>l", require("lsp_lines").toggle, { desc = "Toggle lsp_lines" })
    end,
  },

  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      {
        "<leader>cf",
        function()
          require("conform").format({ async = true })
        end,
        mode = "",
        desc = "Format buffer",
      },
    },
    formatters_by_ft = {
      lua = { "stylua" },
      -- Conform will run multiple formatters sequentially
      rust = { "rustfmt", lsp_format = "fallback" },
      python = { "isort", "black" },
      go = { "goimports", "gofmt" },
      bash = { "shfmt" },
      nix = { "nixpkg_fmt" },
      -- filetypes without any formatters specified
      ["_"] = { "trim_whitespace" },
    },
  },

  {
    "mfussenegger/nvim-lint",
    config = function ()
      require("lint").linters_by_ft = {
        bash = { "shellcheck" },
        nix = { "statix" },
        python = { "flake8" },
        -- TODO: linter for english writing
      }
    end,
  },
}
