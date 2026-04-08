return {
  -- LazyGit integration (lazygit binary installed via homebrew)
  {
    'kdheepak/lazygit.nvim',
    lazy = true,
    cmd = {
      'LazyGit',
      'LazyGitConfig',
      'LazyGitCurrentFile',
      'LazyGitFilter',
      'LazyGitFilterCurrentFile',
    },
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    keys = {
      { '<leader>gg', '<cmd>LazyGit<cr>', desc = 'LazyGit' },
    },
  },

  -- Diffview for git diffs and merge conflicts
  {
    'sindrets/diffview.nvim',
    lazy = true,
    cmd = {
      'DiffviewOpen',
      'DiffviewClose',
      'DiffviewToggleFiles',
      'DiffviewFocusFiles',
      'DiffviewFileHistory',
    },
    keys = {
      { '<leader>gd', '<cmd>DiffviewOpen<cr>', desc = 'Diff View' },
      { '<leader>gh', '<cmd>DiffviewFileHistory %<cr>', desc = 'File History' },
    },
  },
}
