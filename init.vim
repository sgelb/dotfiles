" Clear all autocmds in the group
autocmd!

"""""""""""""""""""""""""""""
" BASIC CONFIGURATION
"""""""""""""""""""""""""""""
set autowrite  " autosave when changing buffer/tab/...
set clipboard=unnamedplus
set colorcolumn=100  " highlight column
set conceallevel=2
set confirm  " ask before closing modified buffer
set cursorline
set enc=utf-8
set expandtab
set fenc=utf-8
set hidden
set ignorecase smartcase " search case insensitive, except when using capital letters
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
set synmaxcol=1000  " max column to search for syntax. Avoid lag for very long lines
set termguicolors
set tabstop=2
set title titlestring=  " needed for vim-autoswap
set termencoding=utf-8
set visualbell

"""""""""
" Plugins
"""""""""

call plug#begin('~/.local/share/nvim/plugged')

" Python indentation style
Plug 'Vimjas/vim-python-pep8-indent'

" Shows a git diff in the gutter (sign column) and stages/undoes hunks.
Plug 'airblade/vim-gitgutter'

" The uncompromising Python code formatter
Plug 'ambv/black'

" Nightfly theme
Plug 'bluz71/vim-nightfly-guicolors'

" Autocompletion and static analysis library for python / vim integration
Plug 'davidhalter/jedi'
Plug 'davidhalter/jedi-vim'

" Instant table creation
Plug 'dhruvasagar/vim-table-mode'

" Timer
Plug 'dominikduda/vim_timebox'

" Better JSON highlighting, warnings, quote concealing
Plug 'elzr/vim-json'

" Golang Development Plugin
Plug 'fatih/vim-go', {'for': 'go', 'do': ':GoInstallBinaries'}

" Don't ask about swap file, just switch to correct window
Plug 'gioele/vim-autoswap'

" Solarized theme
Plug 'iCyMind/NeoSolarized'

" Status bar
Plug 'itchyny/lightline.vim'

" Insert or delete brackets, parens, quotes in pair
Plug 'jiangmiao/auto-pairs'

" FZF / vim integration
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --bin' }
Plug 'junegunn/fzf.vim'

" Goyo / Distraction-free writing in Vim
Plug 'junegunn/goyo.vim'

" Git commit browser
Plug 'junegunn/gv.vim'

" Modern vim plugin for editing LaTeX files
Plug 'lervag/vimtex'

" Local wiki
Plug 'lervag/wiki.vim'
Plug 'lervag/wiki-ft.vim'

" Rainbow Color parenthesis
Plug 'luochen1990/rainbow'

" Add/delete/replace surroundings of sandwiched text, like (foo) or bar"
Plug 'machakann/vim-sandwich'

" Display tags in a window, ordered by scope
Plug 'majutsushi/tagbar'

" Rainbow color csv columns
Plug 'mechatroner/rainbow_csv'

" Shows diff signs in gutter
Plug 'mhinz/vim-signify'
"
" Intellisense engine for nvim
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Better whitespace highlighting
Plug 'ntpeters/vim-better-whitespace'

" Start a * or # search from a visual block
Plug 'nelstrom/vim-visual-star-search'

" Access most recently Used files with fzf.vim
Plug 'pbogut/fzf-mru.vim'

" Formatting code
Plug 'sbdchd/neoformat'

" Translate text
Plug 'sgelb/vim-translator'

" Run code quickly
Plug 'thinca/vim-quickrun'

" Pairs of handy bracket mappings
Plug 'tpope/vim-unimpaired'

" Comment stuff out
Plug 'tpope/vim-commentary'

" Git wrapper
Plug 'tpope/vim-fugitive'

" Heuristically set buffer options
Plug 'tpope/vim-sleuth'

" More text objects
Plug 'wellle/targets.vim'

call plug#end()

""" ambv/black
let g:black_linelength = 100

function! StatusDiagnostic() abort
  let info = get(b:, 'coc_diagnostic_info', {})
  if empty(info) | return '' | endif
  let msgs = []
  if get(info, 'error', 0)
    call add(msgs, "\uf05e " . info['error'])
  endif
  if get(info, 'warning', 0)
    call add(msgs, "\uf06a " . info['warning'])
  endif
  return join(msgs, ' ')
endfunction

""" itchyny/lightline.vim
let g:lightline = {'colorscheme': 'nightfly'}
let g:lightline.component_function = { 'gitbranch': 'fugitive#statusline' }
let g:lightline = {
        \ 'component': { 'tagbar': '%{tagbar#currenttag("[%s]", "", "f")}',
        \                'timebar': '%{vim_timebox#time_left()}',
        \                'statusdiagnostics': '%{StatusDiagnostic()}',
        \              },
        \ }

let g:lightline.active = {
      \ 'left': [['mode', 'paste'], ['gitbranch', 'readonly', 'filename', 'modified'], ['tagbar']],
      \ 'right': [
      \   ['timebar'],
      \   ['lineinfo'],
      \   ['percent'],
      \   ['fileformat', 'fileencoding', 'filetype', 'statusdiagnostics'],
      \ ]
      \ }

""" gioele/vim-autoswap
let g:autoswap_detect_tmux = 1

""" junegunn/fzf
let g:fzf_nvim_statusline = 0 " disable statusline overwriting

""" lervag/vimtex
let g:tex_flavor = "latex"
let g:vimtex_compiler_progname = 'nvr'
let g:vimtex_view_method = 'zathura'
let g:vimtex_format_enabled = 1
let g:vimtex_quickfix_latexlog = { 'overfull' : 0, 'underfull' : 0 }
let g:vimtex_compiler_latexmk = { 'build_dir' : 'output' }
let g:vimtex_toc_config = { 'layers' : ['content', 'todo'], 'show_help' : 0 }

""" lervag/wiki
let g:wiki_root = '~/.local/share/vimwiki'
let g:wiki_filetypes = ['md']

""" luochen1990/rainbow
let g:rainbow_active = 1

""" ntpeters/vim-better-whitespace
autocmd BufEnter * EnableStripWhitespaceOnSave  " strip whitespace on save
let g:strip_whitespace_confirm=0

""" sbdchd/neoformat
let g:neoformat_enabled_python = ['black', 'isort', 'docformatter']
let g:neoformat_python_run_all_formatters = 1

""" sgelb/vim-translator
let g:translate_cmd='trans -b :en'

""" tpope/vim-unimpaired
nmap < [
nmap > ]
omap < [
omap > ]
xmap < [
xmap > ]

""" tpope/vim-commentary
autocmd FileType markdown setlocal commentstring=<!--\ %s\ -->

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
  autocmd BufRead /tmp/alot.*.eml :set ft=mail
  " autocmd FileType mail set tw=80

  " python
  autocmd BufNewFile,BufRead *.py set keywordprg=pydoc
augroup END


"""""""""""""""""
" CUSTOM COMMANDS
"""""""""""""""""

" Show TODO and FIXME in quickfix window
command Todo noautocmd vimgrep /TODO\|FIXME/j * | cw

command TOC :VimtexTocToggle


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

""" sgelb/vim-translator
vmap T <Plug>Translate
vmap R <Plug>TranslateReplace

""" thinca/vim-quickrun
nmap <silent> <leader>q :QuickRun<cr>

""" sbdchd/neoformat
nmap <silent> <leader>y :Neoformat<cr>

set updatetime=300
call coc#config('python', {
      \   'jediEnabled': v:false,
      \   'pythonPath': split(execute('!which python'), '\n')[-1]
      \ })

inoremap <silent><expr> <tab> pumvisible() ? "\<c-n>" : <sid>check_back_space() ? "\<tab>" : coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Navigate diagnostics
nmap <silent> <leader>ak <Plug>(coc-diagnostic-prev)
nmap <silent> <leader>aj <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

""" Shougo/neosnippet.vim
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)

" sane movement over wrapped lines
nmap j gj
nmap k gk

" allow saving as sudo
cmap w!! w !sudo tee > /dev/null %

" jump tags
nnoremap ü <C-]>
nnoremap Ü <C-O>

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


""""""""""""""
" COLOR SCHEME
""""""""""""""

colorscheme nightfly
" Highlight same text in nightfly Cyan Blue
highlight CocHighlightText ctermfg=Red guibg=#296596
