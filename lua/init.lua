-- require lazy package manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- install nerd font (optional)
-- 1. https://www.nerdfonts.com/font-downloads
-- 2. SauceCodePro Nerd Font
-- 3. install and change term font

require("lazy").setup({
    "hynek/vim-python-pep8-indent",
    "airblade/vim-gitgutter",
    "lvht/tagbar-markdown",
    { "tpope/vim-fugitive", tag = "v3.7" },
    "cohama/lexima.vim",
    "vim-scripts/argtextobj.vim",
    "scrooloose/nerdtree",
    "tpope/vim-surround",
    "tpope/vim-commentary",
    "lifepillar/vim-solarized8",
    "vim-airline/vim-airline",
    "vim-airline/vim-airline-themes",
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope.nvim", tag = "0.1.2" },
    "github/copilot.vim",
    "pangloss/vim-javascript",
    "mxw/vim-jsx",
    "justinmk/vim-sneak",
})

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<C-p>', builtin.find_files, {})
vim.keymap.set('n', '<leader>g', builtin.live_grep, {})
