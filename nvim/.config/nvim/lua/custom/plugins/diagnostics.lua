local M = {}

M.setup = function()
  -- Diagnostic configuration
  vim.diagnostic.config {
    virtual_text = {
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
    opts = {},
    keys = {
      { '<leader>xx', '<cmd>Trouble diagnostics toggle<cr>', desc = 'Diagnostics (Trouble)' },
      { '<leader>xX', '<cmd>Trouble diagnostics toggle filter.buf=0<cr>', desc = 'Buffer Diagnostics (Trouble)' },
      { '<leader>xs', '<cmd>Trouble symbols toggle focus=false<cr>', desc = 'Symbols (Trouble)' },
      { '<leader>xl', '<cmd>Trouble lsp toggle focus=false win.position=right<cr>', desc = 'LSP Definitions / references / ... (Trouble)' },
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
