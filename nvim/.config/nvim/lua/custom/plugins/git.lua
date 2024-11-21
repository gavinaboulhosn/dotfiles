return {
  {
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add = { text = '│' }, -- Vertical bar for added lines
        change = { text = '│' },
        delete = { text = '▶' }, -- Small arrow showing where line was deleted
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
        untracked = { text = '┆' }, -- Dotted line for untracked files
      },
      signcolumn = true,
      word_diff = true, -- Show word diff in changed lines
      current_line_blame = true,
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = 'right_align',
        delay = 200, -- Faster blame display
        ignore_whitespace = true,
        virt_text_priority = 100,
      },
      current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> • <summary>',
      preview_config = {
        border = 'rounded',
        style = 'minimal',
        relative = 'cursor',
        row = 0,
        col = 1,
      },
      -- Fun stuff: watch changes happen in real time
      watch_gitdir = {
        interval = 100,
        follow_files = true,
      },
      attach_to_untracked = true,
      on_attach = function(bufnr)
        local gs = require 'gitsigns'

        local function map(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
        end

        -- Navigation
        map('n', ']c', function()
          if vim.wo.diff then
            return ']c'
          end
          vim.schedule(function()
            gs.next_hunk()
            -- Center the view on the hunk
            vim.cmd 'normal! zz'
          end)
          return '<Ignore>'
        end, 'Next Git hunk')

        map('n', '[c', function()
          if vim.wo.diff then
            return '[c'
          end
          vim.schedule(function()
            gs.prev_hunk()
            vim.cmd 'normal! zz'
          end)
          return '<Ignore>'
        end, 'Previous Git hunk')

        -- Actions
        map('n', '<leader>hs', gs.stage_hunk, 'Stage hunk')
        map('n', '<leader>hr', gs.reset_hunk, 'Reset hunk')
        map('v', '<leader>hs', function()
          gs.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, 'Stage selected hunk')
        map('v', '<leader>hr', function()
          gs.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, 'Reset selected hunk')
        map('n', '<leader>hS', gs.stage_buffer, 'Stage buffer')
        map('n', '<leader>hu', gs.undo_stage_hunk, 'Undo stage hunk')
        map('n', '<leader>hR', gs.reset_buffer, 'Reset buffer')

        -- Enhanced preview with centering
        map('n', '<leader>hp', function()
          gs.preview_hunk()
          -- Auto-close preview after a delay
          vim.defer_fn(function()
            vim.cmd 'pclose'
          end, 2000)
        end, 'Preview git hunk')

        -- Enhanced blame with full commit info
        map('n', '<leader>hb', function()
          gs.blame_line { full = true, ignore_whitespace = true }
        end, 'Blame line')

        -- Toggle signs
        map('n', '<leader>tb', gs.toggle_current_line_blame, 'Toggle git blame')
        map('n', '<leader>td', gs.toggle_deleted, 'Toggle git deleted')
        map('n', '<leader>tw', gs.toggle_word_diff, 'Toggle word diff')

        -- Enhanced diff view
        map('n', '<leader>hd', function()
          gs.diffthis()
          -- Make the diff window more readable
          vim.schedule(function()
            vim.cmd 'wincmd p'
            vim.cmd 'set wrap'
            vim.cmd 'set linebreak'
          end)
        end, 'Diff against index')

        -- Text object
        map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>', 'Select git hunk')
      end,
      -- Fun status line integrations
      status_formatter = function(status)
        local added, changed, removed = status.added, status.changed, status.removed
        local status_txt = {}
        if added and added > 0 then
          table.insert(status_txt, '+' .. added)
        end
        if changed and changed > 0 then
          table.insert(status_txt, '~' .. changed)
        end
        if removed and removed > 0 then
          table.insert(status_txt, '-' .. removed)
        end
        return table.concat(status_txt, ' ')
      end,
      max_file_length = 40000, -- Support larger files
    },
  },
}
