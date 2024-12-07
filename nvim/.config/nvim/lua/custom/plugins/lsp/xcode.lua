return {
  -- Swift linting
  {
    'mfussenegger/nvim-lint',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      local lint = require 'lint'

      lint.linters_by_ft = {
        swift = { 'swiftlint' },
      }

      local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })

      vim.api.nvim_create_autocmd({ 'BufWritePost', 'BufReadPost', 'InsertLeave', 'TextChanged' }, {
        group = lint_augroup,
        callback = function()
          if not vim.endswith(vim.fn.bufname(), 'swiftinterface') then
            require('lint').try_lint()
          end
        end,
      })

      vim.keymap.set('n', '<leader>ml', function()
        require('lint').try_lint()
      end, { desc = 'Lint file' })
    end,
  },

  -- Xcode integration
  {
    'wojciech-kulik/xcodebuild.nvim',
    dependencies = {
      'nvim-telescope/telescope.nvim',
      'MunifTanjim/nui.nvim',
    },
    config = function()
      require('xcodebuild').setup {
        project_manager = {
          find_xcodeproj = true, -- instead of using configured xcodeproj search for xcodeproj closest to targeted file
        },
      }

      -- Xcode keymaps
      vim.keymap.set('n', '<leader>xl', '<cmd>XcodebuildToggleLogs<cr>', { desc = 'Toggle Xcodebuild Logs' })
      vim.keymap.set('n', '<leader>xb', '<cmd>XcodebuildBuild<cr>', { desc = 'Build Project' })
      vim.keymap.set('n', '<leader>xr', '<cmd>XcodebuildBuildRun<cr>', { desc = 'Build & Run Project' })
      vim.keymap.set('n', '<leader>xt', '<cmd>XcodebuildTest<cr>', { desc = 'Run Tests' })
      vim.keymap.set('n', '<leader>xT', '<cmd>XcodebuildTestClass<cr>', { desc = 'Run This Test Class' })
      vim.keymap.set('n', '<leader>X', '<cmd>XcodebuildPicker<cr>', { desc = 'Show Xcodebuild Picker' })
      vim.keymap.set('n', '<leader>xd', '<cmd>XcodebuildSelectDevice<cr>', { desc = 'Select Device' })
      vim.keymap.set('n', '<leader>xp', '<cmd>XcodebuildSelectTestPlan<cr>', { desc = 'Select Test Plan' })
    end,
  },
  {
    'mfussenegger/nvim-dap',
    dependencies = {
      'rcarriga/nvim-dap-ui',
      'wojciech-kulik/xcodebuild.nvim',
    },
    config = function()
      local xcodebuild = require 'xcodebuild.integrations.dap'

      local lldbPath = vim.fn.expand('$HOME' .. '/.local/share/nvim/mason/bin/codelldb')
      xcodebuild.setup(lldbPath)

      vim.keymap.set('n', '<leader>dd', xcodebuild.build_and_debug, { desc = 'Build & Debug' })
      vim.keymap.set('n', '<leader>dr', xcodebuild.debug_without_build, { desc = 'Debug Without Building' })
      vim.keymap.set('n', '<leader>dt', xcodebuild.debug_tests, { desc = 'Debug Tests' })
      vim.keymap.set('n', '<leader>dT', xcodebuild.debug_class_tests, { desc = 'Debug Class Tests' })
      vim.keymap.set('n', '<leader>b', xcodebuild.toggle_breakpoint, { desc = 'Toggle Breakpoint' })
      vim.keymap.set('n', '<leader>B', xcodebuild.toggle_message_breakpoint, { desc = 'Toggle Message Breakpoint' })
      vim.keymap.set('n', '<leader>dx', xcodebuild.terminate_session, { desc = 'Terminate Debugger' })
    end,
  },
}
