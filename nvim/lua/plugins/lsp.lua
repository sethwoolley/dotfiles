return {
  -- LSP config - "Inspired by" kickstart.nvim
  {
    'neovim/nvim-lspconfig',

    dependencies = {
      'williamboman/mason.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',

      { 'j-hui/fidget.nvim', opts = {} },

    },
    config = function()
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc)
            vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
          map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
          map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
          map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
          map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
          map('K', vim.lsp.buf.hover, 'Hover Documentation')
          map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

        end,
      })

      -- cmp-nvim-lsp adds new capabilities
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

      -- LSP server names according to Mason
      local server_names = {'basedpyright', 'lua-language-server'}

      require('mason').setup()
      require('mason-tool-installer').setup { ensure_installed = server_names }

      -- LSP server configurations according to vim.lsp
      -- { server_name : config }
      local server_configs = {
        basedpyright = {
          settings = {
            basedpyright = {
              analysis = {
                reportAny = 'none',
                typeCheckingMode = 'standard',
              },
            },
          },
        },
        lua_ls = {
          settings = {
            Lua = {
              completion = {
                callSnippet = 'Replace',
              },
            },
          },
        },
      }

      -- for every server, vim.lsp.enable it
      for server_name, config in pairs(server_configs) do
        config = vim.tbl_deep_extend(
            "force",
            { capabilities = vim.deepcopy(capabilities) },
            config or {}
        )
        vim.lsp.config(server_name, config)
        vim.lsp.enable({server_name})
      end
    end,
  },

  -- neovim dev
  {
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    opts = {},
  },
}
