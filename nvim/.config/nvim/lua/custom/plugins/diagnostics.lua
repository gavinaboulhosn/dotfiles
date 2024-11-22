local M = {}

M.setup = function()
  -- Diagnostic configuration
  vim.diagnostic.config {
    virtual_text = {
      prefix = '●',
      format = function(diagnostic)
        -- Enhanced formatting for ESLint and other sources
        if diagnostic.source == 'eslint' then
          local message = diagnostic.message
          -- Extract rule name if it's in brackets at the end
          local rule = message:match '%[(.+)%]$'
          -- Remove the rule from the message if found
          message = rule and message:gsub('%[.+%]$', '') or message
          return string.format('ESLint%s: %s', rule and string.format('[%s]', rule) or '', message)
        elseif diagnostic.source == 'typescript-tools' then
          return string.format('TS: %s', diagnostic.message)
        end
        return diagnostic.message
      end,
    },
    float = {
      source = true,
      border = 'rounded',
      header = '',
      prefix = function(diagnostic, i, total)
        local icons = {
          [vim.diagnostic.severity.ERROR] = '✘',
          [vim.diagnostic.severity.WARN] = '▲',
          [vim.diagnostic.severity.INFO] = 'ℹ',
          [vim.diagnostic.severity.HINT] = '⚑',
        }
        local severities = {
          [vim.diagnostic.severity.ERROR] = 'Error',
          [vim.diagnostic.severity.WARN] = 'Warn',
          [vim.diagnostic.severity.INFO] = 'Info',
          [vim.diagnostic.severity.HINT] = 'Hint',
        }
        -- Return both the prefix string and its highlight group
        return string.format('%s %d/%d ', icons[diagnostic.severity] or '●', i, total), 'DiagnosticSign' .. (severities[diagnostic.severity] or 'Info')
      end,
    },
    signs = {
      text = {
        [vim.diagnostic.severity.ERROR] = '✘',
        [vim.diagnostic.severity.WARN] = '▲',
        [vim.diagnostic.severity.INFO] = 'ℹ',
        [vim.diagnostic.severity.HINT] = '⚑',
      },
    },
    underline = true,
    update_in_insert = false,
    severity_sort = true,
  }

  -- Customize diagnostic signs
  local signs = { Error = '✘', Warn = '▲', Hint = '⚑', Info = 'ℹ' }
  for type, icon in pairs(signs) do
    local hl = 'DiagnosticSign' .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
  end

  -- Diagnostic keymaps - keeping your existing navigation pattern
  vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous [D]iagnostic message' })
  vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next [D]iagnostic message' })
  vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })
  vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
end

return {
  -- Trouble for enhanced diagnostic views
  {
    'folke/trouble.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {
      position = 'bottom',
      height = 10,
      icons = true,
      mode = 'document_diagnostics',
      fold_open = '',
      fold_closed = '',
      group = true,
      padding = true,
      cycle_results = true,
      action_keys = {
        -- Add custom key mappings here
        close = 'q',
        cancel = '<esc>',
        refresh = 'r',
        jump = { '<cr>', '<tab>' },
        toggle_fold = { 'zA', 'za' },
      },
      indent_lines = true,
      auto_open = false,
      auto_close = false,
      auto_preview = true,
      auto_fold = false,
      use_diagnostic_signs = true,
    },
    keys = {
      { '<leader>xx', '<cmd>Trouble diagnostics toggle<cr>', desc = 'Diagnostics (Trouble)' },
      { '<leader>xX', '<cmd>Trouble diagnostics toggle filter.buf=0<cr>', desc = 'Buffer Diagnostics (Trouble)' },
      { '<leader>cs', '<cmd>Trouble symbols toggle focus=false<cr>', desc = 'Symbols (Trouble)' },
      { '<leader>cl', '<cmd>Trouble lsp toggle focus=false win.position=right<cr>', desc = 'LSP Definitions / references / ... (Trouble)' },
      { '<leader>xL', '<cmd>Trouble loclist toggle<cr>', desc = 'Location List (Trouble)' },
      { '<leader>xQ', '<cmd>Trouble qflist toggle<cr>', desc = 'Quickfix List (Trouble)' },
    },
  },
  {
    'nvim-lua/plenary.nvim',
    config = function()
      M.setup()
    end,
  },
}
