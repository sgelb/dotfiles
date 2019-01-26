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

Plug 'KeitaNakamura/highlighter.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'Shougo/neosnippet.vim'
Plug 'Shougo/neosnippet-snippets'
Plug 'Vimjas/vim-python-pep8-indent'
Plug 'airblade/vim-gitgutter'
Plug 'ambv/black'
Plug 'davidhalter/jedi'
Plug 'davidhalter/jedi-vim'
Plug 'dhruvasagar/vim-table-mode'
Plug 'elzr/vim-json'
Plug 'fatih/vim-go', {'for': 'go', 'do': ':GoInstallBinaries'}
Plug 'gioele/vim-autoswap'
Plug 'iCyMind/NeoSolarized'
Plug 'itchyny/lightline.vim'
Plug 'jiangmiao/auto-pairs'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --bin' }
Plug 'junegunn/fzf.vim'
Plug 'lervag/vimtex'
Plug 'luochen1990/rainbow'
Plug 'machakann/vim-sandwich'
Plug 'majutsushi/tagbar'
Plug 'maximbaz/lightline-ale'
Plug 'mechatroner/rainbow_csv'
Plug 'mhinz/vim-signify'
Plug 'ntpeters/vim-better-whitespace'
Plug 'numirias/semshi', {'do': ':UpdateRemotePlugins'}
Plug 'pbogut/fzf-mru.vim'
Plug 'sbdchd/neoformat'
Plug 'scrooloose/nerdtree', {'on': 'NERDTreeToggle'}
Plug 'sgelb/vim-translator'
Plug 'thinca/vim-quickrun'
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
let g:deoplete#sources#jedi#show_docstring = 1

""" davidhalter/jedi-vim
" disable completions as we use deoplete for that
let g:jedi#completions_enabled = 0

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

" requires font with symbols, e.g. from https://github.com/ryanoasis/nerd-fonts
let g:lightline#ale#indicator_checking = "\uf110 "
let g:lightline#ale#indicator_warnings = "\uf06a "
let g:lightline#ale#indicator_errors = "\uf05e "

""" gioele/vim-autoswap
let g:autoswap_detect_tmux = 1

""" junegunn/fzf
let g:fzf_nvim_statusline = 0 " disable statusline overwriting

""" lervag/vimtex
let g:vimtex_compiler_progname = 'nvr'
let g:vimtex_view_method = 'zathura'
let g:vimtex_format_enabled = 1
let g:vimtex_quickfix_latexlog = { 'overfull' : 0, 'underfull' : 0 }
call deoplete#custom#var('omni', 'input_patterns', { 'tex': g:vimtex#re#deoplete })

""" maximbaz/lightline-ale
" see https://github.com/maximbaz/lightline-ale/issues/5
function! s:goyo_enter()
  let g:ale_enabled=0
endfunction
autocmd! User GoyoEnter call <SID>goyo_enter()

function! s:goyo_leave()
  let g:ale_enabled=1
endfunction
autocmd! User GoyoLeave call <SID>goyo_leave()

""" luochen1990/rainbow
let g:rainbow_active = 1

""" numirias/semshi
let g:semshi#simplify_markup = 0

""" ntpeters/vim-better-whitespace
autocmd BufEnter * EnableStripWhitespaceOnSave  " strip whitespace on save

""" sbdchd/neoformat
let g:neoformat_enabled_python = ['black', 'isort', 'docformatter']
let g:neoformat_python_run_all_formatters = 1


""" tengufromsky/vim-translator
let g:translate_cmd='trans -b :en'

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
let g:ale_python_flake8_options = '--ignore=E501,E111,E114 --max-line-length=100'
let g:ale_fixers = {
      \ 'python': [
      \   'autopep8',
      \   'add_blank_lines_for_python_control_statements'
      \ ]
      \}

let g:ale_html_tidy_options = '--drop-empty-elements no'


""""""""""""""
" CODING STUFF
""""""""""""""

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

inoremap <Leader><Tab> <Tab>

""" junegunn/fzf
nnoremap <silent> <leader>f :Files<CR>
nnoremap <silent> <leader>b :Buffers<CR>
nnoremap <leader>rg :Rg<Space>
nnoremap <silent> <leader>m :FZFMru<CR>

""" tengufromsky/vim-translator
vmap T <Plug>Translate
vmap R <Plug>TranslateReplace

""" thinca/vim-quickrun
nmap <silent> <leader>q :QuickRun<cr>

""" sbdchd/neoformat
nmap <silent> <leader>y :Neoformat<cr>

""" Shougo/deoplete.vim
inoremap <silent><expr><tab>  pumvisible() ? "\<c-n>" : deoplete#mappings#manual_complete()
inoremap <silent><expr><s-tab>  pumvisible() ? "\<c-p>" : "\<c-tab>"

""" Shougo/neosnippet.vim
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)

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
endfunction
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
