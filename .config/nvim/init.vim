"
"
" ~/.vimrc (local shell)
"

set ruler
set ignorecase
set smartcase

set shell=/usr/local/bin/zsh
set encoding=utf8
set ffs=unix,dos,mac
set nobackup
set noswapfile
set incsearch
set title
set showmode
set wildmenu
set history=1000

try
    set undodir=~/.vim_runtime/undodir
    set undofile
catch
endtry

set smarttab
set expandtab
set linebreak
set textwidth=0

" Disable case insensitive search and replace.
set noignorecase
set nosmartcase

set foldcolumn=2
" Fix up arrow not working in search.

set laststatus=2
set number

set ts=4
set sw=4
set ai
set expandtab
set hlsearch

" -----
" 24-bit colors
" -----
"Credit joshdick
"Use 24-bit (true-color) mode in Vim/Neovim when outside tmux.
"If you're using tmux version 2.2 or later, you can remove the outermost $TMUX check and use tmux's 24-bit color support
"(see < http://sunaku.github.io/tmux-24bit-color.html#usage > for more information.)
if (empty($TMUX))
  if (has("nvim"))
  "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
  let $NVIM_TUI_ENABLE_TRUE_COLOR=1
  endif
  "For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
  "Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
  " < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
  if (has("termguicolors"))
    set termguicolors
  endif
endif
set termguicolors
set clipboard=unnamedplus


"
" -----------------------

call plug#begin()

" --- Colorscheme ---
Plug 'flazz/vim-colorschemes'
Plug 'tibabit/vim-templates'
Plug 'iCyMind/NeoSolarized'

Plug 'amiorin/vim-project'

Plug 'rakr/vim-one'

Plug 'scrooloose/nerdcommenter'
Plug 'scrooloose/nerdtree'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }

Plug 'SidOfc/mkdx'
Plug 'itspriddle/vim-marked'
Plug 'tpope/vim-fugitive'

Plug 'w0rp/ale'
Plug 'bfredl/nvim-ipy', { 'for' : 'python' }
Plug 'plytophogy/vim-virtualenv', { 'for' : 'python' }
Plug 'lambdalisue/vim-pyenv', { 'for' : 'python' }
Plug 'scrooloose/nerdtree'

Plug 'zchee/deoplete-jedi'
Plug 'deoplete-plugins/deoplete-go', { 'for' : 'go', 'do': 'make'}
Plug 'Shougo/denite.nvim'

if has('nvim')
    Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
else
    Plug 'Shougo/deoplete.nvim'
    Plug 'roxma/nvim-yarp'
    Plug 'roxma/vim-hug-neovim-rpc'
endif
Plug 'davidhalter/jedi-vim'
 
" Plug 'Valloric/YouCompleteMe', { 'do': './install.py' }
Plug 'itchyny/lightline.vim'
Plug 'maximbaz/lightline-ale'

Plug 'scrooloose/nerdcommenter'
Plug 'scrooloose/nerdtree'

" Auto format
Plug 'sbdchd/neoformat'
Plug 'neomake/neomake'
Plug 'tmhedberg/SimpylFold'
Plug 'numirias/semshi', {'do': ':UpdateRemotePlugins'}
Plug 'Vigemus/iron.nvim'


Plug 'Vigemus/impromptu.nvim'
Plug 'fatih/vim-go', { 'for': 'go', 'do': ':GoUpdateBinaries' }

" Indent lines
Plug 'nathanaelkane/vim-indent-guides'

Plug 'junegunn/fzf.vim'
Plug 'numkil/ag.nvim'

Plug 'sakhnik/nvim-gdb', { 'do': ':!./install.sh \| UpdateRemotePlugins' }

" Git gutter
Plug 'mhinz/vim-signify'

Plug '~/.doftiles/projects'

" Session 
"Plug 'tpope/vim-obsession'
"Plugin 'vim-scripts/vim-misc'
"Plugin 'vim-scripts/gitdiff.vim'
"Plugin 'vim-scripts/pdbvim'
"Plugin 'solarnz/thrift.vim'

" Local Shortccuts
" uses pygtk
" A simple color picker for VIM, based on GTK color chooser dialog.
" Plugin 'vim-scripts/VIM-Color-Picker'
" Plugin 'vim-scripts/ColorX'

call plug#end()

filetype plugin indent on     " required

"----------------------------------------------
" Plugin: 'nathanaelkane/vim-indent-guides'
"----------------------------------------------
"
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_guide_size = 1
let g:indent_guides_start_level = 2

"----------------------------------------------
" Plugin: 'tpope/vim-obsession'
"----------------------------------------------

"----------------------------------------------
" Plugin: 'sakhnik/nvim-gdb', 
"----------------------------------------------
" We're going to define single-letter keymaps, so don't try to define them
" in the terminal window.  The debugger CLI should continue accepting text commands.
function! NvimGdbNoTKeymaps()
  tnoremap <silent> <buffer> <esc> <c-\><c-n>
endfunction

let g:nvimgdb_config_override = {
  \ 'key_next': 'n',
  \ 'key_step': 's',
  \ 'key_finish': 'f',
  \ 'key_continue': 'c',
  \ 'key_until': 'u',
  \ 'key_breakpoint': 'b',
  \ 'set_tkeymaps': "NvimGdbNoTKeymaps",
  \ }

"----------------------------------------------
" Plugin: 'SidOfc/mkdx'
"----------------------------------------------
"
" fzf + mxdx
fun! s:MkdxGoToHeader(header)
    " given a line: '  84: # Header'
    " this will match the number 84 and move the cursor to the start of that line
    call cursor(str2nr(get(matchlist(a:header, ' *\([0-9]\+\)'), 1, '')), 1)
endfun

fun! s:MkdxFormatHeader(key, val)
    let text = get(a:val, 'text', '')
    let lnum = get(a:val, 'lnum', '')

    " if the text is empty or no lnum is present, return the empty string
    if (empty(text) || empty(lnum)) | return text | endif

    " We can't jump to it if we dont know the line number so that must be present in the outpt line.
    " We also add extra padding up to 4 digits, so I hope your markdown files don't grow beyond 99.9k lines ;)
    return repeat(' ', 4 - strlen(lnum)) . lnum . ': ' . text
endfun

fun! s:MkdxFzfQuickfixHeaders()
    " passing 0 to mkdx#QuickfixHeaders causes it to return the list instead of opening the quickfix list
    " this allows you to create a 'source' for fzf.
    " first we map each item (formatted for quickfix use) using the function MkdxFormatHeader()
    " then, we strip out any remaining empty headers.
    let headers = filter(map(mkdx#QuickfixHeaders(0), function('<SID>MkdxFormatHeader')), 'v:val != ""')

    " run the fzf function with the formatted data and as a 'sink' (action to execute on selected entry)
    " supply the MkdxGoToHeader() function which will parse the line, extract the line number and move the cursor to it.
    call fzf#run(fzf#wrap(
            \ {'source': headers, 'sink': function('<SID>MkdxGoToHeader') }
          \ ))
endfun

" finally, map it -- in this case, I mapped it to overwrite the default action for toggling quickfix (<PREFIX>I)
nnoremap <silent> <Leader>I :call <SID>MkdxFzfQuickfixHeaders()<Cr>

let g:mkdx#settings = { 'checkbox': { 'toggles': [' ', '-', 'x'] } }

" newomake automagic check
call neomake#configure#automake('nrwi', 500)

"----------------------------------------------
" Whitespace options
"----------------------------------------------

"let c_space_errors = 0
let python_space_errors = 1
"blet ruby_space_errors = 1
"let java_space_errors = 1

:au BufNewFile,BufRead *.jinja set filetype=jinja

" Tell VIM which tags file to use.
set tags=./.tags,./tags,./docs/tags,tags,TAGS;$HOME

" When shifting always round to the correct indentation.
set shiftround

set list
set listchars=eol:$,tab:>-,trail:~,extends:>,precedes:.

" Show < or > when characters are not displayed on the left or right.
":set list listchars=precedes:<,extends:>
" Same, but also show tabs and trailing spaces.
":set list listchars=tab:>-,trail:.,precedes:<,extends:>
" Show invisible characters as dots
":set listchars=tab:··,trail:·

set mouse+=a

" Reload .vimrc immediately when edited
autocmd! bufwritepost .vim,.vimrc source ~/.config/nvim/init.vim

imap OA <ESC>ki
imap OB <ESC>ji
imap OC <ESC>li
imap OD <ESC>hi

au BufNewFile COMMIT_EDITING let syntax = diff
" Use ag for vimgrep
set grepprg=ag\ --vimgrep\ $* 
set grepformat=%f:%l:%c:%m

set foldenable          " enable folding
set foldlevelstart=10   " open most folds by default
set foldnestmax=10      " 10 nested fold max
set foldmethod=indent   " fold based on indent level


" For local replace
nnoremap gr gd[{V%::s/<C-R>///gc<left><left><left>

" For global replace
nnoremap gR gD:%s/<C-R>///gc<left><left><left>

"----------------------------------------------
" Plugin: 'Vigemus/iron.nvim'
"----------------------------------------------
luafile $HOME/.config/nvim/iron.plugin.lua

"----------------------------------------------
" Plugin: 'davidhalter/jedi-vim'
"----------------------------------------------
" disable autocompletion, cause we use deoplete for completion
let g:jedi#completions_enabled = 0

" open the go-to function in split, not another buffer
let g:jedi#use_splits_not_buffers = "right"
" <leader>n: show the usage of a name in current file
" <leader>r: rename a name

if jedi#init_python()
  function! s:python_from_env() 
    if exists("$VIRTUAL_ENV")
        let g:python3_host_prog=substitute(system("which -a python3 | head -n1 | tail -n1"), "\n", '', 'g')
    jelse
        let g:python3_host_prog=substitute(system("which python3"), "\n", '', 'g')
    endif
  endfunction
  function! s:jedi_auto_force_py_version() abort
    let g:jedi#force_py_version = pyenv#python#get_internal_major_version()
  endfunction
  augroup vim-pyenv-custom-augroup
    autocmd! *
    autocmd User vim-pyenv-activate-post   call s:jedi_auto_force_py_version()
    autocmd User vim-pyenv-deactivate-post call s:jedi_auto_force_py_version()
    autocmd User vim-pyenv-activate-post call s:python_from_env()
  augroup END
endif

let g:deoplete#enable_at_startup = 1
let g:deoplete#sources#go#gocode_binary=$GOPATH.'/bin/gocode'
" use tab
inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"

"----------------------------------------------
" Plugin: 'w0rp/ale'
"----------------------------------------------
" Error and warning signs.
let g:ale_sign_error = '⤫'
let g:ale_sign_warning = '⚠'
let g:ale_set_loclist = 0
let g:ale_set_quickfix = 1
" Enable integration with " Check Python files with flake8 and pylint.
let b:ale_linters = { 'python': ['flake8', 'pylint', 'mypy' ] }
" Fix Python files with autopep8 and yapf.
let b:ale_fixers = { 'python' : ['autopep8', 'yapf'] }
" Disable warnings about trailing whitespace for Python files.
let b:ale_warn_about_trailing_whitespace = 0
"
"----------------------------------------------
" Plugin: 'itchyny/lightline.vim'
"----------------------------------------------
" :au BufNewFile,BufRead AirlineTheme luna
" let g:airline_theme='solarized_flood' " <theme> is a valid theme name
" let g:airline_solarized_bg='dark'
" let g:airline_theme='one' " <theme> is a valid theme name

" let g:airline#extensions#tabline#enabled = 1
" let g:airline#extensions#ale#enabled = 1

let g:lightline = {
      \ 'active': {
      \   'left': [ [  'mode', 'paste' ],
      \             [ 'readonly', 'filename', 'modified', 'spell' ] ],
      \   'right': [ [ 'gitbranch', 'filename', 'lineno', 
      \                'linter_checking', 'linter_errors',
      \                'linter_warnings', 'linter_ok', 'percent' ] ],
      \ },
      \ 'colorscheme' : 'one'
      \ }


function! LightlineFilename()
  let filename = expand('%:t') !=# '' ? expand('%:t') : '[No Name]'
  let modified = &modified ? ' +' : ''
  return filename . modified
endfunction

let g:lightline#ale#indicator_checking = "\uf110 "
let g:lightline#ale#indicator_warnings = "\uf071 "
let g:lightline#ale#indicator_errors = "\uf05e "
let g:lightline#ale#indicator_ok = "\uf00c "
let g:lightline.component_expand = {
      \  'linter_checking': 'lightline#ale#checking',
      \  'linter_warnings': 'lightline#ale#warnings',
      \  'linter_errors': 'lightline#ale#errors',
      \  'linter_ok': 'lightline#ale#ok',
      \   'filename': 'LightlineFilename',
      \   'gitbranch': 'fugitive#head'
      \ }
let g:lightline.component_type = {
      \     'linter_checking': 'left',
      \     'linter_warnings': 'warning',
      \     'linter_errors': 'error',
      \     'linter_ok': 'left',
      \ }

"----------------------------------------------
" Plugin: bling/vim-go
"----------------------------------------------
"
let g:go_auto_sameids = 1
let g:go_fmt_command = "goimports"

au FileType go nmap <leader>gt :GoDeclsDir<cr>
au Filetype go nmap <leader>ga <Plug>(go-alternate-edit)
" Test coverage
au FileType go nmap <F9> :GoCoverageToggle -short<cr>
au Filetype go nmap <leader>gah <Plug>(go-alternate-split)
au Filetype go nmap <leader>gav <Plug>(go-alternate-vertical)

" show type in status bar
let g:go_auto_type_info = 1
au FileType go nmap <Leader>d <Plug>(go-def)
" Snake case or camel case
let g:go_addtags_transform = "snakecase"

"----------------------------------------------
" Plugin: christoomey/vim-tmux-navigator
"----------------------------------------------
" tmux will send xterm-style keys when its xterm-keys option is on
if &term =~ '^screen'
    execute "set <xUp>=\e[1;*A"
    execute "set <xDown>=\e[1;*B"
    execute "set <xRight>=\e[1;*C"
    execute "set <xLeft>=\e[1;*D"
endif

" Tmux vim integration
let g:tmux_navigator_no_mappings = 1
let g:tmux_navigator_save_on_switch = 1

" Move between splits with ctrl+h,j,k,l
nnoremap <silent> <c-h> :TmuxNavigateLeft<cr>
nnoremap <silent> <c-j> :TmuxNavigateDown<cr>
nnoremap <silent> <c-k> :TmuxNavigateUp<cr>
nnoremap <silent> <c-l> :TmuxNavigateRight<cr>
nnoremap <silent> <c-\> :TmuxNavigatePrevious<cr>

"----------------------------------------------
" Plugin: scrooloose/nerdtree
"----------------------------------------------
nnoremap <leader>d :NERDTreeToggle<cr>
nnoremap <F2> :NERDTreeToggle<cr>

" Files to ignore
let NERDTreeIgnore = [
    \ '\~$',
    \ '\.pyc$',
    \ '^\.DS_Store$',
    \ '^node_modules$',
    \ '^.ropeproject$',
    \ '^__pycache__$'
\]

" Close vim if NERDTree is the only opened window.
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

" Show hidden files by default.
let NERDTreeShowHidden = 1

" Allow NERDTree to change session root.
let g:NERDTreeChDirMode = 2

" --------------------------------------------
" Colorscheme 
" --------------------------------------------
colorscheme one

set background=dark " for the light version
map <F3> :let &background = ( &background == "dark"? "light" : "dark" )<CR>
let g:one_allow_italics = 1 " I love italic for comments
colorscheme one

" base 00
autocmd VimEnter,Colorscheme * hi IndentGuidesOdd  ctermbg=8 guibg=#002b36
" base 01
"autocmd VimEnter,Colorscheme * hi IndentGuidesEven ctermbg=8 guibg=#586e75
" base 02
autocmd VimEnter,Colorscheme * hi IndentGuidesEven ctermbg=0 guibg=#073642 

" Change the Pmenu colors so they're more readable.
highlight Pmenu ctermbg=cyan ctermfg=white
highlight PmenuSel ctermbg=black ctermfg=white

" Set max line length.
"let linelen = 120 
" execute "set colorcolumn=".linelen
"execute "match OverLength /\%".linelen."v.\+/"

" set highlight cursor
"augroup CursorLine
"  au!
"  au VimEnter,WinEnter,BufWinEnter * setlocal cursorline
"  au VimEnter,WinEnter,BufWinEnter * hi CursorLine ctermfg=136
"  au WinLeave * setlocal nocursorline
"augroup END
function! SemhiOneHighlights()
hi semshiLocal           ctermfg=209 guifg=#e06c75
hi semshiGlobal          ctermfg=214 guifg=#56b6c2
hi semshiImported        ctermfg=214 guifg=#e5c07b cterm=bold gui=bold
hi semshiParameter       ctermfg=75  guifg=#61AFEF
hi semshiParameterUnused ctermfg=117 guifg=#61AFEF cterm=underline gui=underline
hi semshiFree            ctermfg=218 guifg=#ffafd7
hi semshiBuiltin         ctermfg=207 guifg=#c678dd
hi semshiAttribute       ctermfg=49  guifg=#98c379
hi semshiSelf            ctermfg=249 guifg=#abb2bf
hi semshiUnresolved      ctermfg=226 guifg=#e5c07b cterm=underline gui=underline
hi semshiSelected        ctermfg=231 guifg=#ffffff ctermbg=161 guibg=#d7005f

hi semshiErrorSign       ctermfg=231 guifg=#ffffff ctermbg=160 guibg=#e06c75
hi semshiErrorChar       ctermfg=231 guifg=#ffffff ctermbg=160 guibg=#e06c75
endfunction
autocmd FileType python call SemhiOneHighlights()

