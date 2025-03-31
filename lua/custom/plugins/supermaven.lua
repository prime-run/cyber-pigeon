return {
  'github/copilot.vim',
  vim.api.nvim_set_keymap('i', '<C-l>', 'copilot#Accept()', { expr = true, silent = true, noremap = false }),
}

-- return {
--   {
--     'supermaven-inc/supermaven-nvim',
--     config = function()
--       require('supermaven-nvim').setup {
--         ignore_filetypes = { cpp = true, oil = true },
--       }
--     end,
--   },
-- }
