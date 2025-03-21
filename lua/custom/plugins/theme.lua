function ColorMyPencils(color)
  color = color or 'rose-pine'
  vim.cmd.colorscheme(color)
  vim.api.nvim_set_hl(0, 'Normal', { bg = '#000000' })
  vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'none' })
end

return {
  {
    'folke/tokyonight.nvim',
    config = function()
      require('tokyonight').setup {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        style = 'moon', -- The theme comes in three styles, `storm`, `moon`, a darker variant `night` and `day`
        transparent = true, -- Enable this to disable setting the background color
        terminal_colors = true, -- Configure the colors used when opening a `:terminal` in Neovim
        styles = {
          -- Style to be applied to different syntax groups
          -- Value is any valid attr-list value for `:help nvim_set_hl`
          comments = { italic = true },
          keywords = { italic = false },
          -- Background styles. Can be "dark", "transparent" or "normal"
          sidebars = 'dark', -- style for sidebars, see below
          floats = 'dark', -- style for floating windows
        },
      }
      vim.cmd.colorscheme 'tokyonight-moon'
    end,
  },

  {
    'rose-pine/neovim',

    name = 'rose-pine',

    config = function()
      require('rose-pine').setup {
        variant = 'main',
        dark_variant = 'main',
        disable_background = true,
        disable_float_background = false,
        disable_italics = true,
        -- Increase color vibrancy
        groups = {
          -- background = '#000000',
          -- background_nc = '#000000',
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

      ColorMyPencils()
    end,
  },
}
