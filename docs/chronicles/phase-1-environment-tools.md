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

## Entry 5: macOS launchd Service Skill - Complete Service Infrastructure Generator (2025-12-27)

**Context**: After research (Entry 3) identified launchd service pattern as high-priority, time to implement the skill.

### The Problem

Both apantli and temoa use nearly identical launchd service setups:

- install.sh (96-136 lines) - environment detection, template substitution, service installation
- {project}.plist.template - service configuration
- dev.sh - development mode (stop service, run with reload, restore on exit)
- view-logs.sh - log viewer with modes

Setting this up manually for each project means:

- Copying and modifying 4 files
- Careful sed substitutions for all variables
- Getting plist XML formatting correct
- Remembering all the launchctl commands
- Easy to make mistakes (typos, wrong paths, incorrect permissions)

Takes 1-2 hours per project and error-prone.

### The Solution

Created `macos-launchd-service` skill that generates complete service infrastructure from templates.

**What it generates**:

```
launchd/
├── install.sh                    # Automated installer
├── {project}.plist.template     # Service config
dev.sh                            # Development mode
view-logs.sh                      # Log viewer
```

**Key features**:

- Template-based generation (clean separation)
- Parameterized (project name, port, CLI commands, etc.)
- Comprehensive documentation (SKILL.md for LLMs, README.md for users)
- Based on proven patterns from temoa/apantli

### Implementation Details

**Skill structure**:

```
skills/macos-launchd-service/
├── SKILL.md              # LLM implementation guide
├── README.md             # User documentation
└── templates/
    ├── install.sh.template
    ├── service.plist.template
    ├── dev.sh.template
    └── view-logs.sh.template
```

**Template variables**:

- `{{PROJECT_NAME}}` - Project name (e.g., "temoa")
- `{{MODULE_NAME}}` - Python module for import check
- `{{PORT}}` - Port number
- `{{CLI_COMMAND}}` - Full CLI as plist array
- `{{DEV_COMMAND}}` - Dev mode command
- `{{PROCESS_NAME}}` - For pkill/pgrep
- Auto-detected: `{{USERNAME}}`, `{{HOME}}`, `{{PROJECT_DIR}}`, `{{VENV_PYTHON}}`, `{{VENV_BIN}}`

**Special handling - CLI_COMMAND**:

Must convert shell command to plist array format:

```
Input: "temoa server --host 0.0.0.0 --port 4001"

Output:
        <string>{{VENV_BIN}}/temoa</string>
        <string>server</string>
        <string>--host</string>
        <string>0.0.0.0</string>
        <string>--port</string>
        <string>4001</string>
```

**install.sh.template** (99 lines):

- Color-coded output (GREEN, BLUE, YELLOW, RED)
- Environment detection (username, paths, venv)
- Validation (venv exists, module importable)
- Template substitution with sed
- Service installation and loading
- Access info display (localhost, LAN IP)

**service.plist.template** (42 lines):

- RunAtLoad: true (auto-start on login)
- KeepAlive: true (auto-restart on crash)
- Logs to ~/Library/Logs/
- Environment PATH with venv
- Working directory set to project root

**dev.sh.template** (56 lines):

- Stops production service if running
- Kills any running process on same port
- Uses caffeinate to prevent sleep
- Runs with `uv run {DEV_COMMAND}`
- cleanup() trap to restore service on exit
- Interactive prompt (restore service y/n)

**view-logs.sh.template** (18 lines):

- Modes: app (stdout), error (stderr), all
- Uses tail -f for live viewing
- Simple case statement

**SKILL.md** (200 lines):

- Step-by-step process for LLMs
- Parameter gathering
- Template substitution logic
- CLI_COMMAND conversion algorithm
- Validation steps
- Example (temoa)

**README.md** (150 lines):

- User-facing documentation
- Quick start guide
- What gets generated
- Service management commands
- Development workflow
- Troubleshooting
- Why launchd?

### Key Decisions

**DEC-003: Make launchd setup a skill (not a command)**

- **Rationale**: Multi-file generation, interactive parameters, template processing - classic skill characteristics
- **Alternative**: Command that provides instructions
- **Impact**: More complex to build but provides much more value - generates everything, not just instructions

**DEC-004: Use template files instead of string concatenation**

- **Rationale**:
  - Cleaner separation (templates readable as actual files)
  - Easier to maintain (edit template, not string literals)
  - Proven pattern (apantli/temoa already use this)
  - Simple substitution with sed

- **Alternative**: Build files programmatically with string concatenation
- **Impact**: More files but much cleaner code, easier to understand and modify

### Testing

**Not yet tested on real project** - needs actual execution to verify:

- Template substitution works correctly
- CLI_COMMAND conversion handles edge cases
- Generated scripts are executable
- Service installs and runs properly

**Next**: Test on temoa or create fresh test project.

### What's Next

1. Test skill on a nahuatl project
2. Fix any issues discovered
3. Potentially add Tailscale support (apantli has this)
4. Document usage in main README

---

**Entry created**: 2025-12-27
**Author**: Claude (Sonnet 4.5)
**Type**: Feature
**Impact**: HIGH - Saves hours per project, prevents errors
**Duration**: ~2 hours
**Branch**: main
**Commits**: [pending]
**Files created**: 7 (SKILL.md, README.md, 4 templates)
**Lines added**: ~450
**Decision IDs**: DEC-003, DEC-004

---

## Entry 6: DOMAIN Parameter - Use Owned Domains for Service Labels (2025-12-27)

**Context**: After implementing macos-launchd-service skill, Philip pointed out service naming issue.

### The Problem

Service labels were using `dev.{{USERNAME}}.{{PROJECT_NAME}}`:

```
dev.philip.temoa
```

This works but doesn't follow best practices:

- `dev.philip` implies ownership of `philip.dev` domain
- Philip doesn't own `philip.dev`
- He does own `pborenstein.dev` and `pborenstein.com`
- Proper reverse domain notation should use owned domains

### The Solution

Changed service label to use `{{DOMAIN}}` parameter instead of hardcoded `dev.{{USERNAME}}`:

```
{{DOMAIN}}.{{PROJECT_NAME}}
```

Now users can specify their actual owned domain:

- `dev.pborenstein.temoa` (if you own pborenstein.dev)
- `com.pborenstein.temoa` (if you own pborenstein.com)
- `dev.philip` (fallback if no owned domain)

### Implementation Details

**Files changed**:

1. **service.plist.template**: `dev.{{USERNAME}}` → `{{DOMAIN}}`
2. **install.sh.template**: All references updated (3 locations)
3. **dev.sh.template**: Removed `USERNAME` variable, use `{{DOMAIN}}` (2 locations)
4. **SKILL.md**: Added DOMAIN to parameter list with guidance
5. **README.md**: Updated examples and technical details

**Parameter guidance** (in SKILL.md):

```
- **Domain** (e.g., "dev.pborenstein", "com.pborenstein")
  - Default suggestion: `dev.{username}`
  - Best practice: Use owned domain
```

**Example**:

Before: `dev.philip.temoa`
After: `dev.pborenstein.temoa`

### Key Decisions

**DEC-005: Make DOMAIN a skill parameter (not inferred)**

- **Rationale**:
  - Simple and explicit
  - User knows their owned domains
  - Can't reliably infer from git config (many use gmail/outlook)
  - Future: Could save preference in config file

- **Alternative**:
  - Auto-detect from git config email
  - Config file with saved preference
  - Hybrid approach (check config, ask, save)

- **Impact**:
  - Adds one more parameter to collect
  - But ensures correct domain usage
  - Clean, no magic

**Deferred**: Config file preference for future enhancement

### Interesting Episodes

**Challenge**: Should we remove `USERNAME` variable entirely from dev.sh?

**Decision**: Yes - `USERNAME` was only used to construct the plist path. Now that path uses `{{DOMAIN}}`, we don't need `USERNAME` at all. Cleaner.

### What's Next

1. Test with real domain (dev.pborenstein)
2. Consider config file for saving domain preference
3. Continue with testing skill on nahuatl project

---

**Entry created**: 2025-12-27
**Author**: Claude (Sonnet 4.5)
**Type**: Enhancement
**Impact**: MEDIUM - Improves compliance with domain naming best practices
**Duration**: ~20 minutes
**Branch**: main
**Commits**: [pending]
**Files changed**: 5 templates, SKILL.md, README.md
**Lines changed**: ~20
**Decision IDs**: DEC-005

---

## Entry 7: Uninstall Script - Add Service Removal Tool (2025-12-27)

**Context**: After implementing the launchd service skill, Philip noted that people like uninstallers.

### The Problem

The install.sh creates and loads a launchd service, but there was no convenient way to remove it:

- Manual process: `launchctl unload` + `rm` the plist file
- Easy to forget steps or get paths wrong
- No confirmation or feedback
- Should be a separate script (not part of install.sh)

### The Solution

Created `uninstall.sh.template` that:

1. Checks if service exists (exits gracefully if not)
2. Shows what will be removed
3. Asks for confirmation (y/n)
4. Stops running service if active
5. Removes the plist file
6. Confirms completion and shows reinstall command

### Implementation Details

**uninstall.sh.template** (58 lines):

- Same color scheme as install.sh (GREEN, BLUE, YELLOW, RED)
- Auto-detects paths (PROJECT_DIR, HOME_DIR)
- Constructs SERVICE_PLIST path using {{DOMAIN}}.{{PROJECT_NAME}}
- Graceful handling if service doesn't exist
- Interactive confirmation prompt
- Checks if service is running before unloading
- Clean error handling with `|| true` for failed unloads
- Success message with reinstall instructions

**Flow**:

```bash
./launchd/uninstall.sh
# Shows what will be removed
# Asks: Are you sure? (y/n)
# Stops service if running
# Removes plist file
# Confirms: "Uninstall complete!"
# Reminds: "To reinstall, run: ./launchd/install.sh"
```

**Documentation updates**:

- SKILL.md: Added uninstall.sh to generated files list
- SKILL.md: Added description of what uninstaller does
- SKILL.md: Updated validation (4 files → 5 files)
- SKILL.md: Added to chmod list
- README.md: Added uninstall.sh to generated files diagram
- README.md: Added "What Gets Generated" section for uninstaller
- README.md: Updated "Uninstall" section with script usage

### Why Separate Script?

Could have added `--uninstall` flag to install.sh, but separate script is better:

- Clearer intent (`./launchd/uninstall.sh` is obvious)
- Follows Unix convention (separate install/uninstall)
- Simpler logic (each script does one thing)
- Easier to document and use

### What's Next

Test the complete flow: install → use → uninstall → reinstall

---

**Entry created**: 2025-12-27
**Author**: Claude (Sonnet 4.5)
**Type**: Enhancement
**Impact**: LOW - Quality of life improvement
**Duration**: ~15 minutes
**Branch**: main
**Commits**: [pending]
**Files created**: 1 (uninstall.sh.template)
**Files changed**: 2 (SKILL.md, README.md)
**Lines added**: ~90

---

## Entry 8: Testing Guide - Comprehensive Skill Testing Instructions (2025-12-27)

**Context**: Before closing Phase 1, need a clear way to test the launchd skill.

### The Problem

Have a complete skill with templates but no testing procedure:

- How to invoke the skill on a real project?
- What parameters to provide?
- How to verify it worked?
- How to compare to existing setup?
- What to test?

Initially created a bash script for manual template substitution - completely wrong approach.

### The Solution

Created `TESTING-LAUNCHD-SKILL.md` - comprehensive testing guide (522 lines).

Then realized the error and rewrote it to properly invoke the skill.

### Implementation Details

**Testing guide structure**:

1. Prerequisites and setup
2. **Invoke skill in Claude Code** ("Run the macos-launchd-service skill")
3. Compare generated vs backup files
4. Test all scripts (install, uninstall, dev, view-logs)
5. Service verification
6. Validation checklist
7. Cleanup procedures

**Parameters documented** (for temoa):
- Domain: dev.pborenstein
- Project: temoa
- Module: temoa
- Port: 4001
- CLI command: temoa server --host 0.0.0.0 --port 4001 --log-level info
- Dev command: temoa server --reload
- Process name: temoa server

**Quick test flow**:
```bash
cd ~/projects/nahuatl-projects/temoa
# Backup
cp -r launchd launchd.backup && cp dev.sh dev.sh.backup && cp view-logs.sh view-logs.sh.backup
# In Claude: "Run the macos-launchd-service skill"
# Provide parameters
# Test scripts
```

### Key Realization

**Skills are LLM instructions, not executables.**

Wrong approach: Create bash script to substitute templates manually
Right approach: Ask Claude to run the skill, skill reads SKILL.md, follows instructions

The skill invocation IS the execution - no framework needed.

### What's Next

Philip will test using this guide and report results when returning.

---

**Entry created**: 2025-12-27
**Author**: Claude (Sonnet 4.5)
**Type**: Documentation
**Impact**: MEDIUM - Enables Phase 1 validation
**Duration**: ~30 minutes
**Branch**: main
**Commits**: 025fac7, e5c1513
**Files created**: 1 (TESTING-LAUNCHD-SKILL.md)
**Lines added**: 522 initially, then revised
**Lines changed**: 221 changes in fix commit

---

## Entry 9: FastAPI Scaffold Skill - Production-Ready Project Generator (2025-12-27)

**Context**: After discovering the OpenAPI docs pattern was too simple for a skill (3-line addition), Philip suggested building a complete FastAPI scaffold based on temoa/apantli patterns. "There are going to be more" FastAPI services.

### The Problem

Creating a new FastAPI project from scratch requires:

- Setting up project structure (pyproject.toml, package directory)
- Configuring FastAPI app (OpenAPI, CORS, lifespan)
- Building CLI entry point (argparse, uvicorn)
- Configuration management (multi-location search, JSON/YAML support)
- Version management (importlib.metadata pattern)
- Development tooling (pytest, mypy, ruff)
- Documentation (README with usage examples)
- Git ignores and env templates

**Manual approach**: 2-3 hours of setup, easy to miss best practices

**We have 2 proven examples**: temoa and apantli follow similar patterns but with variations

### The Solution

Created `fastapi-scaffold` skill that generates complete FastAPI project structure from templates.

**What it generates** (10 files):
```
{PROJECT_NAME}/
├── pyproject.toml
├── config.example.json
├── {PACKAGE_NAME}/
│   ├── __init__.py
│   ├── __version__.py
│   ├── __main__.py
│   ├── server.py
│   └── config.py
├── .gitignore
├── .env.example
└── README.md
```

**After generation**: `cd project && uv sync && uv run package --reload`

### Implementation Details

**Research Phase:**

Used Task tool with Explore agent to analyze both temoa and apantli:
- Project structure and file organization
- FastAPI app configuration patterns
- CLI entry point patterns
- Configuration management approaches
- Version management strategies
- Dependencies and tooling choices

**Key findings:**

1. **FastAPI app setup** - Both use identical pattern:
   - Lifespan context manager for startup/shutdown
   - CORS middleware (allow all for development)
   - OpenAPI configuration (title, description, version, docs_url, redoc_url)
   - Logging setup

2. **CLI entry points** differ:
   - Temoa: Minimal (just host/port from config)
   - Apantli: Full argparse with many options
   - **Chose**: Apantli's comprehensive approach (more flexible)

3. **Configuration patterns**:
   - Both search multiple locations
   - Both support environment variable override
   - Temoa: Manual parsing, detailed error messages
   - Apantli: Pydantic validation, YAML support
   - **Chose**: Hybrid (manual like temoa, YAML support like apantli)

4. **Version management**:
   - Both use `importlib.metadata.version()` pattern
   - Fallback to dev version if not installed
   - **Standard pattern**: Exactly the same in both

**Skill structure:**

```
skills/fastapi-scaffold/
├── SKILL.md (200 lines)      # LLM implementation guide
├── README.md (300 lines)     # User documentation
└── templates/ (10 files)     # Template files with {{VARIABLES}}
```

**Templates created:**

1. **__init__.py.template** - Package initialization
2. **__version__.py.template** - importlib.metadata pattern
3. **server.py.template** - FastAPI app with OpenAPI, CORS, lifespan
4. **__main__.py.template** - CLI with argparse + uvicorn
5. **config.py.template** - Multi-location config loader (4 search paths)
6. **pyproject.toml.template** - uv-based project config
7. **.gitignore.template** - Python/uv/IDE ignores
8. **.env.example.template** - Environment variables template
9. **config.example.json.template** - Example configuration
10. **README.md.template** - Generated project documentation

**Template variables:**

```
{{PROJECT_NAME}}          # Display name (e.g., "MyAPI")
{{PACKAGE_NAME}}          # Python package (e.g., "myapi")
{{PACKAGE_NAME_UPPER}}    # For env vars (e.g., "MYAPI")
{{DESCRIPTION}}           # One-line description
{{SERVER_HOST}}           # Default: "0.0.0.0"
{{SERVER_PORT}}           # Default: 8000
{{PYTHON_VERSION}}        # Default: ">=3.11"
{{VERSION}}               # Default: "0.1.0"
```

**SKILL.md implementation guide:**

9 steps for LLMs to follow:
1. Gather parameters (with AskUserQuestion if needed)
2. Derive additional variables (PACKAGE_NAME_UPPER)
3. Create project directory
4. Create package directory
5. Generate files from templates (with variable substitution)
6. Verify generated files
7. Initialize git (optional, ask user)
8. Setup development environment (uv sync, config)
9. Verification & next steps

**README.md user documentation:**

- What the skill creates
- Features included
- Usage instructions
- Quick start after generation
- File-by-file breakdown
- Next steps (customize config, add endpoints, set up launchd)
- Comparison with manual setup (2-3 hours → 2-3 minutes)

### Validation Before Building

**Tested the pattern first** by adding OpenAPI docs to apantli:

1. Created `apantli/__version__.py` with importlib.metadata pattern
2. Updated `server.py`:
   ```python
   app = FastAPI(
       title="Apantli",
       description="Lightweight LLM proxy...",
       version=__version__,
       docs_url="/docs",
       redoc_url="/redoc",
       lifespan=lifespan
   )
   ```
3. Verified it worked (http://localhost:4000/docs shows all 12 endpoints)

This 3-line change proved:
- The pattern works
- OpenAPI docs alone aren't worth a skill
- But complete project scaffold IS worth it

### Key Decisions

**Implicit decision: Build scaffold now vs wait for third project**

Philip said "there are going to be more" FastAPI services, which justified building the scaffold before the third project exists.

**Why this makes sense:**
- Have 2 proven examples (temoa, apantli)
- Patterns are stable and mature
- Can test on actual third project when it arrives
- Follows plinth philosophy: "battle-tested before adding"

### Interesting Episodes

**Challenge**: Should we make a skill for just OpenAPI docs?

**Decision**: No - it's a 3-line addition to FastAPI initialization. Too simple to template.

**But**: Complete project scaffold with 10 files and modern Python tooling? That's worth automating.

**The pattern**: Don't automate simple things (OpenAPI enablement), automate complex workflows (complete project setup).

### Updates Made

1. **Updated plinth README.md** - Added FastAPI scaffold section
2. **Updated IMPLEMENTATION.md** - Added items 9-10 to completed list
3. **Updated Quick Reference** - Now 3 skills instead of 2

### What's Next

1. Test the scaffold by creating a new FastAPI project
2. Refine templates based on actual usage
3. Wait for Philip to test launchd skill on temoa
4. Consider Phase 1 complete or iterate

---

**Entry created**: 2025-12-27
**Author**: Claude (Sonnet 4.5)
**Type**: Feature
**Impact**: HIGH - Enables rapid FastAPI project creation
**Duration**: ~2 hours
**Branch**: main
**Commits**: 814cf29
**Files created**: 12 (SKILL.md, README.md, 10 templates)
**Lines added**: ~800
**Decision IDs**: DEC-006, DEC-007

**Note**: First skill built based on multiple project analysis rather than single project extraction.

---

## Entry 10: Bug Fix - Skill Using Old Values When Replacing Existing Setup (2025-12-28)

**Context**: Philip tested the macos-launchd-service skill on temoa (which already had a launchd setup) and found it used old values instead of the new parameters he provided.

### The Problem

When running the skill on existing setup:

- Skill used `USERNAME` instead of new `DOMAIN` parameter
- Used old values from existing files even though user asked to replace them
- LLM was reading existing files and inferring values instead of using provided parameters

**Root cause**: SKILL.md had ambiguous instructions:

1. Step 2 said "Detect from pyproject.toml to infer defaults" - suggested reading from project
2. Still listed `{{USERNAME}}` as auto-detected variable (we removed it in Entry 6)
3. No explicit warning about replacing existing setups
4. Didn't emphasize: "use user parameters, not existing file values"

**Why this happened**: The skill was designed for NEW projects, tested on NEW projects (using testing guide), but never tested on REPLACING existing setup.

### The Solution

Updated SKILL.md with three critical changes:

**1. Added prominent warning section**:
```markdown
**IMPORTANT - Replacing Existing Setup**:

If the project already has launchd/ directory or existing scripts:
- **ALWAYS use the parameters provided by the user**
- **DO NOT read values from existing files**
- The user wants to replace with NEW values, not keep old ones
- Overwrite existing files with the new parameter values
```

**2. Reordered and clarified step 1**:
- Changed title: "Gather Information" → "Gather Information from User"
- Made it explicit: "Ask the user for these parameters"
- Added emphasis: "Use these exact values provided by the user - do not infer from existing files"

**3. Demoted pyproject.toml detection to step 2 with caveat**:
- Changed title: "Detect from pyproject.toml" → "Suggest Defaults from pyproject.toml (Optional)"
- Added qualifier: "Only if the user hasn't provided values"
- Emphasized: "But always use what the user explicitly provides"

**4. Removed USERNAME from variables list**:
- Split substitution variables into two groups:
  - "User-provided parameters (use values from step 1)"
  - "Auto-detected variables (filled in by install.sh at runtime)"
- Removed `{{USERNAME}}` entirely (obsolete since Entry 6)
- Made it crystal clear which values come from user vs runtime detection

### Files Changed

**skills/macos-launchd-service/SKILL.md**:
- Lines 27-48: Added "IMPORTANT - Replacing Existing Setup" section
- Lines 50-80: Restructured steps 1-2 to prioritize user input
- Lines 94-109: Reorganized substitution variables with clear categories

### Testing Plan

Philip will re-test on temoa with these updated instructions. The skill should now:

1. Ask for all parameters upfront
2. Use exactly what Philip provides
3. Use DOMAIN (not USERNAME)
4. Overwrite existing files with new values

### Key Insight

**Skills need testing in BOTH scenarios**:
- ✅ Fresh project (covered by TESTING-LAUNCHD-SKILL.md)
- ❌ Replacing existing setup (not tested until now)

This is a common pattern: tools work on greenfield but fail on brownfield.

### What's Next

1. Philip re-tests on temoa with updated skill
2. If this works, consider Phase 1 validated
3. If still issues, iterate further

---

**Entry created**: 2025-12-28
**Author**: Claude (Sonnet 4.5)
**Type**: Bug Fix
**Impact**: HIGH - Skill was unusable for replacing existing setups
**Duration**: ~20 minutes
**Branch**: main
**Commits**: b3d9400
**Files changed**: 1 (SKILL.md)
**Lines changed**: ~30
**Issue**: Skill used old values when replacing existing setup
**Resolution**: Explicit instructions to always use user-provided parameters

---

## Entry 11: Permission Prompts - Add allowed-tools to Skills (2025-12-28)

**Context**: Philip tested the fixed macos-launchd-service skill but it stopped to ask permission to read its own templates. Skills should be able to read their templates and write files without prompting users.

### The Problem

When running a skill:
- Skill execution stopped to ask: "Can I read this template file?"
- Had to approve each Read, Write, Bash operation
- Interrupted the skill's flow
- Poor user experience

**Root cause**: Skills didn't declare what tools they need to use.

### The Solution

Added `allowed-tools` field to all three skill frontmatter sections.

**What allowed-tools does**:
- Declares tools a skill is allowed to use without permission prompts
- Configured per-skill in SKILL.md frontmatter
- Users installing the plugin don't need manual permission setup
- Skill can execute smoothly without interruption

### Implementation Details

**skills/macos-launchd-service/SKILL.md**:
```yaml
---
name: macos-launchd-service
description: Set up macOS launchd service...
allowed-tools: Read, Write, Bash, Glob
---
```

**skills/fastapi-scaffold/SKILL.md**:
```yaml
---
name: fastapi-scaffold
description: Generate FastAPI project scaffold...
allowed-tools: Read, Write, Bash, Glob, AskUserQuestion
---
```

**skills/project-documentation-tracking/SKILL.md**:
```yaml
---
name: project-documentation-tracking
description: Establish the files used to track...
allowed-tools: Read, Write, Bash, Glob
---
```

**Why these tools**:
- **Read**: Read template files from skill directory
- **Write**: Create generated files in user's project
- **Bash**: Run commands (chmod, mkdir, git)
- **Glob**: Find files and directories
- **AskUserQuestion**: (fastapi-scaffold only) Ask for parameters interactively

### Key Insight

**Initial mistake**: Claude tried to add global permissions to `~/.claude/settings.json`.

**Why wrong**:
- That would give permission to ALL Claude Code operations forever
- Philip wanted skill-specific permissions
- Skills should declare their own tool needs

**Correct approach**: Use `allowed-tools` in SKILL.md frontmatter - scoped to that skill's execution only.

### Learning Moment

Claude initially:
1. Misunderstood the request (thought it was global permissions)
2. Started guessing instead of reading documentation
3. Wasted time and money on wrong approaches

**Better approach**:
1. Ask for clarification when unsure
2. Read documentation before implementing
3. Admit when you don't know something

Philip's feedback: "do you not understand that your guessing and dicking around costs me actual money?"

Fair point. Should have looked up plugin permission system first.

### What's Next

1. Philip re-tests launchd skill with both fixes (Entry 10 + Entry 11)
2. Should execute smoothly without permission prompts
3. Ready for Phase 1 validation

---

**Entry created**: 2025-12-28
**Author**: Claude (Sonnet 4.5)
**Type**: Bug Fix
**Impact**: HIGH - Skills were unusable due to permission prompts
**Duration**: ~30 minutes (including wrong approaches)
**Branch**: main
**Commits**: ee98e63
**Files changed**: 3 (all SKILL.md files)
**Lines added**: 3 (one allowed-tools line per skill)
**Issue**: Skills prompted for permission on every operation
**Resolution**: Add allowed-tools declaration to skill frontmatter
**Lesson**: Read documentation first, don't guess

---

## Entry 12: Validation - Successful Test on Temoa (2025-12-28)

**Context**: After fixing both bugs (Entry 10 + 11), Philip re-tested the macos-launchd-service skill on temoa.

### The Test

Ran the skill on temoa (which already had launchd setup) to replace existing configuration.

**Result**: "worked like a champ"

### What This Validates

Both bug fixes worked correctly:

**From Entry 10** (parameter handling):
- ✅ Skill used Philip's provided parameters
- ✅ Used new DOMAIN instead of old USERNAME
- ✅ Replaced existing files with new values
- ✅ Didn't read from old configuration files

**From Entry 11** (permissions):
- ✅ No permission prompts for reading templates
- ✅ No permission prompts for writing files
- ✅ Skill executed smoothly from start to finish
- ✅ allowed-tools configuration working as expected

### Phase 1 Complete

This successful test validates Phase 1 is ready:

- macOS launchd service skill: ✅ Working on real project
- FastAPI scaffold skill: ✅ Ready for use (deferred testing to Phase 2)
- Project documentation tracking skill: ✅ Working (dogfooded on plinth itself)
- All skills have allowed-tools: ✅ No permission friction

**Phase 1 achievements**:
- 3 commands implemented
- 3 skills implemented
- Real-world testing complete
- 2 bugs found and fixed
- Ready for use

**Deferred to Phase 2**:
- Test fastapi-scaffold on new project
- Tailscale support
- Additional tooling based on usage

### What's Next

Phase 1 is complete. Phase 2 will be triggered by:
- User feedback from real usage
- Additional patterns discovered in nahuatl-projects
- Requests for new features

For now: plinth is ready for publication and use.

---

**Entry created**: 2025-12-28
**Author**: Claude (Sonnet 4.5)
**Type**: Validation
**Impact**: HIGH - Phase 1 complete and validated
**Duration**: ~5 minutes (Philip's test)
**Branch**: main
**Commits**: [pending - marking phase complete]
**Testing**: temoa (real project, existing setup)
**Result**: Success - "worked like a champ"
**Milestone**: Phase 1 Complete ✅

---
