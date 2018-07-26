" Clear all autocmds in the group
autocmd!

"""""""""""""""""""""""""""""
" BASIC EDITING CONFIGURATION
"""""""""""""""""""""""""""""
set autowrite  " autosave when changing buffer/tab/...
set clipboard=unnamedplus
set colorcolumn=88
set conceallevel=0
set confirm  " ask before closing modified buffer
set cursorline
set enc=utf-8
set expandtab
set fenc=utf-8
set hidden
set ignorecase smartcase " use case insensitive search, except when using capital letters
set incsearch
set inccommand=split " live view of substitutions as you type .g :%s/foo/bar/
set linebreak  " break long lines at breakat
set mouse=r
set nobackup
set nohlsearch
set nojoinspaces  " no double-spaces when joining lines
set nowritebackup
set number
set pastetoggle=<F10>
set scrolloff=3  " show at least 3 lines above/below the cursor
set shell=zsh
set shiftwidth=2
set showmode
set smartcase
set softtabstop=2
set splitbelow  " open new split pane below
set splitright  " open new split pane on the right
set synmaxcol=512
set termguicolors
set tabstop=2
set title titlestring=  " needed for vim-autoswap
set termencoding=utf-8
set visualbell
set wrap

"""""""""
" Plugins
"""""""""

call plug#begin('~/.local/share/nvim/plugged')

" Plug 'lifepillar/vim-solarized8'
Plug 'KeitaNakamura/highlighter.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'Vimjas/vim-python-pep8-indent'
Plug 'airblade/vim-gitgutter'
Plug 'ambv/black'
Plug 'davidhalter/jedi-vim'
Plug 'elzr/vim-json'
Plug 'fatih/vim-go', {'for': 'go', 'do': ':GoInstallBinaries'}
Plug 'gioele/vim-autoswap'
Plug 'google/yapf', { 'rtp': 'plugins/vim', 'for': 'python' }
Plug 'iCyMind/NeoSolarized'
Plug 'itchyny/lightline.vim'
Plug 'jiangmiao/auto-pairs'
Plug 'joereynolds/deoplete-minisnip', { 'do': ':UpdateRemotePlugins' }
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --bin' }
Plug 'junegunn/fzf.vim'
Plug 'junegunn/goyo.vim'
Plug 'kh3phr3n/python-syntax'
Plug 'luochen1990/rainbow'
Plug 'machakann/vim-sandwich'
Plug 'majutsushi/tagbar'
Plug 'maximbaz/lightline-ale'
Plug 'mhinz/vim-signify'
Plug 'mileszs/ack.vim'
Plug 'ntpeters/vim-better-whitespace'
Plug 'ryanoasis/vim-devicons'
Plug 'sbdchd/neoformat'
Plug 'sbdchd/vim-run'
Plug 'scrooloose/nerdtree', {'on': 'NERDTreeToggle'}
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
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
" imap <C-k> <Plug>(neosnippet_expand_or_jump)
smap <C-k> <Plug>(neosnippet_expand_or_jump)
xmap <C-k> <Plug>(neosnippet_expand_target)

""" davidhalter/jedi-vim
let g:jedi#completions_enabled = 0
let g:jedi#show_call_signatures = "1"
let g:jedi#rename_command = "<leader>R"

""" fatih/vim-go
let $GOPATH = $HOME."/code/golang/"

""" google/yapf
let g:formatter_yapf_style = 'google'

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

" requires font with symbols, e.g. from https://github.com/ryanoasis/nerd-fonts
let g:lightline#ale#indicator_checking = "\uf110"
let g:lightline#ale#indicator_warnings = "\uf06a"
let g:lightline#ale#indicator_errors = "\uf05e"

""" gioele/vim-autoswap
let g:autoswap_detect_tmux = 1

""" joereynolds/deoplete-minisnip
let g:minisnip_dir = '~/.local/share/nvim/minisnip'

""" junegunn/fzf
let g:fzf_nvim_statusline = 0 " disable statusline overwriting

""" luochen1990/rainbow
let g:rainbow_active = 1

""" mileszs/ack.vim
if executable('rg')
  let g:ackprg = 'rg --vimgrep'
endif

""" ntpeters/vim-better-whitespace
autocmd BufEnter * EnableStripWhitespaceOnSave  " strip whitespace on save

""" sbdchd/vim-run
autocmd FileType python nmap <silent> <leader>r :Run<cr>

""" vim-python/python-syntax
let g:python_highlight_all = 1

""" vimwiki/vimwiki
let g:vimwiki_list = [{'path': '~/.local/share/vimwiki',
      \ 'syntax': 'markdown',
      \ 'ext': '.md'}]
let g:vimwiki_global_ext = 0

""" tpope/vim-commentary
autocmd FileType markdown setlocal commentstring=<!--\ %s\ -->

""" w0rp/ale
" Python: ignore warnings about maximum line length, intent not multiple
" of 4 (code and comments)
let g:ale_python_flake8_args = '--ignore=E501,E111,E114'
let g:ale_fixers = {
      \ 'python': [
      \   'autopep8',
      \   'add_blank_lines_for_python_control_statements'
      \ ]
      \}

""""""""""""""
" CODING STUFF
""""""""""""""

let python_highlight_all = 1
let g:python_host_prog = '/usr/bin/python2'
let g:python3_host_prog = '/usr/bin/python3'


"""""""""""""""""
" CUSTOM AUTOCMDS
"""""""""""""""""

augroup vimrcEx
  " Clear all autocmds in the group
  autocmd!

  " mutt
  autocmd BufRead /tmp/mutt* :set ft=mail
  " autocmd FileType mail set tw=80

  " python
  autocmd BufNewFile,BufRead *.py set keywordprg=pydoc
augroup END


"""""""""""""
" KEY MAPPING
"""""""""""""

let mapleader=","

""" Shougo/deoplete.vim
inoremap <silent><expr><tab>  pumvisible() ? "\<c-n>" : deoplete#mappings#manual_complete()
inoremap <silent><expr><s-tab>  pumvisible() ? "\<c-p>" : "\<c-tab>"

""" junegunn/fzf
nnoremap <silent> <leader>t :Files<CR>
nnoremap <silent> <leader>b :Buffers<CR>

""" mileszs/ack.vim
cnoreabbrev Ack Ack!
nnoremap <Leader>a :Ack!<Space>

""" w0rp/ale
nmap <silent> <leader>aj :ALENextWrap<cr>
nmap <silent> <leader>ak :ALEPreviousWrap<cr>

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

" Make zO recursively open whatever fold we're in, even if it's partially open.
nnoremap zO zczO

" Fold all folds the current line is not in
nnoremap zÜ mzzMzvzz<cr>

" use Y to yank to end of line
map Y y$


"""""""""
" FOLDING
"""""""""

let g:markdown_folding = 1
set nofoldenable
set fml=0

function! MyFoldText()
    let line = getline(v:foldstart)

    let nucolwidth = &fdc + &number * &numberwidth
    let windowwidth = winwidth(0) - nucolwidth
    let foldedlinecount = v:foldend - v:foldstart

    let line = strpart(line, 0, windowwidth - 2 - len(foldedlinecount))
    let fillcharcount = windowwidth - strdisplaywidth(line) - len(foldedlinecount) - 6
    return line . repeat(" ",fillcharcount) . foldedlinecount . ' lines' . ' '
endfunction "
set foldtext=MyFoldText()


"""""""
" COLOR
"""""""

set background=dark
colorscheme NeoSolarized
let g:neosolarized_contrast = "low"
let g:neosolarized_italic = 1

""""""""""""""
" HIGHLIGHTING
""""""""""""""

" does not work with screen
highlight Comment cterm=italic
