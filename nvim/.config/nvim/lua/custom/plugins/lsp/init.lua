return {
  -- Copilot and completion plugins
  require 'custom.plugins.lsp.copilot',
  require 'custom.plugins.lsp.completions',
  require 'custom.plugins.lsp.xcode',

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
    },
    config = function()
      require('custom.plugins.lsp.setup').setup()
    end,
  },

  -- TypeScript-specific tools
  {
    'pmizio/typescript-tools.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'neovim/nvim-lspconfig',
      'oleggulevskyy/better-ts-errors.nvim', -- Enhanced TypeScript diagnostics
      'MunifTanjim/nui.nvim', -- UI component library
    },
    opts = {
      tsserver_file_preferences = {
        includeInlayParameterNameHints = 'all',
        includeInlayParameterNameHintsWhenArgumentMatchesName = true,
        includeInlayFunctionParameterTypeHints = true,
        includeInlayVariableTypeHints = true,
        includeInlayVariableTypeHintsWhenTypeMatchesName = true,
        includeInlayPropertyDeclarationTypeHints = true,
        includeInlayFunctionLikeReturnTypeHints = true,
        includeInlayEnumMemberValueHints = true,
      },
      expose_as_code_action = 'all', -- Show TypeScript tools as code actions
      complete_function_calls = true, -- Enable function call completions
    },
    config = function(_, opts)
      require('typescript-tools').setup(opts)
      require('better-ts-errors').setup()
    end,
  },

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
