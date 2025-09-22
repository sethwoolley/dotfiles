-- Plugins that effect code/text editing
return {

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
