return {
  {
    "mfussenegger/nvim-dap",

    dependencies = {
      {
        "rcarriga/nvim-dap-ui",
        config = function(_, opts)
          require("dapui").setup(opts)
        end,
      },
      { "theHamsta/nvim-dap-virtual-text" },
      -- { "jbyuki/one-small-step-for-vimkind" },
    },
    init = function()
      vim.keymap.set("n", "<leader>db", function()
        require("dap").toggle_breakpoint()
      end, { desc = "Toggle Breakpoint" })

      vim.keymap.set("n", "<leader>dB", function()
        require("dap").set_breakpoint(vim.fn.input("[DAP] condition: "))
      end, { desc = "Conditional Breakpoint" })

      vim.keymap.set("n", "<leader>dc", function()
        require("dap").continue()
      end, { desc = "Continue" })

      vim.keymap.set("n", "<leader>dn", function()
        require("dap").step_over()
      end, { desc = "Step Over" })

      vim.keymap.set("n", "<leader>di", function()
        require("dap").step_into()
      end, { desc = "Step Into" })

      vim.keymap.set("n", "<leader>do", function()
        require("dap").step_out()
      end, { desc = "Step Out" })

      vim.keymap.set("n", "<leader>dw", function()
        require("dap.ui.widgets").hover()
      end, { desc = "Widgets" })

      vim.keymap.set("n", "<leader>dr", function()
        require("dap").repl_toggle()
      end, { desc = "Repl Toggle" })

      vim.keymap.set("n", "<leader>dl", function()
        require("dap").run_last()
      end, { desc = "Run Last" })

      vim.keymap.set("n", "<leader>du", function()
        require("dapui").toggle({})
      end, { desc = "Dap UI" })

      -- vim.keymap.set("n", "<leader>ds", function()
      --   require("osv").launch({ port = 54321 })
      -- end, { desc = "Launch Lua Debugger Server" })
      --
      -- vim.keymap.set("n", "<leader>dd", function()
      --   require("osv").run_this()
      -- end, { desc = "Launch Lua Debugger" })
    end,

    config = function ()
      local dap = require("dap")

      -- LUA(osv)
      -- this `config` is `dap.configurations.<lang>`.
      dap.adapters.nlua = function(callback, config)
        callback({ type = "server", host = config.host, port = config.port })
      end

      dap.configurations.lua = {
        {
          type = "nlua",
          request = "attach",
          name = "Attach to running Neovim instance",
          host = "127.0.0.1",
          port = 54321,
        },
      }

      -- C, CPP, RUST(lldb)
      dap.adapters.lldb = {
        type = "executable",
        command = "lldb-vscode",
        name = "lldb",
      }

      dap.configurations.c = {
        {
          type = "lldb",
          request = "launch",
          name = "Launch",
          program = function()
            return vim.fn.input("[DAP] Path to executable: ", vim.fn.getcwd() .. "/", "file")
          end,
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
          args = {},
        },
      }

      dap.configurations.cpp = dap.configurations.c
      dap.configurations.rust = dap.configurations.c

      local dapui = require("dapui")
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end
    end,
  },
--  {
--    "mfussenegger/nvim-dap-python",
--    -- enabled = false,
--    dependencies = "mfussenegger/nvim-dap",
--    -- ft = "python",
--    event = "VeryLazy",
--    keys = {
--      { "<leader>dtm", require("dap-python").test_method() },
--      { "<leader>dtc", require("dap-python").test_class() },
--      { "<leader>ds", require("dap-python").debug_selection() },
--    },
--    config = function ()
--      require("dap-python").setup("python")
--    end,
--  },
}
