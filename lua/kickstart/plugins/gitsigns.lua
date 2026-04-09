-- Adds git related signs to the gutter, as well as utilities for managing changes
-- NOTE: gitsigns is already included in init.lua but contains only the base
-- config. This will add also the recommended keymaps.

-- Diffview integration for gitsigns blame buffers
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'gitsigns-blame',
  callback = function(args)
    local bufnr = args.buf

    local function get_sha()
      local buf_lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
      local row = vim.api.nvim_win_get_cursor(0)[1]
      for i = row, 1, -1 do
        local sha = buf_lines[i]:match '(%x%x%x%x%x%x%x%x+)'
        if sha then return sha end
      end
    end

    local function get_parents(sha)
      local output = vim.fn.systemlist('git rev-list --parents -n 1 ' .. sha)[1]
      local parents = {}
      for word in string.gmatch(output, '%S+') do
        table.insert(parents, word)
      end
      table.remove(parents, 1)
      return parents
    end

    local function get_commit_msg(sha)
      return vim.fn.systemlist('git log -n 1 --pretty=%s ' .. sha)[1] or ''
    end

    local function open_diff(sha, parent_index)
      require('diffview')
      vim.cmd('DiffviewOpen ' .. sha .. '^' .. parent_index .. '..' .. sha)
    end

    -- D → open commit in Diffview (with parent picker for merge commits)
    vim.keymap.set('n', 'D', function()
      local sha = get_sha()
      if not sha then return end

      local parents = get_parents(sha)
      if #parents <= 1 then
        require('diffview')
        vim.cmd('DiffviewOpen ' .. sha .. '^!')
      else
        local choices = {}
        for i, parent in ipairs(parents) do
          local msg = get_commit_msg(parent)
          table.insert(choices, string.format('Parent %d: %s (%s)', i, parent:sub(1, 7), msg))
        end
        vim.ui.select(choices, { prompt = 'Select parent to diff against:' }, function(choice)
          if not choice then return end
          local idx = tonumber(choice:match 'Parent (%d+)')
          open_diff(sha, idx)
        end)
      end
    end, { buffer = bufnr, desc = 'Show commit in Diffview' })

    -- E → diff against second parent (merge commits only)
    vim.keymap.set('n', 'E', function()
      local sha = get_sha()
      if not sha then return end
      open_diff(sha, 2)
    end, { buffer = bufnr, desc = 'Diff vs parent 2' })

    -- Add Diffview entries to the blame popup menu (shown on <CR>)
    vim.schedule(function()
      vim.cmd([[nmenu <silent> ]GitsignsBlame.Show\ commit\ (D) D]])

      -- Override <CR> to dynamically show/hide the merge commit option
      vim.keymap.set('n', '<CR>', function()
        local sha = get_sha()
        if sha then
          local parents = get_parents(sha)
          if #parents > 1 then
            pcall(vim.cmd, [[nmenu <silent> ]GitsignsBlame.Diff\ parent\ 2\ (E) E]])
          else
            pcall(vim.cmd, [[nunmenu ]GitsignsBlame.Diff\ parent\ 2\ (E)]])
          end
        end
        vim.cmd.popup(']GitsignsBlame')
      end, { buffer = bufnr, desc = 'Open blame context menu' })
    end)
  end,
})

return {
  {
    'lewis6991/gitsigns.nvim',
    opts = {
      on_attach = function(bufnr)
        local gitsigns = require 'gitsigns'

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map('n', ']c', function()
          if vim.wo.diff then
            vim.cmd.normal { ']c', bang = true }
          else
            gitsigns.nav_hunk 'next'
          end
        end, { desc = 'Jump to next git [c]hange' })

        map('n', '[c', function()
          if vim.wo.diff then
            vim.cmd.normal { '[c', bang = true }
          else
            gitsigns.nav_hunk 'prev'
          end
        end, { desc = 'Jump to previous git [c]hange' })

        -- Actions
        -- visual mode
        map('v', '<leader>hs', function() gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' } end, { desc = 'git [s]tage hunk' })
        map('v', '<leader>hr', function() gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' } end, { desc = 'git [r]eset hunk' })
        -- normal mode
        map('n', '<leader>hs', gitsigns.stage_hunk, { desc = 'git [s]tage hunk' })
        map('n', '<leader>hr', gitsigns.reset_hunk, { desc = 'git [r]eset hunk' })
        map('n', '<leader>hS', gitsigns.stage_buffer, { desc = 'git [S]tage buffer' })
        map('n', '<leader>hu', gitsigns.stage_hunk, { desc = 'git [u]ndo stage hunk' })
        map('n', '<leader>hR', gitsigns.reset_buffer, { desc = 'git [R]eset buffer' })
        map('n', '<leader>hp', gitsigns.preview_hunk, { desc = 'git [p]review hunk' })
        map('n', '<leader>hb', gitsigns.blame_line, { desc = 'git [b]lame line' })
        map('n', '<leader>hB', gitsigns.blame, { desc = 'git [B]lame' })
        map('n', '<leader>hd', gitsigns.diffthis, { desc = 'git [d]iff against index' })
        map('n', '<leader>hD', function() gitsigns.diffthis '@' end, { desc = 'git [D]iff against last commit' })
        -- Toggles
        map('n', '<leader>tb', gitsigns.toggle_current_line_blame, { desc = '[T]oggle git show [b]lame line' })
        map('n', '<leader>tD', gitsigns.preview_hunk_inline, { desc = '[T]oggle git show [D]eleted' })
      end,
      sign_priority = 100,
    },
  },
}
