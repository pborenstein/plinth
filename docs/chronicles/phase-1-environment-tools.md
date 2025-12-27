# Phase 1: Environment Tools

Chronicle entries for adding macOS service management and common development tools.

---

## Entry 3: Pattern Research - Analyzed nahuatl-projects for Common Tools (2025-12-27)

**Context**: After establishing foundation and python-setup, needed to identify next high-value patterns.

### The Problem

Philip has 5 nahuatl-projects (apantli, temoa, tequitl, nahuatl-frontmatter, tagex) that have evolved similar tooling. Instead of cherry-picking randomly, needed systematic analysis to identify:

- What patterns are truly common (used by 2+ projects)
- Which patterns provide highest value (save most time/complexity)
- Which patterns are generalizable (not project-specific)

### The Solution

Conducted systematic exploration of all nahuatl-projects:

1. **Shell scripts**: Found dev.sh, view-logs.sh patterns
2. **launchd services**: Both apantli and temoa use identical setup patterns
3. **Testing patterns**: All projects use pytest + mypy
4. **Makefiles**: apantli uses for common tasks (test, typecheck, clean)

### Analysis Process

**Tools checked**:

```bash
# Shell scripts in each project
ls ~/projects/nahuatl-projects/*/\*.sh

# Makefiles
ls ~/projects/nahuatl-projects/*/Makefile

# launchd directories
ls ~/projects/nahuatl-projects/*/launchd/

# Testing directories
ls ~/projects/nahuatl-projects/*/tests/

# Configuration patterns
# .env files, config.json files, templates
```

### Findings

**HIGH PRIORITY - macOS launchd Service Pattern**

**Used by**: apantli, temoa

**Complete pattern**:

- `launchd/install.sh` (96-136 lines) - Automated installer
- `launchd/{project}.plist.template` - Service config
- `dev.sh` - Development mode (stop service, run with --reload, restore on exit)
- `view-logs.sh` - Log viewer with modes

**Characteristics**:

- Auto-start on login (`RunAtLoad: true`)
- Auto-restart on crash (`KeepAlive: true`)
- Project-specific ports (4000, 4001)
- Service naming: `dev.{username}.{project}`
- Template variables: `{{USERNAME}}`, `{{PROJECT_DIR}}`, `{{VENV_PYTHON}}`, `{{VENV_BIN}}`, `{{HOME}}`
- Logs to `~/Library/Logs/{project}.log`

**Key insight**: Install scripts are nearly identical between projects - just different project names, ports, and CLI commands. Highly generalizable.

**MEDIUM PRIORITY - Testing Pattern**

**Used by**: All projects

Pattern: `uv run pytest` and `uv run mypy {package}/`

apantli has Makefile:

```make
test: uv run python run_unit_tests.py
typecheck: uv run mypy apantli/
all: typecheck test
clean: # remove caches
```

**LOW PRIORITY - Skip**:

- Configuration patterns (covered by /python-setup)
- Project-specific utilities (gleanings, etc.)

### Key Decisions

**DEC-002: Prioritize launchd service setup over other patterns**

- **Rationale**: Most complex, saves most time, used by production services (apantli, temoa), generalizable pattern
- **Alternative**: Start with simpler test runner command
- **Impact**: Higher value but more work; test runner is trivial (`uv run pytest`)

Test runner doesn't add much value - users can just type `uv run pytest`. launchd setup saves hours and handles complex template generation.

### What Discovered

**launchd pattern is sophisticated**:

- Template substitution with sed
- Environment detection (username, paths)
- Service management (unload/load)
- Color-coded output
- Interactive prompts (restore service on exit)
- Network IP detection for access info
- Error handling (venv checks, port conflicts)

Both projects independently evolved nearly identical solutions. Prime candidate for extraction.

### What's Next

1. Create project documentation for plinth (dogfooding)
2. Design launchd skill structure
3. Decide on parameterization approach
4. Implement skill with templates
5. Test on temoa or apantli

---

**Entry created**: 2025-12-27
**Author**: Claude (Sonnet 4.5)
**Type**: Research
**Impact**: HIGH - Identifies next major feature
**Duration**: ~45 minutes
**Commits**: None (research phase)
**Decision IDs**: DEC-002

---

## Entry 4: Documentation Setup - Dogfooding the Project Tracking System (2025-12-27)

**Context**: Plinth provides project-documentation-tracking skill but doesn't use it on itself.

### The Problem

Philip asked to "turn these findings into an IMPLEMENTATION.md" and start using the documentation system on plinth itself.

This presents a classic dogfooding opportunity:

- Validate the documentation system works well in practice
- Identify any rough edges or missing features
- Demonstrate the system for users (README can point to plinth's own docs)
- Force ourselves to follow the workflow we're prescribing

### The Solution

Set up complete project-documentation-tracking system on plinth:

1. Created `docs/` directory structure
2. Created `docs/IMPLEMENTATION.md` with Phase Overview and current status
3. Created `docs/CHRONICLES.md` with entry index
4. Created `docs/DECISIONS.md` with decision registry
5. Created `docs/chronicles/phase-0-foundation.md` with retroactive entries
6. Created `docs/chronicles/phase-1-environment-tools.md` for current work

### Implementation Details

**Phase structure**:

- **Phase 0: Foundation** ✅ COMPLETE
  - Entry 1: Initial plugin structure
  - Entry 2: Python environment setup

- **Phase 1: Environment Tools** 🔵 CURRENT
  - Entry 3: Pattern research (this entry's predecessor)
  - Entry 4: Documentation setup (this entry)

**IMPLEMENTATION.md structure** (356 lines):

- Phase Overview table (3 phases)
- Phase 0: Completed phase summary (~80 lines)
- Phase 1: Current phase detailed (~250 lines)
  - Research findings
  - Tasks with checkboxes
  - Design questions
  - What's next
- Phase 2: Planned phase (placeholder)
- Development Workflow section
- Quick Reference section

**Retroactive documentation approach**:

For Phase 0 entries, documented:
- What was built (high-level)
- Why it was needed
- Key implementation details
- Commits and file counts

Kept it concise - not trying to reconstruct detailed session notes from git history.

### Key Decisions

**DEC-001: Use project-documentation-tracking system on plinth itself (dogfooding)**

- **Rationale**:
  - Validates the system works well
  - Identifies rough edges early
  - Provides real-world example for users
  - Forces us to eat our own cooking

- **Alternative**:
  - Just use git commits and README
  - Wait until plinth is more mature

- **Impact**:
  - Adds documentation overhead to plinth development
  - But pays off in system validation and user confidence
  - README can point to plinth's docs as example

### Interesting Episodes

**Challenge**: Should plinth track every small change?

**Decision**: No - use IMPLEMENTATION.md for current work, but keep chronicle entries focused on meaningful work sessions. Small doc updates or tweaks can be mentioned in entry but don't need separate entries.

**Example**: This documentation setup is Entry 4, which is substantial. But fixing a typo in README doesn't need an entry - just commit it.

### Testing the System

Writing these docs revealed:

- ✅ Chronicle entry template is clear and helpful
- ✅ Decision format works well
- ✅ IMPLEMENTATION.md phase structure makes sense
- ⚠️ Retroactive documentation takes thought (Entry 1 and 2 required synthesis)
- ✅ CHRONICLES.md navigation is clean

No issues found - system works as designed.

### What's Next

1. Commit this documentation setup
2. Update README to mention docs/ and point to it as example
3. Move forward with launchd skill implementation
4. Use this tracking system going forward

---

**Entry created**: 2025-12-27
**Author**: Claude (Sonnet 4.5)
**Type**: Documentation
**Impact**: MEDIUM - Establishes tracking for plinth, validates the system
**Duration**: ~1 hour
**Branch**: main
**Commits**: [pending]
**Files created**: 5 (IMPLEMENTATION.md, CHRONICLES.md, DECISIONS.md, 2 chronicle files)
**Lines added**: ~750
**Decision IDs**: DEC-001

**Note**: First real use of project-documentation-tracking on its own source repository.

---
