" Clear all autocmds in the group
autocmd!

"""""""""""""""""""""""""""""
" BASIC EDITING CONFIGURATION
"""""""""""""""""""""""""""""

set autoindent
set autoread   " autoload file changes
set autowrite  " autosave when changing buffer/tab/...
set backspace=indent,eol,start  " Allow backspacing over autoindent, line breaks and start of insert action
set clipboard=unnamedplus
set colorcolumn=80
set conceallevel=0
set confirm  " ask before closing modified buffer
set cursorline
set enc=utf-8
set expandtab
set fenc=utf-8
set hidden
set history=1000
set ignorecase smartcase " Use case insensitive search, except when using capital letters
set incsearch
set mouse=r
set nobackup
set nocompatible
set nohlsearch
set nojoinspaces  " no double-spaces when joining lines
set nowritebackup
set number
set pastetoggle=<F10>
set ruler
set scrolloff=3  " show at least 3 lines above/below the cursor
set shell=zsh
set shiftwidth=2
set showcmd
set showmode
set smartcase
set softtabstop=2
set splitbelow  " open new split pane below
set splitright  " open new split pane on the right
set synmaxcol=512
set tabstop=2
set termencoding=utf-8
set visualbell
set wrap


"""""""""
" Plugins
"""""""""

call plug#begin('~/.local/share/nvim/plugged')

Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'Shougo/neosnippet'
Plug 'Shougo/neosnippet-snippets'
Plug 'airblade/vim-gitgutter'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'elzr/vim-json'
Plug 'fatih/vim-go', {'for': 'go', 'do': ':GoInstallBinaries'}
Plug 'itchyny/lightline.vim'
Plug 'jiangmiao/auto-pairs'
Plug 'lifepillar/vim-solarized8'
Plug 'majutsushi/tagbar'
Plug 'maximbaz/lightline-ale'
Plug 'metakirby5/codi.vim'
Plug 'ntpeters/vim-better-whitespace'
Plug 'ryanoasis/vim-devicons'
Plug 'scrooloose/nerdtree', {'on': 'NERDTreeToggle'}
Plug 'tpope/vim-commentary'
Plug 'vim-python/python-syntax'
Plug 'vimwiki/vimwiki'
Plug 'w0rp/ale'
Plug 'zchee/deoplete-jedi'

call plug#end()

""" Shougo/deoplete.vim
let g:deoplete#enable_at_startup = 1
set completeopt-=preview  " Disable documentation window
let g:deoplete#enable_smart_case = 1
let g:deoplete#disable_auto_complete = 1

""" Shougo/neosnippet
imap <C-k> <Plug>(neosnippet_expand_or_jump)
smap <C-k> <Plug>(neosnippet_expand_or_jump)
xmap <C-k> <Plug>(neosnippet_expand_target)

""" fatih/vim-go
let $GOPATH = $HOME."/code/golang/"

""" itchyny/lightline.vim
let g:lightline = {'colorscheme': 'solarized'}
let g:lightline.component_function = {'gitbranch': 'fugitive#statusline'}
let g:lightline.component_expand = {
      \ 'linter_checking': 'lightline#ale#checking',
      \ 'linter_warnings': 'lightline#ale#warnings',
      \ 'linter_errors': 'lightline#ale#errors',
      \ }
let g:lightline.component_type = {
      \ 'linter_checking': 'left',
      \ 'linter_warnings': 'warning',
      \ 'linter_errors': 'error',
      \ }
let g:lightline.active = {
      \ 'left': [['mode', 'paste'], ['gitbranch', 'readonly', 'filename', 'modified']],
      \ 'right': [
      \   ['lineinfo'],
      \   ['percent'],
      \   ['fileformat', 'fileencoding', 'filetype', 'linter_errors', 'linter_warnings']
      \ ]
      \ }

let g:lightline#ale#indicator_checking = "\uf110"
let g:lightline#ale#indicator_warnings = "\uf06a"
let g:lightline#ale#indicator_errors = "\uf05e"

""" ntpeters/vim-better-whitespace
autocmd BufEnter * EnableStripWhitespaceOnSave  " strip whitespace on save

""" vimwiki/vimwiki
let g:vimwiki_list = [{'path': '~/.local/share/vimwiki'}]

""" ctrlpvim/ctrlp.vim
if executable('rg')
  set grepprg=rg\ --color=never
  let g:ctrlp_user_command = 'rg %s --files --color=never --glob ""'
endif
let g:ctrlp_use_caching = 0
let g:ctrlp_custom_ignore = 'node_modules\|DS_Store\|git'


""""""""""""""
" CODING STUFF
""""""""""""""

let python_highlight_all = 1
" enable :make to run python script in vim
au Filetype python set makeprg=python\ %
let g:python_host_prog = '/usr/bin/python2'
let g:python3_host_prog = '/usr/bin/python'


"""""""""""""""""
" CUSTOM AUTOCMDS
"""""""""""""""""

augroup vimrcEx
  " Clear all autocmds in the group
  autocmd!

  " mutt
  autocmd BufRead /tmp/mutt* :set ft=mail
  autocmd FileType mail set tw=80
augroup END


"""""""""""""
" KEY MAPPING
"""""""""""""

let mapleader=","

""" Shougo/deoplete.vim
inoremap <silent><expr><tab>  pumvisible() ? "\<c-n>" : deoplete#mappings#manual_complete()
inoremap <silent><expr><s-tab>  pumvisible() ? "\<c-p>" : "\<c-tab>"

""" ctrlpvim/ctrlp.vim
nnoremap <leader>b :CtrlPBuffer<CR>
nnoremap <leader>t :CtrlP<CR>

""" w0rp/ale
nmap <silent> <leader>aj :ALENext<cr>
nmap <silent> <leader>ak :ALEPrevious<cr>

" sane movement over wrapped lines
nmap j gj
nmap k gk

" allow saving as sudo
cmap w!! w !sudo tee > /dev/null %

" unbind the cursor keys in insert, normal and visual modes.
for prefix in ['i', 'n', 'v']
  for key in ['<Up>', '<Down>', '<Left>', '<Right>']
    exe prefix . "noremap " . key . " <Nop>"
  endfor
endfor

" use Y to yank to end of line
map Y y$


"""""""
" COLOR
"""""""

colorscheme solarized8_dark
