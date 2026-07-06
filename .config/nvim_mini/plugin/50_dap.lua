-- ┌───────────┐
-- │ Debugging │
-- └───────────┘

local add = vim.pack.add
local later = Config.later

later(function()
  add({
    'https://github.com/mfussenegger/nvim-dap',
    'https://github.com/rcarriga/nvim-dap-ui',
    'https://github.com/nvim-neotest/nvim-nio',
    'https://github.com/theHamsta/nvim-dap-virtual-text',
    'https://github.com/jbyuki/one-small-step-for-vimkind',
  })

  local dap = require('dap')
  local dapui = require('dapui')

  dapui.setup()
  require('nvim-dap-virtual-text').setup()

  -- Lua (in-process, via 'one-small-step-for-vimkind') =========================
  dap.adapters.nlua = function(callback, config)
    callback({ type = 'server', host = config.host, port = config.port })
  end
  dap.configurations.lua = {
    {
      type = 'nlua',
      request = 'attach',
      name = 'Attach to running Neovim instance',
      host = '127.0.0.1',
      port = 54321,
    },
  }

  -- C, C++, Rust (lldb via codelldb) ============================================
  -- Requires a `codelldb` binary on PATH
  local codelldb_path = vim.fn.exepath('codelldb')
  if codelldb_path == '' then
    vim.notify(
      '[dap] `codelldb` not found on PATH: C/C++/Rust debugging will not work '
        .. 'until it is installed (e.g. via nixpkgs).',
      vim.log.levels.WARN
    )
  end

  dap.adapters.codelldb = {
    type = 'server',
    port = '${port}',
    executable = { command = codelldb_path, args = { '--port', '${port}' } },
  }

  local lldb_config = {
    {
      type = 'codelldb',
      request = 'launch',
      name = 'Launch',
      program = function()
        return vim.fn.input('[DAP] Path to executable: ', vim.fn.getcwd() .. '/', 'file')
      end,
      cwd = '${workspaceFolder}',
      stopOnEntry = false,
      args = {},
    },
  }
  dap.configurations.c = lldb_config
  dap.configurations.cpp = lldb_config
  dap.configurations.rust = lldb_config

  dap.listeners.after.event_initialized['dapui_config'] = function() dapui.open() end
  dap.listeners.before.event_terminated['dapui_config'] = function() dapui.close() end
  dap.listeners.before.event_exited['dapui_config'] = function() dapui.close() end

  -- Keymaps ======================================================================
  -- d is for 'Debug'.
  local nmap_leader = function(suffix, rhs, desc)
    vim.keymap.set('n', '<Leader>' .. suffix, rhs, { desc = desc })
  end

  nmap_leader('db', function() dap.toggle_breakpoint() end, 'Toggle breakpoint')
  nmap_leader('dB', function() dap.set_breakpoint(vim.fn.input('[DAP] condition: ')) end, 'Conditional breakpoint')
  nmap_leader('dc', function() dap.continue() end, 'Continue')
  nmap_leader('dn', function() dap.step_over() end, 'Step over')
  nmap_leader('di', function() dap.step_into() end, 'Step into')
  nmap_leader('do', function() dap.step_out() end, 'Step out')
  nmap_leader('ds', function() require('osv').launch({ port = 54321 }) end, 'Launch Lua debug server')
  nmap_leader('dw', function() require('dap.ui.widgets').hover() end, 'Widgets hover')
  nmap_leader('dr', function() dap.repl_toggle() end, 'REPL toggle')
  nmap_leader('dl', function() dap.run_last() end, 'Run last')
  nmap_leader('du', function() dapui.toggle({}) end, 'DAP UI toggle')
end)
