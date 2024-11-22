local M = {}

M.on_attach = function(client, bufnr)
  local nmap = function(keys, func, desc)
    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = 'LSP: ' .. desc })
  end

  nmap('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
  nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
  nmap('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
  nmap('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
  nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
  nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
  nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
  nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
  nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
  nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    vim.lsp.buf.format()
  end, { desc = 'Format current buffer with LSP' })

  if client.server_capabilities.documentHighlightProvider then
    vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
      buffer = bufnr,
      callback = vim.lsp.buf.document_highlight,
    })
    vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
      buffer = bufnr,
      callback = vim.lsp.buf.clear_references,
    })
  end
end

local servers = {
  lua_ls = {
    settings = {
      Lua = {
        completion = { callSnippet = 'Replace' },
        diagnostics = { globals = { 'vim' } },
      },
    },
  },
  tsserver = {},
  eslint = {
    settings = {
      validate = 'on',
      codeActionOnSave = { enable = false, mode = 'all' },
      format = false,
      quiet = false,
      onIgnoredFiles = 'off',
      rulesCustomizations = {},
      run = 'onType',
      problems = { shortenToSingleLine = false },
      codeAction = {
        disableRuleComment = { enable = true, location = 'separateLine' },
        showDocumentation = { enable = true },
      },
    },
  },
  zls = {
    cmd = { 'zls' },
    root_dir = require('lspconfig.util').root_pattern '.git',
    settings = {
      zls = {
        enable_build_on_save = true,
        build_on_save_step = 'check',
      },
    },
  },
  taplo = {
    settings = {
      taplo = {
        evenBetterToml = {
          schema = {
            catalogs = {
              'https://www.schemastore.org/api/json/catalog.json',
            },
            repositoryEnabled = true,
            enabled = true,
          },
        },
      },
    },
  },
  jsonls = {},
}

M.setup = function()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

  require('mason').setup()
  require('mason-lspconfig').setup {
    ensure_installed = vim.tbl_keys(servers),
    handlers = {
      function(server_name)
        local server_config = servers[server_name] or {}
        require('lspconfig')[server_name].setup {
          capabilities = capabilities,
          on_attach = M.on_attach,
          settings = server_config.settings,
          filetypes = server_config.filetypes,
          cmd = server_config.cmd,
          root_dir = server_config.root_dir,
        }
      end,
    },
  }

  require('mason-tool-installer').setup {
    ensure_installed = {
      'stylua',
      'eslint_d',
      'jdtls',
      'swiftlint',
    },
  }

  -- Set up sourcekit-lsp separately
  require('lspconfig').sourcekit.setup {
    cmd = { 'xcrun', 'sourcekit-lsp' },
    capabilities = capabilities,
    on_attach = M.on_attach,
    root_dir = require('lspconfig.util').root_pattern('buildServer.json', 'Package.swift', '.git'),
  }
end

return M
