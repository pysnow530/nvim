-- 编辑器基础配置
vim.cmd('syntax on')
vim.opt.history = 50
vim.opt.showcmd = true
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.cursorline = true
vim.opt.showmatch = true
vim.opt.scrolloff = 1
vim.opt.wrap = false
vim.opt.foldtext = 'getline(v:foldstart)'
vim.opt.foldlevel = 99  -- don't fold on opened
vim.opt.background = 'dark'
vim.opt.laststatus = 2
if vim.fn.exists('+colorcolumn') then
    vim.opt.colorcolumn = '100'
end

-- 行号和相对行号
vim.opt.number = true
if vim.fn.exists('+rnu') then
    vim.opt.relativenumber = true
end

-- ripgrep
local function find_git_root_dir()
    -- current path
    local curr_buf_path = vim.fn.expand('%:p')
    if curr_buf_path == nil or curr_buf_path == "" then
        error(string.format('Expand current path error: %q', curr_buf_path))
    end

    -- git root directory
    local util = require('lspconfig.util')
    local root_dir = util.find_git_ancestor(curr_buf_path)
    if root_dir == nil then
        error(string.format('Find git ancestor error: %q', curr_buf_path))
    end

    return root_dir
end
vim.opt.grepprg = 'rg --vimgrep $*'
vim.api.nvim_create_user_command('RipGrep', "execute 'silent grep! <args>' | redraw! | copen 10", { nargs = 1 })
vim.api.nvim_set_keymap('n', '<leader>g', '', {
    callback = function()
        local root_dir = find_git_root_dir()
        local pattern = vim.fn.expand('<cword>')
        if string.len(pattern) < 3 then
            error('Pattern on curser is too short: ' .. pattern)
        end

        vim.cmd(string.format(':RipGrep %q %q', pattern, root_dir))
    end,
    desc = 'Ripgrep search words'
})
vim.api.nvim_set_keymap('n', '<leader><leader>g', '', {
    callback = function()
        local root_dir = find_git_root_dir()
        local pattern = vim.fn.input('rg pattern: ')
        if pattern == "" then
            return
        end

        vim.cmd(string.format(':RipGrep %q %q', pattern, root_dir))
    end,
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
            {
                '<leader>f',
                function()
                    -- current path
                    local util = require('lspconfig.util')
                    local curr_buf_path = vim.fn.expand('%:p')
                    local root_dir = util.find_git_ancestor(curr_buf_path)

                    -- git root directory
                    if root_dir == nil then
                        vim.cmd('NERDTreeToggle')
                    else
                        vim.cmd('NERDTreeToggle ' .. root_dir)
                    end
                end
                ,
                desc = 'Toggle file tree'
            }
        },
        init = function()
            vim.g.NERDTreeQuitOnOpen = 0
        end,
    },
}
