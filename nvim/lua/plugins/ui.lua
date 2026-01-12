-- Plugins that affect the user interface

return {

  -- Treesitter
  {
    'nvim-treesitter/nvim-treesitter',
    version = false,
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    cmd = { "TSUpdateSync" },
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects', -- Additional textobjects for treesitter
      init = function()
        require("lazy.core.loader").disable_rtp_plugin("nvim-treesitter-textobjects")
      end,
    },
    opts = {
      highlight = {
        enable = true, -- false will disable the whole extension
      },
    }
  },

  -- colorscheme
  {
    "olimorris/onedarkpro.nvim",
    lazy=false,
    priority=1000,
    opts = {
      colors = {
        dark_yellow = "require('onedarkpro.helpers').darken('yellow', 10, 'onedark')"
      },
      highlights = {
        -- Highlighting every variable is far far too colourful
        ["@variable"] = { },
        -- Dark mode search is hard to see
        Search = { fg = '${black}', bg = '${dark_yellow}' },
      },
    },
  },

  -- Markdown prettifier
  {
      'MeanderingProgrammer/markdown.nvim',
      dependencies = { 'nvim-treesitter/nvim-treesitter' },
      opts = {},
  },

  -- Status line
  {
    'nvim-lualine/lualine.nvim',
    opts = {
      options = {
        icons_enabled = true,
        component_separators = '|',
        section_separators = '',
      },
      sections = {
        lualine_a = {'mode'},
        lualine_b = {'branch', 'diff', 'diagnostics'},
        lualine_c = {'filename'},
        lualine_x = {'copilot', 'filetype'},
        lualine_y = {'progress'},
        lualine_z = {'location'}
      },
    },
    requires = { 'nvim-tree/nvim-web-devicons', opt = true },
  },

  -- Smooth scrolling
  {
    'karb94/neoscroll.nvim',
    lazy = false,
    opts = {} ;
  },
}
