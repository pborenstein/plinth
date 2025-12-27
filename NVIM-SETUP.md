# Nvim Setup for plinth

This directory has a project-specific nvim configuration optimized for markdown and python development.

## Files Created

- `/Users/philip/.config/nvim/init.lua` - Main nvim configuration (enables project configs)
- `/Users/philip/projects/plinth/.nvim.lua` - Project-specific configuration

## How It Works

When you open nvim in this directory, it automatically loads `.nvim.lua` with custom settings for markdown and python files. The global config has `exrc` enabled to allow this.

## Features

### General

- Line numbers with relative numbering
- Mouse support enabled
- Smart case-insensitive search
- System clipboard integration
- Split windows open right/below
- Syntax highlighting

### Markdown Files

- Automatic spell checking (US English)
- Line wrapping at word boundaries
- Concealment level 2 (cleaner rendering of markdown syntax)
- 2-space indentation

### Python Files

- 4-space indentation (PEP 8)
- 88 character line width (Black formatter default)
- Visual guide at column 89
- Trailing whitespace highlighting

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

### Window Navigation

| Shortcut | Action |
|----------|--------|
| `Ctrl + h` | Move to left window |
| `Ctrl + j` | Move to window below |
| `Ctrl + k` | Move to window above |
| `Ctrl + l` | Move to right window |

### Markdown Helpers

| Shortcut | Action |
|----------|--------|
| `Space + mb` | Make word under cursor **bold** |
| `Space + mi` | Make word under cursor *italic* |
| `Space + mc` | Make word under cursor `code` |
| `]]` | Jump to next heading (any level) |
| `[[` | Jump to previous heading (any level) |
| `][` | Jump to next subheading (## or deeper) |
| `[]` | Jump to previous subheading (## or deeper) |

### Python Helpers

| Shortcut | Action |
|----------|--------|
| `Space + pb` | Insert breakpoint() on new line |

## Quick Reference

Press `Space + k` while in nvim to see a popup with all shortcuts.

## Customization

To modify settings:

- Edit `~/.config/nvim/init.lua` for global settings
- Edit `.nvim.lua` in this directory for project-specific settings

## Security Note

The global config has `secure = true` set, which prevents project configs from executing shell commands or writing files, protecting against malicious project configs.
