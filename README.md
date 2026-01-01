# Plinth

A Claude Code plugin for setting up project working environments and documentation tracking.

## What's Included

### Commands

**Session Management**

- `/session-pickup` - Read project documentation to prepare for new work (reads CONTEXT.md for fast 50-line pickup)
- `/session-wrapup` - Update project documentation at end of session
- `/migrate-to-token-efficient` - Migrate existing documentation to token-efficient system

**Project Initialization**

- `/python-project-init` - Initialize complete Python project with documentation, environment setup, and tooling

**Development Environment**

- `/python-env-setup` - Set up Python development environment for existing projects using uv

### Skills

**Project Tracking**

- `project-tracking` - Establish token-efficient documentation system for tracking project progress

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

Reads `docs/CONTEXT.md` (30-50 lines of current session state) for fast pickup. Falls back to `docs/IMPLEMENTATION.md` if CONTEXT.md is missing.

**Ending a work session:**

```
/session-wrapup
```

Updates project documentation:

- Update CONTEXT.md with current focus and tasks
- Update IMPLEMENTATION.md task checkboxes
- Add chronicle entry to chronicles/phase-X.md (if significant work done)
- Update DECISIONS.md if architectural decisions were made
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

Creates and maintains token-efficient documentation:

- `docs/CONTEXT.md` - Current session state (30-50 lines, hot state for instant pickup)
- `docs/IMPLEMENTATION.md` - Living todo list for current phase (400-600 lines)
- `docs/DECISIONS.md` - Registry of architectural decisions (heading-based, grep-friendly)
- `docs/chronicles/phase-X.md` - Detailed session-by-session implementation notes (slim entries)

**Migrating existing documentation:**

```
/migrate-to-token-efficient
```

Converts legacy documentation to token-efficient format:
- Creates CONTEXT.md from current phase
- Compresses completed phases in IMPLEMENTATION.md
- Converts DECISIONS.md to heading-based format
- Eliminates CHRONICLES.md index file

See [DOCUMENTATION-GUIDE.md](skills/project-tracking/DOCUMENTATION-GUIDE.md) for complete documentation system explanation.

## Documentation System Overview (Token-Efficient)

The project documentation tracking system separates **hot state** (current session) from **cold storage** (history):

- **CONTEXT.md** - "Current session state" (30-50 lines, read every session)
- **IMPLEMENTATION.md** - "What we're doing" (current phase detailed, completed phases compressed to 3-5 bullets)
- **DECISIONS.md** - "What we decided" (heading-based format, grep-friendly, single source of truth)
- **chronicles/phase-X.md** - "Detailed history" (slim 15-20 line entries, session-by-session)

**Token Efficiency Wins:**

| Metric | Old System | New System | Savings |
|--------|-----------|------------|---------|
| Session pickup | ~200 lines | ~50 lines | 75% |
| Chronicle entry | 36 lines | 15-20 lines | 45% |
| IMPLEMENTATION.md | 800-1000 lines | 400-600 lines | 40% |

**Goal:** Start new session in < 2 minutes by reading only CONTEXT.md (30-50 lines).

**Example**: Plinth uses its own documentation system - see [docs/](docs/) for a real-world implementation.

## Templates

Templates are provided for:

- `CONTEXT.md` - Hot state template (new)
- `chronicle-entry-template.md` - Slim entry (15-20 lines)
- `chronicle-entry-full.md` - Full entry (36 lines, optional)
- `decision-entry-template.md` - Heading-based decision (new)
- `DECISIONS.md` - Full decisions file template (new)

Legacy templates (kept for backward compatibility):
- `decision-template.md` - Old decision format
- `decision-table-row-template.md` - Old table row format

Located in `skills/project-tracking/templates/`

## Contributing

[Contribution guidelines TBD]

## License

MIT License - see [LICENSE](LICENSE) file for details
