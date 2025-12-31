# Plinth

A Claude Code plugin for setting up project working environments and documentation tracking.

## What's Included

### Commands

**Session Management**

- `/session-pickup` - Read project documentation to prepare for new work
- `/session-wrapup` - Update project documentation at end of session

**Project Initialization**

- `/python-project-init` - Initialize complete Python project with documentation, environment setup, and tooling

**Development Environment**

- `/python-env-setup` - Set up Python development environment for existing projects using uv

### Skills

**Project Tracking**

- `project-tracking` - Establish four-file system for tracking project progress

**macOS Service Management**

- `macos-launchd-service` - Generate complete launchd service infrastructure for auto-starting Python applications

**FastAPI Project Scaffolding**

- `fastapi-scaffold` - Generate production-ready FastAPI project with uvicorn, OpenAPI docs, and configuration management

## Installation

[Installation instructions TBD]

## Usage

### Session Management

**Starting a work session:**

```
/session-pickup
```

Reads `docs/IMPLEMENTATION.md` (current phase), `docs/CHRONICLES.md` (latest entries), and `docs/DECISIONS.md` to prepare for work.

**Ending a work session:**

```
/session-wrapup
```

Updates project documentation:

- Update IMPLEMENTATION.md task status
- Add chronicle entry to chronicles/phase-X.md
- Update DECISIONS.md if architectural decisions were made
- Update CHRONICLES.md index
- Commit documentation changes

**Initializing a new Python project:**

```
/python-project-init
```

Creates a complete Python project from scratch:

- Gathers project information (name, description, etc.)
- Generates `pyproject.toml` with uv configuration and dev tools
- Creates `README.md` and `CLAUDE.md` for documentation
- Sets up project documentation tracking (IMPLEMENTATION.md, CHRONICLES.md, DECISIONS.md)
- Creates Python package structure with CLI entry point
- Generates `.gitignore` and test structure
- Optionally initializes git repository and development environment

After creation: `cd project && uv sync && uv run package --version`

**Setting up environment for existing Python project:**

```
/python-env-setup
```

Sets up Python development environment for projects that already have a `pyproject.toml`:

- Verifies uv package manager is installed
- Runs `uv sync` to create virtual environment and install dependencies
- Copies `.env.example` to `.env` if present
- Verifies installation with version checks

### macOS launchd Service Setup

**Setting up auto-start service for Python applications:**

```
/macos-launchd-service
```

Generates complete service infrastructure:

- `launchd/install.sh` - Automated service installer
- `launchd/{project}.plist.template` - Service configuration
- `dev.sh` - Development mode with auto-reload
- `view-logs.sh` - Log viewer with modes

Services auto-start on login, auto-restart on crash, and log to `~/Library/Logs/`.

See [macos-launchd-service README](skills/macos-launchd-service/README.md) for complete guide.

### FastAPI Project Scaffold

**Creating a new FastAPI project:**

```
/fastapi-scaffold
```

Generates a production-ready FastAPI project:

- `pyproject.toml` - uv-based project config with FastAPI dependencies
- `{package}/server.py` - FastAPI app with OpenAPI, CORS, lifespan management
- `{package}/__main__.py` - CLI entry point with argparse + uvicorn
- `{package}/config.py` - Configuration loader (JSON/YAML, multiple search paths)
- `{package}/__version__.py` - Version management via importlib.metadata
- `.gitignore`, `.env.example`, `README.md`

After generation: `cd project && uv sync && uv run package --reload`

See [fastapi-scaffold README](skills/fastapi-scaffold/README.md) for complete guide.

### Project Tracking

**Setting up project tracking for a new or existing project:**

```
/project-tracking
```

Creates and maintains:

- `docs/IMPLEMENTATION.md` - Living todo list for current phase
- `docs/CHRONICLES.md` - Navigation index for project history
- `docs/DECISIONS.md` - Registry of architectural decisions
- `docs/chronicles/phase-X.md` - Detailed session-by-session implementation notes

See [DOCUMENTATION-GUIDE.md](skills/project-tracking/DOCUMENTATION-GUIDE.md) for complete documentation system explanation.

## Documentation System Overview

The project documentation tracking system separates concerns for fast session pickup:

- **IMPLEMENTATION.md** - "What we're doing now" (current phase detailed, completed phases summarized)
- **CHRONICLES.md** - "How to navigate the history" (index only, not content)
- **DECISIONS.md** - "What we decided" (decision registry with links to detailed rationale)
- **chronicles/phase-X.md** - "The detailed story" (session-by-session implementation notes)

**Goal:** Start new session in under 5 minutes by reading IMPLEMENTATION.md current phase section (~200 lines).

**Example**: Plinth uses its own documentation system - see [docs/](docs/) for a real-world implementation.

## Templates

Templates are provided for:

- Chronicle entries
- Decision documentation
- DECISIONS.md table rows

Located in `skills/project-tracking/templates/`

## Contributing

[Contribution guidelines TBD]

## License

MIT License - see [LICENSE](LICENSE) file for details
