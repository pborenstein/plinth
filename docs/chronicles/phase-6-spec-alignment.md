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
