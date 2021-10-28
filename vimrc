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
let $PATH = '/usr/local/bin:/bin:/usr/bin:/usr/local/bin:/opt/local/bin'
" }}}

" {{{ plugins.requirements
if !has('python3')
    execute '!echo "vim --enable-python3interp was required"'
    execute 'quit'
endif

py3 << EOF
import os
from importlib import reload

if os.path.dirname(os.getenv('MYVIMRC')) in sys.path:
    sys.path.remove(os.path.dirname(os.getenv('MYVIMRC')))
sys.path.insert(0, os.path.dirname(os.getenv('MYVIMRC')))
EOF

" }}}

" {{{ config.ui
syntax on
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
set background=dark
colorscheme desert

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
nnoremap <S-TAB> :call ToggleAllFolds()<cr>
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
nnoremap <leader>b :b#<cr>
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
nnoremap <leader>k :q<cr>
nnoremap <leader>j :w<cr>

nnoremap <leader>s :e ~/.vim/vimrc<cr>
nnoremap <leader>w :set invwrap<cr>
" }}}

" {{{ plugins.global
filetype off

call plug#begin()
Plug 'hynek/vim-python-pep8-indent'  " neovim also has indent problem
Plug 'mattn/emmet-vim'
Plug 'airblade/vim-gitgutter'
Plug 'scrooloose/nerdtree'
Plug 'majutsushi/tagbar'
Plug 'lvht/tagbar-markdown'
Plug 'tpope/vim-fugitive'
Plug 'cohama/lexima.vim'
Plug 'vim-scripts/argtextobj.vim'
call plug#end()

" emmet-vim
let g:user_emmet_leader_key = '<leader>e'

" nerdtree
let g:NERDTreeQuitOnOpen = 0
nnoremap <leader>n :NERDTreeToggle<cr>
let NERDTreeIgnore = ['\~$', '\.class$', '\.pyc$']

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
nnoremap <leader>t :TagbarToggle<cr>

" vim-fugitive
nnoremap <leader>v :Gstatus<cr>

" }}}

" {{{ plugins.commenter
py3 import plugins.commenter; reload(plugins.commenter)

fun! ToggleBlockComment(type) abort
    if a:type == ''
        set opfunc=ToggleBlockComment
        return 'g@'
    endif

    py3 plugins.commenter.toggle_block_comment()
endf

nnoremap <expr> gc ToggleBlockComment('')
xnoremap <expr> gc ToggleBlockComment('')
nnoremap <expr> gcc ToggleBlockComment('') . '_'
" }}}

" {{{ plugins.tabular
py3 import plugins.tabular; reload(plugins.tabular)

fun! Tabular(sep, start, end) abort
    py3 plugins.tabular.tabular()  # a:sep, a:start, a:end
endf

command -range -nargs=1 Tab :call Tabular(<q-args>, <line1>, <line2>)
" }}}

" {{{ plugins.ctrlp
py3 import plugins.ctrlp; reload(plugins.ctrlp)

nnoremap <c-p> :py3 plugins.ctrlp.ctrlp(True)<cr>

augroup filetype_ctrlp
    autocmd!
    " TODO: fix cannot delete old input after switch to normal mode and back
    autocmd FileType ctrlp inoremap <buffer> <c-j> <c-o>j
    autocmd FileType ctrlp inoremap <buffer> <c-k> <c-o>k
    autocmd FileType ctrlp inoremap <buffer> <c-c> <esc>:bdelete!<cr>
    autocmd FileType ctrlp inoremap <buffer> <cr> <esc>:py3 plugins.ctrlp.edit()<cr>
    autocmd FileType ctrlp autocmd TextChangedI <buffer=abuf> :py3 plugins.ctrlp.syntax(); plugins.ctrlp.ctrlp(False)
augroup END
" }}}

" {{{ plugins.surrounder
py3 import plugins.surrounder; reload(plugins.surrounder)

fun! Surround(type) abort
    if a:type == ''
        set opfunc=Surround
        return 'g@'
    endif

    py3 plugins.surrounder.surround()
endf

nnoremap <expr> ys Surround('')
nnoremap ds :py3 plugins.surrounder.unsurround()<cr>
nnoremap cs :py3 plugins.surrounder.resurround()<cr>
" }}}

" {{{ plugins.sneak
fun! Sneak()
    let search = nr2char(getchar()) . nr2char(getchar())
    let @/ = search
    execute 'normal! n'
endfun

nnoremap s :call Sneak()<cr>
" }}}

" {{{ config.filetypes
filetype plugin indent on

augroup filetype_vim
    autocmd!
    autocmd FileType vim setlocal fdm=marker
    autocmd FileType vim nnoremap <buffer> <localleader>r :so %<cr>
augroup END

augroup filetype_shell
    autocmd!
    autocmd FileType sh nnoremap <buffer> <localleader>r :!sh %<cr>
    autocmd FileType sh vnoremap <buffer> <localleader>r :w !sh<cr>
    autocmd FileType sh nnoremap <buffer> <localleader>d :!sh -x %<cr>
augroup END

augroup filetype_php
    autocmd!
    autocmd FileType php nnoremap <buffer> <localleader>r :!php %<cr>
    autocmd FileType php vnoremap <buffer> <localleader>r :w !php<cr>
    command! -nargs=1 Phpdoc !open http://php.net/<args>
    autocmd FileType php setlocal keywordprg=:Phpdoc
augroup END

augroup filetype_c
    autocmd!
    autocmd FileType c nnoremap <buffer> <localleader>r :!gcc % && ./a.out<cr>
augroup END

augroup filetype_cpp
    autocmd!
    autocmd FileType cpp nnoremap <buffer> <localleader>r :!g++ % && ./a.out<cr>
augroup END

augroup filetype_html
    autocmd!
    autocmd FileType html,htmldjango setlocal tabstop=4
    autocmd FileType html,htmldjango setlocal softtabstop=4
    autocmd FileType html,htmldjango setlocal shiftwidth=4
    autocmd FileType html,htmldjango nnoremap <buffer> <localleader>r :!open %<cr>
    autocmd FileType html,htmldjango setlocal foldmethod=indent
    autocmd FileType htmldjango setlocal filetype=htmldjango.html
    autocmd FileType javascript iabbrev <buffer> clog console.log
augroup END

augroup filetype_javascript
    autocmd!
    autocmd FileType javascript setlocal tabstop=4
    autocmd FileType javascript setlocal softtabstop=4
    autocmd FileType javascript setlocal shiftwidth=4
    autocmd FileType javascript nnoremap <buffer> <localleader>r :!node %<cr>
    autocmd FileType javascript vnoremap <buffer> <localleader>r :w !node<cr>
    autocmd FileType javascript nnoremap <buffer> <localleader>i :!node<cr>
    autocmd FileType javascript iabbrev <buffer> clog console.log
augroup END

augroup filetype_python
    autocmd!
    autocmd FileType python setlocal fdm=indent
    autocmd FileType python nnoremap <buffer> <localleader>r :!python3 %<cr>
    autocmd FileType python vnoremap <buffer> <localleader>r :w !python3<cr>
    autocmd FileType python nnoremap <buffer> <localleader>i :!python3<cr>
    autocmd FileType python iabbrev <buffer> im import
    autocmd FileType python iabbrev <buffer> ifmain if __name__ == '__main__'
augroup END

augroup filetype_ruby
    autocmd!
    autocmd FileType ruby nnoremap <buffer> <localleader>r :!ruby %<cr>
    autocmd FileType ruby vnoremap <buffer> <localleader>r :w !ruby<cr>
    autocmd FileType ruby nnoremap <buffer> <localleader>s :!irb<cr>
augroup END

augroup filetype_makefile
    autocmd!
    autocmd FileType make setlocal shiftwidth=8
    autocmd FileType make setlocal noexpandtab
    autocmd FileType make setlocal tabstop=8
augroup END

augroup filetype_lua
    autocmd!
    autocmd FileType lua nnoremap <buffer> <localleader>r :!lua %<cr>
    autocmd FileType lua vnoremap <buffer> <localleader>r :w !lua<cr>
    autocmd FileType lua nnoremap <buffer> <localleader>i :!lua<cr>
augroup END

augroup filetype_cs
    autocmd!
    autocmd FileType cs nnoremap <buffer> <localleader>b :!csc.exe /out:%:r.exe %<cr>
    autocmd FileType cs nnoremap <buffer> <localleader>r :!%:r.exe<cr>
augroup END

augroup filetype_scheme
    autocmd!
    autocmd FileType scheme nnoremap <buffer> <localleader>r :!mzscheme %<cr>
    autocmd FileType scheme vnoremap <buffer> <localleader>r :w !mzscheme<cr>
augroup END

augroup filetype_dot
    autocmd!
    autocmd FileType dot nnoremap <buffer> <localleader>r :!dot -Tpng % >%:r.png && open %:r.png<cr>
    autocmd FileType dot nnoremap <buffer> <localleader>b :!dot -Tpng % >%:r.png<cr>
augroup END

augroup filetype_coffee
    autocmd!
    autocmd FileType coffee nnoremap <buffer> <localleader>b :!coffee -c %<cr>
    autocmd FileType coffee nnoremap <buffer> <localleader>r :!coffee %<cr>
augroup END

augroup filetype_sql
    autocmd!
    autocmd FileType sql nnoremap <buffer> <localleader>r :!mysql <%<cr>
    autocmd FileType sql vnoremap <buffer> <localleader>r :w !mysql<cr>
augroup END

augroup filetype_markdown
    autocmd!
    autocmd FileType markdown setlocal wrap
    autocmd BufNewFile,BufReadPost *.md,README set filetype=markdown
    autocmd FileType markdown vnoremap <buffer> <localleader>r :w !python3<cr>
augroup END

augroup filetype_go
    autocmd!
    autocmd FileType go setlocal shiftwidth=8
    autocmd FileType go setlocal tabstop=8
    autocmd FileType go setlocal softtabstop=8
    autocmd FileType go setlocal noexpandtab
    autocmd FileType go setlocal keywordprg=go\ doc
    autocmd FileType go nnoremap <buffer> <localleader>f :% !gofmt<cr>
    autocmd FileType go nnoremap <buffer> <localleader>b :make<cr>
    autocmd FileType go nnoremap <buffer> <localleader>r :!go run %<cr>
augroup END

augroup filetype_java
    autocmd!
    autocmd FileType java nnoremap <buffer> <localleader>b :!javac -Xlint:all %<cr>
    autocmd FileType java nnoremap <buffer> <localleader>r :!javac -Xlint:all % && java %:r<cr>
augroup END

augroup filetype_vue
    autocmd!
    autocmd FileType vue set tabstop=2
    autocmd FileType vue set softtabstop=2
    autocmd FileType vue set shiftwidth=2
augroup END

augroup filetype_perl
    autocmd!
    autocmd FileType perl nnoremap <buffer> <localleader>r :!perl %<cr>
    autocmd FileType perl vnoremap <buffer> <localleader>r :w !perl<cr>
augroup END

augroup filetype_yaml
    autocmd!
    autocmd FileType yaml setlocal tabstop=2
    autocmd FileType yaml setlocal softtabstop=2
    autocmd FileType yaml setlocal shiftwidth=2
augroup END

augroup filetype_lisp
    autocmd!
    autocmd FileType lisp nnoremap <buffer> <localleader>r :!sbcl --script %<cr>
    autocmd FileType lisp nnoremap <buffer> <localleader>i :!sbcl<cr>
augroup END

augroup filetype_haskell
    autocmd!
    autocmd FileType haskell nnoremap <buffer> <localleader>r :!stack runhaskell %<cr>
    autocmd FileType haskell nnoremap <buffer> <localleader>i :!stack ghci<cr>
augroup END
" }}}
