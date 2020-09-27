" Comments in Vimscript start with a `"`.

""""""""""""""""""""""""""""""""""""""""""""""
" Vim plug-in list
" Updated : 23 aug 2020
"
" 0. vim-plug
" Candidates : surround.vim / NERD Tree
"		fzf / ALE / coc.nvim 
" 		gruvbox/Nord colorscheme / commentary.vim 
"
call plug#begin('~/.vim/plugged')
Plug 'morhetz/gruvbox'
	autocmd vimenter * colorscheme gruvbox
	set background=dark

"" editing
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'

" browsing file system
Plug 'scrooloose/nerdtree'
" After install fzf, go installed directory and run ./install script
" to modify your {bash, zsh, fish}rc file
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" LSP(coc.nvim) + linter(ale)
" \"diagnostics.displayByAle\" : \"true\" in cocconfig
" ALE enables all available linters by default
" python : jedi(LSP)
" c/c++ : clangd(LSP)
" vimscript : vim-lsp
" bashscript : bash-lsp
Plug 'w0rp/ale'
	let g:ale_disable_lsp = 1
	" let g:ale_lint_delay = 1000
	let g:ale_lint_on_text_changed = 'never'
	" let g:ale_linters = {
	" 			\	'python' : ['flake8', 'mypy']
	" 			\	}
Plug 'neoclide/coc.nvim', {'branch': 'release'}
	let g:coc_global_extensions = ['coc-git', 'coc-python',
				\	'coc-sh', 'coc-vimlsp', 'coc-clangd']

"" git integration
Plug 'tpope/vim-fugitive'

call plug#end()
""""""""""""""""""""""""""""""""""""""""""""""
" If you open this file in Vim, it'll be syntax highlighted for you.

" Vim is based on Vi. Setting `nocompatible` switches from the default
" Vi-compatibility mode and enables useful Vim functionality. This
" configuration option turns out not to be necessary for the file named
" '~/.vimrc', because Vim automatically enters nocompatible mode if that file
" is present. But we're including it here just in case this config file is
" loaded some other way (e.g. saved as `foo`, and then Vim started with
" `vim -u foo`).
set nocompatible

" Turn on syntax highlighting.
syntax on
" Indenting policy
filetype plugin indent on

" Disable the default Vim startup message.
set shortmess+=I

" Show line numbers.
set number

" This enables relative line numbering mode. With both number and
" relativenumber enabled, the current line shows the true line number, while
" all other lines (above and below) are numbered relative to the current line.
" This is useful because you can tell, at a glance, what count is needed to
" jump up or down to a particular line, by {count}k to go up or {count}j to go
" down.
set relativenumber

" whitespace setup
" softtab is one way of tabbing w/o pressing real tab key, but only with spaces.
" i am a hardtab guy
set shiftwidth=4
set tabstop=4

" Always show the status line at the bottom, even if you only have one window open.
set laststatus=2

" The backspace key has slightly unintuitive behavior by default. For example,
" by default, you can't backspace before the insertion point set with 'i'.
" This configuration makes backspace behave more reasonably, in that you can
" backspace over anything.
set backspace=indent,eol,start

" By default, Vim doesn't let you hide a buffer (i.e. have a buffer that isn't
" shown in any window) that has unsaved changes. This is to prevent you from "
" forgetting about unsaved changes and then quitting e.g. via `:qa!`. We find
" hidden buffers helpful enough to disable this protection. See `:help hidden`
" for more information on this.
set hidden

" This setting makes search case-insensitive when all characters in the string
" being searched are lowercase. However, the search becomes case-sensitive if
" it contains any capital letters. This makes searching more convenient.
set ignorecase
set smartcase

" Enable searching as you type, rather than waiting till you press enter.
set incsearch

" Unbind some useless/annoying default key bindings.
" 'Q' in normal mode enters Ex mode. You almost never want this.
nmap Q <Nop>

" Disable audible bell because it's annoying.
set noerrorbells visualbell t_vb=

" Enable mouse support. You should avoid relying on this too much, but it can
" sometimes be convenient.
set mouse+=a

" Try to prevent bad habits like using the arrow keys for movement. This is
" not the only possible bad habit. For example, holding down the h/j/k/l keys
" for movement, rather than using more efficient movement commands, is also a
" bad habit. The former is enforceable through a .vimrc, while we don't know
" how to prevent the latter.
" Do this in normal mode...
nnoremap <Left>  :echoe "Use h"<CR>
nnoremap <Right> :echoe "Use l"<CR>
nnoremap <Up>    :echoe "Use k"<CR>
nnoremap <Down>  :echoe "Use j"<CR>
" ...and in insert mode
inoremap <Left>  <ESC>:echoe "Use h"<CR>
inoremap <Right> <ESC>:echoe "Use l"<CR>
inoremap <Up>    <ESC>:echoe "Use k"<CR>
inoremap <Down>  <ESC>:echoe "Use j"<CR>
