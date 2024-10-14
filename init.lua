-- pysnow530's neovim configuration.
--
-- Maintainer:   pysnow530 <pysnow530@163.com>
-- Inittime:     Apr 5, 2015
--
-- neovim
-- git clone git@github.com:pysnow530/dotvim.git ~/.config/nvim && nvim +PlugInstall
-- remote develop with neovim: https://neovide.dev/features.html
--
-- let mapleader = ","
-- let maplocalleader = '\'
require('config.lazy')

local config_dir = vim.fn.stdpath('config')
local init_lua_path = config_dir .. '/init.lua'

-- legacy config
vim.cmd('source ' .. config_dir .. '/legacy.vim')

-- the great config
vim.api.nvim_set_keymap('n', '<leader>s', '', { callback = function() vim.cmd('e ' .. init_lua_path) end, desc = 'Edit init.lua file' })
vim.api.nvim_set_keymap('n', '<leader>v', ':Git<CR>', { desc = 'Open git version control system' })

-- reload after save
vim.api.nvim_create_autocmd({ "BufWritePost" }, {
    pattern = { "init.lua" },
    callback = function(ev) vim.cmd('luafile %') end,
    group = vim.api.nvim_create_augroup('AutoReloadConfigGroup', {})
})
