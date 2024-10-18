vim.api.nvim_set_keymap('n', '<c-h>', '<c-w>h', { desc = 'left window' })
vim.api.nvim_set_keymap('n', '<c-j>', '<c-w>j', { desc='bottom window' })
vim.api.nvim_set_keymap('n', '<c-k>', '<c-w>k', { desc='up window' })
vim.api.nvim_set_keymap('n', '<c-l>', '<c-w>l', { desc='right window' })

vim.api.nvim_set_keymap('n', '<leader>b', ':b#<CR>', { desc='go to prev buffer' })
vim.api.nvim_set_keymap('n', '<leader><leader>', 'q:<CR>', { desc='open the command-line window' })
vim.api.nvim_set_keymap('n', '<leader>j', ':w<CR>', { desc='write buffer to file' })
vim.api.nvim_set_keymap('n', '<leader>k', ':q<CR>', { desc='quit the current window' })

return {}
