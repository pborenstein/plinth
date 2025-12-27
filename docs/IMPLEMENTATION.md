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

**Documentation Phase** 🔵 IN PROGRESS
- [ ] Create IMPLEMENTATION.md (this file)
- [ ] Create CHRONICLES.md
- [ ] Create DECISIONS.md
- [ ] Create chronicles/phase-0-foundation.md
- [ ] Create chronicles/phase-1-environment-tools.md
- [ ] Document decision to use own tracking system on plinth

**Implementation Phase** 📋 NEXT
- [ ] Design launchd service setup (skill vs command)
- [ ] Decide on parameterization approach
- [ ] Create templates for plist, install.sh, dev.sh, view-logs.sh
- [ ] Implement skill/command
- [ ] Test on a nahuatl project
- [ ] Document in README.md
- [ ] Consider test runner command
- [ ] Consider Makefile generator skill

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

### What's Next

1. Set up project documentation on plinth (dogfooding)
2. Create Phase 0 chronicle entry (retroactive)
3. Design launchd skill structure
4. Implement launchd service setup skill
5. Test on temoa or apantli
6. Update README.md

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
**Next task**: Set up project documentation (CHRONICLES.md, DECISIONS.md)
**After that**: Design and implement launchd service setup skill

**Recent decisions**:
- Use own documentation system on plinth (dogfooding)
- Prioritize launchd service setup (high value, complex pattern)

**Key metrics**:
- Commands: 3 (session-pickup, session-wrapup, python-setup)
- Skills: 1 (project-documentation-tracking)
- Projects using plinth: 0 (not yet published)
