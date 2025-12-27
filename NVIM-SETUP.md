# Nvim Setup for plinth

Modern nvim configuration optimized for technical documentation in markdown and python development.

## What's Installed

### Plugin Manager

**lazy.nvim** - Modern plugin manager that auto-installs on first nvim launch

### Plugins

**For Markdown:**

- **render-markdown.nvim** - Beautiful in-editor rendering with formatted headings, code blocks, and bullets
- **markdown-preview.nvim** - Live preview in browser with dark mode
- **Marksman LSP** - Navigation, document symbols, cross-file links, rename support

**For Python:**

- **pyright** - Python language server for type checking and IntelliSense

**Core:**

- **nvim-treesitter** - Advanced syntax highlighting for markdown, python, lua, vim
- **nvim-lspconfig** - LSP client configuration

## Files Created

- `/Users/philip/.config/nvim/init.lua` - Main nvim configuration with lazy.nvim and plugins
- `/Users/philip/projects/plinth/.nvim.lua` - Project-specific keybindings and settings

## First Launch

On first launch, nvim will automatically:

1. Clone lazy.nvim plugin manager
2. Install all configured plugins
3. Download treesitter parsers for markdown and python
4. Connect to Marksman and pyright LSP servers

This takes about 30 seconds. Just wait for it to complete.

## Features

### General

- Line numbers with relative numbering
- Mouse support enabled
- Smart case-insensitive search
- System clipboard integration
- Split windows open right/below
- Treesitter syntax highlighting

### Markdown Files

- **Beautiful rendering** - Headings, code blocks, and lists display with visual formatting
- **Live preview** - `:MarkdownPreview` opens browser preview
- **LSP features** - Document symbols, go to definition, rename across files
- **Spell checking** - Automatic US English spell check
- **Line wrapping** - Wraps at word boundaries
- **2-space indentation**

### Python Files

- **LSP features** - Type checking, autocomplete, go to definition, find references
- **4-space indentation** (PEP 8)
- **88 character line width** (Black formatter default)
- **Visual guide at column 89**
- **Trailing whitespace highlighting**

## Keyboard Shortcuts

### Leader Key

The leader key is **Space**

### General Commands

| Shortcut | Action |
|----------|--------|
| `Space + w` | Save file |
| `Space + q` | Quit |
| `Space + h` | Clear search highlight |
| `Space + e` | Open file explorer |
| `Space + k` | Show quick reference help |

### Plugin Manager

| Shortcut | Action |
|----------|--------|
| `:Lazy` | Open plugin manager UI |
| `:Lazy sync` | Update all plugins |
| `:Lazy clean` | Remove unused plugins |

### Window Navigation

| Shortcut | Action |
|----------|--------|
| `Ctrl + h` | Move to left window |
| `Ctrl + j` | Move to window below |
| `Ctrl + k` | Move to window above |
| `Ctrl + l` | Move to right window |

### Markdown Commands

| Command | Action |
|---------|--------|
| `:MarkdownPreview` | Open live preview in browser |
| `:MarkdownPreviewStop` | Stop preview |
| `:RenderMarkdown toggle` | Toggle in-editor rendering |

### Markdown Shortcuts

| Shortcut | Action |
|----------|--------|
| `Space + mb` | Make word under cursor **bold** |
| `Space + mi` | Make word under cursor *italic* |
| `Space + mc` | Make word under cursor `code` |
| `]]` | Jump to next heading (any level) |
| `[[` | Jump to previous heading (any level) |
| `][` | Jump to next subheading (## or deeper) |
| `[]` | Jump to previous subheading (## or deeper) |

### LSP Shortcuts (works in markdown and python)

| Shortcut | Action |
|----------|--------|
| `gd` | Go to definition |
| `gr` | Find references |
| `K` | Show hover documentation |
| `<leader>rn` | Rename symbol |
| `[d` | Previous diagnostic |
| `]d` | Next diagnostic |

### Python Helpers

| Shortcut | Action |
|----------|--------|
| `Space + pb` | Insert breakpoint() on new line |

## Quick Reference

Press `Space + k` while in nvim to see a popup with all shortcuts.

## Customization

To modify settings:

- Edit `~/.config/nvim/init.lua` for global settings and plugins
- Edit `.nvim.lua` in this directory for project-specific keybindings

To add more plugins, edit `~/.config/nvim/init.lua` and add them to the `require("lazy").setup({})` table.

## Installed LSP Servers

These were installed via homebrew:

- `marksman` - Markdown language server
- `pyright` - Python language server

## Security Note

The global config has `secure = true` set, which prevents project configs from executing shell commands or writing files, protecting against malicious project configs.

## Resources

Modern markdown setup based on 2025 best practices. See:

- [render-markdown.nvim](https://github.com/MeanderingProgrammer/render-markdown.nvim)
- [markdown-preview.nvim](https://github.com/iamcco/markdown-preview.nvim)
- [Marksman LSP](https://github.com/artempyanykh/marksman)
- [lazy.nvim](https://github.com/folke/lazy.nvim)
