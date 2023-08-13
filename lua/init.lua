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
    -- version control
    {
        "lewis6991/gitsigns.nvim",
        config = function()
            require('gitsigns').setup{
                on_attach = function(bufnr)
                    local gs = package.loaded.gitsigns
                    vim.keymap.set('n', ']c', gs.next_hunk, {})
                    vim.keymap.set('n', '[c', gs.prev_hunk, {})
                end
            }
        end,
    },
    { "tpope/vim-fugitive", tag = "v3.7" },
    -- "airblade/vim-gitgutter",

    -- editor
    {
        'windwp/nvim-autopairs',
        event = "InsertEnter",
        opts = {} -- this is equalent to setup({}) function
    },
    "vim-scripts/argtextobj.vim",
    "tpope/vim-surround",
    "tpope/vim-commentary",
    "justinmk/vim-sneak",

    -- theme
    "lifepillar/vim-solarized8",
    "vim-airline/vim-airline",
    "vim-airline/vim-airline-themes",

    -- finder
    "nvim-lua/plenary.nvim",
    {
        "nvim-telescope/telescope.nvim",
        keys = {
            { "<C-p>", "<cmd>Telescope find_files<cr>", desc = "Telescope_find_files" },
            { "<leader>g", "<cmd>Telescope live_grep<cr>", desc = "Telescope_live_grep" }
        },
        tag = "0.1.2",
    },
    {
        "nvim-neo-tree/neo-tree.nvim",
        keys = {
            { "<leader>n", "<cmd>Neotree toggle<cr>", desc = "NeoTree" }
        },
        branch = "v3.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
            "MunifTanjim/nui.nvim",
        },
    },

    -- ai
    "github/copilot.vim",

    -- languages: general
    {
        'nvim-treesitter/nvim-treesitter',
        config = function()
            require'nvim-treesitter.configs'.setup {
                -- A list of parser names, or "all" (the five listed parsers should always be installed)
                ensure_installed = { "c", "lua", "vim", "vimdoc", "python", "javascript", "html", "c_sharp", },

                highlight = {
                    enable = true,
                },

                -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
                -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
                -- Using this option may slow down your editor, and you may see some duplicate highlights.
                -- Instead of true it can also be a list of languages
                additional_vim_regex_highlighting = false,
            }
        end
    },

    -- languages: javascript
    "pangloss/vim-javascript",
    "mxw/vim-jsx",

    -- languages: python
    "hynek/vim-python-pep8-indent",
})
