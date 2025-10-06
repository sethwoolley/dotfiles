-- Plugins for Version Control Systems (aka Git, but maybe I'll need another in the future)

return {
  -- Gitgutter
  {
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
      current_line_blame_formatter = '      <committer> - <sha> - <summary>',

      on_attach = function(bufnr)
        local gitsigns = require('gitsigns')

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        map(
          'n', '[c', function() gitsigns.nav_hunk('prev') end,
          { desc = 'prev [c]hange', buffer = bufnr }
        )
        map(
          'n', ']c', function() gitsigns.nav_hunk('next') end,
          { desc = 'next [c]hange', buffer = bufnr }
        )
        map(
          'n', ' b', function() gitsigns.toggle_current_line_blame() end,
          { desc = 'Git [b]lame line' }
        )

        map(
          'n', ' gh', function() gitsigns.stage_hunk() end,
          { desc = '[g]it [h]unk stage' }
        )
        map(
          'v', ' gh', function() gitsigns.stage_hunk() end,
          { desc = '[g]it [h]unk stage' }
        )

        map(
          'n', ' gd', function() gitsigns.preview_hunk_inline() end,
          { desc = '[g]it [d]iff' }
        )
      end,
    },
  },

  -- blame commit copying
  {
    'f-person/git-blame.nvim',
    keys = {
      {' bc', '<cmd>GitBlameCopySHA<CR>', desc = 'Git [b]lame [c]opy commit ID'},
    },
    opts = {
      virtual_text_column = 0,
      highlight_group = 'NonText',
      message_template = '      <committer> - <sha> - <summary>',
    }
  },
}
