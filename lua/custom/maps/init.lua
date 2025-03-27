vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
vim.keymap.set('n', '<leader>pv', ':e .<CR>', { noremap = true, silent = true })

vim.keymap.set('n', '<leader>pp', vim.cmd.Oil)

vim.keymap.set('n', '<Tab>', 'o<Esc>', { noremap = true, silent = true })

-- vim.keymap.set('n', '!', '^', { noremap = true, silent = true })
-- vim.keymap.set('n', '@', '$', { noremap = true, silent = true })
--
-- vim.keymap.set('v', '!', '^', { noremap = true, silent = true })
-- vim.keymap.set('v', '@', '$', { noremap = true, silent = true })
-- move commands in visual mode
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv")
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv")
vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', '<C-u>', '<C-u>zz')
vim.keymap.set({ 'n', 'v' }, '<leader>y', [["+y]])

vim.keymap.set('i', '<M-h>', '<Left>', { noremap = true })
vim.keymap.set('i', '<M-j>', '<Down>', { noremap = true })
vim.keymap.set('i', '<M-k>', '<Up>', { noremap = true })
vim.keymap.set('i', '<M-l>', '<Right>', { noremap = true })

vim.keymap.set('i', '<M-CR>', '<Esc>o<UP>', { noremap = true, silent = true })

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

vim.keymap.set('n', '<leader>rep', function()
  local replacement = vim.fn.escape(vim.fn.getreg '.', '/\\&') -- Use LAST INSERTED TEXT (.)
  vim.cmd('keeppatterns %s//' .. replacement .. '/g')
end, { desc = 'Replace all with last change' })

vim.keymap.set('n', '<leader>colt', function()
  vim.cmd.colorscheme 'tokyonight-moon'
end, { desc = 'Color Tokyo' })

vim.keymap.set('n', '<leader>colr', function()
  vim.cmd.colorscheme 'rose-pine'
end, { desc = 'Color Rose-pine' })

--replace them ffs that messes up the damn pp in v mode!
vim.keymap.set('i', '<C-c>', '<C-[><Esc>', { noremap = true })
