" {{{ description
" pysnow530's neovim configuration.
"
" Maintainer:   pysnow530 <pysnow530@163.com>
" Inittime:     Apr 5, 2015
"
" neovim
" git clone git@github.com:pysnow530/dotvim.git ~/.config/nvim && nvim +PlugInstall
" remote develop with neovim: https://neovide.dev/features.html
"
let mapleader = ","
let maplocalleader = '\'
" }}}

" {{{ config.environ
" let $PATH = '/usr/local/bin:/bin:/usr/bin:/usr/local/bin:/opt/local/bin'
" }}}

" {{{ config.ui
" https://github.com/ryanoasis/vim-devicons/issues/398
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
" set guifont=SauceCodeProNerdFontCompleteM-Regular:h11,SauceCodeProNerdFontComplete-Regular:h11,*
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
let $LANG='en_US.utf-8'
set tabstop=8
set softtabstop=4
set shiftwidth=4
set expandtab
set autoindent
set sessionoptions+=unix,slash
" set lazyredraw
set undofile
set noswapfile
set clipboard+=unnamedplus

let g:neovide_cursor_vfx_mode = "pixiedust"

set mouse=a

inoremap jk <ESC>
inoremap <c-u> <esc>vbUea
nnoremap <leader>b :b#<CR>
" neovim defaults to use `rg --vimgrep -uu `, ref :help grepprg
set grepprg=rg\ --vimgrep\ $*\ ~/projs/vsops\ ~/projs/vsops2-fe-cost\ ~/projs/api
command! -nargs=+ NewGrep execute 'silent grep! <args>' | redraw! | copen 10
nnoremap <leader>g :NewGrep <c-r><c-w>
nnoremap <c-h> <c-w>h
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-l> <c-w>l
tnoremap <c-h> <c-\><c-n><c-w>h
tnoremap <c-j> <c-\><c-n><c-w>j
tnoremap <c-k> <c-\><c-n><c-w>k
tnoremap <c-l> <c-\><c-n><c-w>l
nnoremap <leader><leader> q:
nnoremap <leader>k :q<CR>
nnoremap <leader>j :w<CR>

if has('nvim')
    nnoremap <leader>s :e ~/.config/nvim/vimrc<CR>
else
    nnoremap <leader>s :e ~/.vim/vimrc<CR>
endif
" }}}

" {{{ plugins.global
filetype off

call plug#begin()
Plug 'hynek/vim-python-pep8-indent'  " neovim also has indent problem
Plug 'airblade/vim-gitgutter'
Plug 'lvht/tagbar-markdown'
Plug 'tpope/vim-fugitive', { 'tag': 'v3.7' }
Plug 'cohama/lexima.vim'
Plug 'vim-scripts/argtextobj.vim'

" file management
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
let g:NERDTreeQuitOnOpen = 0
nnoremap <leader>f :NERDTreeToggle<CR>
let NERDTreeIgnore = ['\~$', '\.pyc$']

Plug 'habamax/vim-sendtoterm'
xmap <leader>r  <Plug>(SendToTerm)
nmap <leader>r  <Plug>(SendToTerm)
omap <leader>r  <Plug>(SendToTerm)
nmap <leader>rr <Plug>(SendToTermLine)
nmap <C-CR> <Plug>(SendToTermLine)

Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'

Plug 'lifepillar/vim-solarized8'

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

Plug 'kien/ctrlp.vim'

Plug 'chrisbra/NrrwRgn'

Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx'

Plug 'justinmk/vim-sneak'

call plug#end()

" emmet-vim
let g:user_emmet_leader_key = '<leader>e'

set fillchars+=vert:\│
set guioptions=egm

" solarized8
colorscheme solarized8
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
    autocmd FileType javascript setlocal tabstop=2
    autocmd FileType javascript setlocal softtabstop=2
    autocmd FileType javascript setlocal shiftwidth=2
    autocmd FileType javascript nnoremap <buffer> <localleader>r :!node %<CR>
    autocmd FileType javascript vnoremap <buffer> <localleader>r :w !node<CR>
    autocmd FileType javascript nnoremap <buffer> <localleader>i :!node<CR>
    autocmd FileType javascript iabbrev <buffer> clog console.log
augroup END

augroup filetype_python
    autocmd!
    autocmd FileType python setlocal fdm=indent
    autocmd FileType python nnoremap <buffer> <localleader>r :!python3 %<CR>
    " TODO: refactor command line output strategy
    autocmd FileType python vnoremap <buffer> <localleader>r :w !python3 >/tmp/vim-python.out && cat /tmp/vim-python.out<CR>
    autocmd FileType python nnoremap <buffer> <localleader>i :!python3<CR>
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

augroup filetype_dot
    autocmd!
    autocmd FileType dot nnoremap <buffer> <localleader>r :!dot -Tpng % >%:r.png && open %:r.png<CR>
    autocmd FileType dot nnoremap <buffer> <localleader>b :!dot -Tpng % >%:r.png<CR>
augroup END

augroup filetype_markdown
    autocmd!
    autocmd FileType markdown setlocal wrap
    autocmd BufNewFile,BufReadPost *.md,README set filetype=markdown
    autocmd FileType markdown vnoremap <buffer> <localleader>r :w !sh<CR>
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

augroup filetype_yaml
    autocmd!
    autocmd FileType yaml setlocal tabstop=2
    autocmd FileType yaml setlocal softtabstop=2
    autocmd FileType yaml setlocal shiftwidth=2
augroup END

augroup filetype_haskell
    autocmd!
    autocmd FileType haskell nnoremap <buffer> <localleader>r :!stack runhaskell %<CR>
    autocmd FileType haskell nnoremap <buffer> <localleader>i :!stack ghci<CR>
augroup END

function! GenerateRustScript()
    call system('rm -f ' . expand('%:t:r') . ' ' . expand('__%:t'))

    let has_fn_main = 0
    let lines = getline('^', '$')
    for line in lines
        if line =~ 'fn\s\+main'
            let has_fn_main = 1
            break
        endif
    endfor
    if has_fn_main == 0
        let expand_file = '__' . expand('%:t')
        let lines = ['fn main() {'] + lines + ['}']
        call writefile(lines, expand_file)
        return expand_file
    else
        return expand('%')
    endif
endfunction

function! RunRustScript()
    let script_file = GenerateRustScript()
    if script_file == expand('%')
        execute '!rustc % && ./%:t:r'
    else
        execute '!rustc -o %:t:r __%:t && ./%:t:r'
    endif
endfunction

function! BuildRustScript()
    let script_file = GenerateRustScript()
    if script_file == expand('%')
        execute '!rustc -o %:t:r.mac % && rustc --target x86_64-unknown-linux-musl --codegen linker=/usr/local/bin/x86_64-linux-musl-gcc -o %:t:r.linux %'
    else
        execute '!rustc -o %:t:r.mac __%:t && rustc --target x86_64-unknown-linux-musl --codegen linker=/usr/local/bin/x86_64-linux-musl-gcc -o %:t:r.linux __%:t'
    endif
endfunction

augroup filetype_rust
    autocmd!
    autocmd FileType rust nnoremap <buffer> <localleader>f :RustFmt<CR>
    autocmd FileType rust nnoremap <buffer> <localleader>r :call RunRustScript()<CR>
    autocmd FileType rust nnoremap <buffer> <localleader>t :RustTest<CR>
    autocmd FileType rust nnoremap <buffer> <localleader>b :call BuildRustScript()<CR>
    command! -nargs=1 Rustdoc !open https://doc.rust-lang.org/std/index.html?search=<args>
    autocmd FileType rust setlocal keywordprg=:Rustdoc
augroup END

augroup filetype_j
    autocmd!
    autocmd FileType j nnoremap <buffer> <localleader>r :!jconsole %<CR>
    autocmd FileType j vnoremap <buffer> <localleader>r :w !jconsole<CR>
    autocmd FileType j nnoremap <buffer> <localleader>i :!jconsole<CR>
augroup END

augroup filetype_cs
    autocmd!
    autocmd FileType cs nnoremap <buffer> <localleader>r :!cd %:h && csc % && mono %:r.exe<CR>
    autocmd FileType cs iabbrev <buffer> log Debug.Log
augroup END

augroup filetype_dart
    autocmd!
    autocmd FileType dart setlocal tabstop=2
    autocmd FileType dart setlocal softtabstop=2
    autocmd FileType dart setlocal shiftwidth=2
    autocmd FileType dart nnoremap <buffer> <localleader>r :!dart %<CR>
    command! -nargs=1 FlutterDoc !open https://api.flutter.dev/flutter/search.html?q=<args>
    autocmd FileType dart setlocal keywordprg=:FlutterDoc
augroup END
" }}}
