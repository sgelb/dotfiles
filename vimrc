" vim:set ts=2 sts=2 sw=2 expandtab:

" Clear all autocmds in the group
autocmd!

"""""""""""""""""""""""""""""
" BASIC EDITING CONFIGURATION
"""""""""""""""""""""""""""""
set autoindent
set autoread
set autowrite
set backspace=indent,eol,start
set colorcolumn=80
set conceallevel=0
set confirm
set enc=utf-8
set expandtab
set fenc=utf-8
set hidden
set history=1000
set ignorecase smartcase  "ignorecase unless we use an uppercase
set incsearch
set mouse=r
set nobackup
set nocompatible
set nohlsearch
set nojoinspaces  "No double-space when joining lines if sentence structure
set nowritebackup
set number
set pastetoggle=<F10>
set ruler
set scrolloff=3
set shell=zsh
set shiftwidth=2
set showcmd
set showmode
set smartcase
set softtabstop=2
set synmaxcol=512
set tabstop=2
set termencoding=utf-8
set timeout timeoutlen=1000 ttimeoutlen=100  " Fix slow O inserts
set vb
set wrap

syntax enable
filetype off

" Use the below highlight group when displaying bad whitespace is desired
highlight BadWhitespace ctermbg=red guibg=red

""""""""
" VUNDLE
""""""""

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Bundle 'gmarik/Vundle.vim'

" Bundles here:
Bundle 'airblade/vim-gitgutter'
Bundle 'altercation/vim-colors-solarized'
Bundle 'bullfight/vim-matchit'
Bundle 'cespare/vim-toml'
Bundle 'ctrlpvim/ctrlp.vim'
Bundle 'fatih/vim-go'
Bundle 'godlygeek/tabular'
Bundle 'jiangmiao/auto-pairs'
Bundle 'Konfekt/FastFold'
Bundle 'luochen1990/rainbow'
Bundle 'majutsushi/tagbar'
Bundle 'matze/vim-tex-fold'
Bundle 'mileszs/ack.vim'
Bundle 'nsf/gocode', {'rtp': 'vim/'}
Bundle 'octol/vim-cpp-enhanced-highlight'
Bundle 'pangloss/vim-javascript'
Bundle 'plasticboy/vim-markdown'
Bundle 'scrooloose/nerdtree'
Bundle 'scrooloose/syntastic'
Bundle 'sgelb/TaskList.vim'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
if has('lua')
  Bundle 'Shougo/neocomplete.vim'
endif
Bundle 'sjl/gundo.vim'
Bundle 'tikhomirov/vim-glsl'
Bundle 'tpope/vim-commentary'
Bundle 'tpope/vim-endwise'
Bundle 'tpope/vim-fugitive'
Bundle 'vhdirk/vim-cmake'
Bundle 'vim-scripts/a.vim'
Bundle 'vim-scripts/DoxygenToolkit.vim'
Bundle 'vim-scripts/indentpython.vim'

call vundle#end()

""""""""""""""""""""""
" PLUGIN CONFIGURATION
""""""""""""""""""""""

filetype plugin on

" A.VIM
let g:alternateSearchPath = 'sfr:../source,sfr:../src,sfr:../include,sfr:../inc'
let g:alternateNoDefaultAlternate = 1

" ACK.VIM
if executable('ag')
  let g:ackprg = 'ag --vimgrep'
endif

" AIRLINE
let g:airline_theme='solarized'
let g:airline_powerline_fonts=1
let g:airline#extensions#whitespace#enabled = 0
" Show just the filename
let g:airline#extensions#tabline#fnamemod = ':t'
" Show all buffers if only one tab open
let g:airline#extensions#tabline#enabled = 1
" Load these extensions
let g:airline_extensions = ['branch']

" MARKDOWN
let g:markdown_fenced_languages = ['html', 'vim', 'ruby', 'python', 'bash=sh']

" NEOCOMPLETE
if has('lua')
  " Use neocomplete.
  let g:neocomplete#enable_at_startup = 1
  " Use smartcase.
  let g:neocomplete#enable_smart_case = 1
  " Set minimum syntax keyword length.
  let g:neocomplete#sources#syntax#min_keyword_length = 3
  " Auto-close preview window
  let g:neocomplete#enable_auto_close_preview = 1	
endif


" RAINBOW PARENTHESIS
let g:rainbow_active = 1

" SYNTASTIC
let g:syntastic_python_checkers = ['python', 'flake8', 'pep8']
let g:syntastic_cpp_checkers = ['cpplint']
let g:syntastic_cpp_cpplint_exec = '/usr/bin/cpplint'
let g:syntastic_ruby_checkers = ['rubocop', 'mri']
let g:syntastic_go_checkers = ['go', 'golint', 'govet', 'gometalinter', 'gofmt']
let g:syntastic_mode_map = { 'mode': 'active', 'passive_filetypes': ['go']  }

" TAGBAR
map <F5> :TagbarToggle<CR>

" TASKLIST
let g:tlTokenList = ['TODO', 'FIXME', 'XXX', 'HACK']
nnoremap <silent> <F7> :TaskListToggle<CR>

" VIM-JAVASCRIPT
" see conceallevel
let g:javascript_conceal_function       = "ƒ"
let g:javascript_conceal_null           = "ø"
let g:javascript_conceal_this           = "@"
let g:javascript_conceal_return         = "⇚"
let g:javascript_conceal_undefined      = "¿"
let g:javascript_conceal_NaN            = "ℕ"
let g:javascript_conceal_prototype      = "¶"
let g:javascript_conceal_static         = "•"
let g:javascript_conceal_super          = "Ω"
let g:javascript_conceal_arrow_function = "⇒"

" VIM-GO
let $GOPATH = $HOME."/code/golang/"
let g:go_fmt_command = "goimports"
let g:go_fmt_fail_silently = 0
" " turn highlighting on
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_structs = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1"
au FileType go nmap <leader>r <Plug>(go-run)
au FileType go nmap <leader>e <Plug>(go-test)
au FileType go nmap <Leader>n <Plug>(go-rename)
au FileType go nmap <leader>c <Plug>(go-coverage-browser)
au FileType go nmap <Leader>i <Plug>(go-info)
au FileType go nmap <Leader>A <Plug>(go-alternate-edit)

"""""""""""""""""
" CUSTOM AUTOCMDS
"""""""""""""""""
augroup vimrcEx
  " Clear all autocmds in the group
  autocmd!

  " Default textwidth for text
  autocmd FileType text setlocal textwidth=80
  " Always mark whitespace at eol
  autocmd FileType text match BadWhitespace /\s\+$/

  " Jump to last cursor position unless it's invalid or in an event handler
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

  " " Go
  " au Filetype go nnoremap <leader>d :tab split <CR>:exe "GoDef"<CR>

  " Ruby
  autocmd FileType ruby set ai sw=2 sts=2 et

  " Python
  autocmd FileType python set ts=4 sw=4 sts=4 et ai
  autocmd FileType python match BadWhitespace /^\t\+/
  autocmd BufWritePre *.py :%s/\s\+$//e

  " Markdown
  autocmd! BufNewFile,BufRead *.md setlocal ft=
  autocmd BufRead *.mkd  set ai formatoptions=tcroqn2 comments=n:&gt;
  autocmd BufRead *.markdown  set ai formatoptions=tcroqn2 comments=n:&gt;
  autocmd BufRead,BufNewFile *.{md,mkd,markdown} set filetype=markdown
  " autocmd BufRead,BufNewFile *.{md,mkd,markdown} autocmd VimEnter * UniCycleOn

  " Tex
  set grepprg=grep\ -nH\ $*
  autocmd BufRead,BufNewFile *.{tex} set filetype=tex
  autocmd FileType tex set tw=80
  autocmd FileType tex nmap <F2> :!latexmk -xelatex<cr>

  " MUTT
  autocmd BufRead /tmp/mutt* :set ft=mail

  " Load templates for new files
  autocmd BufNewFile  *.java	0r ~/.vim/skel/java | %s/<FILE>/\=expand("%:t:r")/g
  autocmd BufNewFile  *.py	0r ~/.vim/skel/py | call LoadTemplate()
  autocmd BufNewFile  *.rb	0r ~/.vim/skel/rb 
  autocmd BufNewFile  *.sh	0r ~/.vim/skel/sh | call LoadTemplate()

augroup END

if has('lua')
" <CR>: close popup and save indent.
  inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
  function! s:my_cr_function()
  return neocomplete#close_popup() . "\<CR>"
       " For no inserting <CR> key.
       return pumvisible() ? neocomplete#close_popup() : "\<CR>"
  endfunction
endif

" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"

set backupdir=~/.vim/tmp,.
set directory=~/.vim/tmp,.

set laststatus=2
let g:bufferline_echo = 0
set noshowmode
set statusline=%f%m%r%h%w\ [%{&ff}]\ %y\ %{GitBranch()}\ %=\ [%l,%v][%p%%]\[%L]

" File type detection. Indent based on filetype. Recommended.
filetype plugin indent on

"""""""""""""
" KEY MAPPING
"""""""""""""

let mapleader=","

" CTRLP
nnoremap <leader>t :CtrlP<CR>
nnoremap <leader>b :CtrlPBuffer<CR>

" GUNDO
nnoremap <leader>u :GundoToggle<CR>

" Yank into system clipboard
map <leader>y "*y
" Need to overwrite default TaskList mapping 
nnoremap <leader>v <Plug>TaskList

" Sane movement over wrapped line
nmap j gj
nmap k gk

" For local replace
nnoremap gr gd[{V%::s/<C-R>///gc<left><left><left>

" For global replace
nnoremap gR gD:%s/<C-R>///gc<left><left><left>

" Unbind the cursor keys in insert, normal and visual modes.
" Force myself to use hjkl
for prefix in ['i', 'n', 'v']
  for key in ['<Up>', '<Down>', '<Left>', '<Right>']
    exe prefix . "noremap " . key . " <Nop>"
  endfor
endfor

""""""""""""""""""""""
" MULTIPURPOSE TAB KEY
""""""""""""""""""""""

" Indent if we're at the beginning of a line. Else, do completion.
function! InsertTabWrapper()
    let col = col('.') - 1
    if !col || getline('.')[col - 1] !~ '\k'
        return "\<tab>"
    else
        return "\<c-p>"
    endif
endfunction
inoremap <expr> <tab> InsertTabWrapper()
inoremap <s-tab> <c-n>


""""""""""""""""""""
" FUNCTIONS AND SUCH
""""""""""""""""""""

"Print to ps with hardcopy filename.ps
let &printexpr="(v:cmdarg=='' ? ".
    \"system('lpr' . (&printdevice == '' ? '' : ' -P' . &printdevice)".
    \". ' ' . v:fname_in) . delete(v:fname_in) + v:shell_error".
    \" : system('mv '.v:fname_in.' '.v:cmdarg) + v:shell_error)"

"Autoload templates
fun LoadTemplate()
	if getline(line('$')) == ''
		exe ':' . line('$') . 'delete 1'
	endif
	" Insert time automagicaly
	let time = strftime('%Y-%m-%d, %H:%M')
	exe ':%s/<vi-tpl-time>/' . time . '/g'
endfun

" Very (!) basic adding/removing of license
fun ToggleLicense(license)
  let cursorposition = getpos(".")
  let fname = expand('~/.vim/skel/') . a:license
  let licenselength = len(readfile(fname))

  if getline(1) !~# "Copyright (C)"
    " Add file
    exe ':0r ' . fname
    " Set year
    exe ':%s/<tpl-year>/' . strftime('%Y') . '/'
    " Get new cursor position
    let cursorposition[1] += licenselength
    " comment license - needs 'tpope/vim-commentary'
    exe ':0,' . licenselength . 'Commentary'
  else
    " Get new cursor position
    let cursorposition[1] -= licenselength
    " Delete license
    exe '0,' . licenselength . 'delete'
  endif

  call setpos(".", cursorposition)
endfun

"""""""
" COLOR
"""""""

set background=dark
colorscheme solarized
