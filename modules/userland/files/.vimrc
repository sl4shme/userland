"==========================================================
" Vundle
" ==========================================================
" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'
Plugin 'bling/vim-airline'
Plugin 'altercation/vim-colors-solarized'
Plugin 'scrooloose/syntastic'
Plugin 'scrooloose/nerdtree'
Plugin 'ervandew/supertab'
Plugin 'scrooloose/nerdcommenter'
Plugin 'sjl/gundo.vim'
Plugin 'raimondi/delimitMate'
Plugin 'tpope/vim-fugitive'

call vundle#end()            " required
filetype plugin indent on    " required

" ==========================================================
" Shortcuts
" ==========================================================
" Reload Vimrc
map <silent> <leader>V :source ~/.vimrc<CR>:filetype detect<CR>:exe ":echo 'vimrc reloaded'"<CR>

" for when we forget to use sudo to open/edit a file
cmap w!! w !sudo tee % >/dev/null

"remove all trailing whitespaces
:nnoremap <silent> <F9> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar>:nohl<CR>

" Toggle line numbering
:nmap <F12> :set invnumber<CR>
" ==========================================================
" Basic Settings
" ==========================================================
syntax on " syntax highlighing
set history=700
filetype on " try to detect filetypes
set number " Display line numbers
set title " show title in console title bar
let g:solarized_termcolors=256
colorscheme solarized
set background=dark

" don't bell or blink
set noerrorbells
set vb t_vb=

" Ignore these files when completing
set wildignore+=*.o,*.obj,.git,*.pyc
set wildignore+=eggs/**
set wildignore+=*.egg-info/**

" Set working directory
nnoremap <leader>. :lcd %:p:h<CR>

""" Moving Around/Editing
set cursorline " have a line indicate the cursor location
set ruler " show the cursor position all the time
set nostartofline " Avoid moving cursor to BOL when jumping around
set virtualedit=block " Let cursor move past the last char in <C-v> mode
set scrolloff=3 " Keep 3 context lines above and below the cursor
set backspace=2 " Allow backspacing over autoindent, EOL, and BOL
set showmatch " Briefly jump to a paren once it's balanced
set wrap " Wrap text
set linebreak " don't wrap textin the middle of a word
set formatoptions=tcroql " Setting text and comment formatting to auto
set textwidth=150 " lines are automatically wrapped after 80 columns
set nofoldenable " turn off folding
set colorcolumn=80 " highlight column 80 (where words will wrap)

""" Indent
set autoindent " always set autoindenting on
set smartindent " use smart indent if there is no indent file
set tabstop=4 " <tab> inserts 4 spaces
set shiftwidth=4 " And an indent level is 4 spaces wide.
set softtabstop=4 " <BS> over an autoindent deletes all spaces.
set expandtab " Use spaces, not tabs, for autoindent/tab key.
set shiftround " rounds indent to a multiple of shiftwidth

"""" Reading/Writing
set noautoread " Don't automatically re-read changed files.
set modeline " Allow vim options to be embedded in files;
set modelines=5 " they must be within the first or last 5 lines.

"""" Messages, Info, Status
set ls=2 " allways show status line
set showcmd " Show incomplete normal mode commands as I type.
set report=0 " : commands always print changed line count.
set shortmess+=a " Use [+]/[RO]/[w] for modified/readonly/written.
set laststatus=2 " Always show statusline, even if only 1 window.

"toogle paste mode
map <leader>pp :setlocal paste!<cr>

""" Searching and Patterns
set ignorecase " Default to using case insensitive searches,
set smartcase " unless uppercase letters are used in the regex.
set hlsearch " Highlight searches by default.
set incsearch " Incrementally search while typing a /regex
set magic

""" Undo after close
if exists("+undofile")
" undofile - This allows you to use undos after exiting and restarting
" This, like swap and backups, uses .vim-undo first, then ~/.vim/undo
" :help undo-persistence
" This is only present in 7.3+
if isdirectory($HOME . '/.vim/undo') == 0
:silent !mkdir -p ~/.vim/undo > /dev/null 2>&1
endif
set undodir=./.vim-undo//
set undodir+=~/.vim/undo//
set undofile
endif

" Show matching brackets when text indicator is over them
set showmatch
" How many tenths of a second to blink when matching brackets
set mat=2

" Set utf8 as standard encoding and en_US as the standard language
set encoding=utf8

" Use Unix as the standard file type
set ffs=unix,dos,mac

set foldmethod=indent

 "======================="
" NerdTree "
"======================="
"Open if nothing
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
" Mouse
set mouse=a
map <F5> :NERDTreeToggle<CR>
" Close if nothing
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif
let NERDTreeDirArrows=0

"======================="
" Powerline "
"======================="
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

"======================="
" Syntastic"
"======================="
nnoremap <F9> :SyntasticCheck<CR>
nnoremap <F10> :SyntasticReset<CR>

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list=1
let g:syntastic_check_on_open=1
let g:syntastic_enable_signs=1

"======================="
" SuperTab"
"======================="
au FileType python set omnifunc=pythoncomplete#Complete
let g:SuperTabDefaultCompletionType = "context"
let g:SuperTabContextDefaultCompletionType = "<c-n>"
let g:SuperTabClosePreviewOnPopupClose = 1
let g:SuperTabLongestEnhanced = 1
let g:SuperTabCrMapping = 1
set completeopt=menuone,longest,preview

"======================="
" NerdCommenter"
"======================="
let g:NERDSpaceDelims=1

"======================="
" Gundo"
"======================="
nnoremap <F6> :GundoToggle<CR>


"======================="
" Securing tmp files"
"======================="
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
