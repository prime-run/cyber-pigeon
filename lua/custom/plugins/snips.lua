local function insert_go_error_check()
  local lines = {
    'if err != nil {',
    '\t',
    '}',
  }

  vim.api.nvim_put(lines, 'l', true, true)

  vim.cmd 'normal! k$'
  vim.cmd 'normal! k$'

  vim.api.nvim_feedkeys('a', 'n', false)
end

vim.keymap.set('n', '<leader>err', insert_go_error_check, { desc = 'Insert Go error check block', silent = true, noremap = true })

return {}
