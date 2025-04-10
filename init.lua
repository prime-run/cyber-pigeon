require 'setup'

--NOTE: [[ Install `lazy.nvim` plugin manager ]]
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

require('lazy').setup {
  'tpope/vim-sleuth', --auto shift width and width tab

  {
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',

        build = 'make',

        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
      { 'nvim-telescope/telescope-ui-select.nvim' },

      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
    },
    config = function()
      require('telescope').setup {
        defaults = {
          --   mappings = {
          --     i = { ['<c-enter>'] = 'to_fuzzy_refine' },
          file_ignore_patterns = {
            'node_modules',
            'venv',
          },
          --   },
        },
        -- pickers = {}
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
        },
      }

      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')

      local builtin = require 'telescope.builtin'
      vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
      vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
      vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
      vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
      vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
      vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
      vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
      vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
      vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })

      vim.keymap.set('n', '<leader><leader>', function()
        builtin.buffers(require('telescope.themes').get_dropdown {
          sort_mru = true,
          ignore_current_buffer = true,
          previewer = false,
          initial_mode = 'normal',
          attach_mappings = function(prompt_bufnr, map)
            map('i', '<Tab>', 'move_selection_next')
            map('i', '<S-Tab>', 'move_selection_previous')
            return true
          end,
        })
      end, { desc = '[ ] Find existing buffers' })

      local function get_sorted_buffers()
        local buffers = {}
        local current = vim.fn.bufnr()
        for _, bufnr in ipairs(vim.fn.getbufinfo { buflisted = 1 }) do
          if bufnr.bufnr ~= current then
            table.insert(buffers, bufnr.bufnr)
          end
        end
        table.sort(buffers, function(a, b)
          return vim.fn.getbufinfo(a)[1].lastused > vim.fn.getbufinfo(b)[1].lastused
        end)

        return buffers
      end

      -- Jump to nth buffer in MRU list
      local function jump_to_buffer(n)
        local buffers = get_sorted_buffers()
        if #buffers >= n then
          vim.api.nvim_set_current_buf(buffers[n])
        end
      end

      vim.keymap.set('n', '<leader>1', function()
        jump_to_buffer(1)
      end, { desc = 'Jump to previous buffer' })

      vim.keymap.set('n', '<leader>2', function()
        jump_to_buffer(2)
      end, { desc = 'Jump to second most recent buffer' })

      vim.keymap.set('n', '<leader>/', function()
        builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
          previewer = false,
        })
      end, { desc = '[/] Fuzzily search in current buffer' })

      vim.keymap.set('n', '<leader>s/', function()
        builtin.live_grep {
          grep_open_files = true,
          prompt_title = 'Live Grep in Open Files',
        }
      end, { desc = '[S]earch [/] in Open Files' })

      vim.keymap.set('n', '<leader>sn', function()
        builtin.find_files { cwd = vim.fn.stdpath 'config' }
      end, { desc = '[S]earch [N]eovim files' })
    end,
  },
  -- LSP Plugins NOTE: Initial Setup
  {
    'folke/lazydev.nvim',
    ft = { 'lua', 'typescript', 'javascript', 'javascriptreact', 'typescriptreact' }, -- Load for TS/JS files too

    opts = {
      library = {
        { path = 'luvit-meta/library', words = { 'vim%.uv' } },
      },
    },
  },
  { 'Bilal2453/luvit-meta', lazy = true },
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      -- NOTE: `opts = {}` is the same as calling `require('mason').setup({})`
      { 'williamboman/mason.nvim', opts = {} },
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
      { 'j-hui/fidget.nvim', opts = {} },

      'hrsh7th/cmp-nvim-lsp',
      'saghen/blink.cmp',
    },
    config = function()
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc, mode)
            mode = mode or 'n'
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
          map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
          map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
          map('<leader>dt', require('telescope.builtin').lsp_type_definitions, '[D]efinition [T]ype')
          map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
          map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
          map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
          map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction', { 'n', 'x' })
          map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
            local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd('LspDetach', {
              group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
              end,
            })
          end

          if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
            map('<leader>th', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
            end, '[T]oggle Inlay [H]ints')
          end
        end,
      })

      vim.diagnostic.config {
        float = {
          border = 'rounded',
          source = true,
          header = '',
          prefix = '',
          close_events = { 'BufLeave', 'CursorMoved', 'InsertEnter', 'FocusLost' },
        },
        --NOTE:it should be broken to wrok!! dont touch it it works! eventho it shouldn
        virtual_text = true,
        -- virtual_text = {
        --   spacing = 4,
        --   source = 'if_many',
        --   prefix = '●',
        -- },
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
      }

      vim.api.nvim_create_autocmd('CursorHold', {
        callback = function()
          local opts = {
            focusable = false,
            close_events = { 'BufLeave', 'CursorMoved', 'InsertEnter', 'FocusLost' },
            border = 'rounded',
            source = 'always',
            prefix = ' ',
            scope = 'cursor',
          }
          vim.diagnostic.open_float(nil, opts)
        end,
      })

      local signs = { Error = '🔴', Warn = '🟡', Hint = 'H', Info = '' }
      for type, icon in pairs(signs) do
        local hl = 'DiagnosticSign' .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
      end

      local capabilities = vim.tbl_deep_extend(
        'force',
        vim.lsp.protocol.make_client_capabilities(),
        require('blink.cmp').get_lsp_capabilities(),
        require('cmp_nvim_lsp').default_capabilities()
      )
      local servers = {
        -- clangd = {},
        -- gopls = {},
        -- pyright = {
        --   settings = {
        --     python = {
        --       analysis = {
        --         typeCheckingMode = 'basic', -- or 'strict' for stricter checks
        --         diagnosticMode = 'workspace',
        --         autoSearchPaths = true,
        --         useLibraryCodeForTypes = true,
        --         stubPath = vim.fn.stdpath 'data' .. '/stubs',
        --         extraPaths = { './your_project_dir' }, -- Add your Django project root
        --         djangoEnabled = true,
        --         diagnosticSeverityOverrides = {
        --           reportUnusedVariable = 'warning',
        --         },
        --       },
        --     },
        --   },
        -- },
        lua_ls = {
          -- cmd = { ... },
          -- filetypes = { ... },
          -- capabilities = {},
          settings = {
            Lua = {
              completion = {
                callSnippet = 'Replace',
              },
              -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
              diagnostics = { disable = { 'missing-fields' } },
            },
          },
        },
      }

      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, {
        'stylua', -- Used to format Lua code
      })
      require('mason-tool-installer').setup { ensure_installed = ensure_installed }

      require('mason-lspconfig').setup {
        handlers = {
          function(server_name)
            -- Skip TypeScript LSP since we're using typescript-tools.nvim
            if server_name == 'tsserver' then
              return
            end
            local server = servers[server_name] or {}
            server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
            require('lspconfig')[server_name].setup(server)
          end,
        },
      }
    end,
  },

  -- require 'core.plugins.debug',
  -- require 'core.plugins.lint',
  require 'core.plugins.autopairs',
  require 'core.plugins.gitsigns',

  { import = 'custom.plugins' },
  { import = 'custom.themes' },
  -- <leader>sh snvim help
}

--  `modeline`.  `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
