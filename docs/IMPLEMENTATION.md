# Plinth Implementation Tracker

Living document tracking progress on the Claude Code plugin for project environment setup.

**Last updated**: 2025-12-29

---

## Phase Overview

| Phase | Status | Description | Lines |
|-------|--------|-------------|-------|
| Phase 0: Foundation | ✅ COMPLETE | Basic plugin structure, session management, python setup | ~80 |
| Phase 1: Environment Tools | ✅ COMPLETE | macOS services, FastAPI scaffold, tested on real projects | ~250 |
| Phase 2: Project Initialization | 🚧 IN PROGRESS | Python project initialization from scratch | ~100 |
| Phase 3: Advanced Features | 📋 PLANNED | Additional tools based on usage feedback | TBD |

---

## Phase 0: Foundation ✅ COMPLETE

**Goal**: Establish basic plinth plugin structure with core documentation and environment commands.

**Status**: Complete (2025-12-27)

### Achievements

- ✅ Created plugin directory structure (commands/, skills/, templates/)
- ✅ Added MIT license
- ✅ Created CLAUDE.md with development workflow
- ✅ Created comprehensive README.md
- ✅ Implemented session management commands (pickup/wrapup)
- ✅ Implemented project-documentation-tracking skill with templates
- ✅ Implemented /python-setup command for uv-based environments
- ✅ Established git repository with clean commit history

### Key Files Created

- `LICENSE` - MIT license
- `CLAUDE.md` - Development instructions
- `README.md` - User documentation
- `commands/session-pickup.md` - Session context loading
- `commands/session-wrapup.md` - Documentation updates at session end
- `commands/python-setup.md` - Python environment setup with uv
- `skills/project-documentation-tracking/SKILL.md` - Documentation system skill
- `skills/project-documentation-tracking/DOCUMENTATION-GUIDE.md` - Complete documentation guide
- `skills/project-documentation-tracking/templates/` - Chronicle, decision templates

### Commits

- `de18f32` - wip
- `8c5b454` - Add basic nvim configuration for markdown and python
- `3979a71` - Get claude to write the skill
- `5679b6c` - Long names save lines
- `f46cd4c` - Break out templates
- `80a58eb` - docs: add project documentation and MIT license
- `fb06c14` - feat: add /python-setup command for uv-based Python environments

**See**: [chronicles/phase-0-foundation.md](chronicles/phase-0-foundation.md) for detailed session notes.

---

## Phase 1: Environment Tools ✅ COMPLETE

**Goal**: Add macOS service management and testing tools based on nahuatl-projects patterns.

**Status**: Complete (2025-12-28) - Tested and validated on temoa

### Research Complete

Analyzed nahuatl-projects (apantli, temoa, tequitl, nahuatl-frontmatter, tagex) for common patterns:

**Findings categorized by priority:**

#### HIGH PRIORITY - macOS launchd Service Pattern

Used by: apantli, temoa

**Complete pattern includes:**

- `launchd/install.sh` (96-136 lines) - Automated service installer
- `launchd/{project}.plist.template` - Service configuration template
- `dev.sh` - Development mode (stops service, runs with --reload, offers to restore)
- `view-logs.sh` - Log viewer with modes (stdout/stderr/all)

**Key characteristics:**

- Auto-start on login (`RunAtLoad: true`)
- Auto-restart on crash (`KeepAlive: true`)
- Project-specific ports (4000, 4001, etc.)
- Logs to `~/Library/Logs/{project}.log`
- Service naming: `dev.{username}.{project}`
- Template substitutions: `{{USERNAME}}`, `{{PROJECT_DIR}}`, `{{VENV_PYTHON}}`, `{{VENV_BIN}}`, `{{HOME}}`

**Install scripts are nearly identical** - highly generalizable pattern.

#### MEDIUM PRIORITY - Testing Pattern

Used by: All projects

Common commands:

```bash
uv run pytest                    # Run tests
uv run mypy {package}/          # Type checking
```

apantli Makefile pattern:

```make
test: uv run python run_unit_tests.py
typecheck: uv run mypy apantli/
all: typecheck test
clean: # remove __pycache__, .mypy_cache, .pytest_cache
```

#### LOW PRIORITY - Skip for now

- Configuration file patterns (covered by /python-setup)
- Project-specific utility scripts

### Tasks

**Research Phase** ✅
- [x] Explore nahuatl-projects for common patterns
- [x] Document launchd service pattern
- [x] Document testing patterns
- [x] Categorize by priority
- [x] Create findings document

**Documentation Phase** ✅
- [x] Create IMPLEMENTATION.md (this file)
- [x] Create CHRONICLES.md
- [x] Create DECISIONS.md
- [x] Create chronicles/phase-0-foundation.md
- [x] Create chronicles/phase-1-environment-tools.md
- [x] Document decision to use own tracking system on plinth

**Implementation Phase** ✅
- [x] Design launchd service setup (skill vs command) - Decided: skill
- [x] Decide on parameterization approach - Template-based with {{VARIABLES}}
- [x] Create templates for plist, install.sh, dev.sh, view-logs.sh
- [x] Implement skill (SKILL.md with step-by-step process)
- [x] Test on temoa - Found bugs (Entry 10)
- [x] Fix: Skill now uses provided parameters instead of reading old files (Entry 10)
- [x] Fix: Add allowed-tools to all skills for permission-free operation (Entry 11)
- [x] Re-test on temoa - Success! (Entry 12)
- [x] Document in README.md
- [ ] Consider test runner command - Deferred to Phase 2
- [ ] Consider Makefile generator skill - Deferred to Phase 2
- [x] Build FastAPI scaffold skill (Entry 9)
- [x] Add OpenAPI docs to apantli (tested pattern first)

### Design Questions

**Q1: Skill or Command for launchd setup?**

Options:
- **Skill**: Multi-file generation, interactive questions, complete setup
- **Command**: Step-by-step instructions, user runs install.sh manually

Leaning toward: **Skill** - generates complete launchd/ directory with all files

**Q2: How to parameterize?**

Need to collect:
- Project name (e.g., "temoa", "apantli")
- Port number (e.g., 4001)
- CLI command (e.g., "temoa server", "python3 -m apantli.server")
- Optional: Tailscale support (yes/no)

Could use AskUserQuestion or infer from pyproject.toml

**Q3: Where to store templates?**

Options:
- `skills/macos-service-setup/templates/` - with skill
- `skills/macos-service-setup/launchd-templates/` - clearer naming

**Q4: Test runner - necessary?**

`uv run pytest` and `uv run mypy` are simple enough. A command might add overhead without much value. Could include in Makefile generator instead.

### Completed

1. ✅ Set up project documentation on plinth (Entry 4)
2. ✅ Create Phase 0 chronicle entries (retroactive)
3. ✅ Design launchd skill structure (skill with templates)
4. ✅ Implement launchd service setup skill (Entry 5)
5. ✅ Add DOMAIN parameter (Entry 6)
6. ✅ Add uninstall.sh (Entry 7)
7. ✅ Create testing guide (Entry 8)
8. ✅ Update README.md
9. ✅ Build FastAPI scaffold skill (Entry 9)
10. ✅ Add OpenAPI docs to apantli (validation)
11. ✅ Fix parameter handling bug (Entry 10)
12. ✅ Add allowed-tools to all skills (Entry 11)
13. ✅ Successfully tested on temoa (Entry 12)

### Phase 1 Complete!

**Achievements**:
- macOS launchd service skill: fully tested and working
- FastAPI scaffold skill: ready for use
- Both skills have allowed-tools configured
- Real-world validation on temoa project
- 2 bugs found and fixed during testing

**Deferred to Phase 2**:
- Test fastapi-scaffold skill on new project
- Tailscale support for launchd
- Test runner command
- Makefile generator skill

---

## Phase 2: Project Initialization 🚧 IN PROGRESS

**Goal**: Add comprehensive project initialization command that creates new Python projects from scratch.

**Status**: Branch `python-project-init` - implementation complete, testing done

### Current Status

Branch created with complete implementation:

**Completed**:
- [x] Review setup-skill for useful patterns
- [x] Design python-project-init command structure
- [x] Create templates (pyproject.toml, README.md, CLAUDE.md, .gitignore)
- [x] Write python-project-init.md command documentation
- [x] Test on /tmp test projects
- [x] Fix uv deprecation warning (dependency-groups)
- [x] Rename python-setup → python-env-setup for clarity
- [x] Update README.md documentation
- [x] Add frontmatter to all commands (session-pickup, session-wrapup, python-env-setup, python-project-init)
- [x] Convert python-project-init to skill with thin command wrapper
- [x] Move templates to skills/python-project-init/templates/
- [x] Create PLUGIN-DEVELOPMENT-HANDBOOK.md reference
- [x] Add GitHub repository links to plugin.json
- [x] Update example project links with pborenstein username

**Next**:
- [ ] Merge python-project-init branch to main
- [ ] Test creating a real project with the command/skill
- [ ] Consider if templates need refinement

### Key Files Created

- `commands/python-project-init.md` - Thin wrapper command (31 lines)
- `skills/python-project-init/SKILL.md` - Full implementation (317 lines)
- `skills/python-project-init/templates/pyproject.toml.template` - Python config with uv
- `skills/python-project-init/templates/README.md.template` - Project overview
- `skills/python-project-init/templates/CLAUDE.md.template` - Development guide
- `skills/python-project-init/templates/.gitignore.template` - Python gitignore
- `commands/python-env-setup.md` - Renamed from python-setup
- `docs/PLUGIN-DEVELOPMENT-HANDBOOK.md` - Comprehensive plugin development reference

### Templates

All templates use `{{VARIABLE}}` substitution pattern:
- `{{PROJECT_NAME}}` - Display name
- `{{PACKAGE_NAME}}` - Python package name
- `{{DESCRIPTION}}` - One-line description
- `{{PYTHON_VERSION}}` - Python version requirement
- `{{VERSION}}` - Initial version

### Testing Results

Created test projects in /tmp:
- Template substitution works correctly
- `uv sync` completes without warnings
- CLI entry point works (`uv run package --version`)
- Tests pass (`uv run pytest`)

---

## Phase 3: Advanced Features 📋 PLANNED

**Status**: Not started - waiting for feedback

### Potential Features

Based on future usage:
- Additional environment setup patterns
- Multi-project workspace tools
- CI/CD helpers
- Deployment automation patterns

Will define based on real-world needs.

---

## Development Workflow

### Adding New Commands

1. Create `commands/command-name.md`
2. Use task list format (what the command should do)
3. Test on nahuatl project
4. Update README.md
5. Update CLAUDE.md if workflow changes
6. Commit with `feat: add /command-name`

### Adding New Skills

1. Create `skills/skill-name/` directory
2. Add `SKILL.md` with frontmatter
3. Add supporting docs and templates
4. Test on nahuatl project
5. Update README.md
6. Commit with `feat: add skill-name skill`

### Session Management

**Start session**: Read current phase section (~250 lines)
**End session**: Update task checkboxes, create chronicle entry, commit docs

### Testing

Test all commands/skills on nahuatl-projects before committing to plinth.

---

## Quick Reference

**Current phase**: Phase 1 - COMPLETE ✅
**Next phase**: Phase 2 - Advanced Features (when needed)
**Ready for**: Plugin publication and real-world use

**Recent decisions**:
- Use own documentation system on plinth (dogfooding)
- Prioritize launchd service setup (high value, complex pattern)
- Build FastAPI scaffold based on temoa/apantli patterns
- Add allowed-tools to all skills (Entry 11)

**Key metrics**:
- Commands: 3 (session-pickup, session-wrapup, python-setup)
- Skills: 3 (project-documentation-tracking, macos-launchd-service, fastapi-scaffold)
- All skills have allowed-tools configured (no permission prompts)
- Tested on real projects: 1 (temoa - successful)
- Bugs found and fixed: 2 (Entry 10, Entry 11)
- Phase 0: Complete ✅
- Phase 1: Complete ✅
