# Plinth

A Claude Code plugin for setting up project working environments.

## Skills Included

### Project Initialization

- `plinth:python-project-init` - Initialize complete Python project with Click-based CLI, documentation, and tooling

### Project Enhancement

- `plinth:fastapi-sweetener` - Add FastAPI server capabilities to existing Python project as CLI subcommand

### macOS Service Management

- `plinth:macos-launchd-service` - Generate complete launchd service infrastructure for auto-starting Python applications

### Release Management

- `plinth:releaserator` - Automated release process with semantic versioning and changelog generation

### Git Workflow

- `plinth:git-workflow-hooks` - Install git hooks to prevent common workflow mistakes (blocks manual version tag pushes)

## Session Tracking

Session management and project tracking skills have moved to the [handoff](https://github.com/pborenstein/handoff) plugin:

- `handoff:project-tracking` - Establish token-efficient documentation structure
- `handoff:session-pickup` - Read CONTEXT.md to resume work in under 2 minutes
- `handoff:session-wrapup` - Update docs and commit at end of session

## Installation

Clone the repository and add it to your Claude Code plugins:

```bash
git clone https://github.com/pborenstein/plinth.git ~/.claude/plugins/plinth
```

Or add as a dependency in your project's `.claude/settings.json`:

```json
{
  "plugins": ["~/.claude/plugins/plinth"]
}
```

## Usage

### Initializing a new Python project

```
/plinth:python-project-init
```

Creates a complete Python project from scratch:

- Gathers project information (name, description, etc.)
- Generates `pyproject.toml` with uv configuration, Click for CLI
- Creates `README.md` and `CLAUDE.md` for documentation
- Sets up project documentation tracking (IMPLEMENTATION.md, CONTEXT.md, DECISIONS.md, chronicles/)
- Creates Python package structure with Click-based CLI entry point
- Generates `.gitignore` and test structure
- Optionally initializes git repository and development environment

After creation: `cd project && uv sync && uv run package --version`

CLI uses Click groups, ready for subcommands (e.g., adding server with fastapi-sweetener).

### macOS launchd Service Setup

**Setting up auto-start service for Python applications:**

```
/plinth:macos-launchd-service
```

Generates complete service infrastructure:

- `launchd/install.sh` - Automated service installer
- `launchd/{project}.plist.template` - Service configuration
- `dev.sh` - Development mode with auto-reload
- `view-logs.sh` - Log viewer with modes

Services auto-start on login, auto-restart on crash, and log to `~/Library/Logs/`.

See [macos-launchd-service README](skills/macos-launchd-service/README.md) for complete guide.

### Adding FastAPI to Existing Project

**Adding FastAPI server to a Python project:**

```
/plinth:fastapi-sweetener
```

Adds FastAPI server capabilities to an existing Python project (created with python-project-init):

- Detects project structure automatically
- Adds `{package}/server.py` - FastAPI app with OpenAPI, CORS, lifespan management
- Adds `{package}/config.py` - Configuration loader (JSON/YAML)
- Updates `{package}/cli.py` - Adds `server` subcommand (converts to Click if needed)
- Updates `pyproject.toml` - Adds fastapi, uvicorn, click dependencies
- Creates `config.example.json` and `.env.example`

**Typical workflow:**

```bash
/plinth:python-project-init   # Create base CLI project
# ... develop CLI functionality ...
/plinth:fastapi-sweetener     # Add API server later
```

**Result:**

```bash
myproject --help       # Shows CLI subcommands
myproject hello        # Runs CLI command
myproject server       # Starts FastAPI server
myproject server --reload --port 8080  # Dev mode
```

See [fastapi-sweetener README](skills/fastapi-sweetener/references/usage.md) for complete guide.

### Release Management

**Creating a release:**

```
/plinth:releaserator
```

Automates the entire release process:

1. Analyzes commits since last release (Conventional Commits)
2. Determines semantic version bump (MAJOR.MINOR.PATCH)
3. Generates Keep A Changelog formatted CHANGELOG.md
4. Updates `.claude-plugin/plugin.json` version
5. Creates git tag (vX.Y.Z)
6. Pushes to remote (with confirmation)
7. Creates GitHub release with generated notes

**Prerequisites:**

- Clean working directory (no uncommitted changes)
- GitHub CLI installed (`brew install gh`)
- Authenticated with GitHub (`gh auth login`)

**Workflow:**

```bash
git status                # Verify clean
/plinth:releaserator      # Create release
```

**Version bumping follows Conventional Commits:**

- MAJOR bump: `BREAKING CHANGE:` or `feat!:`
- MINOR bump: `feat:` commits
- PATCH bump: `fix:` or `perf:` commits
- No bump: `docs:`, `chore:`, etc.

**Changelog format:** [Keep A Changelog](https://keepachangelog.com/)

See [releaserator README](skills/releaserator/README.md) for complete guide.

### Git Workflow Hooks

**Installing workflow protection hooks:**

```
/plinth:git-workflow-hooks
```

Installs git hooks that prevent common workflow mistakes:

**Pre-push Hook:**

- Blocks manual version tag pushes (v*.*.*)
- Displays clear error with correct workflow (/releaserator)
- Allows emergency override with `--no-verify`
- Preserves existing hooks with backup option

**Why use this:**

- Prevents accidentally pushing version tags without running releaserator
- Ensures proper changelog generation and release notes
- Catches mistakes before they reach GitHub

**Testing the hook:**

```bash
git tag v99.99.99
git push origin v99.99.99
# ❌ Blocked! Use /releaserator instead
```

**Emergency override (use sparingly):**

```bash
git push --no-verify origin v99.99.99
```

## Contributing

You're welcome to use this plugin and make changes to it. I'm happy to fix bugs, but if you want new features, you're better off forking.

## License

MIT License - see [LICENSE](LICENSE) file for details
