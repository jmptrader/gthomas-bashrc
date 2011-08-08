set nocompatible    " use vim defaults
set ls=2            " allways show status line
set tabstop=4       " numbers of spaces of tab character
set shiftwidth=4    " numbers of spaces to (auto)indent
set scrolloff=3     " keep 3 lines when scrolling
set showcmd         " display incomplete commands
set hlsearch        " highlight searches
set incsearch       " do incremental searching
set ruler           " show the cursor position all the time
set laststatus=2
set visualbell t_vb=    " turn off error beep/flash
set novisualbell    " turn off visual bell
set nobackup        " do not keep a backup file
set number          " show line numbers
set numberwidth=4   " line numbering takes up 5 spaces
set ignorecase      " ignore case when searching
set nowrap          " stop lines from wrapping
set noignorecase   " don't ignore case
set notitle         " don't show "Thanks for flying vim"
set ttyfast         " smoother changes
"set ttyscroll=0        " turn off scrolling, didn't work well with PuTTY
set bs=2            " Backspace can delete previous characters
set modeline        " last lines in document sets vim mode
set modelines=3     " number lines checked for modelines
set shortmess=atI   " Abbreviate messages
set nostartofline   " don't jump to first character when paging
set whichwrap=b,s,h,l,<,>,[,]   " move freely between files
set undolevels=200
set cpoptions=$cF
set wildignore=*.o,*.obj,*.bak,*.exe,*.pyc,*.DS_Store,*.db
set statusline=%F%m%r%h%w\ [TYPE=%Y\ %{&ff}]\ [%02v,%04l/%L\ (%p%%)]
filetype plugin indent on " turn on the indent plugins

set noautoindent    " turn off by default, enable for specific filetypes
set nosmartindent   " turn off by default, enable for specific filetypes
set nocindent       " turn off by default, enable for specific filetypes

" NERD_tree config
let NERDTreeChDirMode=2
let NERDTreeIgnore=['\.vim$', '\~$', '\.pyc$', '\.swp$']
let NERDTreeSortOrder=['^__\.py$', '\/$', '*', '\.swp$',  '\.bak$', '\~$']
let NERDTreeShowBookmarks=1

" VCS Command Configs
let mapleader = ","

" Syntax for multiple tag files are
" set tags=/my/dir1/tags, /my/dir2/tags
set tags=tags;$HOME/.vim/tags/ "recursively searches directory for 'tags' file

" TagList Plugin Configuration
let Tlist_Ctags_Cmd='/usr/bin/ctags' " point taglist to ctags
let Tlist_GainFocus_On_ToggleOpen = 1      " Focus on the taglist when its toggled
let Tlist_Close_On_Select = 1              " Close when something's selected
let Tlist_Use_Right_Window = 1             " Project uses the left window
let Tlist_File_Fold_Auto_Close = 1         " Close folds for inactive files

" SCMDiff Plugin Configuration
let SCMDiffCommand = 'git'

"set autowrite       " auto saves changes when quitting and swiching buffer
set expandtab       " tabs are converted to spaces
set sm              " show matching braces, somewhat annoying...

" remove ALL auto-commands so there are no dupes
autocmd!

syntax on                 " syntax highlighing
if has("gui_running")
    " See ~/.gvimrc
    set guifont=Inconsolata\ 10.00  " use this font
    set lines=50          " height = 50 lines
    set columns=120       " width = 100 columns
    set background=dark   " adapt colors for background
    set guioptions-=T
    set list listchars=tab:▷⋅,trail:⋅,nbsp:⋅ " mark trailing white space
    " colorscheme brookstream
else
    colorscheme elflord   " use this color scheme
    set background=light   " adapt colors for background
endif

if has("autocmd")
    " Restore cursor position
    au BufReadPost * if line("'\"") > 0|if line("'\"") <= line("$")|exe("norm '\"")|else|exe "norm $"|endif|endif

    " Filetypes (au = autocmd)
    au FileType helpfile set nonumber      " no line numbers when viewing help
    au FileType helpfile nnoremap <buffer><cr> <c-]>   " Enter selects subject
    au FileType helpfile nnoremap <buffer><bs> <c-T>   " Backspace to go back

    " When using mutt, text width=72
    au FileType mail,tex set textwidth=72
    au FileType cpp,c,java,sh,pl,php,py,asp  set autoindent
    au FileType cpp,c,java,sh,pl,php,py,asp  set smartindent
    au FileType cpp,c,java,sh,pl,php,py,asp  set cindent
    au FileType py set foldmethod=indent
    au FileType py set textwidth=79  " PEP-8 friendly
    au FileType py inoremap # X#
    au FileType py set expandtab
    au FileType py set omnifunc=pythoncomplete#Complete
    autocmd BufRead *.py set makeprg=python\ -c\ \"import\ py_compile,sys;\ sys.stderr=sys.stdout;\ py_compile.compile(r'%')\"
    autocmd BufRead *.py set efm=%C\ %.%#,%A\ \ File\ \"%f\"\\,\ line\ %l%.%#,%Z%[%^\ ]%\\@=%m
    autocmd BufWritePre *.py :%s/\s\+$//e
    "au BufRead mutt*[0-9] set tw=72

    " Automatically chmod +x Shell scripts
    au BufWritePost   *.sh             !chmod +x %

    " File formats
    au BufNewFile,BufRead  *.pls    set syntax=dosini
    au BufNewFile,BufRead  modprobe.conf    set syntax=modconf
endif

" Keyboard mappings
map <F1> :previous<CR>  " map F1 to open previous buffer
map <F2> :next<CR>      " map F2 to open next buffer
map <F3> :NERDTreeToggle<CR>" map F3 to open NERDTree
map <F7> :TlistToggle<CR> " map F7 to toggle the Tag Listing
map <silent> <C-N> :silent noh<CR> " turn off highlighted search
map ,v :sp ~/.vimrc<cr> " edit my .vimrc file in a split
map ,e :e ~/.vimrc<cr>      " edit my .vimrc file
map ,u :source ~/.vimrc<cr> " update the system settings from my vimrc file
map ,p :Lodgeit<CR>         " pastes selection / file to paste.pocoo.org
map ,ft :%s/    /    /g<CR> " replace all tabs with 4 spaces
map ,d :call <SID>SCMDiff()<CR>

" Viewport Controls
" ie moving between split panes
map <silent>,h <C-w>h
map <silent>,j <C-w>j
map <silent>,k <C-w>k
map <silent>,l <C-w>l

map <silent><C-left> <C-T>  " step out of a python function
map <silent><C-right> <C-]> " follow a python function
