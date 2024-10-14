local config_dir = vim.fn.stdpath('config')

-- legacy config
vim.cmd('source ' .. config_dir .. '/legacy.vim')

vim.api.nvim_set_keymap('n', '<leader>v', ':Git<CR>', { desc = 'Open version control system' })
