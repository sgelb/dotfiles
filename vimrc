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
set cursorline
set enc=utf-8
set expandtab
set fenc=utf-8
set hidden
set history=1000
set ignorecase smartcase  "ignorecase unless we use an uppercase
set incsearch
set mouse=a
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

syntax on
filetype off

" Use the below highlight group when displaying bad whitespace is desired
highlight BadWhitespace ctermbg=red guibg=red

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

  " Ruby
  autocmd FileType ruby set ai sw=2 sts=2 et

  " Python
  autocmd FileType python set sw=4 sts=4 et
  autocmd FileType python match BadWhitespace /^\t\+/

  " Markdown
  autocmd! BufNewFile,BufRead *.md setlocal ft=
  autocmd BufRead *.mkd  set ai formatoptions=tcroqn2 comments=n:&gt;
  autocmd BufRead *.markdown  set ai formatoptions=tcroqn2 comments=n:&gt;
  autocmd BufRead,BufNewFile *.{md,mkd,markdown} set filetype=markdown
  autocmd BufRead,BufNewFile *.{md,mkd,markdown} autocmd VimEnter * UniCycleOn

  " Tex
  set grepprg=grep\ -nH\ $*
  autocmd FileType tex set tw=80
  autocmd FileType tex nmap <F2> :!pdflatex %<cr>

  " Make trailing whitespace be flagged as bad.
  autocmd BufRead,BufNewFile *.py,*.pyw,*.c,*.h match BadWhitespace /\s\+$/

  " MUTT
  autocmd BufRead /tmp/mutt* :set ft=mail

  " Load templates for new files
  autocmd BufNewFile  *.java	0r ~/.vim/skel/java | %s/<FILE>/\=expand("%:t:r")/g
  autocmd BufNewFile  *.py	0r ~/.vim/skel/py | call LoadTemplate()
  autocmd BufNewFile  *.rb	0r ~/.vim/skel/rb 
  autocmd BufNewFile  *.sh	0r ~/.vim/skel/sh | call LoadTemplate()

augroup END

" <CR>: close popup and save indent.
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function()
return neocomplete#close_popup() . "\<CR>"
     " For no inserting <CR> key.
     return pumvisible() ? neocomplete#close_popup() : "\<CR>"
endfunction

" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"

au BufWinLeave ?* mkview 
au BufWinEnter ?* silent loadview

set backupdir=~/.vim/tmp,.
set directory=~/.vim/tmp,.

set laststatus=2
let g:bufferline_echo = 0
set noshowmode
set statusline=%f%m%r%h%w\ [%{&ff}]\ %y\ %{GitBranch()}\ %=\ [%l,%v][%p%%]\[%L]
filetype plugin on

" File type detection. Indent based on filetype. Recommended.
filetype plugin indent on

"""""""""""""
" KEY MAPPING
"""""""""""""

let mapleader=","

" Yank into system clipboard
map <leader>y "*y
" Need to overwrite default TaskList mapping 
nnoremap <leader>v <Plug>TaskList
map <leader>t :tabnew 

" Sane movement over wrapped line
nmap j gj
nmap k gk

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

""""""""
" VUNDLE
""""""""

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()
Bundle 'gmarik/vundle'

" Bundles here:
Bundle 'airblade/vim-gitgutter'
Bundle 'altercation/vim-colors-solarized'
Bundle 'bling/vim-airline'
Bundle 'bullfight/vim-matchit'
" Bundle 'chrisbra/csv.vim'
" Bundle 'ervandew/supertab'
" Bundle 'itszero/javacomplete'
Bundle 'jiangmiao/auto-pairs'
Bundle 'jelera/vim-javascript-syntax'
Bundle 'kien/rainbow_parentheses.vim'
" Bundle 'kien/ctrlp.vim'
Bundle 'majutsushi/tagbar'
Bundle 'matze/vim-tex-fold'
Bundle 'mileszs/ack.vim'
Bundle 'nathanaelkane/vim-indent-guides'
Bundle 'octol/vim-cpp-enhanced-highlight'
Bundle 'pangloss/vim-javascript'
Bundle 'plasticboy/vim-markdown'
"Bundle 'rstacruz/sparkup'
" Bundle 'Rip-Rip/clang_complete'
Bundle 'scrooloose/nerdtree'
Bundle 'scrooloose/syntastic'
Bundle 'sgelb/TaskList.vim'
Bundle 'Shougo/neocomplete.vim'
" Bundle 'sgelb/vTransfer'
Bundle 'sjl/gundo.vim'
Bundle 'terryma/vim-multiple-cursors'
Bundle 'tikhomirov/vim-glsl'
Bundle 'tpope/vim-commentary'
Bundle 'tpope/vim-endwise'
Bundle 'tpope/vim-fugitive'
Bundle 'tpope/vim-speeddating'
Bundle 'tpope/vim-unimpaired'
Bundle 'vim-scripts/a.vim'
" Bundle 'vim-scripts/OmniCppComplete'
" Bundle 'yakiang/excel.vim'

""""""""""""""""""""""
" PLUGIN CONFIGURATION
""""""""""""""""""""""

" AIRLINE
let g:airline_theme='solarized'
let g:airline_powerline_fonts=1
let g:airline#extensions#whitespace#enabled = 0
" Show just the filename
let g:airline#extensions#tabline#fnamemod = ':t'

" GUNDO
nnoremap <leader>u :GundoToggle<CR>

" NEOCOMPLETE
let g:neocomplete#enable_at_startup = 0
" Use smartcase.
let g:neocomplete#enable_smart_case = 1

" RAINBOW PARENTHESIS
au VimEnter * RainbowParenthesesToggle
au Syntax * RainbowParenthesesLoadRound
au Syntax * RainbowParenthesesLoadSquare
au Syntax * RainbowParenthesesLoadBraces

" SYNTASTIC
let g:syntastic_python_checkers = ['flake8']
let g:syntastic_cpp_checkers = ['cpplint']
let g:syntastic_cpp_cpplint_exec = '/usr/bin/cpplint'
let g:syntastic_ruby_checkers = ['rubocop', 'mri']

" TAGBAR
map <F5> :TagbarToggle<CR>

" TASKLIST
let g:tlTokenList = ['TODO', 'FIXME', 'XXX', 'HACK']
nnoremap <silent> <F7> :TaskListToggle<CR>


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
  exe ':5'
endfun

"""""""
" COLOR
"""""""

set background=dark
colorscheme solarized
