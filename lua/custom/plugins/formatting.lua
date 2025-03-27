-- { -- Autoformat
--   'stevearc/conform.nvim',
--   event = { 'BufWritePre' },
--   cmd = { 'ConformInfo' },
--   keys = {
--     {
--       '<leader>ff',
--       function()
--         require('conform').format { async = true, lsp_format = 'fallback' }
--       end,
--       mode = '',
--       desc = '[F]ormat buffer',
--     },
--   },
--   opts = {
--     notify_on_error = false,
--     format_on_save = function(bufnr)
--       -- Disable "format_on_save lsp_fallback" for languages that don't
--       local disable_filetypes = { c = true, cpp = true }
--       local lsp_format_opt
--       if disable_filetypes[vim.bo[bufnr].filetype] then
--         lsp_format_opt = 'never'
--       else
--         lsp_format_opt = 'fallback'
--       end
--       return {
--         timeout_ms = 500,
--         lsp_format = lsp_format_opt,
--       }
--     end,
--     formatters_by_ft = {
--       lua = { 'stylua' },
--       -- Conform can also run multiple formatters sequentially
--       -- python = { "isort", "black" },
--       -- javascript = { "prettierd", "prettier", stop_after_first = true },
--     },
--   },
-- },
return {
  'stevearc/conform.nvim',
  event = { 'BufReadPre', 'BufNewFile' },

  config = function()
    local conform = require 'conform'

    --NOTE:MANUALLY INSTALL FORMATTER VIA MASON! DONT MAKE MASON CONFIG MESSY (ALSO BREAKING UPDATES IS A THING !)
    conform.setup {
      formatters_by_ft = {
        javascript = { 'prettier' },
        typescript = { 'prettier' },
        javascriptreact = { 'prettier' },
        typescriptreact = { 'prettier' },
        svelte = { 'prettier' },
        css = { 'prettier' },
        html = { 'prettier' },
        json = { 'prettier' },
        yaml = { 'prettier' },
        markdown = { 'prettier' },
        graphql = { 'prettier' },
        liquid = { 'prettier' },
        lua = { 'stylua' },
        python = { 'black' },
      },
      format_on_save = {
        lsp_fallback = true,
        async = false,
        timeout_ms = 1000,
      },
    }

    vim.keymap.set({ 'n', 'v' }, '<leader>ff', function()
      conform.format {
        lsp_fallback = true,
        async = false,
        timeout_ms = 1000,
      }
      vim.cmd.write()
    end, { desc = 'Format file or range (in visual mode)' })
  end,
}
