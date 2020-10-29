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


    set spell
    set spelllang=en
    set spellfile=$HOME/.config/nvim/spell/en.utf-8.add 
" }}}

" Mappings {{{
    let mapleader=","

    " set paste toggle
    set pastetoggle=<F2>

    " Edit vim config
    map <leader>ev :e! ~/.config/nvim/init.vim<cr>

    " Clear highlighted search
    noremap <space> :set hlsearch! hlsearch?<cr>

    " remove extra whitespace
    nmap <leader><space> :%s/\s\+$<cr>
    nmap <leader><space><space> :%s/\n\{2,}/\r\r/g<cr>

    inoremap <expr> <C-j> pumvisible() ? "\<C-N>" : "\<C-j>"
    inoremap <expr> <C-k> pumvisible() ? "\<C-P>" : "\<C-k>"

    nmap <leader>l :set list!<cr>

    " keep visual selection when indenting/outdenting
    vmap < <gv
    vmap > >gv

    " switch between current and last buffer
    nmap <leader>. <c-^>

" }}}

" AutoGroups {{{
    " file type specific settings
    augroup configgroup
        autocmd!

        " automatically resize panes on resize
        autocmd VimResized * exe 'normal! \<c-w>='
        autocmd BufWritePost .vimrc,.vimrc.local,init.vim source %
        autocmd BufWritePost .vimrc.local source %
        " save all files on focus lost, ignoring warnings about untitled buffers
        autocmd FocusLost * silent! wa

        " make quickfix windows take all the lower section of the screen
        " when there are multiple windows open
        autocmd FileType qf wincmd J
        autocmd FileType qf nmap <buffer> q :q<cr>
    augroup END
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
    set shell=bash " I tend to use fish, and vim doesn't like that.
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

    set t_Co=256 " Explicitly tell vim that the terminal supports 256 colours

    if &term =~ '256color'
        " disable background colour erase
        set t_ut=
    endif

    " enable 24 bit colour support if supported
    if (has("termguicolors"))
        if (!(has("nvim")))
            let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
            let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
        endif
        set termguicolors
    endif

    " highlight conflicts
    match ErrorMsg '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$'

    " Colour scheme
    Plug 'morhetz/gruvbox'

    " Light line {{{
    Plug 'itchyny/lightline.vim'
    Plug 'shinchu/lightline-gruvbox.vim'
    let g:lightline = {
                \   'colorscheme': 'gruvbox',
                \   'active': {
                \       'left': [ [ 'mode', 'paste' ],
                \               [ 'gitbranch' ],
                \               [ 'readonly', 'filetype', 'filename' ]],
                \       'right': [ [ 'percent' ], [ 'lineinfo' ],
                \               [ 'fileformat', 'fileencoding' ],
                \               [ 'cocstatus', 'linter_errors', 'linter_warnings' ]]
                \   },
                \   'component_expand': {
                \   },
                \   'component_type': {
                \       'readonly': 'error',
                \       'linter_warnings': 'warning',
                \       'linter_errors': 'error'
                \   },
                \   'component_function': {
                \       'fileencoding': 'helpers#lightline#fileEncoding',
                \       'filename': 'helpers#lightline#fileName',
                \       'fileformat': 'helpers#lightline#fileFormat',
                \       'filetype': 'helpers#lightline#fileType',
                \       'gitbranch': 'helpers#lightline#gitBranch',
                \   },
                \   'tabline': {
                \       'left': [ [ 'tabs' ] ],
                \       'right': [ [ 'close' ] ]
                \   },
                \   'tab': {
                \       'active': [ 'filename', 'modified' ],
                \       'inactive': [ 'filename', 'modified' ],
                \   },
                \   'separator': { 'left': '', 'right': '' },
                \   'subseparator': { 'left': '', 'right': '' }
                \ }
" }}}

" Vim go {{{
    Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
    
    " Go settings settings
    let g:go_fmt_command = 'goimports'
    let g:go_imports_autosave = 1
    let g:go_metalinter_autosave = 1
    let g:go_term_enabled = 1
    let g:go_gopls_use_placeholders = 1
    let g:go_addtags_skip_unexported = 0
    let g:go_highlight_string_spellcheck = 1
" }}}

" deoplete and snippets {{{
    Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
    Plug 'Shougo/neosnippet.vim'
    Plug 'Shougo/neosnippet-snippets'

    let g:deoplete#enable_at_startup = 1
    imap <C-k>     <Plug>(neosnippet_expand_or_jump)
    smap <C-k>     <Plug>(neosnippet_expand_or_jump)
    xmap <C-k>     <Plug>(neosnippet_expand_target)

    " SuperTab like snippets behavior.
    " Note: It must be "imap" and "smap".  It uses <Plug> mappings.
    imap <expr><TAB>
    \ pumvisible() ? "\<C-n>" :
    \ neosnippet#expandable_or_jumpable() ?
    \    "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
    smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
    \ "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
" }}}

" General functionality {{{
    " Comment motion commands (`gc`)
    Plug 'tpope/vim-commentary'

    " Generally useful mappings
    Plug 'tpope/vim-unimpaired'

    " Surround options
    Plug 'tpope/vim-surround'
    Plug 'tpope/vim-ragtag'

    " Add repeatable commands
    Plug 'tpope/vim-repeat'

    " .editorconfig support
    Plug 'editorconfig/editorconfig-vim'

    " single/multi line code handler: gS - split one line into multiple, gJ - combine multiple lines into one
    Plug 'AndrewRadev/splitjoin.vim'

    " detect indent style (tabs vs. spaces)
    Plug 'tpope/vim-sleuth'

    " Better buffer deletion
    Plug 'moll/vim-bbye'

    " Startify: Fancy startup screen for vim {{{
        Plug 'mhinz/vim-startify'

        " Don't change to directory when selecting a file
        let g:startify_files_number = 5
        let g:startify_change_to_dir = 0
        let g:startify_custom_header = [ ]
        let g:startify_relative_path = 1
        let g:startify_use_env = 1

        " Custom startup list, only show MRU from current directory/project
        let g:startify_lists = [
        \  { 'type': 'dir',       'header': [ 'Files '. getcwd() ] },
        \  { 'type': 'sessions',  'header': [ 'Sessions' ]       },
        \  { 'type': 'bookmarks', 'header': [ 'Bookmarks' ]      },
        \  { 'type': 'commands',  'header': [ 'Commands' ]       },
        \ ]

        let g:startify_commands = [
        \   { 'up': [ 'Update Plugins', ':PlugUpdate' ] },
        \   { 'ug': [ 'Upgrade Plugin Manager', ':PlugUpgrade' ] },
        \ ]

        let g:startify_bookmarks = [
            \ { 'c': '~/.config/nvim/init.vim' },
        \ ]

        autocmd User Startified setlocal cursorline
        nmap <leader>st :Startify<cr>
    " }}}

    " NERDTree {{{
        Plug 'scrooloose/nerdtree', { 'on': ['NERDTreeToggle', 'NERDTreeFind'] }
        Plug 'Xuyuanp/nerdtree-git-plugin'
        Plug 'ryanoasis/vim-devicons'
        Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
        let g:WebDevIconsUnicodeDecorateFolderNodes = 1
        let g:DevIconsEnableFoldersOpenClose = 1
        let g:DevIconsEnableFolderExtensionPatternMatching = 1
        let NERDTreeDirArrowExpandable = "\u00a0" " make arrows invisible
        let NERDTreeDirArrowCollapsible = "\u00a0" " make arrows invisible
        let NERDTreeNodeDelimiter = "\u263a" " smiley face

        augroup nerdtree
            autocmd!
            autocmd FileType nerdtree setlocal nolist " turn off whitespace characters
            autocmd FileType nerdtree setlocal nocursorline " turn off line highlighting for performance
        augroup END

        " Toggle NERDTree
        function! ToggleNerdTree()
            if @% != "" && @% !~ "Startify" && (!exists("g:NERDTree") || (g:NERDTree.ExistsForTab() && !g:NERDTree.IsOpen()))
                :NERDTreeFind
            else
                :NERDTreeToggle
            endif
        endfunction
        " toggle nerd tree
        nmap <silent> <leader>n :call ToggleNerdTree()<cr>
        " find the current file in nerdtree without needing to reload the drawer
        nmap <silent> <leader>y :NERDTreeFind<cr>

        let NERDTreeShowHidden=1
        " let NERDTreeDirArrowExpandable = '▷'
        " let NERDTreeDirArrowCollapsible = '▼'
        let g:NERDTreeIndicatorMapCustom = {
        \ "Modified"  : "✹",
        \ "Staged"    : "✚",
        \ "Untracked" : "✭",
        \ "Renamed"   : "➜",
        \ "Unmerged"  : "═",
        \ "Deleted"   : "✖",
        \ "Dirty"     : "✗",
        \ "Clean"     : "✔︎",
        \ 'Ignored'   : '☒',
        \ "Unknown"   : "?"
        \ }
    " }}}
    "
    " vim-fugitive {{{
        Plug 'tpope/vim-fugitive'
        nmap <silent> <leader>gs :Gstatus<cr>
        nmap <leader>ge :Gedit<cr>
        nmap <silent><leader>gr :Gread<cr>
        nmap <silent><leader>gb :Gblame<cr>

        Plug 'sodapopcan/vim-twiggy'
        Plug 'rbong/vim-flog'
    " }}}
    
    " Neosnippet {{{




    " FZF {{{
        Plug 'junegunn/fzf',  { 'do': { -> fzf#install() } }
        Plug 'junegunn/fzf.vim'
        let g:fzf_layout = { 'down': '~25%' }
        nmap <C-P> :FZF<CR>
    " }}}

    " JSON {{{
        Plug 'elzr/vim-json', { 'for': 'json' }
        let g:vim_json_syntax_conceal = 0
    " }}}
    
    " YAML {{{
        au! BufNewFile,BufReadPost *.{yaml,yml} set filetype=yaml foldmethod=indent
        autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
    " }}}

    " Docker {{{
        Plug 'ekalinin/Dockerfile.vim'
    " }}}



" Initialise all plug ins.
call plug#end()
autocmd vimenter * ++nested colorscheme gruvbox
call deoplete#custom#option('omni_patterns', { 'go': '[^. *\t]\.\w*' })
