return {
    {
        "neovim/nvim-lspconfig",
        config = function()
            -- :help lspconfig-all
            require'lspconfig'.pyright.setup{}
            require'lspconfig'.lua_ls.setup{}
            require'lspconfig'.ts_ls.setup{}
        end
    }
}