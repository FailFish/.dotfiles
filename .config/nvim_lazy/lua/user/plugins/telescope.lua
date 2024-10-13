local root_patterns = { ".git", "lua" }
-- Extracted from folke/LazyVim
-- returns the root directory based on:
-- * lsp workspace folders
-- * lsp root_dir
-- * root pattern of filename of the current buffer
-- * root pattern of cwd
---@return string
local function get_root()
  ---@type string?
  local path = vim.api.nvim_buf_get_name(0)
  path = path ~= "" and vim.loop.fs_realpath(path) or nil
  ---@type string[]
  local roots = {}
  if path then
    for _, client in pairs(vim.lsp.get_active_clients({ bufnr = 0 })) do
      local workspace = client.config.workspace_folders
      local paths = workspace
          and vim.tbl_map(function(ws)
            return vim.uri_to_fname(ws.uri)
          end, workspace)
        or client.config.root_dir and { client.config.root_dir }
        or {}
      for _, p in ipairs(paths) do
        local r = vim.loop.fs_realpath(p)
        if path:find(r, 1, true) then
          roots[#roots + 1] = r
        end
      end
    end
  end
  table.sort(roots, function(a, b)
    return #a > #b
  end)
  ---@type string?
  local root = roots[1]
  if not root then
    path = path and vim.fs.dirname(path) or vim.loop.cwd()
    ---@type string?
    root = vim.fs.find(root_patterns, { path = path, upward = true })[1]
    root = root and vim.fs.dirname(root) or vim.loop.cwd()
  end
  ---@cast root string
  return root
end

local function tele_files(builtin, opts)
  local params = { builtin = builtin, opts = opts }
  return function()
    builtin = params.builtin
    opts = params.opts
    opts = vim.tbl_deep_extend("force", { cwd = get_root() }, opts or {})
    if builtin == "files" then
      if vim.loop.fs_stat((opts.cwd or vim.loop.cwd()) .. "/.git") then
        opts.show_untracked = true
        builtin = "git_files"
      else
        builtin = "find_files"
      end
    end
    require("telescope.builtin")[builtin](opts)
  end
end

return {
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    dependencies = {
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
      },
    },
    version = false, -- telescope did only one release, so use HEAD for now
    keys = {
      { "<leader>f:", "<cmd>Telescope command_history<cr>", desc = "Command History" },

      -- find
      { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
      { "<leader>ff", tele_files("files"), desc = "Find Files (root dir)" },
      { "<leader>fF", tele_files("files", { cwd = false }), desc = "Find Files (cwd)" },
      { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent" },

      -- git
      { "<leader>gc", "<cmd>Telescope git_commits<CR>", desc = "git commits" },
      { "<leader>gf", "<cmd>Telescope git_files<CR>", desc = "git files" },
      { "<leader>gs", "<cmd>Telescope git_status<CR>", desc = "git status" },

      -- { "<leader>sd", "<cmd>Telescope diagnostics<cr>", desc = "Diagnostics" },
      { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help Pages" },
      { "<leader>f/", "<cmd>Telescope keymaps<cr>", desc = "Key Maps" },
      { "<leader>f<leader>", "<cmd>Telescope builtin<cr>", desc = "Builtins" },
      { "<leader>fvo", "<cmd>Telescope vim_options<cr>", desc = "Options" },
      {
        "<c-r><c-r>",
        "<Plug>(TelescopeFuzzyCommandSearch)",
        mode = "c",
        desc = "command history from cmdline",
        remap = true,
        nowait = true,
      },
      {
        "<leader>fs",
        function()
          require("telescope.builtin").lsp_document_symbols({
            symbols = {
              "Class",
              "Function",
              "Method",
              "Constructor",
              "Interface",
              "Module",
              "Struct",
              "Trait",
              "Field",
              "Property",
            },
          })
        end,
        desc = "Goto Symbol",
      },
      {
        "<leader>fS",
        function()
          require("telescope.builtin").lsp_workspace_symbols({
            symbols = {
              "Class",
              "Function",
              "Method",
              "Constructor",
              "Interface",
              "Module",
              "Struct",
              "Trait",
              "Field",
              "Property",
            },
          })
        end,
        desc = "Goto Symbol (Workspace)",
      },

      -- search
      { "<leader>sg", tele_files("live_grep"), desc = "Grep (root dir)" },
      { "<leader>sG", tele_files("live_grep", { cwd = false }), desc = "Grep (cwd)" },
      { "<leader>sw", tele_files("grep_string"), desc = "Word (root dir)" },
      { "<leader>sW", tele_files("grep_string", { cwd = false }), desc = "Word (cwd)" },
      { "<leader>sb", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Buffer" },
    },
    opts = function()
      local actions = require("telescope.actions")
      local actions_layout = require("telescope.actions.layout")
      local sorters = require("telescope.sorters")
      return {
        defaults = {
          prompt_prefix = " ",
          selection_caret = " ",
          mappings = {
            i = {
              ["<C-x>"] = false,
              ["<C-c>"] = actions.close,
              ["<C-_>"] = actions.which_key, -- keys from pressing <C-/>
              -- navigation
              ["<C-j>"] = actions.cycle_history_next,
              ["<C-k>"] = actions.cycle_history_prev,
              ["<C-n>"] = actions.move_selection_next,
              ["<C-p>"] = actions.move_selection_previous,
              ["<Down>"] = actions.move_selection_next,
              ["<Up>"] = actions.move_selection_previous,
              -- opening the target
              ["<CR>"] = actions.select_default,
              ["<C-s>"] = actions.select_horizontal,
              ["<C-v>"] = actions.select_vertical,
              ["<C-t>"] = actions.select_tab,
              -- preview navigation
              ["<C-u>"] = actions.preview_scrolling_up,
              ["<C-d>"] = actions.preview_scrolling_down,
              ["<PageUp>"] = actions.results_scrolling_up,
              ["<PageDown>"] = actions.results_scrolling_down,
              -- check/uncheck multiple targets
              ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
              ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
              -- quicklist integration
              ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
              ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
              -- what is this
              ["<C-l>"] = actions.complete_tag,
              ["<C-w>"] = { "<c-s-w>", type = "command" },
              ["<M-p>"] = actions_layout.toggle_preview,
              -- ["<M-m>"] = actions_layout.toggle_mirror,
            },
            n = {
              ["<C-x>"] = false,
              ["<esc>"] = actions.close,
              ["?"] = actions.which_key,
              -- navigation
              ["j"] = actions.move_selection_next,
              ["k"] = actions.move_selection_previous,
              ["H"] = actions.move_to_top,
              ["M"] = actions.move_to_middle,
              ["L"] = actions.move_to_bottom,
              ["<Down>"] = actions.move_selection_next,
              ["<Up>"] = actions.move_selection_previous,
              ["gg"] = actions.move_to_top,
              ["G"] = actions.move_to_bottom,
              -- opening the target
              ["<CR>"] = actions.select_default,
              ["<C-s>"] = actions.select_horizontal,
              ["<C-v>"] = actions.select_vertical,
              ["<C-t>"] = actions.select_tab,
              -- preview navigation
              ["<C-u>"] = actions.preview_scrolling_up,
              ["<C-d>"] = actions.preview_scrolling_down,
              ["<PageUp>"] = actions.results_scrolling_up,
              ["<PageDown>"] = actions.results_scrolling_down,
              -- check/uncheck multiple targets
              ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
              ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
              -- quicklist integration
              ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
              ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
            },
            -- i = {
            --   ["<a-i>"] = function()
            --     tele_files("find_files", { no_ignore = true })()
            --   end,
            --   ["<a-h>"] = function()
            --     tele_files("find_files", { hidden = true })()
            --   end,
            --   ["<C-Down>"] = function(...)
            --     return require("telescope.actions").cycle_history_next(...)
            --   end,
            --   ["<C-Up>"] = function(...)
            --     return require("telescope.actions").cycle_history_prev(...)
            --   end,
            --   ["<C-f>"] = function(...)
            --     return require("telescope.actions").preview_scrolling_down(...)
            --   end,
            --   ["<C-b>"] = function(...)
            --     return require("telescope.actions").preview_scrolling_up(...)
            --   end,
            -- },
            -- n = {
            --   ["q"] = function(...)
            --     return require("telescope.actions").close(...)
            --   end,
            -- },
          },
        },
        pickers = {
          -- picker_name = {
          --     pciker_config_key = value,
          -- },
          find_files = {
            theme = "dropdown",
            previewer = false,
            winblend = 10,
          },
          grep_string = {
            short_path = true,
            word_match = "-w",
            only_sort_text = true,
            layout_strategy = "vertical",
            sorter = sorters.get_fzy_sorter(),
          },
        },
        extensions = {
          fzf = {
            fuzzy = true, -- false will only do exact matching
            override_generic_sorter = true, -- override the generic sorter
            override_file_sorter = true, -- override the file sorter
            case_mode = "smart_case", -- or "ignore_case" or "respect_case"
            -- the default case_mode is "smart_case"
          },
          file_browser = {
            theme = "ivy",
            layout_config = {
              height = 15,
            },
            winblend = 10,
          },
          cder = {
            dir_command = { "fd", "--hidden", "--type=d", ".", get_root() },
          },
        },
      }
    end,
    config = function(_, opts)
      local telescope = require("telescope")
      telescope.setup(opts)

      telescope.load_extension("fzf")
      -- telescope.load_extension "notify"
    end,
  },
  {
    "nvim-telescope/telescope-dap.nvim",
    cmd = "Telescope dap",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "mfussenegger/nvim-dap",
    },
    config = function()
      require("telescope").load_extension("dap")
    end,
  },
  {
    "zane-/cder.nvim",
    cmd = "Telescope cder",
    dependencies = "nvim-telescope/telescope.nvim",
    keys = {
      { "<leader>fc", "<cmd>Telescope cder<cr>", desc = "Fast CD" },
    },
    config = function()
      require("telescope").load_extension("cder")
    end,
  },
}
