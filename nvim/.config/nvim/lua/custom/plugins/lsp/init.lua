return {
  -- Core LSP setup
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      { 'j-hui/fidget.nvim', opts = {} }, -- LSP status UI
      { 'folke/neodev.nvim', opts = {} }, -- Improved Lua LSP for Neovim config
      'hrsh7th/cmp-nvim-lsp', -- LSP source for nvim-cmp
      'simrat39/rust-tools.nvim',
    },
    config = function()
      require('custom.plugins.lsp.setup').setup()
    end,
  },

  -- Copilot and completion plugins
  require 'custom.plugins.lsp.copilot',
  require 'custom.plugins.lsp.completions',
  require 'custom.plugins.lsp.xcode',

  -- Java support
  {
    'mfussenegger/nvim-jdtls',
    ft = 'java', -- Lazy load for Java files only
  },

  -- Markdown renderer
  {
    'MeanderingProgrammer/render-markdown.nvim',
    enabled = false, -- Disabled by default
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'echasnovski/mini.nvim', -- Use the mini.nvim suite
    },
    opts = {},
  },

  -- Tailwind CSS tools
  {
    'luckasRanarison/tailwind-tools.nvim',
    name = 'tailwind-tools',
    build = ':UpdateRemotePlugins',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'nvim-telescope/telescope.nvim', -- Optional: Telescope integration
      'neovim/nvim-lspconfig', -- Optional: LSP config for Tailwind
    },
    opts = {},
  },

  -- Prettier configuration plugin
  { 'numToStr/prettierrc.nvim' },

  -- MDX (Markdown + JSX) support
  {
    'davidmh/mdx.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    config = true,
  },
}
