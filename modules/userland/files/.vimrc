" ======================= "
" Vundle
" ======================= "
set nocompatible                  " Do not touch
filetype off                      " Do not touch
set rtp+=~/.vim/bundle/Vundle.vim " Do not touch
call vundle#begin()               " Do not touch
Plugin 'VundleVim/Vundle.Vim'     " Do not touch

""" Plugins list start
Plugin 'bling/vim-airline'                " Fancy status bar
Plugin 'vim-airline/vim-airline-themes'   " Associated themes
Plugin 'altercation/vim-colors-solarized' " Theme
Plugin 'scrooloose/syntastic'             " Syntax checking
Plugin 'scrooloose/nerdtree'              " File explorer
Plugin 'scrooloose/nerdcommenter'         " Comment managment
Plugin 'ervandew/supertab'                " Autocompletion
Plugin 'sjl/gundo.vim'                    " Visual undo tree
Plugin 'raimondi/delimitMate'             " Auto closing of delimiters
Plugin 'tpope/vim-fugitive'               " Git wrapper
Plugin 'terryma/vim-multiple-cursors'     " Multiple cursor
""" Plugins list end

call vundle#end()         " Do not touch
filetype plugin indent on " Do not touch


" ======================= "
" Vim Settings
" ======================= "
""" Theme
let g:solarized_termcolors=256
colorscheme solarized
set background=dark

""" Cosmetic
syntax on             " Syntax highlighing
set noerrorbells      " No bell
set vb t_vb=          " No blink
set number            " Display line numbers
set showmatch         " Show matching brackets
set cursorline        " Have a line indicate the cursor location
set foldmethod=indent " Do the folding in function of the indentation
set nofoldenable      " No automatic folding at opening of file

""" Moving Around/Editing
set nostartofline     " Avoid moving cursor to BOL when jumping around
set virtualedit=block " Let cursor move past the last char in <C-v> mode
set scrolloff=3       " Keep 3 context lines above and below the cursor
set backspace=2       " Allow backspacing over autoindent, EOL, and BOL

""" Line lenght and wrapping
set wrap                 " Wrap text
set linebreak            " Don't wrap textin the middle of a word
set formatoptions=tcroql " Autocomment on newline
set textwidth=80         " Lines are automatically wrapped after 80 columns
set colorcolumn=80       " Highlight column 80

""" Indentation
set autoindent    " Always set autoindenting on
set smartindent   " Use smart indent if there is no indent file
set tabstop=4     " Tab inserts 4 spaces
set shiftwidth=4  " And an indent level is 4 spaces wide
set softtabstop=4 " Backspace over an autoindent deletes all spaces
set expandtab     " Use spaces, not tabs, for autoindent/tab key
set shiftround    " Rounds indent to a multiple of shiftwidth

"""" Messages, Info, Status
set ls=2         " Always show status line
set showcmd      " Show incomplete normal mode commands as I type
set report=0     " Commands always print changed line count
set laststatus=2 " Always show statusline, even if only 1 window
set history=500  " 500 lines of commands history

""" Searching and Patterns
set ignorecase " Default to using case insensitive searches
set smartcase  " Unless uppercase letters are used in the regex
set hlsearch   " Highlight searches by default
set incsearch  " Incrementally search while typing a /regex
set magic      " Use magic in searches

""" Files options
filetype on          " Try to detect filetypes
set noautoread       " Don't automatically re-read changed files
set modeline         " Allow vim options to be embedded in files
set modelines=5      " Those must be within the first or last 5 lines
set encoding=utf8    " Default encoding to utf-8
set ffs=unix,dos,mac " Use Unix as the standard file type
set wildignore+=*.o,*.obj,.git,*.pyc " Ignore these files when completing
set wildignore+=eggs/**
set wildignore+=*.egg-info/**


" ======================= "
" Shortcuts
" ======================= "
""" Toogle paste mode
nnoremap <F1> :setlocal paste!<cr>

""" Removes any search highlighting
nnoremap <silent> <F2> :nohl<CR><C-l>

""" Write file as root using sudo
cmap w!! w !sudo tee % >/dev/null

""" Remove all trailing whitespaces
nnoremap <silent> <F3> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar>:nohl<CR>

""" Toggle line numbering
nnoremap <F4> :set invnumber<CR>


" ======================= "
" Gundo
" ======================= "
nnoremap <F5> :GundoToggle<CR>


" ======================= "
" Syntastic
" ======================= "
nnoremap <F6> :SyntasticCheck<CR>
nnoremap <F7> :SyntasticReset<CR>

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list=1
let g:syntastic_check_on_open=1
let g:syntastic_enable_signs=1


" ======================= "
" NerdTree
" ======================= "
nnoremap <F8> :NERDTreeToggle<CR>

"Open if nothing
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
set mouse=a
" Close if nothing
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif
let NERDTreeDirArrows=0


" ======================= "
" Powerline
" ======================= "
let g:airline_theme='solarized'
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif
" unicode symbols
let g:airline_left_sep = '»'
let g:airline_left_sep = '▶'
let g:airline_right_sep = '«'
let g:airline_right_sep = '◀'
let g:airline_symbols.linenr = '␊'
let g:airline_symbols.linenr = '␤'
let g:airline_symbols.linenr = '¶'
let g:airline_symbols.branch = '⎇'
let g:airline_symbols.paste = 'ρ'
let g:airline_symbols.paste = 'Þ'
let g:airline_symbols.paste = '∥'
let g:airline_symbols.whitespace = 'Ξ'


" ======================= "
" SuperTab
" ======================= "
au FileType python set omnifunc=pythoncomplete#Complete
let g:SuperTabDefaultCompletionType = "context"
let g:SuperTabContextDefaultCompletionType = "<c-n>"
let g:SuperTabClosePreviewOnPopupClose = 1
let g:SuperTabLongestEnhanced = 1
let g:SuperTabCrMapping = 1
set completeopt=menuone,longest,preview


" ======================= "
" NerdCommenter
" ======================= "
let g:NERDSpaceDelims=1


" ======================= "
" Undo after close
" ======================= "
if exists("+undofile")
    if isdirectory($HOME . '/.vim/undo') == 0
        :silent !mkdir -p ~/.vim/undo > /dev/null 2>&1
    endif
    set undodir=./.vim-undo//
    set undodir+=~/.vim/undo//
    set undofile
endif


" ======================= "
" Securing tmp files
" ======================= "
if exists('&backupskip')
    set backupskip+=/tmp/*,$TMPDIR/*,$TMP/*,$TEMP/*,*/shm/*
endif

" Don't keep swap files in temp directories or shm
if has('autocmd')
    augroup swapskip
        autocmd!
        silent! autocmd BufNewFile,BufReadPre
            \ /tmp/*,$TMPDIR/*,$TMP/*,$TEMP/*,*/shm/*
            \ setlocal noswapfile
    augroup END
endif

" Don't keep undo files in temp directories or shm
if has('persistent_undo') && has('autocmd')
    augroup undoskip
        autocmd!
        silent! autocmd BufWritePre
            \ /tmp/*,$TMPDIR/*,$TMP/*,$TEMP/*,*/shm/*
            \ setlocal noundofile
    augroup END
endif

" Don't keep viminfo for files in temp directories or shm
if has('viminfo')
    if has('autocmd')
        augroup viminfoskip
            autocmd!
            silent! autocmd BufNewFile,BufReadPre
                \ /tmp/*,$TMPDIR/*,$TMP/*,$TEMP/*,*/shm/*
                \ setlocal viminfo=
        augroup END
    endif
endif
