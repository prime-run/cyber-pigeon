return {
  'L3MON4D3/LuaSnip',
  version = 'v2.*',
  build = 'make install_jsregexp',
  dependencies = {
    'rafamadriz/friendly-snippets',
  },
  config = function()
    local luasnip = require 'luasnip'

    -- Load friendly-snippets
    require('luasnip.loaders.from_vscode').lazy_load()

    -- Set more aggressive history (helps with jumps)
    luasnip.config.setup {
      history = true,
      update_events = 'TextChanged,TextChangedI',
    }

    -- Better keybindings with fallbacks
    vim.keymap.set({ 'i', 's' }, '<C-n>', function()
      luasnip.expand_or_jump()
    end, { expr = true, silent = true })

    vim.keymap.set({ 'i', 's' }, '<C-m>', function()
      luasnip.jump(-1)
      -- Fallback to normal <C-k> behavior if no snippet active
    end, { expr = true, silent = true })

    -- Alternative: Use Tab/Shift-Tab (uncomment to try)
    --[[
    vim.keymap.set({'i', 's'}, '<Tab>', function()
      if luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        return '<Tab>'
      end
    end, {expr = true})
    
    vim.keymap.set({'i', 's'}, '<S-Tab>', function()
      if luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        return '<S-Tab>'
      end
    end, {expr = true})
    --]]

    -- Visual feedback when jumping works
    vim.api.nvim_create_autocmd('User', {
      pattern = 'LuasnipJumpNodeEnter',
      callback = function()
        vim.notify('Jumping to next snippet node', vim.log.levels.INFO, { title = 'LuaSnip' })
      end,
    })
  end,
}
