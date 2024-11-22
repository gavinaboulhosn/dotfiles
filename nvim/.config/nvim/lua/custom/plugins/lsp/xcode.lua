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
        restore_on_start = true,
        auto_save = true,
        show_build_output_in_float = true,
        logs = {
          auto_show_on_error = true,
          auto_show_on_run = true,
          auto_focus = true,
          auto_close_on_success = true,
        },
        tests = {
          auto_focus = true,
          auto_run_last = false,
          auto_close_on_success = {
            running = true,
            building = true,
          },
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
}
