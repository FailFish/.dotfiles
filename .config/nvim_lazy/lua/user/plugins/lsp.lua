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
      { "folke/neoconf.nvim", cmd = "Neoconf", config = true },
      { "folke/neodev.nvim", opts = { experimental = { pathStrict = true } } },
      { "hrsh7th/cmp-nvim-lsp" },
      { "ray-x/lsp_signature.nvim" },
      {
        "weilbith/nvim-code-action-menu",
        cmd = 'CodeActionMenu',
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
    end,
  },

  {
    "jose-elias-alvarez/null-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = function()
      local null_ls = require("null-ls")
      local null_fmt = null_ls.builtins.formatting
      local null_diag = null_ls.builtins.diagnostics
      local null_act = null_ls.builtins.code_actions
      return {
        root_dir = require("null-ls.utils").root_pattern(
        ".null-ls-root",
        ".neoconf.json",
        "Makefile",
        ".git"
        ),
        sources = {
          -- lua
          null_fmt.stylua,

          -- shell
          null_fmt.shfmt,
          null_diag.shellcheck,

          -- python
          null_fmt.black,
          null_fmt.isort,
          null_diag.flake8,

          -- nix
          null_diag.statix,
          null_act.statix,

          -- english writing (tex, markdown)
          null_act.proselint,
          null_diag.proselint,
          null_diag.write_good,
          null_diag.chktex,
          -- null_fmt.latexindent,

          -- etc
          null_fmt.trim_newlines.with({
            disabled_filetypes = { "rust" }, -- use rustfmt
          }),
          null_fmt.trim_whitespace.with({
            disabled_filetypes = { "rust" }, -- use rustfmt
          }),
          null_fmt.prettier.with({
            filetypes = { "html", "css", "yaml", "markdown", "json" },
          }),
        },
      }
    end,
  },
}
