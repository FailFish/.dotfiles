" Comments in Vimscript start with a `"`.
"
" install vim plug if not found
if empty(glob('~/.vim/autoload/plug.vim'))
	silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
				\ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" install node (for nvim.coc plugin) if not found
if !executable('node')
	!curl -sL install-node.now.sh/lts | sudo bash
endif

""""""""""""""""""""""""""""""""""""""""""""""
""""""""""""""""""""""""""""""""""""""""""""""
" Vim plug-in list
" Updated : 05 FEB 2021
"
" 0. vim-plug
" Candidates : surround.vim / vim-vinegar
"		fzf / ALE / coc.nvim
"		gruvbox/Nord colorscheme / commentary.vim
" {{
call plug#begin('~/.vim/plugged')
" Colorschemes
Plug 'morhetz/gruvbox'
	autocmd vimenter * colorscheme gruvbox
	set background=dark
Plug 'arcticicestudio/nord-vim'

"" editing
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'

" extension for built-in file system browser
" Replacement of NERDTree
Plug 'tpope/vim-vinegar'

" After install fzf, go installed directory and run ./install script
" to modify your {bash, zsh, fish}rc file
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all'}
Plug 'junegunn/fzf.vim'

"" LSP(coc.nvim) + linter(ale)
"" ALE settings
" ALE enables all available linters by default
Plug 'w0rp/ale'
	let g:ale_disable_lsp = 1
	" let g:ale_lint_delay = 1000
	let g:ale_lint_on_text_changed = 'never'
	" let g:ale_linters = {
	" 			\	'python' : ['flake8', 'mypy']
	" 			\	}
	" let g:ale_python_pylint_executable = 'python3.7'
	" let g:ale_python_flake8_executable= 'python3.7'
	" let g:ale_python_mypy_executable = 'python3.7'
	let g:ale_fix_on_save = 1
	let g:ale_fixers = {
				\	'*' : ['remove_trailing_lines', 'trim_whitespace'],
				\	'python' : ['black', 'autoimport', 'isort'],
				\	'rust' : ['rustfmt'],
				\	'c' : ['clang-format'],
				\	'cpp' : ['clang-format']
				\	}
	let g:ale_c_clangformat_style_option = '{
				\ BasedOnStyle: LLVM,
				\ IndentWidth: 4,
				\ }'

"" Coc.nvim settings
" dependency: git(coc-git), clangd(coc-clangd), cmake(coc-cmake),
Plug 'neoclide/coc.nvim', {'branch': 'release'}
	let g:coc_global_extensions = ['coc-git', 'coc-pyright', 'coc-json',
				\	'coc-sh', 'coc-vimlsp', 'coc-clangd', 'coc-cmake']
	" call coc#config('diagnostic', {'displayByAle': true})

"" git integration
Plug 'tpope/vim-fugitive'
Plug 'junegunn/gv.vim'
Plug 'rhysd/git-messenger.vim'

"" LaTeX
" dependency: zathura and latexmk(vimtex)
Plug 'lervag/vimtex'
	let g:tex_flavor='latex'
	let g:vimtex_view_method='zathura'
	let g:vimtex_quickfix_mode=0

call plug#end()
" }}
""""""""""""""""""""""""""""""""""""""""""""""
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

" Disable the default Vim startup message
" Truncate long messages
" etc
" see :h shortmess for various flags
set shortmess+=aITc

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

" wildmenu is vim commandline tab-completion
" wildmode option decides how completion suggestions behave
set wildmenu
set wildmode=longest:full,full

" automatically refresh the file when it is modified outside of vim
set autoread

" Always show at least (set scrolloff?) line above/below cursor.
set scrolloff=2

set list
set listchars=tab:\|\ ,trail:-,extends:>,precedes:<,nbsp:+
" set listchars+=,eol:$

set encoding=utf-8

" statusline settings
function! s:statusline_expr()
	" left side
	let mod = "%{&modified ? '[+] ' : !&modifiable ? '[x] ' : ''}"
	let ro  = "%{&readonly ? '[RO] ' : ''}"
	let ft  = "%{len(&filetype) ? '['.&filetype.'] ' : ''}"
	let fug = "%{exists('g:loaded_fugitive') ? fugitive#statusline() : ''}"
	" right side
	let sep = ' %= '
	" coc.nvim statusline integration, see `:h coc-status`
	let coc = " %{coc#status()} |"
	let pos = ' %-12(%l : %c%V%) '
	let pct = ' %P'

	" return '[%n] %F %< %m %r %y'.fug.sep.pos.'%*'.pct
	return '[%n] %F %<'.mod.ro.ft.fug.sep.coc.pos.'%*'.pct
endfunction

let &statusline = s:statusline_expr()

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

# <C-L> will erase hlsearch
if maparg('<C-L>', 'n') ==# ''
	nnoremap <silent> <C-L> :nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR><C-L>
endif
" -----------------------------------------------------------------------------
" coc.nvim-related keybinds {{{
" -----------------------------------------------------------------------------
if has_key(g:plugs, 'coc.nvim')
	" Use tab for trigger completion with characters ahead and navigate.
	" " Use command ':verbose imap <tab>' to make sure tab is not mapped by other
	" plugin.
	inoremap <silent><expr> <TAB>
				\ pumvisible() ? "\<C-n>" :
				\ <SID>check_back_space() ? "\<TAB>" :
				\ coc#refresh()
	inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

	function! s:check_back_space() abort
		let col = col('.') - 1
		return !col || getline('.')[col - 1]  =~# '\s'
	endfunction

	" Use <c-space> to trigger completion.
	inoremap <silent><expr> <c-space> coc#refresh()

	" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
	" Coc only does snippet and additional edit on confirm.
	inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

	" Use `[c` and `]c` to navigate diagnostics
	nmap <silent> [g <Plug>(coc-diagnostic-prev)
	nmap <silent> ]g <Plug>(coc-diagnostic-next)

	" Remap keys for gotos
	nmap <silent> gd <Plug>(coc-definition)
	nmap <silent> gy <Plug>(coc-type-definition)
	nmap <silent> gi <Plug>(coc-implementation)
	nmap <silent> gr <Plug>(coc-references)

	" Use gK to show documentation in preview window (K is default in vim).
	nnoremap <silent> gK :call <SID>show_documentation()<CR>

	function! s:show_documentation()
		if (index(['vim','help'], &filetype) >= 0)
			execute 'h '.expand('<cword>')
		else
			call CocAction('doHover')
		endif
	endfunction

	" Use `:Format` to format current buffer
	command! -nargs=0 Format :call CocAction('format')

	" Use `:Fold` to fold current buffer
	command! -nargs=? Fold :call CocAction('fold', <f-args>)

	" use `:OR` for organize import of current buffer
	command! -nargs=0 OR   :call CocAction('runCommand', 'editor.action.organizeImport')


	" Using CocList
	" Show all diagnostics
	nnoremap <silent> <space>a :<C-u>CocList diagnostics<cr>
	" Manage extensions
	nnoremap <silent> <space>e :<C-u>CocList extensions<cr>
	" Show commands
	nnoremap <silent> <space>c :<C-u>CocList commands<cr>
	" Find symbol of current document
	nnoremap <silent> <space>o :<C-u>CocList outline<cr>
	" Search workspace symbols
	nnoremap <silent> <space>s :<C-u>CocList -I symbols<cr>
	" Do default action for next item.
	nnoremap <silent> <space>j :<C-u>CocNext<CR>
	" Do default action for previous item.
	nnoremap <silent> <space>k :<C-u>CocPrev<CR>
	" Resume latest coc list
	nnoremap <silent> <space>p :<C-u>CocListResume<CR>

	" FROM HERE.. I still dont know the usage -----
	" Remap for rename current word
	nmap <leader>rn <Plug>(coc-rename)

	" Remap for format selected region
	xmap <leader>f <Plug>(coc-format-selected)
	nmap <leader>f <Plug>(coc-format-selected)

	" Highlight symbol under cursor on CursorHold
	autocmd CursorHold * silent call CocActionAsync('highlight')

	augroup agcoc
		autocmd!
		" Update signature help on jump placeholder
		autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
	augroup end

	" Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
	xmap <leader>a <Plug>(coc-codeaction-selected)
	nmap <leader>a <Plug>(coc-codeaction-selected)

	" Remap for do codeAction of current line
	nmap <leader>ac <Plug>(coc-codeaction)
	" Fix autofix problem of current line
	nmap <leader>qf <Plug>(coc-fix-current)
endif

" }}}
" -----------------------------------------------------------------------------
" fzf-related keybinds {{{
" -----------------------------------------------------------------------------
if has_key(g:plugs, 'fzf.vim')
	nnoremap <silent> <leader>-        :Files<CR>
	nnoremap <silent> <leader>B        :Buffers<CR>
	nnoremap <silent> <leader>L        :Lines<CR>
	nnoremap <silent> <leader>`        :Marks<CR>
	" grep visual block
	xnoremap <silent> <Leader>rg       y:Rg <C-R>"<CR>
	" nnoremap <silent> <Leader>C        :Colors<CR>
endif

" }}}
" ===============================================================================
