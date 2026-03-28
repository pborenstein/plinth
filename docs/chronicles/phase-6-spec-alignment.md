# Phase 6: Spec Alignment

Aligning plugin with agentskills.io specification.

---

## Entry 20: Skills spec migration (2026-02-13)

**What**: Restructured plugin to align with Agent Skills specification (https://agentskills.io/specification).

**Why**: Ensure plugin conforms to standard skill structure for better interoperability and validation.

**How**:
- Migrated session-pickup and session-wrapup from commands/ to skills/
- Removed obsolete commands (migrate-to-token-efficient, python-env-setup, python-project-init command)
- Renamed all skills' templates/ directories to assets/ per spec
- Moved user documentation to references/usage.md (implementation stays in SKILL.md)
- Moved git-workflow-hooks pre-push script to references/
- Standardized template variable syntax to {{VARIABLE}} throughout SKILL.md files
- Version bumped to 1.2.1

**Decisions**: None

**Files**: Commits eea2372, a3afefd, 3ed069e, 269609c

---

## Entry 21: fastapi-sweetener refactoring (2026-02-13)

**What**: Renamed fastapi-scaffold to fastapi-sweetener and refactored from generative to additive.

**Why**: Support common pattern where projects start as CLI tools and later need API servers. Avoids choosing between two separate project initializers.

**How**:
- Fixed session-pickup description (ed63b2c)
- Added strict uv-only and no-emoji rules to python-project-init (e551eae)
- Renamed fastapi-scaffold → fastapi-sweetener (bb1730d)
- Rewrote skill to add FastAPI to existing projects instead of creating from scratch
- Updated python-project-init to use Click instead of argparse for subcommand support
- Added click>=8.0 to python-project-init dependencies
- Updated README with new workflow pattern (d91a92e)

**Decisions**: DEC-009 (fastapi-sweetener pattern)

**Files**: Commits ed63b2c, e551eae, bb1730d, d91a92e

---

## Entry 22: Modernize macos-launchd-service skill (2026-03-28)

**What**: Updated all launchd templates to use modern `launchctl bootstrap/bootout` API and rewrote dev.sh template with subcommands.

**Why**: Deprecated `launchctl load/unload` doesn't reliably stop services when `KeepAlive=true`. Old dev.sh prompted to restart service on exit, which was never wanted. Discovered while fixing temoa and apantli.

**How**:
- Rewrote `dev.sh.template` with subcommands (bare=dev, start, stop, status), no exit prompt
- Updated `install.sh.template` to use `bootstrap`/`bootout` and print `./dev.sh` commands
- Updated `uninstall.sh.template` to use `bootout` and `launchctl print` for status
- Updated SKILL.md descriptions and "next steps" output
- Updated references/usage.md service management and dev workflow sections

**Decisions**: None

**Files**: assets/dev.sh.template, assets/install.sh.template, assets/uninstall.sh.template, SKILL.md, references/usage.md

---

## Entry 23: Releaserator version-file agnostic (2026-03-28)

**What**: Removed hardcoded `.claude-plugin/plugin.json` dependency from releaserator. Now auto-detects version file.

**Why**: Releaserator could only run in Claude Code plugin repos. Non-plugin projects (Python, Node, Rust) use different version files.

**How**:

- Step 1 now detects version file in priority order: plugin.json, package.json, pyproject.toml, Cargo.toml
- Step 2 has per-type version parsing instructions
- Step 7 renamed to "Update Version File" with per-type update instructions
- Step 8 stages detected VERSION_FILE instead of hardcoded path
- Error messages and success criteria reference VERSION_FILE
- Updated references/usage.md with "Supported Version Files" section

**Decisions**: None

**Files**: skills/releaserator/SKILL.md, skills/releaserator/references/usage.md
