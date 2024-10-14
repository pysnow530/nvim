local config_dir = vim.fn.stdpath('config')

-- legacy config
vim.cmd('source ' .. config_dir .. '/legacy.vim')
