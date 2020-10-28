" Vim plug initialisation
call plug#begin(stdpath('data') . '/plugged')

" General {{{
    " Abbreviations, as in auto correct common typos.
    abbr teh the

    set autoread " Detect file changes

    set history=1000
    set textwidth=100

    set backupdir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
    set directory=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp

    set inccommand=nosplit

    set backspace=indent,eol,start
    set clipboard=unnamed

    if has('mouse')
       set mouse=a
    endif

    set hlsearch
    set incsearch
    set nolazyredraw

    set magic

    set noerrorbells
    set visualbell
    set t_vb=
    set tm=500
" }}}

" Appearance {{{
    " Relative line numbering.
    set number relativenumber
    set nu rnu

    set wrap
    set wrapmargin=8
    set linebreak
    set showbreak=↪
    set autoindent
    set ttyfast
    set diffopt+=vertical,iwhite,internal,algorithm:patience,hiddenoff
	set laststatus=2
    set so=7
    set wildmenu
    set hidden
    set showcmd
    set noshowmode
    set wildmode=list:longest
    set shell=sh " I tend to use fish, and vim doesn't like that.
    set cmdheight=1
    set title
    set showmatch
    set mat=2
    set updatetime=300
    set signcolumn=yes
    set shortmess+=c

    " Tab behaviour
    set smarttab
    set tabstop=4
    set softtabstop=4
    set shiftwidth=4
    set shiftround
	set expandtab

    " code folding settings
    set foldmethod=syntax
    set foldlevelstart=99
    set foldnestmax=10
    set nofoldenable
    set foldlevel=1

    set list
    set listchars=tab:→\ ,eol:¬,trail:⋅,extends:❯,precedes:❮

    set t_Co=256 " Explicitly tell vim that the terminal supports 256 colors

    if &term =~ '256color'
        " disable background color erase
        set t_ut=
    endif

    " enable 24 bit color support if supported
    if (has("termguicolors"))
        if (!(has("nvim")))
            let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
            let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
        endif
        set termguicolors
    endif

    " highlight conflicts
    match ErrorMsg '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$'

    " Colorscheme
    Plug 'morhetz/gruvbox'

    " Light line
    Plug 'itchyny/lightline.vim'
    Plug 'shinchu/lightline-gruvbox.vim'
    let g:lightline = {}
    let g:lightline.colorscheme = 'gruvbox'

    " Vim go
    Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }

    " deoplete
    Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
    let g:deoplete#enable_at_startup = 1

" Initialise all plugins.
call plug#end()
autocmd vimenter * ++nested colorscheme gruvbox
call deoplete#custom#option('omni_patterns', { 'go': '[^. *\t]\.\w*' })
