-- vim.opt.nocompatible = true -- this feature is removed as it becomes default
vim.opt.shortmess = vim.opt.shortmess
    + "a"   -- compilation of multiple options :h shortmess
    + "I"   -- remove vim intro
    + "c"   -- remove ins-completion-menu msgs
    - "S"   -- show search count msgs

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.shiftwidth = 2                      -- length of an indent
vim.opt.tabstop = 2                         -- length of a tab
vim.opt.expandtab = true                    -- expand a tab into spaces
-- vim.opt.smarttab = true                  -- nvim default

-- vim.opt.laststatus = 2                   -- nvim default
-- vim.opt.backspace = indent,eol,start     -- nvim default
-- vim.opt.hidden = true                    -- nvim default

-- case insensitive searching unless capital in search
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- vim.opt.incsearch = true                 -- nvim default
vim.opt.hlsearch = false

vim.opt.errorbells = false
vim.opt.visualbell = true
-- vim.opt.t_vb = ""                        -- t_XX keycodes doesn't exist in nvim

vim.opt.mouse = "a"                         -- enable mouse

-- vim.opt.wildmenu = true                  -- nvim default
vim.opt.wildmode = {"longest:full", "full"}

-- vim.opt.autoread = true                  -- nvim default

vim.opt.scrolloff = 2

vim.opt.list = true
vim.opt.listchars = {
    tab = "| ",
    trail = "-",
    extends = ">",
    precedes = "<",
    nbsp = "+"
}
-- vim.opt.listchars:append({ eol = "$" })

-- vim.opt.encoding = "utf-8"                -- nvim default
-- vim.opt.nrformats:remove("octal")         -- nvim default
-- vim.opt.complete:remove("i")              -- nvim default

vim.opt.backupdir = "/tmp//,."
vim.opt.directory = "/tmp//,."

-- nvim is always feature complete (+persistent-undo)
vim.opt.undofile = true
vim.opt.undodir = "/tmp,."                   -- semi persistent using /tmp

-- appearance
vim.opt.termguicolors = true
-- vim.cmd [[colorscheme gruvbox]]

-- for a better completion experience
vim.opt.updatetime = 300                     -- this affects faster completion
vim.opt.completeopt = { "menuone", "noselect" }

-- from others

-- vim.opt.pumheight = 10
-- vim.opt.showmode = false
-- vim.opt.breakindent = true
-- vim.opt.smartindent = true
-- vim.opt.autoindent = true
-- vim.opt.splitbelow = true
-- vim.opt.splitright = true
-- vim.opt.signcolumn = "yes"
-- vim.opt.cursorline = true
-- vim.opt.formatoptions = vim.opt.formatoptions
--     + ""
--     - ""

-- vim.o.shell = "/usr/bin/fish"


-- statusbar setup
