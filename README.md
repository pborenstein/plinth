# Plinth

A Claude Code plugin for setting up project working environments and documentation tracking.

## What's Included

### Commands

**Session Management**

- `/session-pickup` - Read project documentation to prepare for new work
- `/session-wrapup` - Update project documentation at end of session

**Development Environment**

- `/python-setup` - Set up Python development environment using uv package manager

### Skills

**Project Documentation Tracking**

- `project-documentation-tracking` - Establish four-file documentation system for tracking project progress

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

**Setting up Python environment:**

```
/python-setup
```

Sets up Python development environment:

- Verifies uv package manager is installed
- Runs `uv sync` to create virtual environment and install dependencies
- Copies `.env.example` to `.env` if present
- Verifies installation with version checks

### Project Documentation Tracking

**Setting up documentation for a new or existing project:**

[Usage instructions TBD]

Creates and maintains:

- `docs/IMPLEMENTATION.md` - Living todo list for current phase
- `docs/CHRONICLES.md` - Navigation index for project history
- `docs/DECISIONS.md` - Registry of architectural decisions
- `docs/chronicles/phase-X.md` - Detailed session-by-session implementation notes

See [DOCUMENTATION-GUIDE.md](skills/project-documentation-tracking/DOCUMENTATION-GUIDE.md) for complete documentation system explanation.

## Documentation System Overview

The project documentation tracking system separates concerns for fast session pickup:

- **IMPLEMENTATION.md** - "What we're doing now" (current phase detailed, completed phases summarized)
- **CHRONICLES.md** - "How to navigate the history" (index only, not content)
- **DECISIONS.md** - "What we decided" (decision registry with links to detailed rationale)
- **chronicles/phase-X.md** - "The detailed story" (session-by-session implementation notes)

**Goal:** Start new session in under 5 minutes by reading IMPLEMENTATION.md current phase section (~200 lines).

## Templates

Templates are provided for:

- Chronicle entries
- Decision documentation
- DECISIONS.md table rows

Located in `skills/project-documentation-tracking/templates/`

## Contributing

[Contribution guidelines TBD]

## License

MIT License - see [LICENSE](LICENSE) file for details
