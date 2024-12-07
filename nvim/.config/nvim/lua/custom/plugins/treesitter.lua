-- Treesitter
return {
  'nvim-treesitter/nvim-treesitter',
  build = ':TSUpdate',
  event = { 'BufReadPre', 'BufNewFile' },
  dependencies = {
    'nvim-treesitter/nvim-treesitter-textobjects',
    'RRethy/nvim-treesitter-endwise',
    'mfussenegger/nvim-ts-hint-textobject',
  },
  opts = {
    ensure_installed = { 'bash', 'c', 'html', 'lua', 'markdown', 'vim', 'vimdoc', 'rust' },
    auto_install = true,
    highlight = {
      enable = true,
      disable = function()
        return vim.b.large_buf
      end,
      additional_vim_regex_highlighting = false,
    },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = '<C-space>',
        node_incremental = '<C-space>',
        scope_incremental = '<nop>',
        node_decremental = '<bs>',
      },
    },
    endwise = {
      enable = true,
    },
    indent = { enable = true },
    autopairs = { enable = true },
    textobjects = {
      select = {
        enable = true,
        lookahead = true,
        keymaps = {
          ['af'] = '@function.outer',
          ['if'] = '@function.inner',
          ['ac'] = '@class.outer',
          ['ic'] = '@class.inner',
          ['al'] = '@loop.outer',
          ['il'] = '@loop.inner',
          ['ib'] = '@block.inner',
          ['ab'] = '@block.outer',
          ['ir'] = '@parameter.inner',
          ['ar'] = '@parameter.outer',
        },
      },
    },
    context_commentstring = { enable = true },
    filetype_to_parsername = {
      ['objective-c'] = 'objc',
    },

    rainbow = {
      enable = true,
      disable = { 'html' },
      query = 'rainbow-parens',
    },
  },
  config = function(_, opts)
    vim.treesitter.language.register('objc', { 'objective-c' })

    require('nvim-treesitter.configs').setup(opts)
  end,
}
