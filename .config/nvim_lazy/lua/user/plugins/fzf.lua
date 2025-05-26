local picker = setmetatable({}, {
  __call = function(m, ...)
    return m.wrap(...)
  end,
})

function picker.wrap(command, opts)
  return function()
    picker.adjust_cwd_and_call(command, opts)
  end
end

function picker.adjust_cwd_and_call(command, opts)
  opts = opts or {}
  local fzf_lua = require("fzf-lua")
  local path = require("fzf-lua.path")
  local git_root = path.git_root({})
  local search_dir = opts.cwd == true and vim.loop.cwd() or git_root
  if command == "files" and git_root then
    command = "git_files"
  end
  return fzf_lua[command]({ cwd = search_dir })
end

return {
  {
    "ibhagwan/fzf-lua",
    cmd = "FzfLua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      winopts = {
        -- disable backdrop
        backdrop = 100,
      },
      previewers = {
        builtin = {
          -- The previewer will not add syntax highlighting to files larger than 100KB
          syntax_limit_b = 1024 * 100, -- 100KB
        },
      },
      keymap = {
        fzf = {
          ["ctrl-z"] = "abort",
          ["ctrl-d"] = "half-page-down",
          ["ctrl-u"] = "half-page-up",
          -- ["shift-d"]  = "preview-page-down",
          -- ["shift-up"]    = "preview-page-up",
        },
      },
      -- actions = { },
    },
    keys = {
      -- find
      { "<leader>f;", "<cmd>FzfLua resume<cr>", desc = "Resume" },
      { "<leader>f:", "<cmd>FzfLua command_history<cr>", desc = "Command History" },
      { '<leader>f"', "<cmd>FzfLua registers<cr>", desc = "Registers" },
      { "<leader>f/", "<cmd>FzfLua search_history<cr>", desc = "Search History" },
      { "<leader>f?", "<cmd>FzfLua keymaps<cr>", desc = "Key Maps" },
      {
        "<leader>fb",
        "<cmd>FzfLua buffers sort_mru=true sort_lastused=true<cr>",
        desc = "Buffers",
      },
      { "<leader>ff", picker("files"), desc = "Find Files (root dir)" },
      { "<leader>fF", picker("files", { cwd = true }), desc = "Find Files (cwd)" },
      { "<leader>fr", "<cmd>FzfLua oldfiles<cr>", desc = "Recent" },

      -- git
      { "<leader>gc", "<cmd>FzfLua git_commits<CR>", desc = "git commits" },
      { "<leader>gf", "<cmd>FzfLua git_files<CR>", desc = "git files" },
      { "<leader>gs", "<cmd>FzfLua git_status<CR>", desc = "git status" },

      { "<leader>fd", "<cmd>FzfLua diagnostics_document<cr>", desc = "Document Diagnostics" },
      { "<leader>fD", "<cmd>FzfLua diagnostics_workspace<cr>", desc = "Workspace Diagnostics" },
      { "<leader>fh", "<cmd>FzfLua helptags<cr>", desc = "Help Pages" },
      { "<leader>fM", "<cmd>FzfLua man_pages<cr>", desc = "Man Pages" },
      { "<leader>fm", "<cmd>FzfLua marks<cr>", desc = "Jump to Mark" },
      { "<leader>f<leader>", "<cmd>FzfLua builtin<cr>", desc = "Builtins" },
      {
        "<leader>fs",
        function()
          require("fzf-lua").lsp_document_symbols({})
        end,
        desc = "Goto Symbol",
      },
      {
        "<leader>fS",
        function()
          require("fzf-lua").lsp_live_workspace_symbols({})
        end,
        desc = "Goto Symbol (Workspace)",
      },

      -- search
      { "<leader>sb", "<cmd>FzfLua grep_curbuf<cr>", desc = "Buffer Lines" },
      { "<leader>sg", picker("live_grep"), desc = "Grep (root dir)" },
      { "<leader>sG", picker("live_grep", { cwd = true }), desc = "Grep (cwd)" },
      { "<leader>sw", picker("grep_cword"), desc = "Word (root dir)" },
      { "<leader>sW", picker("grep_cword", { cwd = true }), desc = "Word (cwd)" },
      { "<leader>sw", picker("grep_visual"), mode = "v", desc = "Selection (root dir)" },
      { "<leader>sW", picker("grep_visual", { cwd = true }), mode = "v", desc = "Selection (cwd)" },
    },
  },
}
