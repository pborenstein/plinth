---
description: Set up Python development environment using uv package manager
---

# Python Environment Setup

Set up Python development environment for an existing project using uv package manager.

**Note**: For creating a new Python project from scratch, use `/python-project-init` instead.

## Prerequisites Check

1. Verify uv is installed:

   ```bash
   which uv
   ```

   If not found, install via homebrew:

   ```bash
   brew install uv
   ```

2. Verify project has `pyproject.toml`:

   ```bash
   ls pyproject.toml
   ```

## Setup Tasks

1. **Sync dependencies and create virtual environment**:

   ```bash
   uv sync
   ```

   This will:
   - Create `.venv/` directory if it doesn't exist
   - Install all dependencies from `pyproject.toml`
   - Lock dependencies in `uv.lock`
   - Handle local path dependencies automatically

2. **Set up environment file** (if `.env.example` exists):

   ```bash
   if [ -f .env.example ] && [ ! -f .env ]; then
     cp .env.example .env
     echo "Created .env from template. Edit as needed."
   fi
   ```

3. **Verify installation**:

   ```bash
   uv run python --version
   ```

   If project has a CLI tool defined in `[project.scripts]`:

   ```bash
   # Check the CLI tool name in pyproject.toml [project.scripts] section
   # Then run: uv run <tool-name> --help
   ```

## Running Commands

You don't need to activate the virtual environment. Use `uv run` instead:

```bash
# Run Python scripts
uv run python script.py

# Run CLI tools defined in project
uv run <tool-name> <args>

# Run tests
uv run pytest

# Run with development dependencies
uv run --group dev pytest
```

## Activating Virtual Environment (Optional)

If you prefer to activate the environment:

```bash
# bash/zsh
source .venv/bin/activate

# fish
source .venv/bin/activate.fish
```

## Common Issues

### Missing System Python

If you see "python not found" errors:

```bash
# Install Python via homebrew
brew install python@3.13

# Or use pyenv to manage Python versions
brew install pyenv
pyenv install 3.13
```

### Local Path Dependencies Not Found

If project depends on local packages (like `nahuatl-frontmatter`), ensure:

1. Parent directory structure matches `[tool.uv.sources]` in `pyproject.toml`
2. Local dependency has been synced:

   ```bash
   cd ../nahuatl-frontmatter
   uv sync
   cd -
   uv sync
   ```

## After Setup

You're ready to work when:

- `.venv/` directory exists
- `uv.lock` file is present
- `uv run python --version` shows correct Python version
- Project-specific CLI tools run with `uv run <tool-name> --help`

$ARGUMENTS
