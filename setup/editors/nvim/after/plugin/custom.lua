-- System clipboard by default
vim.opt.clipboard = 'unnamedplus'

-- Auto-refresh buffers when files change outside nvim
vim.opt.autoread = true
vim.api.nvim_create_autocmd({ 'FocusGained', 'BufEnter', 'CursorHold', 'CursorHoldI' }, {
  pattern = '*',
  callback = function()
    if vim.fn.mode() ~= 'c' then
      vim.cmd 'checktime'
    end
  end,
})

-- jj to exit insert mode
vim.keymap.set('i', 'jj', '<Esc>', { desc = 'Exit insert mode' })

-- Tab to accept completion suggestions
vim.keymap.set('i', '<Tab>', function()
  local cmp_ok, cmp = pcall(require, 'cmp')
  if cmp_ok and cmp.visible() then
    cmp.confirm { select = true }
  else
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Tab>', true, true, true), 'n', false)
  end
end, { desc = 'Accept completion or Tab' })
