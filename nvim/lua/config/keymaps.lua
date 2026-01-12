--Remap space as leader key
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)

-- Trash single character cuts
vim.keymap.set('n', 'x', '"_x')

-- remove gutters for copying for commenting
vim.keymap.set('n', '\\c',
    function()
        require('gitsigns').toggle_signs()
        vim.cmd("TSToggle python")
        vim.cmd("set number!")
    end
)

-- ctrl+[/] to cycle through tabs
vim.keymap.set('n', '<C-l>', ':tabnext<CR>', { desc = 'Next tab' })
vim.keymap.set('n', '<C-h>', ':tabprevious<CR>', { desc = 'Previous tab' })
