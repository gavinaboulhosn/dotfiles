return {
  {
    'zbirenbaum/copilot.lua',
    cmd = 'Copilot',
    event = 'InsertEnter',
    opts = {
      suggestion = {
        enabled = true,
        auto_trigger = true,
        debounce = 100,
        keymap = {
          -- We'll handle this ourselves in the config
          accept = false,
        },
      },
      panel = {
        enabled = true,
        auto_refresh = true,
      },
      filetypes = {
        markdown = true,
        gitcommit = true,
      },
    },
    config = function(_, opts)
      require('copilot').setup(opts)

      -- Get the suggestion module
      local suggestion = require 'copilot.suggestion'

      -- Replace the default Tab behavior
      vim.keymap.set('i', '<Tab>', function()
        if suggestion.is_visible() then
          suggestion.accept()
        else
          -- Forward the original <Tab> keypress
          vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Tab>', true, false, true), 'n', false)
        end
      end, {
        silent = true,
      })
    end,
  },
}
