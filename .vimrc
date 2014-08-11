""turn off backwards compatibility
set nocompatible

"vundle setup
filetype off

set rtp+=~/.vim/bundle/vundle/
"add powerline
set rtp+=~/.local/lib/python2.7/site-packages/powerline/bindings/vim/
call vundle#rc()
" Always show statusline
set laststatus=2

"Begin Vundle section"
"Keep Vundle itself up to date
Bundle 'gmarik/vundle' 
"vim scripts to maintain packages
"update vundle itself
Bundle 'L9'
Bundle 'matchit.zip'
Bundle 'NERD_tree-Project'
Bundle 'scrooloose/nerdcommenter.git'
Bundle 'repeat.vim'
Bundle 'surround.vim'
Bundle 'Raimondi/delimitMate.git'
"look into closeTags for html?
Bundle 'Tagbar'
Bundle 'othree/xml.vim'
Bundle 'Valloric/YouCompleteMe' 
"Python specific
Bundle 'klen/python-mode'
"Bundle 'davidhalter/jedi-vim'
Bundle 'ivanov/vim-ipython'
"git integration
Bundle 'tpope/vim-fugitive.git'
"javascript completion
Bundle 'wookiehangover/jshint.vim'
""Make sure these are loaded *AFTER* supertab is installed so supertab doesn't
"clobber the snippet completion
Bundle 'MarcWeber/vim-addon-mw-utils'
Bundle 'tomtom/tlib_vim'
Bundle 'garbas/vim-snipmate' 
" Optional:
Bundle 'honza/vim-snippets'
Bundle 'zeis/vim-kolor'

"make sure snipmate is bound properly
"imap <Tab> <Plug>snipMateNextOrTrigger

syntax on                    
filetype plugin indent on
highlight ExtraWhitespace ctermbg=red guibg=red

"let g:SuperTabDefaultCompletionType = '<C-X><C-O>'
let g:SuperTabDefaultCompletionType = 'context'

highlight Tabs ctermbg=blue ctermfg=black
"autocmd Syntax * syntax match Tabs '\t' containedin=all
match Tabs '\t'
highlight LineNr ctermbg=234
"highlight NonTab ctermbg=black
"autocmd Syntax * syntax match NonTab '\(^ *\)\@<=[^	].*'
set cmdheight=2
set number
set ruler
set laststatus=2

set background=dark
set hlsearch

"indentation options
set smartindent
set expandtab
set tabstop=4
set shiftwidth=4

"auto change to directory
set autochdir
"save folds on leaving, reopen them upon loading a file
"autocmd BufWinLeave * silent! mkview
"try to load view, but if not present, don't send errors
autocmd BufWinEnter * silent! loadview
                                                                 
set t_Co=256
colorscheme kolor
"make marks visible with selected colorscheme on terminals
"doesn't seem to work properly without autocommands??
autocmd BufWinEnter * highlight ShowMarksHLl ctermbg=white ctermfg=darkgreen 
autocmd BufWinEnter * highlight ShowMarksHLu ctermfg=red ctermbg=black
autocmd BufWinEnter * highlight ShowMarksHLo ctermfg=white ctermbg=blue

noremap <F3> :NERDTreeToggle<CR>
noremap <F7> :TagbarToggle<CR>
nnoremap <Leader>t :tabnew<CR>
nnoremap <space> za

"highlight normal characters except for tabs 
"show 80 column width with red bar
set cc=80


"disable rope-vim so jedi-vim will work properly
let g:pymode_rope_vim_completion = 0

""Broken
"match any indents which aren't a multiple of four spaces
"highlight non4space ctermbg=220
"match non4space '^\( \{4}\)* \{1,3}\([^ ]\)\@='
"intentionally cause eyestrain for lines exceeding 79 chars
"highlight longstrings ctermbg=red ctermfg=green
"match longstrings '\%>79v.\+'
"match whitespace at end of line adjacent to a word boundary
"match ExtraWhitespace /\S\@<=\s\+$/        
"set background to black for characters except for tabs and leading spaces
"highlight NonTab ctermbg=black
"match NonTab /\(^ *\)\@<=[^ ].*/
"syntax match NonTab '\(^ *\)\@<=[^ ].*'
"autocmd WinEnter * silent! call matchadd('nonTab', '\(^ *\)\@<=[^ ].*')
"autocmd BufWinEnter * silent! call matchadd('nonTab', '\(^ *\)\@<=[^ ].*')

"show tabs with a » symbol highlighted with a blue background
set list listchars=tab:»\ 
"highlight Tabs ctermbg=blue ctermfg=black
"2match Tabs /\t/
"autocmd BufWinEnter * silent! call matchadd('Tabs', '\t')
"autocmd WinEnter * silent! call matchadd('Tabs', '\t')
au BufRead,BufNewFile *.md set filetype=markdown

"PostgreSQL dbext config
"insanely broken table name completion
"let g:dbext_default_profile_pgsql = 'type=PGSQL:user=postgres:dbname=lisdata'
"let g:omni_sql_include_owner = '0'

"TODO: fallback gracefully for non 256 color terms
"TODO: Clean up configuration
if &term =~ "xterm\\|rxvt"
" use an orange cursor in insert mode
let &t_SI = "\<Esc>]12;grey\x7"
" use a red cursor otherwise
let &t_EI = "\<Esc>]12;orange\x7"
silent !echo -ne "\033]12;red\007"
    " reset cursor when vim exits
    autocmd VimLeave * silent !echo -ne "\033]112\007"
    " use \003]12;gray\007 for gnome-terminal
else  " use an orange cursor in insert mode
    let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]12;grey\x7\<Esc>\\"
    " use a red cursor otherwise
    let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]12;orange\x7\<Esc>\\"
    silent !printf '\033Ptmux;\033\033]12;orange\007\033\\'
"" reset cursor when vim exits
"" not necessary
" autocmd VimLeave * silent !echo -ne "\034]112\007"
" use \003]12;gray\007 for gnome-terminal
endif
