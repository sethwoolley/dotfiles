-- Miscellaneous utilities plugins that don't quite fit in anywhere else


return {
  -- Fuzzy Finder (files, lsp, etc)
  { 'nvim-telescope/telescope.nvim', tag = 'v0.2.1', dependencies = { 'nvim-lua/plenary.nvim' } },
  {
    'nvim-telescope/telescope-fzf-native.nvim',
    build = 'make',
  },

  -- per-cwd session saving
  {
    'rmagatti/auto-session',
    opts = {
      auto_session_suppress_dirs = { '~/', '~/Projects', '~/Downloads', '/' },
    }
  },

  -- fast fuzzy file finder
  {
    'dmtrKovalenko/fff.nvim',
    build = function()
      require("fff.download").download_or_build_binary()
    end,
    opts = {},
    lazy = false,
    keys = {
      {
        "ff",
        function() require('fff').find_files() end,
        desc = 'FFFind files',
      }
    }
  }
}
