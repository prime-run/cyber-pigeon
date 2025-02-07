return {
  'navarasu/onedark.nvim',
  config = function()
    require('onedark').setup {
      colors = {
        bg0 = '#000000',
      },
    }
    require('onedark').load()
  end,
}
