# Plinth Architectural Decisions

Registry of key decisions made during plinth development. Search with `grep -i "keyword" docs/DECISIONS.md`.

---

## Active Decisions

### DEC-001: Use project-tracking system on plinth itself (2025-12-27)

**Status**: Active

**Context**: Need to document plinth's own development progress and validate the documentation system.

**Decision**: Apply project-tracking documentation system to plinth itself (dogfooding).

**Alternatives considered**:
- Skip documentation on plinth (just build the tool)
- Use simpler system for plinth

**Consequences**: Validates the system in real use, provides example for users, adds overhead to development but ensures system works well.

---

### DEC-002: Token-efficient documentation system (2026-01-01)

**Status**: Active

**Context**: Session pickup was reading ~200 lines from IMPLEMENTATION.md, slow and verbose for LLMs.

**Decision**: Implement CONTEXT.md-based system to reduce session pickup to ~50 lines.

**Alternatives considered**:
- Keep existing system: No token savings
- Eliminate documentation: Loses project context
- Use separate state file outside git: Harder to sync

**Consequences**: Migration effort for existing projects, but 75% reduction in session pickup tokens. Breaking change requiring migration command.

---

### DEC-003: Prioritize launchd service setup (2025-12-28)

**Status**: Active

**Context**: Multiple patterns identified in nahuatl-projects; need to prioritize implementation order.

**Decision**: Build launchd service setup first (high value, complex pattern worth automating).

**Alternatives considered**:
- Start with simpler patterns (testing, Makefile)
- Build all patterns simultaneously

**Consequences**: Delivers high-value automation first, validates skill-based approach on complex pattern.

---

### DEC-004: Make launchd setup a skill (2025-12-28)

**Status**: Active

**Context**: Need to generate multiple files (plist, install.sh, dev.sh, view-logs.sh) for launchd setup.

**Decision**: Implement as skill (not command) for multi-file generation capability.

**Alternatives considered**:
- Command with step-by-step instructions
- Hybrid approach

**Consequences**: More complex implementation, but provides complete automated setup. Users get working launchd setup with one command.

---

### DEC-005: Use template files for code generation (2025-12-28)

**Status**: Active

**Context**: Need to generate configuration files with variable substitution.

**Decision**: Use separate template files with `{{VARIABLE}}` substitution instead of string concatenation in code.

**Alternatives considered**:
- Inline templates as strings in SKILL.md
- Generate files programmatically

**Consequences**: Templates are easier to read, maintain, and test. Clear separation between logic and content.

---

### DEC-006: Make DOMAIN a skill parameter (2025-12-28)

**Status**: Active

**Context**: Tailscale domains needed for service configuration.

**Decision**: Make DOMAIN an explicit skill parameter (not inferred from project files).

**Alternatives considered**:
- Infer from Tailscale config
- Hardcode common patterns

**Consequences**: Explicit control for users, no magic behavior, clear in skill invocation.

---

### DEC-007: Don't create skills for trivial patterns (2025-12-28)

**Status**: Active

**Context**: Found simple patterns like adding 3 lines for OpenAPI docs.

**Decision**: Don't build skills for patterns that are simpler to do manually or document.

**Alternatives considered**:
- Create skills for everything
- Build "snippet library"

**Consequences**: Focus skill development on high-value automation. Simple patterns documented as examples.

---

### DEC-008: Build fastapi-scaffold from 2 examples (2025-12-28)

**Status**: Active

**Context**: Identified FastAPI pattern in temoa and apantli.

**Decision**: Build scaffold skill based on 2 examples (not waiting for more).

**Alternatives considered**:
- Wait for third project to validate pattern
- Skip FastAPI scaffold

**Consequences**: Faster delivery of useful skill, risk of needing adjustments if pattern varies in future projects.

---

### DEC-009: Read only current phase for session pickup (2025-12-30)

**Status**: Superseded by DEC-002

**Context**: IMPLEMENTATION.md growing large, full file read is slow.

**Decision**: Use Grep to find current phase marker, Read with offset to get only ~200 lines.

**Alternatives considered**:
- Read entire file
- Split into multiple files

**Consequences**: Faster pickup, but still ~200 lines. Led to DEC-002 (CONTEXT.md system).

---

### DEC-010: Template-based python-project-init (2025-12-29)

**Status**: Active

**Context**: Need to generate multiple files for new Python projects.

**Decision**: Use separate template files for each generated file (pyproject.toml, README.md, etc).

**Alternatives considered**:
- Inline all templates in SKILL.md
- Programmatic generation

**Consequences**: Easy to maintain and update templates, clear structure, follows DEC-005 pattern.

---

### DEC-011: Rename python-setup to python-env-setup (2025-12-29)

**Status**: Active

**Context**: Had python-setup for existing projects, adding python-project-init for new projects.

**Decision**: Rename to python-env-setup to clarify it's for environment setup in existing projects.

**Alternatives considered**:
- Keep python-setup name
- Rename to python-venv-setup

**Consequences**: Clearer naming, distinguishes "setup environment" from "init new project".

---

### DEC-012: Use dependency-groups over dev-dependencies (2025-12-29)

**Status**: Active

**Context**: uv deprecated tool.uv.dev-dependencies in favor of dependency-groups.

**Decision**: Use [dependency-groups] in pyproject.toml templates.

**Alternatives considered**:
- Keep using deprecated format
- Support both formats

**Consequences**: Avoids deprecation warnings, follows uv best practices, future-proof templates.

---

### DEC-013: Convert python-project-init to skill (2025-12-29)

**Status**: Active

**Context**: Commands can't be auto-invoked by Claude, skills can (via Skill tool).

**Decision**: Convert python-project-init to skill with thin command wrapper.

**Alternatives considered**:
- Keep as pure command
- Make it skill-only (no command)

**Consequences**: Users can invoke via `/python-project-init` OR Claude can auto-invoke as skill. Best of both worlds.

---

### DEC-014: Add frontmatter to all commands (2025-12-29)

**Status**: Active

**Context**: Commands need frontmatter with description for proper CLI behavior.

**Decision**: Add `---\ndescription: ...\n---` to all command files.

**Alternatives considered**:
- Use first line as description
- No descriptions

**Consequences**: Proper command listing in CLI, consistent structure, better UX.

---

## Superseded/Deprecated

### DEC-009: Read only current phase for session pickup (2025-12-30)

**Status**: Superseded by DEC-002

**Original decision**: Use Grep+Read with offset to read only current phase section (~200 lines).

**Why superseded**: DEC-002 introduced CONTEXT.md which reduces pickup to ~50 lines. The offset approach was an intermediate optimization, but CONTEXT.md provides far better results (75% reduction vs ~33% reduction).

---

## Notes

For chronicle entries with detailed decision context, see:
- chronicles/phase-0-foundation.md
- chronicles/phase-1-environment-tools.md
- chronicles/phase-2-project-initialization.md
