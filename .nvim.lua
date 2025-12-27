-- Project-specific nvim config for plinth
-- To use this, add 'set exrc' to your main nvim config (~/.config/nvim/init.lua or ~/.vimrc)

-- General settings
vim.opt.number = true              -- Show line numbers
vim.opt.relativenumber = true      -- Relative line numbers for easier jumping
vim.opt.mouse = 'a'                -- Enable mouse support
vim.opt.ignorecase = true          -- Case insensitive search
vim.opt.smartcase = true           -- Unless search has capitals
vim.opt.hlsearch = true            -- Highlight search results
vim.opt.incsearch = true           -- Incremental search
vim.opt.expandtab = true           -- Use spaces instead of tabs
vim.opt.smartindent = true         -- Smart auto-indenting
vim.opt.wrap = true                -- Wrap long lines
vim.opt.breakindent = true         -- Indent wrapped lines
vim.opt.splitright = true          -- Vertical splits open to the right
vim.opt.splitbelow = true          -- Horizontal splits open below
vim.opt.clipboard = 'unnamedplus'  -- Use system clipboard

-- Color scheme (if available)
vim.cmd([[
  silent! colorscheme habamax
]])

-- Markdown-specific settings
vim.api.nvim_create_autocmd("FileType", {
  pattern = {"markdown", "md"},
  callback = function()
    vim.opt_local.spell = true           -- Enable spell check
    vim.opt_local.spelllang = 'en_us'    -- English US dictionary
    vim.opt_local.conceallevel = 2       -- Conceal markdown syntax for cleaner view
    vim.opt_local.wrap = true            -- Wrap long lines
    vim.opt_local.linebreak = true       -- Break lines at word boundaries
    vim.opt_local.textwidth = 0          -- No hard wrapping
    vim.opt_local.shiftwidth = 2         -- 2 space indents
    vim.opt_local.tabstop = 2            -- Tab = 2 spaces
  end,
})

-- Python-specific settings
vim.api.nvim_create_autocmd("FileType", {
  pattern = "python",
  callback = function()
    vim.opt_local.shiftwidth = 4         -- 4 space indents (PEP 8)
    vim.opt_local.tabstop = 4            -- Tab = 4 spaces
    vim.opt_local.softtabstop = 4        -- Backspace removes 4 spaces
    vim.opt_local.expandtab = true       -- Use spaces, not tabs
    vim.opt_local.textwidth = 88         -- Black formatter default
    vim.opt_local.colorcolumn = '89'     -- Visual guide at 89 chars

    -- Highlight trailing whitespace
    vim.cmd([[match ErrorMsg '\s\+$']])
  end,
})

-- Key mappings
local keymap = vim.keymap.set

-- Leader key
vim.g.mapleader = ' '

-- Quick save
keymap('n', '<leader>w', ':w<CR>', { desc = 'Save file' })

-- Quick quit
keymap('n', '<leader>q', ':q<CR>', { desc = 'Quit' })

-- Clear search highlighting
keymap('n', '<leader>h', ':nohlsearch<CR>', { desc = 'Clear search highlight' })

-- Better window navigation
keymap('n', '<C-h>', '<C-w>h', { desc = 'Move to left window' })
keymap('n', '<C-j>', '<C-w>j', { desc = 'Move to window below' })
keymap('n', '<C-k>', '<C-w>k', { desc = 'Move to window above' })
keymap('n', '<C-l>', '<C-w>l', { desc = 'Move to right window' })

-- Markdown helpers
keymap('n', '<leader>mb', 'viw<Esc>a**<Esc>bi**<Esc>', { desc = 'Make word bold' })
keymap('n', '<leader>mi', 'viw<Esc>a*<Esc>bi*<Esc>', { desc = 'Make word italic' })
keymap('n', '<leader>mc', 'viw<Esc>a`<Esc>bi`<Esc>', { desc = 'Make word code' })

-- Markdown navigation
keymap('n', ']]', '/^#\\+\\s<CR>:nohlsearch<CR>', { desc = 'Next heading', silent = true })
keymap('n', '[[', '?^#\\+\\s<CR>:nohlsearch<CR>', { desc = 'Previous heading', silent = true })
keymap('n', '][', '/^##\\+\\s<CR>:nohlsearch<CR>', { desc = 'Next subheading', silent = true })
keymap('n', '[]', '?^##\\+\\s<CR>:nohlsearch<CR>', { desc = 'Previous subheading', silent = true })

-- Python helpers
keymap('n', '<leader>pb', 'obreakpoint()<Esc>', { desc = 'Insert breakpoint' })

-- File explorer
keymap('n', '<leader>e', ':Explore<CR>', { desc = 'Open file explorer' })

-- Quick reference
keymap('n', '<leader>k', function()
  local help_text = {
    "=== plinth nvim Quick Reference ===",
    "",
    "Leader key: SPACE",
    "",
    "General:",
    "  <leader>w  - Save file",
    "  <leader>q  - Quit",
    "  <leader>h  - Clear search highlight",
    "  <leader>e  - File explorer",
    "  <leader>k  - Show this help",
    "",
    "Windows:",
    "  Ctrl-h/j/k/l - Navigate between windows",
    "",
    "Markdown:",
    "  <leader>mb - Bold word under cursor",
    "  <leader>mi - Italic word under cursor",
    "  <leader>mc - Code format word under cursor",
    "  ]]         - Next heading (any level)",
    "  [[         - Previous heading (any level)",
    "  ][         - Next subheading (## or deeper)",
    "  []         - Previous subheading (## or deeper)",
    "",
    "Python:",
    "  <leader>pb - Insert breakpoint",
    "",
    "Press q to close this help",
  }

  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, help_text)
  vim.api.nvim_buf_set_option(buf, 'modifiable', false)

  local width = 50
  local height = #help_text
  local win = vim.api.nvim_open_win(buf, true, {
    relative = 'editor',
    width = width,
    height = height,
    col = (vim.o.columns - width) / 2,
    row = (vim.o.lines - height) / 2,
    style = 'minimal',
    border = 'rounded',
  })

  vim.api.nvim_buf_set_keymap(buf, 'n', 'q', ':close<CR>', { noremap = true, silent = true })
end, { desc = 'Show quick reference' })
