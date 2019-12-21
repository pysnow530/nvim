" {{{ description
" pysnow530's vimrc file.
"
" Maintainer:   pysnow530 <pysnow530@163.com>
" Inittime:     Apr 5, 2015
"
" vim
" ln -s this_repo_path ~/.vim && vim +PlugInstall
"
" neovim
" ln -s this_repo_path ~/.config/nvim && nvim +PlugInstall
"
" Q: Why not vim8 packages?
" A: Packages will stuck in some plugins.
"
" Q: Why not SPACE for leader?
" A: Space will delay in edit mode.
"
let mapleader = ","
let maplocalleader = '\'
" }}}

" {{{ view
syntax on
set history=50
set showcmd
set hlsearch
set incsearch
set guifont=SauceCodeProNerdFontCompleteM-Regular:h14
set showmatch
set scrolloff=1
set nowrap
set foldtext=getline(v:foldstart)

set cursorline
if exists('+colorcolumn') | set colorcolumn=79 | endif
set nu
if exists('+rnu') | set rnu | endif

fun! StatusLineWrapper() abort
    if exists('*bufferline#refresh_status')
        return '%{bufferline#refresh_status()}' .
                    \ bufferline#get_status_string() . '%=%y %=%P '
    else
        return '%f %=%y %=%P '
    endif
endf

set statusline=%!StatusLineWrapper()
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
        exe 'normal zR'
    else
        exe 'normal zM'
    endif
endf
nnoremap <TAB> za
nnoremap <S-TAB> :call ToggleAllFolds()<cr>
" }}}

" {{{ edit
set fileencodings=utf-8,ucs-bom,cp936,gb18030,big5,euc-jp,euc-kr,latin1
try
    set encoding=utf-8
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

set wildignore+=*.class,*.pyc

inoremap jk <ESC>
inoremap <c-u> <esc>vbUea
nnoremap <leader>b :b#<cr>
nnoremap <leader>s :e ~/Projects/dotvim/main.vim<cr>
if isdirectory('.git') || isdirectory('../.git') || isdirectory('../../.git')
    set grepprg=git\ grep\ -n\ $*
else
    set grepprg=grep\ -n\ $*\ -r\ .\ --exclude\ '.*.swp'
endif
command! -nargs=+ NewGrep execute 'silent grep! <args>' | redraw! | copen 10
nnoremap <leader>g :NewGrep <cword>
nnoremap <c-h> <c-w>h
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-l> <c-w>l
nnoremap <leader>k :q<cr>
nnoremap <leader><leader> q:
nnoremap <leader>j :w<cr>

nnoremap <leader>w :set invwrap<cr>
" }}}

" {{{ plugins
filetype off

call plug#begin()
" Plug 'VundleVim/Vundle.vim'
Plug 'msanders/snipmate.vim'
Plug 'hynek/vim-python-pep8-indent'  " neovim默认的indent也是有问题的
Plug 'mattn/emmet-vim'
Plug 'airblade/vim-gitgutter'
Plug 'scrooloose/nerdtree'
Plug 'majutsushi/tagbar'
Plug 'lvht/tagbar-markdown'
Plug 'pysnow530/snipmate-snippets'
Plug 'tomtom/tcomment_vim'
" Plug 'christoomey/vim-sort-motion'
Plug 'tpope/vim-surround'
Plug 'altercation/vim-colors-solarized'
Plug 'ap/vim-css-color'
" Plug 'kchmck/vim-coffee-script'
Plug 'tpope/vim-fugitive'
Plug 'godlygeek/tabular'
" Plug 'nvie/vim-flake8'
Plug 'cohama/lexima.vim'
" Plug 'bling/vim-bufferline'
" Plug 'Shougo/neocomplete.vim'

" Plug 'Shougo/deoplete.nvim'
" if has('nvim')
"   Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
" else
"   Plug 'Shougo/deoplete.nvim'
"   Plug 'roxma/nvim-yarp'
"   Plug 'roxma/vim-hug-neovim-rpc'
" endif
" let g:deoplete#enable_at_startup = 1

Plug 'udalov/kotlin-vim'
" Plug 'pysnow530/rfc.vim'
Plug 'vim-scripts/argtextobj.vim'
Plug 'ctrlpvim/ctrlp.vim'
" Plug 'pysnow530/nginx.vim'
" Plug 'fatih/vim-go'
Plug 'justinmk/vim-sneak'
Plug 'rhysd/clever-f.vim'
" Plug 'Valloric/YouCompleteMe'
" Plug 'wakatime/vim-wakatime'
" Plug 'ledger/vim-ledger'
" Plug 'bounceme/restclient.vim'
" Plug 'jceb/vim-orgmode'
" Plug 'maksbotan/vim-orgmode', {'branch': 'add-clocking'}
" Plug 'diepm/vim-rest-console'
" Plug 'sharat87/roast.vim'
" Plug 'baverman/vial'
" Plug 'baverman/vial-http'
" Plug 'vim-scripts/vim-http-client'
Plug 'aquach/vim-http-client'
Plug 'posva/vim-vue'
" Plug 'morhetz/gruvbox'
Plug 'dart-lang/dart-vim-plugin'
" Plug 'numirias/semshi', {'do': ':UpdateRemotePlugins'}
" Plug 'davidhalter/jedi-vim'
" Plug 'philip-karlsson/bolt.nvim', { 'do': ':UpdateRemotePlugins' }
" Plug 'airodactyl/neovim-ranger'

" Plug 'xolox/vim-misc'
" Plug 'xolox/vim-easytags'  " 太慢了，卡死编辑器

" Plug 'jsfaint/gen_tags.vim'

" Plug 'vim-airline/vim-airline'
" Plug 'vim-airline/vim-airline-themes'

" Plug 'ryanoasis/vim-devicons'
" Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }

Plug 'masukomi/vim-markdown-folding'

" Plug 'liuchengxu/space-vim-theme'

Plug 'posva/vim-vue'

" Plug 'vim-syntastic/syntastic'
" let g:syntastic_always_populate_loc_list = 1
" let g:syntastic_auto_loc_list = 1
" let g:syntastic_check_on_open = 0
" let g:syntastic_check_on_wq = 0
" let g:syntastic_python_checkers = ['pylint']
" let g:syntastic_python_pylint_args = "--rcfile=.pylintrc"
" let g:syntastic_javascript_checkers = ['eslint']

" Plug 'neovim/nvim-lsp'  " 开启有异常 2019-11-23

" Use release branch (Recommend)
Plug 'neoclide/coc.nvim', {'branch': 'release'}
let g:coc_global_extensions = [
            \ 'coc-python', 'coc-json', 'coc-go', 'coc-tsserver', 'coc-phpls',
            \ 'coc-vetur']

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" use `:OR` for organize import of current buffer
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

call plug#end()

" snipmate.vim
let g:snips_author = 'jianming.wu'

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

" vim-colors-solarized
set background=dark
colorscheme solarized
" highlight VertSplit ctermbg=NONE guibg=NONE

" vim-fugitive
nnoremap <leader>v :Gstatus<cr>

" vim-bufferline
let g:bufferline_echo = 0

" Shougo/neocomplete.vim
if v:version >= 703 && (has('lua') || has('nvim'))
    let g:neocomplete#enable_at_startup = 1
endif

" Shougo/deoplete.nvim

" kien/ctrlp.vim
let g:ctrlp_use_caching = 1
let g:ctrlp_clear_cache_on_exit = 0
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/](\.git|\.hg|\.svn|node_modules)$',
  \ 'file': '\v\.(exe|so|dll)$',
  \ 'link': 'SOME_BAD_SYMBOLIC_LINKS',
  \ }

" Valloric/YouCompleteMe
" let g:ycm_key_list_select_completion = ['<c-n>', '<Down>']
" let g:ycm_key_list_previous_completion = ['<c-p>', '<Up>']

" jceb/vim-orgmode
let org_agenda_files = ['~/Projects/mynote/todos/life-todo.org', '~/Projects/mynote/todos/work-todo.org']

" xolox/vim-easytags
" let g:easytags_async = 1

" vim-airline/vim-airline
" let g:airline#extensions#tabline#enabled = 1
" let g:airline#extensions#tabline#left_sep = ''
" let g:airline#extensions#tabline#left_alt_sep = ''
" let g:airline#extensions#tabline#right_sep = ''
" let g:airline#extensions#tabline#right_alt_sep = ''
" let g:airline#extensions#tabline#formatter = 'unique_tail'
" let g:airline#extensions#tabline#buffer_nr_show = 1
"
" if !exists('g:airline_symbols')
" let g:airline_symbols = {}
" endif

" powerline symbols
" let g:airline_left_sep = ''
" let g:airline_left_alt_sep = ''
" let g:airline_right_sep = ''
" let g:airline_right_alt_sep = ''
" let g:airline_symbols.branch = ''
" let g:airline_symbols.readonly = ''
" let g:airline_symbols.linenr = '☰'
" let g:airline_symbols.maxlinenr = ''
" let g:airline_symbols.dirty='⚡'

" vim-devicons
" enable folder/directory glyph flag (disabled by default with 0)
" let g:WebDevIconsUnicodeDecorateFolderNodes = 1

" python-mode/python-mode
" let g:pymode_python = 'python3'

" enable open and close folder/directory glyph flags (disabled by default with 0)
" let g:DevIconsEnableFoldersOpenClose = 1

" }}}

" {{{ filetypes
set hidden  " required by vial-http
filetype plugin indent on

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
    autocmd FileType html,htmldjango setlocal tabstop=2
    autocmd FileType html,htmldjango setlocal softtabstop=2
    autocmd FileType html,htmldjango setlocal shiftwidth=2
    autocmd FileType html,htmldjango nnoremap <buffer> <localleader>r :!open %<cr>
    autocmd FileType html,htmldjango setlocal foldmethod=indent
    autocmd FileType htmldjango setlocal filetype=htmldjango.html
augroup END

augroup filetype_javascript
    autocmd!
    autocmd FileType javascript setlocal tabstop=2
    autocmd FileType javascript setlocal softtabstop=2
    autocmd FileType javascript setlocal shiftwidth=2
    autocmd FileType javascript nnoremap <buffer> <localleader>r :!node %<cr>
    autocmd FileType javascript vnoremap <buffer> <localleader>r :w !node<cr>
    autocmd FileType javascript nnoremap <buffer> <localleader>i :!node<cr>
augroup END

augroup filetype_dart
    autocmd!
    autocmd FileType dart setlocal tabstop=2
    autocmd FileType dart setlocal softtabstop=2
    autocmd FileType dart setlocal shiftwidth=2
    autocmd FileType dart nnoremap <buffer> <localleader>r :!dart %<cr>
augroup END

function! GetGitRootDir()
    let curr_path = '%:p:h'

    for i in range(10)
        if isdirectory(expand(curr_path) . '/.git')
            return expand(curr_path)
        endif

        let curr_path = curr_path . ':h'
    endfor

    return ''
endfunction

function! RunWithPython(exe_cmd_tmpl)
    let root_dir = GetGitRootDir()
    if (root_dir != '' && filereadable(root_dir . '/.env/bin/python'))
        let python_path = root_dir . '/.env/bin/python'
    elseif (root_dir != '' && filereadable(root_dir . '/.venv/bin/python'))
        let python_path = root_dir . '/.venv/bin/python'
    else
        let python_path = 'python3'
    endif

    let exec_cmd = substitute(a:exe_cmd_tmpl, '{python_path}', python_path, '')
    exec exec_cmd
endfunction

augroup filetype_python
    autocmd!
    autocmd FileType python setlocal fdm=indent
    autocmd FileType python nnoremap <buffer> <localleader>r :!python3 %<cr>
    autocmd FileType python vnoremap <buffer> <localleader>r :!w python3<cr>
    autocmd FileType python nnoremap <buffer> <localleader>i :!python3<cr>
augroup END

augroup filetype_ruby
    autocmd!
    autocmd FileType ruby nnoremap <buffer> <localleader>r :!ruby %<cr>
    autocmd FileType ruby vnoremap <buffer> <localleader>r :w !ruby<cr>
    autocmd FileType ruby nnoremap <buffer> <localleader>s :!irb<cr>
augroup END

augroup filetype_vim
    autocmd!
    autocmd FileType vim setlocal fdm=marker
    autocmd FileType vim nnoremap <buffer> <localleader>r :so %<cr>
    command! -nargs=1 Vimdoc help <args>
    autocmd FileType vim setlocal keywordprg=:Vimdoc
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
augroup END

augroup filetype_snippet
    autocmd!
    autocmd FileType snippet setlocal shiftwidth=8
    autocmd FileType snippet setlocal tabstop=8
    autocmd FileType snippet setlocal softtabstop=8
    autocmd BufWritePost *.snippets call ReloadSnippets(expand('%:t:r'))
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

augroup filetype_wxml
    autocmd!
    autocmd BufNewFile,BufReadPost *.wxml set filetype=xml
augroup END

augroup filetype_wxss
    autocmd!
    autocmd BufNewFile,BufReadPost *.wxss set filetype=css
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

augroup filetype_ledger
    autocmd!
    autocmd FileType ledger nnoremap <buffer> <localleader>r :!ledger -f % balance<cr>
augroup END

augroup filetype_restclient
    autocmd!
    " autocmd BufNewFile,BufReadPost *.http set filetype=restclient
    autocmd FileType vial-http nnoremap <buffer> <cr> :VialHttp<cr>
augroup END

augroup filetype_http
    autocmd!
    autocmd BufNewFile,BufReadPost *.http set filetype=http
    autocmd FileType http syntax keyword Keyword GET POST DELETE PUT
    autocmd FileType http syntax match Comment /#.*/
    autocmd FileType http syntax match String +http://.*+
    autocmd FileType http syntax match Identifier /^[A-Za-z-]\+:/
    autocmd FileType http syntax region String start=/"/ end=/"/
    autocmd FileType http nnoremap <buffer> <localleader>r :HTTPClientDoRequest<cr>
augroup END

augroup filetype_org
    autocmd!
    autocmd FileType org nnoremap <buffer> <localleader>t :OrgAgendaWeek<cr>
augroup END

let g:rfc_folding = 1

function! s:GuessPipeFiletype()
    " json
    let l:line_first = getline(1)
    let l:line_last = getline('$')
    if l:line_first[0] == '{' && l:line_last[len(l:line_last)-1] == '}'
                \ || l:line_first[0] == '[' && l:line_last[len(l:line_last)-1] == ']'
        return 'json'
    endif

    " sql
    for l:lnum in range(line('.'), line('$'))
        let l:line = getline(l:lnum)
        if (l:line =~? '\<create database\>'
                    \ || l:line =~? '\<create table\>'
                    \ || l:line =~? '\<insert into\>'
                    \ || l:line =~? '\<delete from\>'
                    \ || l:line =~? '\<alter table\>')
            return 'sql'
        endif
    endfor

    return 'sh'
endfunction

fun! s:SetPipeFiletype() abort
    let l:from_pipe = (argc() == 0) && ((line('.') > 1) || (getline(1) != ''))
    if l:from_pipe
        let l:filetype = s:GuessPipeFiletype()
        execute 'set filetype=' . l:filetype

        if l:filetype == 'json' && line('$') == 1
            exe "1!python -c 'import json, sys; reload(sys); " .
                        \ "sys.setdefaultencoding(\"utf8\"); " .
                        \ "print json.dumps(json.load(sys.stdin), ensure_ascii=False, indent=4)'"
        endif
    endif
endf

fun! s:FindFile() abort
    if argc() == 1 && !filereadable(argv()[0]) && argv()[0][0] == '/' && len(split(argv()[0], '/')) > 0 && !isdirectory('/'.split(argv()[0], '/')[0])
        execute 'NewGrep' '"'.argv()[0][1:].'"'
    endif
endf

augroup filetype_init
    autocmd!
    autocmd VimEnter * call s:SetPipeFiletype()
    autocmd VimEnter * call s:FindFile()
augroup END
" }}}

" {{{ PAAS commands
command! PAASUpgrade !ssh mnet command 'xssh sz-ops sh /home/web/xy-runner-api/bin/upgrade.sh; xssh 10.0.128.34 sh /home/web/xy-runner-api/bin/upgrade.sh'
augroup filetype_yaml
    autocmd!
    autocmd FileType yaml setlocal tabstop=2
    autocmd FileType yaml setlocal softtabstop=2
    autocmd FileType yaml setlocal shiftwidth=2
    autocmd FileType yaml nnoremap <buffer> <localleader>r :!kubectl apply -n=jianming -f=%<cr>
augroup END
" }}}
