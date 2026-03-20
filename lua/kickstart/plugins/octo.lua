return {
  {
    'pwntester/octo.nvim',
    cmd = 'Octo',
    opts = {
      enable_builtin = true,
      picker = 'telescope',
      default_remote = { 'upstream', 'origin' },
      default_merge_method = 'merge',
      default_delete_branch = false,
      users = 'search',
      ui = {
        use_signcolumn = false,
        use_statuscolumn = true,
      },
      issues = {
        order_by = {
          field = 'CREATED_AT',
          direction = 'DESC',
        },
      },
      reviews = {
        auto_show_threads = true,
        focus = 'right',
      },
      pull_requests = {
        order_by = {
          field = 'CREATED_AT',
          direction = 'DESC',
        },
        always_select_remote_on_create = false,
        use_branch_name_as_title = false,
      },
      notifications = {
        current_repo_only = false,
      },
      poll = {
        enabled = false,
        interval = 10000,
        notify_on_refresh = true,
        notify_on_change = true,
      },
      file_panel = {
        size = 10,
        use_icons = true,
      },
      mappings_disable_default = false,
    },
    keys = {
      {
        '<leader>oi',
        '<CMD>Octo issue list<CR>',
        desc = 'List GitHub Issues',
      },
      {
        '<leader>op',
        '<CMD>Octo pr list<CR>',
        desc = 'List GitHub PullRequests',
      },
      {
        '<leader>od',
        '<CMD>Octo discussion list<CR>',
        desc = 'List GitHub Discussions',
      },
      {
        '<leader>on',
        '<CMD>Octo notification list<CR>',
        desc = 'List GitHub Notifications',
      },
      {
        '<leader>os',
        function()
          require('octo.utils').create_base_search_command { include_current_repo = true }
        end,
        desc = 'Search GitHub',
      },
    },
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope.nvim',
      'nvim-tree/nvim-web-devicons',
    },
  },
}
