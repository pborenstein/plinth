# Plinth Implementation Tracker

Living document tracking progress on the Claude Code plugin for project environment setup.

**Last updated**: 2025-12-27

---

## Phase Overview

| Phase | Status | Description | Lines |
|-------|--------|-------------|-------|
| Phase 0: Foundation | ✅ COMPLETE | Basic plugin structure, session management, python setup | ~80 |
| Phase 1: Environment Tools | 🔵 CURRENT | macOS services, testing tools, common patterns | ~250 |
| Phase 2: Advanced Features | 📋 PLANNED | Additional tools based on usage feedback | TBD |

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

## Phase 1: Environment Tools 🔵 CURRENT

**Goal**: Add macOS service management and testing tools based on nahuatl-projects patterns.

**Status**: In progress - research phase complete

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
- [x] Document in README.md
- [ ] Consider test runner command - Deferred (low value)
- [ ] Consider Makefile generator skill - Deferred (only apantli uses it)
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

### What's Next

1. **Philip to re-test** launchd skill on temoa with bug fixes (Entry 10 + 11)
2. Test fastapi-scaffold skill on new project
3. Consider Tailscale support (optional - deferred to Phase 2)
4. Declare Phase 1 complete or iterate based on test results

---

## Phase 2: Advanced Features 📋 PLANNED

**Status**: Not started - waiting for Phase 1 completion and user feedback

### Potential Features

Based on future usage:
- Additional environment setup patterns
- Multi-project workspace tools
- CI/CD helpers
- Deployment automation patterns

Will define when Phase 1 complete.

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

**Current phase**: Phase 1 - Environment Tools
**Next task**: Re-test launchd skill on temoa (Philip) - with bug fixes from Entry 10+11
**After that**: Consider Phase 1 complete or iterate

**Recent decisions**:
- Use own documentation system on plinth (dogfooding)
- Prioritize launchd service setup (high value, complex pattern)
- Build FastAPI scaffold based on temoa/apantli patterns
- Add allowed-tools to all skills (Entry 11)

**Key metrics**:
- Commands: 3 (session-pickup, session-wrapup, python-setup)
- Skills: 3 (project-documentation-tracking, macos-launchd-service, fastapi-scaffold)
- All skills have allowed-tools configured (no permission prompts)
- Projects using plinth: 0 (not yet published)
- Bugs found and fixed: 2 (Entry 10, Entry 11)
