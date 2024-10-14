return {
    { 'hynek/vim-python-pep8-indent' },
    {
        "neovim/nvim-lspconfig",
        config = function()
            -- npm i -g pyright
            require'lspconfig'.pyright.setup{}
        end
    }
}
