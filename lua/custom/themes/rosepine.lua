return {
  'rose-pine/neovim',

  name = 'rose-pine',

  config = function()
    require('rose-pine').setup {
      variant = 'main',
      dark_variant = 'main',
      disable_background = true,
      disable_float_background = false,
      disable_italics = false,
      -- Increase color vibrancy
      groups = {
        background_nc = '#000000',
        panel = 'surface',
        panel_nc = 'base',
        border = 'highlight_med',
        comment = 'muted',
        link = 'iris',
        punctuation = 'subtle',
        -- Enhance syntax colors
        error = 'love',
        hint = 'iris',
        info = 'foam',
        warn = 'gold',

        -- Boost these colors for more vibrancy
        headings = {
          h1 = 'iris',
          h2 = 'foam',
          h3 = 'rose',
          h4 = 'gold',
          h5 = 'pine',
          h6 = 'foam',
        },
      },

      -- Highlight groups to make colors more vivid
      highlight_groups = {
        Comment = { fg = 'muted', italic = false },
        Function = { fg = 'iris', bold = true },
        Keyword = { fg = 'pine', bold = true },
        Operator = { fg = 'rose', bold = true },
        String = { fg = 'gold' },
        Type = { fg = 'foam', bold = true },
        ['@keyword'] = { fg = 'pine', bold = true },
        ['@function'] = { fg = 'iris', bold = true },
        ['@string'] = { fg = 'gold' },
        ['@type'] = { fg = 'foam', bold = true },
      },
    }
  end,
}
