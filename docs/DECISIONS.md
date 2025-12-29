# Plinth Architectural Decisions

Registry of key decisions made during plinth development.

**Purpose**: Quick lookup of why we chose specific approaches.

---

## Decision Governance

**When to add a decision**:
- Chose between multiple valid approaches
- Made architectural choice affecting future development
- Decided NOT to do something for specific reasons

**Process**:
1. Document decision in chronicle entry (detailed rationale)
2. Add row to table below (one-line summary)
3. Commit both files together

**Decision numbering**: Sequential (DEC-001, DEC-002, etc.)

---

## Decision Registry

| Decision ID | Entry | Summary |
|-------------|-------|---------|
| DEC-001 | 4 | Use project-documentation-tracking system on plinth itself (dogfooding) |
| DEC-002 | 3 | Prioritize launchd service setup over other patterns (high value, complex) |
| DEC-003 | 5 | Make launchd setup a skill (not a command) for multi-file generation |
| DEC-004 | 5 | Use template files instead of string concatenation (cleaner, maintainable) |
| DEC-005 | 6 | Make DOMAIN a skill parameter (not inferred) for explicit control |
| DEC-006 | 9 | Don't create skills for simple patterns (e.g., 3-line OpenAPI addition) |
| DEC-007 | 9 | Build fastapi-scaffold based on 2 examples (not waiting for third project) |
| DEC-008 | 13 | Read only current phase section for pickup (Grep+Read with offset, skip history) |
| DEC-009 | 15 | Use template-based approach for python-project-init (separate files, easier to maintain) |
| DEC-010 | 15 | Rename python-setup to python-env-setup (clarify existing vs new project setup) |
| DEC-011 | 15 | Use dependency-groups instead of tool.uv.dev-dependencies (avoid deprecation) |
| DEC-012 | 16 | Convert python-project-init to skill with thin command wrapper (explicit + auto-invocation) |
| DEC-013 | 16 | Add frontmatter to all commands (required for proper CLI behavior) |

---

## Deprecated Decisions

None yet.

---

## Notes

Decisions are documented in detail in chronicle entries. This table provides quick lookup.

For full context, follow the Entry link to the chronicle file.
