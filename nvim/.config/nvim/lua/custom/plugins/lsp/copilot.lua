return {
  {
    'yetone/avante.nvim',
    event = 'VeryLazy',
    lazy = false,
    version = false,
    -- config docs: https://github.com/yetone/avante.nvim?tab=readme-ov-file#default-setup-configuration
    opts = {
      -- FYI defaults to claude, recommends claude too.. I should try both
      provider = 'copilot',
      auto_suggestions_provider = 'copilot',
      behaviour = {
        auto_suggestions = false, -- Experimental stage
        auto_set_highlight_group = true,
        auto_set_keymaps = true,
        auto_apply_diff_after_generation = false,
        support_paste_from_clipboard = false,
      },
    },
    build = 'make',
    dependencies = {
      'stevearc/dressing.nvim',
      'nvim-lua/plenary.nvim',
      'MunifTanjim/nui.nvim',
      'hrsh7th/nvim-cmp',
      'echasnovski/mini.icons',
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
      {
        -- support for image pasting
        'HakonHarnes/img-clip.nvim',
        event = 'VeryLazy',
        opts = {
          -- recommended settings
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
            use_absolute_path = true,
          },
        },
      },
      {
        -- Make sure to set this up properly if you have lazy=true
        'MeanderingProgrammer/render-markdown.nvim',
        opts = {
          file_types = { 'markdown', 'Avante' },
        },
        ft = { 'markdown', 'Avante' },
      },
    },
  },
}
