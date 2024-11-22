return {
  'hrsh7th/nvim-cmp',
  event = 'InsertEnter',
  dependencies = {
    -- Completion sources
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-cmdline',
    'lukas-reineke/cmp-rg', -- Ripgrep source
    'petertriho/cmp-git',
    'dmitmel/cmp-cmdline-history',
    'FelipeLema/cmp-async-path',
    'saadparwaiz1/cmp_luasnip',

    -- Snippet engine and snippets
    {
      'L3MON4D3/LuaSnip',
      version = 'v2.*',
      build = 'make install_jsregexp',
      dependencies = { 'rafamadriz/friendly-snippets' },
    },

    -- Icons in completion menu
    'onsails/lspkind.nvim',
  },

  config = function()
    local cmp = require 'cmp'
    local luasnip = require 'luasnip'
    local lspkind = require 'lspkind'

    -- LuaSnip setup
    luasnip.config.setup {}
    require('luasnip.loaders.from_vscode').lazy_load()

    -- Helper function for border styling
    local function border(hl_name)
      return {
        { '╭', hl_name },
        { '─', hl_name },
        { '╮', hl_name },
        { '│', hl_name },
        { '╯', hl_name },
        { '─', hl_name },
        { '╰', hl_name },
        { '│', hl_name },
      }
    end

    -- Main completion setup
    cmp.setup {
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      completion = {
        completeopt = 'menu,menuone,noinsert',
        keyword_length = 2,
      },
      formatting = {
        fields = { 'kind', 'abbr', 'menu' },
        format = function(entry, vim_item)
          -- Use your custom kind formatting
          local kind = lspkind.cmp_format {
            maxwidth = 50,
            ellipsis_char = '...',
            preset = 'default',
          }(entry, vim_item)

          -- Customize the "kind" display
          local strings = vim.split(kind.kind, '%s', { trimempty = true })
          kind.kind = ' ' .. (strings[1] or '') .. ' '

          -- Menu labels for each source
          local menu = ({
            buffer = 'Buffer',
            fuzzy_buffer = 'Buffer',
            nvim_lsp = 'LSP',
            nvim_lua = 'Lua',
            rg = 'Ripgrep',
            luasnip = 'Snippet',
            cmdline = 'CmdLine',
            async_path = 'Path',
          })[entry.source.name] or strings[2] or ''

          -- Try to fetch the LSP client name
          local lspserver_name = nil
          pcall(function()
            lspserver_name = entry.source.source.client.name
          end)
          if lspserver_name == nil then
            lspserver_name = menu
          end

          -- Append LSP client or source info to the menu
          kind.menu = '    (' .. lspserver_name .. ')'
          return kind
        end,
      },
      sorting = {
        priority_weight = 2,
        comparators = {
          cmp.config.compare.offset,
          cmp.config.compare.exact,
          cmp.config.compare.score,
          function(entry1, entry2)
            local kind_priority = {
              nvim_lsp = 1,
              luasnip = 2,
              buffer = 3,
              path = 4,
              cmdline = 5,
              rg = 6,
            }
            local kind1 = kind_priority[entry1.source.name] or 100
            local kind2 = kind_priority[entry2.source.name] or 100
            return kind1 < kind2
          end,
          cmp.config.compare.kind,
          cmp.config.compare.sort_text,
          cmp.config.compare.length,
          cmp.config.compare.order,
        },
      },
      window = {
        completion = cmp.config.window.bordered {
          winhighlight = 'Normal:Pmenu,FloatBorder:Pmenu,CursorLine:PmenuSel,Search:None',
          max_height = 10, -- Limit max UI height
        },
        documentation = cmp.config.window.bordered {
          border = border 'CmpDocBorder',
        },
      },
      mapping = cmp.mapping.preset.insert {
        ['<C-n>'] = cmp.mapping.select_next_item(),
        ['<C-p>'] = cmp.mapping.select_prev_item(),
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-y>'] = cmp.mapping.confirm { select = true },
        ['<C-Space>'] = cmp.mapping.complete {},
        ['<C-l>'] = cmp.mapping(function(fallback)
          if luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          else
            fallback()
          end
        end, { 'i', 's' }),
        ['<C-h>'] = cmp.mapping(function(fallback)
          if luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { 'i', 's' }),
      },
      sources = cmp.config.sources {
        { name = 'nvim_lsp', priority = 1000 },
        { name = 'luasnip', priority = 750 },
        { name = 'buffer', priority = 500 },
        { name = 'path', priority = 250 },
        { name = 'rg', priority = 200 },
        { name = 'cmdline', priority = 100 },
      },
    }

    -- Command line mode configuration
    cmp.setup.cmdline(':', {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources {
        { name = 'path' },
        { name = 'cmdline' },
        { name = 'cmdline_history' },
      },
    })

    -- Search mode configuration
    cmp.setup.cmdline({ '/', '?' }, {
      mapping = cmp.mapping.preset.cmdline(),
      sources = {
        { name = 'nvim_lsp' },
        { name = 'buffer' },
        { name = 'cmdline_history' },
      },
    })
  end,
}
