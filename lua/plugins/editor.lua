return {
    {
        'scrooloose/nerdtree',
        keys = {
            { '<leader>f', ':NERDTreeToggle<CR>', desc = 'Toggle file tree' }
        },
        config = function()
            vim.g.NERDTreeQuitOnOpen = 0
        end,
    },
}
