local status_ok, telescope = pcall(require, "telescope")
if not status_ok then
  return
end

local actions = require "telescope.actions"
local actions_layout = require "telescope.actions.layout"
local sorters = require "telescope.sorters"

telescope.setup {
  defaults = {
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
    }
  },
  extensions = {
    fzf = {
      fuzzy = true,                    -- false will only do exact matching
      override_generic_sorter = true,  -- override the generic sorter
      override_file_sorter = true,     -- override the file sorter
      case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
      -- the default case_mode is "smart_case"
    },
    file_browser = {
      theme = "ivy",
      layout_config = {
        height = 15,
      },
      winblend = 10,
    },
  },
}

require("user.telescope.keymaps")
require("telescope").load_extension "file_browser"
require("telescope").load_extension "fzf"
require("telescope").load_extension "projects"
require("telescope").load_extension "dap"
-- require("telescope").load_extension "notify"
