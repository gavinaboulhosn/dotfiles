return {
  {
    'folke/noice.nvim',
    event = 'VeryLazy',
    dependencies = {
      'MunifTanjim/nui.nvim',
      'rcarriga/nvim-notify',
    },
    opts = {
      lsp = {
        -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
        override = {
          ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
          ['vim.lsp.util.stylize_markdown'] = true,
          ['cmp.entry.get_documentation'] = true,
        },
        hover = {
          enabled = true,
        },
        signature = {
          enabled = true,
        },
      },
      -- you can enable a preset for easier configuration
      presets = {
        bottom_search = true, -- use a classic bottom cmdline for search
        command_palette = true, -- position the cmdline and popupmenu together
        long_message_to_split = true, -- long messages will be sent to a split
        inc_rename = false, -- enables an input dialog for inc-rename.nvim
        lsp_doc_border = true, -- add a border to hover docs and signature help
      },
      routes = {
        -- hide the search count message
        {
          filter = {
            event = 'msg_show',
            kind = 'search_count',
          },
          opts = { skip = true },
        },
        -- hide the written messages
        {
          filter = {
            event = 'msg_show',
            find = 'written',
          },
          opts = { skip = true },
        },
      },
      views = {
        cmdline_popup = {
          position = {
            row = 5,
            col = '50%',
          },
          size = {
            width = 60,
            height = 'auto',
          },
        },
        popupmenu = {
          relative = 'editor',
          position = {
            row = 8,
            col = '50%',
          },
          size = {
            width = 60,
            height = 10,
          },
          border = {
            style = 'rounded',
            padding = { 0, 1 },
          },
          win_options = {
            winhighlight = { Normal = 'Normal', FloatBorder = 'DiagnosticInfo' },
          },
        },
      },
    },
    keys = {
      {
        '<leader>nl',
        function()
          require('noice').cmd 'last'
        end,
        desc = 'Noice Last Message',
      },
      {
        '<leader>nh',
        function()
          require('noice').cmd 'history'
        end,
        desc = 'Noice History',
      },
      {
        '<leader>na',
        function()
          require('noice').cmd 'all'
        end,
        desc = 'Noice All',
      },
      {
        '<c-f>',
        function()
          if not require('noice.lsp').scroll(4) then
            return '<c-f>'
          end
        end,
        silent = true,
        expr = true,
        desc = 'Scroll forward',
        mode = { 'i', 'n', 's' },
      },
      {
        '<c-b>',
        function()
          if not require('noice.lsp').scroll(-4) then
            return '<c-b>'
          end
        end,
        silent = true,
        expr = true,
        desc = 'Scroll backward',
        mode = { 'i', 'n', 's' },
      },
    },
  },

  {
    'rcarriga/nvim-notify',
    lazy = false,
    config = function()
      require('notify').setup {
        render = 'compact',
        top_down = false, -- Show at bottom
        max_height = function()
          return math.floor(vim.o.lines * 0.25) -- Maximum of 25% of screen
        end,
        max_width = function()
          return math.floor(vim.o.columns * 0.4) -- Maximum of 40% of screen
        end,
      }
      vim.notify = require 'notify'
    end,
  },
}
