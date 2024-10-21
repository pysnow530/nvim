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

vim.api.nvim_set_keymap('i', 'jk', '<ESC>', { desc = 'jk for exit insert mode quickly' })
vim.api.nvim_set_keymap('i', '<c-u>', '<ESC>vbUea', { desc = 'jk for exit insert mode quickly' })

if vim.fn.exists('+colorcolumn') then
    vim.opt.colorcolumn = '100'
end

-- 行号和相对行号
vim.opt.number = true
if vim.fn.exists('+rnu') then
    vim.opt.relativenumber = true
end

local function find_project_root_dir()
    -- current path
    local curr_buf_path = vim.fn.expand('%:p')
    if curr_buf_path == nil or curr_buf_path == "" then
        return
    end

    local util = require('lspconfig.util')

    -- find python module directory
    -- recursively find __init__.py file, and return the most out directory
    local function search_ancestors_from_root(startpath, func)
        local r = nil
        vim.validate { func = { func, 'f' } }
        if func(startpath) then
            r = startpath
        end
        local guard = 100
        for path in util.path.iterate_parents(startpath) do
            -- Prevent infinite recursion if our algorithm breaks
            guard = guard - 1
            if guard == 0 then
                return r
            end

            if func(path) then
                r = path
            end
        end
        return r
    end

    local function find_pymodule_root(start_path)
        return search_ancestors_from_root(start_path, function(path)
            if util.path.is_file(util.path.join(path, '__init__.py')) then
                return path
            end
        end)
    end

    local root_dir = util.find_git_ancestor(curr_buf_path) or find_pymodule_root(curr_buf_path)

    return root_dir
end

-- ripgrep
vim.opt.grepprg = 'rg --vimgrep $*'
vim.api.nvim_create_user_command('RipGrep', "execute 'silent grep! <args>' | redraw! | copen 10", { nargs = 1 })
vim.api.nvim_set_keymap('n', '<leader>g', '', {
    callback = function()
        local root_dir = find_project_root_dir()
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
        local root_dir = find_project_root_dir()
        local pattern = vim.fn.input('rg pattern: ')
        if pattern == "" then
            return
        end

        vim.cmd(string.format(':RipGrep %q %q', pattern, root_dir))
    end,
    desc = 'Ripgrep search words'
})

vim.api.nvim_set_keymap('n', '<leader>v', ':Git<CR>', { desc = 'Open git version control system' })

local function starts_with(self, substring)
    return self:sub(1, #substring) == substring
end

return {
    { 'airblade/vim-gitgutter' },
    { 'tpope/vim-fugitive', tag = 'v3.7' },
    { 'cohama/lexima.vim' },
    { 'vim-scripts/argtextobj.vim' },
    { 'tpope/vim-surround' },
    {
        'kien/ctrlp.vim',
        init = function()
            vim.g.ctrlp_map = ''
        end,
        keys = {
            {
                '<C-p>',
                function()
                    local project_root = find_project_root_dir()
                    if project_root == nil then
                        vim.cmd('CtrlP')
                    else
                        local cmd = 'CtrlP ' .. project_root
                        vim.cmd(cmd)
                    end
                end,
                desc = 'Ctrl p for searching file'
            }
        }
    },
    { 'justinmk/vim-sneak' },
    { 'tpope/vim-commentary' },
    {
        'scrooloose/nerdtree',
        keys = {
            {
                '<leader>f',
                function()
                    -- current path
                    local root_dir = find_project_root_dir()

                    -- git root directory
                    if root_dir == nil then
                        vim.cmd('NERDTreeToggle')
                    else
                        local curr_buf_path = vim.fn.expand('%:p')
                        vim.cmd('NERDTreeToggle ' .. root_dir)
                        if starts_with(vim.fn.bufname(), 'NERD_tree_tab_') then
                            vim.cmd('NERDTreeFind ' .. curr_buf_path)
                        end
                    end
                end,
                desc = 'Toggle file tree'
            }
        },
        init = function()
            vim.g.NERDTreeQuitOnOpen = 0
        end,
    },
}
