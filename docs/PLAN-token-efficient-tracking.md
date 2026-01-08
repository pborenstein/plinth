# Plan: Token-Efficient Project Tracking

**Created**: 2025-12-31
**Updated**: 2025-12-31
**Status**: Approved
**Goal**: Make session pickup and wrapup quick and complete

**Design Priority**: Optimize for fast, complete pickup/wrapup. Narrative quality in chronicles is acceptable loss since they're cold storage, not read during pickup.

---

## Problem Statement

The current project-tracking system was designed for human readability but is inefficient for LLM token budgets:

| Current Metric | Size | Issue |
|----------------|------|-------|
| Session pickup | ~200 lines from IMPLEMENTATION.md | Still verbose for "what's next" |
| Chronicle entry template | 36 lines | Metadata bloat, forced verbosity |
| CHRONICLES.md | ~150 lines | Redundant with file system |
| Decision documentation | 2 places (chronicle + registry) | Duplication |

**Core insight**: The system conflates two distinct needs:
1. **Hot state** - "Exactly where I left off" (volatile, small)
2. **Cold storage** - "What happened historically" (permanent, can be large)

---

## Proposed Changes

### Change 1: Add CONTEXT.md (Hot State File)

**Purpose**: Ultra-compact file containing only volatile session state

**Location**: `docs/CONTEXT.md`

**Target size**: 30-50 lines max

**Structure**:
```yaml
---
phase: 3
phase_name: Production Hardening
updated: 2025-12-31
last_commit: abc1234
last_entry: 39
---

## Current Focus
[1-2 sentences: exactly what we're working on]

## Active Tasks
- [ ] Task currently in progress
- [ ] Next task after that
- [ ] Blocked: [reason] - task that's blocked

## Blockers
[Empty if none, otherwise 1-2 lines per blocker]

## Context
[3-5 bullet points of "things I need to remember" - decisions in flight, gotchas discovered, etc.]

## Next Session
[1-2 sentences: where to pick up if starting fresh]
```

**Rules**:
- Updated at END of every session (replaces wrapup overhead)
- Completely overwritten, not appended
- No history - that's what chronicles are for
- If it exceeds 50 lines, you're doing it wrong

**Session pickup becomes**:
1. Read CONTEXT.md (30-50 lines)
2. Done. Start working.

Only read IMPLEMENTATION.md or chronicles if you need historical context.

---

### Change 2: Eliminate CHRONICLES.md

**Current purpose**: Navigation index to chronicle files

**Why it's redundant**:
- `ls docs/chronicles/` lists all phase files
- `grep "^## Entry" docs/chronicles/*.md` lists all entries
- The index provides no value over file system + search

**Migration**:
1. Move any unique content (reading guide, etc.) to PROJECT-TRACKING.md
2. Delete CHRONICLES.md
3. Update session-pickup/wrapup commands to not reference it
4. Update PROJECT-TRACKING.md to remove CHRONICLES.md references

**Savings**: ~150 lines eliminated from the system

---

### Change 3: Slim Chronicle Entry Template

**Current template**: 36 lines with extensive metadata footer

**New template**: 15-20 lines focused on content

```markdown
## Entry XX: Title (YYYY-MM-DD)

**What**: [1-2 sentences - what was accomplished]

**Why**: [1-2 sentences - context/motivation]

**How**: [Bullet points - key implementation details, max 5-7 bullets]

**Decisions**: [Optional - only if DEC-XXX made, otherwise omit section]
- DEC-XXX: [one-line summary, detail in DECISIONS.md]

**Files**: [key files changed, or "see commit abc1234"]
```

**Removed from template**:
- "The Problem" / "The Solution" headers (redundant with What/Why)
- "Testing" section (usually obvious or in commit)
- "What's Next" section (belongs in CONTEXT.md only)
- "Interesting Episodes" (nice-to-have, rarely referenced)
- Metadata footer (Author, Impact, Branch, etc. - all in git)

**Rationale**: Chronicle entries are cold storage. They exist for future reference, not session pickup. Make them write-fast and search-friendly rather than exhaustive.

---

### Change 4: Streamline DECISIONS.md

**Current approach**: Decisions documented twice:
1. Detailed in chronicle entry
2. Summary row in DECISIONS.md table

**New approach**: Single source in DECISIONS.md with adequate detail

**New DECISIONS.md structure**:
```markdown
# Decisions

Architectural decisions for this project. Search with `grep -i "keyword" docs/DECISIONS.md`.

## Active Decisions

### DEC-XXX: Title (YYYY-MM-DD)
**Status**: Active | Superseded by DEC-YYY | Deprecated
**Context**: [1-2 sentences why decision needed]
**Decision**: [1-2 sentences what we decided]
**Alternatives considered**: [1 sentence or bullet list]
**Consequences**: [1-2 sentences impact]

[Repeat for each decision]

## Superseded/Deprecated
[Moved here when no longer active, keep for history]
```

**Changes**:
- No separate table (the headings ARE the index)
- Full context in one place
- Chronicle entries just reference: "See DEC-XXX"
- Searchable with grep

**Migration**:
- Convert existing table to heading-per-decision format
- Keep decision detail where it currently exists (chronicle or DECISIONS.md)
- Going forward, all detail goes in DECISIONS.md only

---

### Change 5: Restructure IMPLEMENTATION.md

**Current structure**:
- Phase Overview table
- All phases (completed as summaries, current as detailed)
- Development workflow
- Quick reference

**New structure**:
```markdown
# Implementation

## Phase Overview
| # | Name | Status |
|---|------|--------|
| 0 | Foundation | ✅ Complete |
| 1 | MVP | ✅ Complete |
| 2 | Current Phase | 🔵 Active |
| 3 | Future Work | ⚪ Planned |

## Current Phase: [Name]

[Detailed breakdown - this is the ONLY detailed section]
[200-300 lines max]

## Completed Phases

### Phase 0: Foundation
[3-5 bullet summary]
See: chronicles/phase-0.md

### Phase 1: MVP
[3-5 bullet summary]
See: chronicles/phase-1.md

## Future Phases

### Phase 3: [Name]
[High-level goals, 5-10 bullets]
```

**Key changes**:
- Completed phases: MAX 5 bullets + link (not 80-120 lines)
- Strict enforcement of "only current phase gets detail"
- Remove "Development Workflow" and "Quick Reference" (move to PROJECT-TRACKING.md or CLAUDE.md)

**Target size**: 400-600 lines (down from 800-1000)

---

### Change 6: Update Session Commands

**`/session-pickup`** new behavior:
1. Read CONTEXT.md (primary - 30-50 lines)
2. If CONTEXT.md missing or stale, fall back to IMPLEMENTATION.md current phase
3. Report ready to work

**`/session-wrapup`** new behavior:
1. Update CONTEXT.md (overwrite with current state)
2. If significant work done, add slim chronicle entry
3. If tasks completed, update IMPLEMENTATION.md checkboxes
4. If decisions made, add to DECISIONS.md
5. Commit all changed files

**Session wrapup should take 5 minutes, not 15**

---

## Implementation Plan

### Phase 1: Add CONTEXT.md (Non-breaking)

**Tasks**:
- [ ] Create CONTEXT.md template in `skills/project-tracking/templates/`
- [ ] Add CONTEXT.md to plinth's own docs/ as example
- [ ] Update session-pickup command to read CONTEXT.md first
- [ ] Update session-wrapup command to write CONTEXT.md
- [ ] Update PROJECT-TRACKING.md to explain CONTEXT.md
- [ ] Test on plinth: run pickup/wrapup cycle

**Validation**: Session pickup reads <50 lines

### Phase 2: Slim Chronicle Template (Non-breaking)

**Tasks**:
- [ ] Create new slim template `templates/chronicle-entry-slim.md`
- [ ] Keep old template as `templates/chronicle-entry-full.md` (optional use)
- [ ] Update PROJECT-TRACKING.md with new template guidance
- [ ] Update session-wrapup to use slim template by default

**Validation**: New entries are 15-20 lines

### Phase 3: Eliminate CHRONICLES.md (Breaking)

**Tasks**:
- [ ] Audit CHRONICLES.md for any unique content
- [ ] Move unique content to PROJECT-TRACKING.md
- [ ] Update session-pickup to not read CHRONICLES.md
- [ ] Update session-wrapup to not write CHRONICLES.md
- [ ] Update PROJECT-TRACKING.md to remove CHRONICLES.md references
- [ ] Delete CHRONICLES.md from plinth
- [ ] Update README.md documentation

**Validation**: No references to CHRONICLES.md remain

### Phase 4: Restructure DECISIONS.md (Breaking)

**Tasks**:
- [ ] Create new DECISIONS.md format template
- [ ] Migrate plinth's DECISIONS.md to new format
- [ ] Update session-wrapup decision workflow
- [ ] Update chronicle template to just reference decisions
- [ ] Update PROJECT-TRACKING.md

**Validation**: Decisions searchable with grep, no duplication

### Phase 5: Slim IMPLEMENTATION.md (Non-breaking)

**Tasks**:
- [ ] Compress completed phases to 5 bullets max
- [ ] Remove workflow/reference sections (move elsewhere)
- [ ] Enforce current-phase-only detail
- [ ] Update PROJECT-TRACKING.md size targets

**Validation**: IMPLEMENTATION.md < 600 lines

### Phase 6: Update Skill Documentation

**Tasks**:
- [ ] Rewrite SKILL.md for new system
- [ ] Rewrite PROJECT-TRACKING.md (substantial)
- [ ] Update all templates
- [ ] Update README.md with new workflow

---

## Migration Path for Existing Projects

Projects using the current system can migrate incrementally:

1. **Add CONTEXT.md** immediately (no breaking changes)
2. **Start using slim chronicle entries** (no migration needed)
3. **Delete CHRONICLES.md** when ready (one-time)
4. **Restructure DECISIONS.md** during low-activity period
5. **Compress IMPLEMENTATION.md** during phase transition

---

## Success Metrics

| Metric | Current | Target |
|--------|---------|--------|
| Session pickup tokens | ~200 lines | ~50 lines |
| Chronicle entry size | 36 lines | 15-20 lines |
| Files to read for pickup | 2-3 | 1 |
| Session wrapup time | 15 min | 5 min |
| IMPLEMENTATION.md size | 800-1000 lines | 400-600 lines |

---

## Risks and Mitigations

### Risk: Loss of detail in chronicle entries
**Mitigation**: Keep full template available for complex entries; slim template is default, not mandatory

### Risk: CONTEXT.md becomes stale
**Mitigation**: session-wrapup always updates it; pickup command warns if `updated` date is old

### Risk: Breaking existing projects
**Mitigation**: Phase 1-2 are additive; Phase 3-4 are opt-in breaking changes

### Risk: Decisions become hard to find without table
**Mitigation**: Heading-based format is grep-friendly; `## DEC-` pattern is searchable

---

## Open Questions

1. Should CONTEXT.md use YAML frontmatter + markdown body, or pure YAML?
   - Pro YAML: More compact, machine-parseable
   - Pro Markdown: Consistent with rest of system, human-editable

2. Should we version CONTEXT.md or treat it as ephemeral?
   - Current lean: Git-tracked but understood to be volatile

3. Should completed phases move to an archive/ directory?
   - Current lean: No, just compress in place

---

## References

- Current system: `skills/project-tracking/PROJECT-TRACKING.md`
- Current templates: `skills/project-tracking/templates/`
- Plinth's own docs: `docs/` (dogfooding example)
