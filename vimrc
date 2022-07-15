" {{{ description
" pysnow530's neovim configuration.
"
" Maintainer:   pysnow530 <pysnow530@163.com>
" Inittime:     Apr 5, 2015
"
" neovim
" git clone git@github.com:pysnow530/dotvim.git ~/.config/nvim && nvim +PlugInstall
"
let mapleader = ","
let maplocalleader = '\'
" }}}

" {{{ config.environ
" let $PATH = '/usr/local/bin:/bin:/usr/bin:/usr/local/bin:/opt/local/bin'
" }}}

" {{{ config.ui
" https://github.com/ryanoasis/vim-devicons/issues/398
" syntax on  " this will effect nerdtree weired(icon with [])
set history=50
set showcmd
set hlsearch
set incsearch
set cursorline
set showmatch
set scrolloff=1
set nowrap
set foldtext=getline(v:foldstart)
set foldlevel=99  " don't fold on opened

set termguicolors
set guifont=SauceCodeProNerdFontCompleteM-Regular:h11,SauceCodeProNerdFontComplete-Regular:h11,*
set background=dark

" set cursorline
if exists('+colorcolumn') | set colorcolumn=100 | endif
set nu
if exists('+rnu') | set rnu | endif

set laststatus=2

fun! ToggleAllFolds() abort
    let closed = 0
    for ln in range(1, line('$'))
        if closed == 0 && foldclosed(ln) != -1
            let closed = 1
        endif
    endfor
    echo closed

    if closed == 1
        execute 'normal zR'
    else
        execute 'normal zM'
    endif
endf
nnoremap <S-TAB> :call ToggleAllFolds()<CR>
nnoremap <SPACE> za  " remap <TAB> will cause <CTRL-i> remapped
" }}}

" {{{ config.edit
set fileencodings=UTF-8
try
    set encoding=UTF-8
catch //
endtry
set tabstop=8
set softtabstop=4
set shiftwidth=4
set expandtab
set autoindent
set sessionoptions+=unix,slash
" set lazyredraw
set undofile
set noswapfile

set mouse=a

inoremap jk <ESC>
inoremap <c-u> <esc>vbUea
nnoremap <leader>b :b#<CR>
if isdirectory('.git') || isdirectory('../.git') || isdirectory('../../.git')
    set grepprg=git\ grep\ -n\ $*
else
    set grepprg=grep\ -n\ $*\ -r\ .\ --exclude\ '.*.swp'
endif
command! -nargs=+ NewGrep execute 'silent grep! <args>' | redraw! | copen 10
nnoremap <leader>g :NewGrep <c-r><c-w>
nnoremap <c-h> <c-w>h
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-l> <c-w>l
nnoremap <leader><leader> q:
nnoremap <leader>k :q<CR>
nnoremap <leader>j :w<CR>

nnoremap <leader>s :e ~/.vim/vimrc<CR>
nnoremap <leader>w :set invwrap<CR>
" }}}

" {{{ plugins.global
filetype off

call plug#begin()
Plug 'hynek/vim-python-pep8-indent'  " neovim also has indent problem
Plug 'mattn/emmet-vim'
Plug 'airblade/vim-gitgutter'

Plug 'majutsushi/tagbar'
Plug 'lvht/tagbar-markdown'
Plug 'tpope/vim-fugitive', { 'tag': 'v3.7' }
Plug 'cohama/lexima.vim'
Plug 'vim-scripts/argtextobj.vim'
Plug 'lifepillar/vim-solarized8'
Plug 'rust-lang/rust.vim'

" file management
call mkdir($HOME . "/.vim/files/info/", "p")
set viminfo='100,n$HOME/.vim/files/info/viminfo
Plug 'mhinz/vim-startify'
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
let g:NERDTreeQuitOnOpen = 0
nnoremap <leader>f :NERDTreeToggle<CR>
let NERDTreeIgnore = ['\~$', '\.class$', '\.pyc$']

let g:ctrlp_custom_ignore = 'node_modules\|DS_Store'
Plug 'ctrlpvim/ctrlp.vim'

Plug 'ryanoasis/vim-devicons'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'powerline/fonts', { 'do': './install.sh' }

let g:airline_powerline_fonts = 1

" set updatetime=500
" Plug 'obxhdx/vim-auto-highlight'  " this makes vim slow, refactor parallel

Plug 'habamax/vim-sendtoterm'
xmap <leader>r  <Plug>(SendToTerm)
nmap <leader>r  <Plug>(SendToTerm)
omap <leader>r  <Plug>(SendToTerm)
nmap <leader>rr <Plug>(SendToTermLine)
nmap <C-CR> <Plug>(SendToTermLine)

Plug 'godlygeek/tabular'

" Plug 'terryma/vim-multiple-cursors'  " deprecated
Plug 'mg979/vim-visual-multi', {'branch': 'master'}

Plug 'preservim/vim-markdown'

Plug 'tpope/vim-surround'

Plug 'dhruvasagar/vim-table-mode'

Plug 'dense-analysis/ale'
Plug 'neoclide/coc.nvim', {'branch': 'release'}

call plug#end()

" emmet-vim
let g:user_emmet_leader_key = '<leader>e'

" tagbar
let g:tagbar_type_go = {
    \ 'ctagstype' : 'go',
    \ 'kinds'     : [
        \ 'p:package',
        \ 'i:imports:1',
        \ 'c:constants',
        \ 'v:variables',
        \ 't:types',
        \ 'n:interfaces',
        \ 'w:fields',
        \ 'e:embedded',
        \ 'm:methods',
        \ 'r:constructor',
        \ 'f:functions'
    \ ],
    \ 'sro' : '.',
    \ 'kind2scope' : {
        \ 't' : 'ctype',
        \ 'n' : 'ntype'
    \ },
    \ 'scope2kind' : {
        \ 'ctype' : 't',
        \ 'ntype' : 'n'
    \ },
    \ 'ctagsbin'  : 'gotags',
    \ 'ctagsargs' : '-sort -silent'
\ }
let g:tagbar_autofocus = 1
nnoremap <leader>t :TagbarToggle<CR>

" vim-fugitive
nnoremap <leader>v :Git<CR>

" solarized8
colorscheme solarized8

set fillchars+=vert:\│
hi VertSplit guifg=Black guibg=NONE
set guioptions=egm

" vim-startify
function! StartifyEntryFormat()
    return 'WebDevIconsGetFileTypeSymbol(absolute_path) ." ". entry_path'
endfunction
" }}}

function! Map(expr1, expr2) abort
    return map(deepcopy(a:expr1), a:expr2)
endfunction

function! All(expr1, expr2) abort
    let result_list = Map(a:expr1, a:expr2)
    let result = 1
    for i in result_list
        let result = result && i
    endfor
    return result
endfunction

" {{{ commenter
nnoremap <expr> gc ToggleComment()
xnoremap <expr> gc ToggleComment()
nnoremap <expr> gcc ToggleComment() . '_'

function! ToggleComment(type='') abort
    if a:type == ''
        set opfunc=ToggleComment
        return 'g@'
    endif

    let comment_char = get({'vim': '"', 'javascript': '\/\/', 'rust': '\/\/'}, &ft, '#')

    let lines = getline("'[", "']")
    let commented = All(lines, {_, v -> v =~ '^\s*' . comment_char . ' '})

    " TODO: keep cursor position
    " TODO: compatible vim7
    if commented
        execute "'[,']" 's/\(\s*\)' . comment_char . ' /\1'
    else
        let nr_spaces = min(map(lines, {_, v -> strwidth(matchstr(v, '^\s*'))}))
        execute "'[,']" 's/^\(\s\{' . nr_spaces . '\}\)/\1' . comment_char . ' '
    endif
endfunction
" }}}

" {{{ plugins.sneak
fun! Sneak()
    let search = nr2char(getchar()) . nr2char(getchar())
    let @/ = search
    execute 'normal! n'
endfun

nnoremap s :call Sneak()<CR>
" }}}

" {{{ config.filetypes
filetype plugin indent on

augroup filetype_vim
    autocmd!
    autocmd FileType vim setlocal fdm=marker
    autocmd FileType vim nnoremap <buffer> <localleader>r :so %<CR>
augroup END

augroup filetype_shell
    autocmd!
    autocmd FileType sh nnoremap <buffer> <localleader>r :!sh %<CR>
    autocmd FileType sh vnoremap <buffer> <localleader>r :w !sh<CR>
    autocmd FileType sh nnoremap <buffer> <localleader>d :!sh -x %<CR>
augroup END

augroup filetype_php
    autocmd!
    autocmd FileType php nnoremap <buffer> <localleader>r :!php %<CR>
    autocmd FileType php vnoremap <buffer> <localleader>r :w !php<CR>
    command! -nargs=1 Phpdoc !open http://php.net/<args>
    autocmd FileType php setlocal keywordprg=:Phpdoc
augroup END

augroup filetype_c
    autocmd!
    autocmd FileType c nnoremap <buffer> <localleader>r :!gcc % && ./a.out<CR>
augroup END

augroup filetype_cpp
    autocmd!
    autocmd FileType cpp nnoremap <buffer> <localleader>r :!g++ % && ./a.out<CR>
augroup END

augroup filetype_html
    autocmd!
    autocmd FileType html,htmldjango setlocal tabstop=4
    autocmd FileType html,htmldjango setlocal softtabstop=4
    autocmd FileType html,htmldjango setlocal shiftwidth=4
    autocmd FileType html,htmldjango nnoremap <buffer> <localleader>r :!open %<CR>
    autocmd FileType html,htmldjango setlocal foldmethod=indent
    autocmd FileType htmldjango setlocal filetype=htmldjango.html
    autocmd FileType javascript iabbrev <buffer> clog console.log
augroup END

augroup filetype_javascript
    autocmd!
    autocmd FileType javascript setlocal tabstop=4
    autocmd FileType javascript setlocal softtabstop=4
    autocmd FileType javascript setlocal shiftwidth=4
    autocmd FileType javascript nnoremap <buffer> <localleader>r :!node %<CR>
    autocmd FileType javascript vnoremap <buffer> <localleader>r :w !node<CR>
    autocmd FileType javascript nnoremap <buffer> <localleader>i :!node<CR>
    autocmd FileType javascript iabbrev <buffer> clog console.log
augroup END

augroup filetype_python
    autocmd!
    autocmd FileType python setlocal fdm=indent
    autocmd FileType python nnoremap <buffer> <localleader>r :!python3 %<CR>
    autocmd FileType python vnoremap <buffer> <localleader>r :w !python3<CR>
    autocmd FileType python nnoremap <buffer> <localleader>i :!python3<CR>
    autocmd FileType python iabbrev <buffer> im import
    autocmd FileType python iabbrev <buffer> ifmain if __name__ == '__main__'
augroup END

augroup filetype_ruby
    autocmd!
    autocmd FileType ruby nnoremap <buffer> <localleader>r :!ruby %<CR>
    autocmd FileType ruby vnoremap <buffer> <localleader>r :w !ruby<CR>
    autocmd FileType ruby nnoremap <buffer> <localleader>s :!irb<CR>
augroup END

augroup filetype_makefile
    autocmd!
    autocmd FileType make setlocal shiftwidth=8
    autocmd FileType make setlocal noexpandtab
    autocmd FileType make setlocal tabstop=8
augroup END

augroup filetype_lua
    autocmd!
    autocmd FileType lua nnoremap <buffer> <localleader>r :!lua %<CR>
    autocmd FileType lua vnoremap <buffer> <localleader>r :w !lua<CR>
    autocmd FileType lua nnoremap <buffer> <localleader>i :!lua<CR>
augroup END

augroup filetype_cs
    autocmd!
    autocmd FileType cs nnoremap <buffer> <localleader>b :!csc.exe /out:%:r.exe %<CR>
    autocmd FileType cs nnoremap <buffer> <localleader>r :!%:r.exe<CR>
augroup END

augroup filetype_scheme
    autocmd!
    autocmd FileType scheme nnoremap <buffer> <localleader>r :!mzscheme %<CR>
    autocmd FileType scheme vnoremap <buffer> <localleader>r :w !mzscheme<CR>
augroup END

augroup filetype_dot
    autocmd!
    autocmd FileType dot nnoremap <buffer> <localleader>r :!dot -Tpng % >%:r.png && open %:r.png<CR>
    autocmd FileType dot nnoremap <buffer> <localleader>b :!dot -Tpng % >%:r.png<CR>
augroup END

augroup filetype_coffee
    autocmd!
    autocmd FileType coffee nnoremap <buffer> <localleader>b :!coffee -c %<CR>
    autocmd FileType coffee nnoremap <buffer> <localleader>r :!coffee %<CR>
augroup END

augroup filetype_sql
    autocmd!
    autocmd FileType sql nnoremap <buffer> <localleader>r :!mysql <%<CR>
    autocmd FileType sql vnoremap <buffer> <localleader>r :w !mysql<CR>
augroup END

augroup filetype_markdown
    autocmd!
    autocmd FileType markdown setlocal wrap
    autocmd BufNewFile,BufReadPost *.md,README set filetype=markdown
    autocmd FileType markdown vnoremap <buffer> <localleader>r :w !python3<CR>
augroup END

augroup filetype_go
    autocmd!
    autocmd FileType go setlocal shiftwidth=8
    autocmd FileType go setlocal tabstop=8
    autocmd FileType go setlocal softtabstop=8
    autocmd FileType go setlocal noexpandtab
    autocmd FileType go setlocal keywordprg=go\ doc
    autocmd FileType go nnoremap <buffer> <localleader>f :% !gofmt<CR>
    autocmd FileType go nnoremap <buffer> <localleader>b :make<CR>
    autocmd FileType go nnoremap <buffer> <localleader>r :!go run %<CR>
augroup END

augroup filetype_java
    autocmd!
    autocmd FileType java nnoremap <buffer> <localleader>b :!javac -Xlint:all %<CR>
    autocmd FileType java nnoremap <buffer> <localleader>r :!javac -Xlint:all % && java %:r<CR>
augroup END

augroup filetype_vue
    autocmd!
    autocmd FileType vue set tabstop=2
    autocmd FileType vue set softtabstop=2
    autocmd FileType vue set shiftwidth=2
augroup END

augroup filetype_perl
    autocmd!
    autocmd FileType perl nnoremap <buffer> <localleader>r :!perl %<CR>
    autocmd FileType perl vnoremap <buffer> <localleader>r :w !perl<CR>
augroup END

augroup filetype_yaml
    autocmd!
    autocmd FileType yaml setlocal tabstop=2
    autocmd FileType yaml setlocal softtabstop=2
    autocmd FileType yaml setlocal shiftwidth=2
augroup END

augroup filetype_lisp
    autocmd!
    autocmd FileType lisp nnoremap <buffer> <localleader>r :!sbcl --script %<CR>
    autocmd FileType lisp nnoremap <buffer> <localleader>i :!sbcl<CR>
augroup END

augroup filetype_haskell
    autocmd!
    autocmd FileType haskell nnoremap <buffer> <localleader>r :!stack runhaskell %<CR>
    autocmd FileType haskell nnoremap <buffer> <localleader>i :!stack ghci<CR>
augroup END

augroup filetype_rust
    autocmd!
    autocmd FileType rust nnoremap <buffer> <localleader>f :RustFmt<CR>
    autocmd FileType rust nnoremap <buffer> <localleader>r :RustRun<CR>
    autocmd FileType rust nnoremap <buffer> <localleader>t :RustTest<CR>
    autocmd FileType rust nnoremap <buffer> <localleader>b :!rustc %<CR>
augroup END

augroup filetype_asciidoc
    autocmd!
    autocmd FileType asciidoc nnoremap <buffer> <localleader>r :!asciidoctor -n -o /tmp/tmp.html % && open /tmp/tmp.html<CR>
augroup END
" }}}
