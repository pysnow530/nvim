return {
    { 'airblade/vim-gitgutter' },
    { 'tpope/vim-fugitive', tag = 'v3.7' },
    { 'cohama/lexima.vim' },
    { 'vim-scripts/argtextobj.vim' },
    { 'tpope/vim-surround' },
    { 'kien/ctrlp.vim' },
    { 'justinmk/vim-sneak' },
    { 'tpope/vim-commentary' },
    {
        'scrooloose/nerdtree',
        keys = {
            { '<leader>f', ':NERDTreeToggle<CR>', desc = 'Toggle file tree' }
        },
        init = function()
            vim.g.NERDTreeQuitOnOpen = 0
        end,
    },
}
