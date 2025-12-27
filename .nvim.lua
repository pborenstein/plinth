-- Project-specific nvim config for plinth

-- General visual settings
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.wrap = true
vim.opt.breakindent = true

-- Markdown settings
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.opt_local.spell = true
    vim.opt_local.spelllang = 'en_us'
    vim.opt_local.linebreak = true
    vim.opt_local.shiftwidth = 2
    vim.opt_local.tabstop = 2

    -- Simple folding by heading level
    vim.opt_local.foldmethod = 'expr'
    vim.opt_local.foldexpr = 'v:lua.MarkdownFoldLevel(v:lnum)'
    vim.opt_local.foldlevel = 1
  end,
})

-- Python settings
vim.api.nvim_create_autocmd("FileType", {
  pattern = "python",
  callback = function()
    vim.opt_local.shiftwidth = 4
    vim.opt_local.tabstop = 4
    vim.opt_local.colorcolumn = '89'
  end,
})

-- Markdown folding function
function _G.MarkdownFoldLevel(lnum)
  local line = vim.fn.getline(lnum)
  local heading = line:match('^(#+)%s')
  if heading then
    return '>' .. tostring(#heading)
  end
  return '='
end

-- Keybindings
local map = vim.keymap.set

-- General
map('n', '<leader>w', ':w<CR>')
map('n', '<leader>q', ':q<CR>')
map('n', '<leader>h', ':nohlsearch<CR>')

-- Window navigation
map('n', '<C-h>', '<C-w>h')
map('n', '<C-j>', '<C-w>j')
map('n', '<C-k>', '<C-w>k')
map('n', '<C-l>', '<C-w>l')

-- Markdown
map('n', '<leader>mp', ':!glow %<CR>')
map('n', ']]', '/^#\\+\\s<CR>:nohlsearch<CR>', { silent = true })
map('n', '[[', '?^#\\+\\s<CR>:nohlsearch<CR>', { silent = true })

-- Folding
map('n', '<leader>z', 'za')  -- toggle fold
