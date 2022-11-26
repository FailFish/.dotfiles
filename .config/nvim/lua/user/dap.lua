local has_dap, dap = pcall(require, "dap")
if not has_dap then
  return
end
local dap_python = require("dap-python")
local dapui = require("dapui")
local dap_virt = require("nvim-dap-virtual-text")
local keymap = vim.keymap.set

-- dap general settings
dapui.setup()
dap_virt.setup()

-- :help dap-extensions
dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end

local opts = { noremap = true }
keymap("n", "<F1>", require("dap").continue, opts)
keymap("n", "<F2>", require("dap").step_over, opts)
keymap("n", "<F3>", require("dap").step_into, opts)
keymap("n", "<F4>", require("dap").step_out, opts)
keymap("n", "<leader>db", require("dap").toggle_breakpoint, opts)
keymap("n", "<leader>dB", function()
  require("dap").set_breakpoint(vim.fn.input("[DAP] condition: "))
end, { noremap = true, desc = "conditional breakpoint" })
keymap("n", "<leader>dr", require("dap").repl.toggle, opts)
keymap("n", "<leader>dl", require("dap").run_last, opts)
-- keymap("n", "<leader>dL", require("dap").set_breakpoint(nil, nil, vim.fn.input('[DAP] Log point message: ')), opts)
-- keymap("n", "<??>", require("dap.ui.widgets").hover(), opts)

-- language-specific setting
-- PYTHON(debugpy)
dap_python.setup("python")
dap_python.test_runner = "pytest"
keymap("n", "<leader>dm", require("dap-python").test_method, opts)
keymap("n", "<leader>dc", require("dap-python").test_class, opts)
keymap("n", "<leader>ds", require("dap-python").debug_selection, opts)

-- LUA(osv)
dap.adapters.nlua = function(callback, config) -- this `config` is `dap.configurations.<lang>`.
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
-- keymap("n", "<??>", function() require("osv").launch({ port = 54321 }) end, opts)

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
