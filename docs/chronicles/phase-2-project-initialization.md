# Phase 2: Project Initialization - Chronicle

Detailed chronicle entries for Phase 2 implementation.

**Phase Goal**: Add comprehensive project initialization command that creates new Python projects from scratch.

**Phase Period**: 2025-12-29 onwards

---

## Entry 1: Python Project Init Command (2025-12-29)

**Context**: User asked to review ../setup-skill (earlier implementation) to identify useful patterns for plinth. This led to creating a comprehensive project initialization command.

### The Problem

The old setup-skill had a complete project initialization workflow that created:
- README.md, CLAUDE.md (documentation)
- pyproject.toml with uv
- Full documentation structure (IMPLEMENTATION, CHRONICLES, DECISIONS)
- Initial git commit

Plinth had pieces:
- `project-documentation-tracking` skill for docs
- `/python-setup` command for environment setup
- But no unified "create new project from scratch" workflow

### The Solution

Created `/python-project-init` command that combines everything:

1. **Gathers project information** (name, description, etc.)
2. **Generates files from templates**:
   - `pyproject.toml` - Modern Python config with uv, pytest, mypy, ruff
   - `README.md` - Project overview with placeholders
   - `CLAUDE.md` - Development guide for AI sessions
   - `.gitignore` - Python-specific
3. **Creates package structure**:
   - `{package}/__init__.py`, `cli.py`
   - `tests/` directory with basic test
4. **Sets up documentation** via `project-documentation-tracking` skill
5. **Optionally**: Initialize git repo and run `uv sync`

### Implementation Details

**Template System**:
- Created `commands/python-project-init-templates/` directory
- Templates use `{{VARIABLE}}` substitution:
  - `{{PROJECT_NAME}}` - Display name (e.g., "Temoa")
  - `{{PACKAGE_NAME}}` - Python package name (e.g., "temoa")
  - `{{DESCRIPTION}}` - One-line description
  - `{{PYTHON_VERSION}}` - Python requirement (default: ">=3.11")
  - `{{VERSION}}` - Initial version (default: "0.1.0")

**pyproject.toml template**:
```toml
[dependency-groups]
dev = [
    "pytest>=7.4.0",
    "mypy>=1.6.0",
    "ruff>=0.1.0",
]
```

Initially used `[tool.uv.dev-dependencies]` but that's deprecated. Fixed to use `[dependency-groups]` instead.

**README.md template**:
- Vision section (placeholder)
- Current status (Phase 0 - Research & Design)
- Features list (placeholders)
- Quick start instructions
- Project structure diagram

**CLAUDE.md template**:
- Project overview
- Key principles (placeholders)
- Technology stack (Python, uv, pytest, mypy, ruff)
- Session workflow (pickup/wrapup)
- Session checklist
- Common tasks (adding features, fixing bugs, refactoring)
- Git workflow

**Package files** (generated, not templated):
- `__init__.py` with `__version__`
- `cli.py` with argparse CLI (--version flag)
- `tests/test_basic.py` with version test

### Rename: python-setup → python-env-setup

Renamed `/python-setup` to `/python-env-setup` to clarify purpose:
- **python-env-setup**: Set up environment for *existing* projects
- **python-project-init**: Create *new* projects from scratch

Updated `commands/python-env-setup.md` with note pointing to python-project-init for new projects.

### Testing

Created test projects in /tmp:

**TestProject**:
```bash
cd /tmp/TestProject
uv sync
uv run testproject --version  # → "TestProject 0.1.0"
uv run testproject             # → "TestProject v0.1.0\nReady to go!"
uv run pytest                  # → 1 passed
```

**TestProject2** (testing uv deprecation fix):
```bash
cd /tmp/TestProject2
uv sync  # No warnings!
```

### Key Decisions

**DEC-XXX: Use template-based approach for project initialization**
- **Decision**: Create separate template files with `{{VARIABLE}}` substitution instead of hardcoding templates in the command
- **Rationale**: Easier to maintain and customize templates separately from command logic
- **Alternative considered**: Embedding templates in command markdown (harder to edit)
- **Impact**: Cleaner separation, easier to add/modify templates

**DEC-XXX: Rename python-setup to python-env-setup**
- **Decision**: Rename to clarify it's for setting up environment on existing projects
- **Rationale**: Avoids confusion with new python-project-init command
- **Alternative considered**: Keep both with same name (confusing)
- **Impact**: Clearer naming, better documentation

**DEC-XXX: Use dependency-groups instead of tool.uv.dev-dependencies**
- **Decision**: Use `[dependency-groups]` in pyproject.toml template
- **Rationale**: `tool.uv.dev-dependencies` is deprecated
- **Alternative considered**: Ignore warning (technical debt)
- **Impact**: Future-proof, no deprecation warnings

### Files Changed

**New files**:
- `commands/python-project-init.md` (command implementation, ~320 lines)
- `commands/python-project-init-templates/pyproject.toml.template`
- `commands/python-project-init-templates/README.md.template`
- `commands/python-project-init-templates/CLAUDE.md.template`
- `commands/python-project-init-templates/.gitignore.template`

**Renamed**:
- `commands/python-setup.md` → `commands/python-env-setup.md`

**Modified**:
- `README.md` - Documented new command and renamed command
- `commands/python-env-setup.md` - Added note about python-project-init

### What Went Well

- Template system is clean and easy to understand
- Testing caught the uv deprecation warning early
- Command documentation is comprehensive with step-by-step process
- Templates create a production-ready project structure

### Lessons Learned

- Check for deprecation warnings when using tool configurations
- Template-based approach is much cleaner than embedded templates
- Testing on real tmp projects reveals issues early

### Next Steps

1. Merge `python-project-init` branch to main
2. Test creating a real project with the command
3. Gather feedback on templates (too opinionated? not enough?)
4. Consider if CLAUDE.md template needs more project-specific guidance

---

**Entry created**: 2025-12-29
**Author**: Philip (with Claude)
**Type**: Feature implementation
**Impact**: HIGH - Core functionality for project creation
**Branch**: python-project-init
**Commits**: 9b8199f
**Decision IDs**: DEC-009, DEC-010, DEC-011

---
