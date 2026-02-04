return {
  {
    'github/copilot.vim',
    cmd = 'Copilot', -- Only load when you run :Copilot command
    -- Remove event = "InsertEnter" so it doesn't auto-load
    config = function()
      --vim.g.copilot_no_tab_map = true
      --vim.keymap.set('i', '<Tab>', 'copilot#Accept("\\<CR>")', {
      --  expr = true,
      --  replace_keycodes = false,
      --})

      vim.keymap.set('i', '<M-]>', '<Plug>(copilot-next)')
      vim.keymap.set('i', '<M-[>', '<Plug>(copilot-previous)')
      vim.keymap.set('i', '<C-]>', '<Plug>(copilot-dismiss)')
    end,
  },
  {
    'CopilotC-Nvim/CopilotChat.nvim',
    branch = 'main',
    dependencies = {
      { 'zbirenbaum/copilot.lua' },
      { 'nvim-lua/plenary.nvim', branch = 'master' },
    },
    opts = {
      debug = false, -- Set to true to see logs
      -- See configuration options below
    },
    keys = {
      -- Example keymaps:
      { '<leader>zc', ':CopilotChat<CR>', mode = 'n', desc = 'Chat with Copilot' },
      { '<leader>ze', ':CopilotChatExplain<CR>', mode = 'v', desc = 'Explain code' },
      { '<leader>zr', ':CopilotChatReview<CR>', mode = 'v', desc = 'Review code' },
      { '<leader>zf', ':CopilotChatFix<CR>', mode = 'v', desc = 'Fix Code Issues' },
      { '<leader>zo', ':CopilotChatOptimize<CR>', mode = 'v', desc = 'Optimize code' },
      { '<leader>zd', ':CopilotChatDocs<CR>', mode = 'v', desc = 'Generate Docs' },
      { '<leader>zt', ':CopilotChatTests<CR>', mode = 'v', desc = 'Generate Tests' },
    },
  },
}
