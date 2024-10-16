-- ripgrep
vim.opt.grepprg = 'rg --vimgrep $*'
vim.api.nvim_create_user_command('RipGrep', "execute 'silent grep! <args>' | redraw! | copen 10", { nargs = 1 })
vim.api.nvim_set_keymap('n', '<leader>g', '', {
    callback =
        function()
            -- current path
            local curr_path = vim.fn.expand('%:p')
            if curr_path == nil or curr_path == "" then
                error(string.format('Expand current path error: %q', curr_path))
            end

            -- git root directory
            local util = require('lspconfig.util')
            local root = util.find_git_ancestor(curr_path)
            if root == nil then
                error(string.format('Find git ancestor error: %q', curr_path))
            end

            local search = vim.fn.input('rg search: ', vim.fn.expand('<cword>'))
            if search ~= "" then
                vim.cmd(string.format(':RipGrep %q %q', search, root))
            end
        end
    ,
    desc = 'Ripgrep search words'
})

vim.api.nvim_set_keymap('n', '<leader>v', ':Git<CR>', { desc = 'Open git version control system' })

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
