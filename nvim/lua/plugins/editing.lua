-- Plugins that effect code/text editing
return {

  -- auto completion
  {
    "hrsh7th/nvim-cmp",
    version = false, -- last release is way too old
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-path",
    },
    opts = function()
      vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })
      local cmp = require("cmp")
      local defaults = require("cmp.config.default")()
      return {
        completion = {
          completeopt = "menu,menuone,noinsert",
        },
        snippet = {
          expand = function(args)
              vim.snippet.expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-d>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ['<CR>'] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = false,
          },
          ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            else
              fallback()
            end
          end, { 'i', 's' }),
          ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            else
              fallback()
            end
          end, { 'i', 's' }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "path" },
        }),
        sorting = defaults.sorting,
      }
    end,
  },

  -- copilot
  {
    'zbirenbaum/copilot.lua',
    opts = {
      panel = { enabled = false },
      suggestion = {
          enabled = true,
          keymap = {
              accept = "<C-J>",
              accept_line = "<C-H>",
          },
      },
    },
  },

  -- extend a/i textobjects
  {
    'echasnovski/mini.ai',
    opts = {},
  },

  -- more surround support
  {
    'echasnovski/mini.surround',
    opts = {},
  },

  -- remove trailing whitespace
  {
    'echasnovski/mini.trailspace',
    opts = {},
  },
}
