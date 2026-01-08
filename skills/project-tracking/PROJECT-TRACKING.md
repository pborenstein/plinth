# Documentation Guide - Token-Efficient Project Tracking

> **Purpose**: Complete guide to the token-efficient project documentation system
>
> **Audience**: Contributors, LLMs, future maintainers

**Created**: 2025-12-25
**Updated**: 2026-01-01
**Status**: Living document
**Version**: 2.0 (Token-Efficient System)

---

## Documentation Philosophy

**Design Priority**: Optimize for fast, complete session pickup with minimal token usage.

### Core Principle: Hot State vs Cold Storage

The system separates two distinct needs:

1. **Hot State** - "Exactly where I left off" (volatile, small, fast)
2. **Cold Storage** - "What happened historically" (permanent, detailed, searchable)

### File Purposes

- **CONTEXT.md** = "Current session state" (30-50 lines, read every session)
- **IMPLEMENTATION.md** = "What we're doing" (current phase detailed, past phases compressed)
- **DECISIONS.md** = "What we decided" (heading-based, grep-friendly)
- **chronicles/phase-N.md** = "Detailed history" (session-by-session narrative)

### Token-Efficiency Wins

| Metric | Old System | New System | Savings |
|--------|-----------|------------|---------|
| Session pickup | ~200 lines | ~50 lines | 75% |
| Chronicle entry | 36 lines | 15-20 lines | 45% |
| Files to read | 2-3 | 1 | 67% |
| IMPLEMENTATION.md | 800-1000 lines | 400-600 lines | 40% |

**Goal**: Session pickup in < 2 minutes, reading only CONTEXT.md

---

## Documentation Structure

### Required Files

```
docs/
├── CONTEXT.md                 # Hot state (30-50 lines) ← READ THIS FIRST
├── IMPLEMENTATION.md          # Progress tracker (400-600 lines)
├── DECISIONS.md               # Decision registry (heading-based)
└── chronicles/                # Detailed history by phase
    ├── phase-0-foundation.md
    ├── phase-1-mvp.md
    └── phase-2-features.md
```

### Optional Files

```
docs/
├── README.md                  # Documentation index
├── ARCHITECTURE.md            # System architecture
├── DEPLOYMENT.md              # Deployment guide
└── archive/                   # Historical documents
```

### What Changed from Legacy System

**Eliminated**:
- `CHRONICLES.md` - Redundant index file (use `ls chronicles/` instead)
- Verbose chronicle entry template (36 lines → 15-20 lines)
- Table-based DECISIONS.md (hard to search, duplicative)

**Added**:
- `CONTEXT.md` - Hot state file for instant pickup

**Compressed**:
- Completed phases in IMPLEMENTATION.md (120 lines → 5 bullets)

---

## File Details & When to Update

### CONTEXT.md (Hot State)

**Purpose**: Ultra-compact file containing ONLY volatile session state

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
[3-5 bullet points of "things I need to remember"]

## Next Session
[1-2 sentences: where to pick up if starting fresh]
```

**When to update**:
- ✅ **End of every session** (session-wrapup command)
- Completely overwrite, never append
- If it exceeds 50 lines, you're doing it wrong

**What goes here**:
- Current task in progress
- Blockers preventing progress
- Decisions in flight (not finalized)
- Gotchas discovered recently
- Exactly where to continue

**What DOESN'T go here**:
- Historical context (goes in chronicles)
- Finalized decisions (goes in DECISIONS.md)
- Completed tasks (check them off in IMPLEMENTATION.md)

**Rules**:
- No history - that's what chronicles are for
- Maximum 5 context bullets
- Maximum 3-5 active tasks
- Update `updated` date every session

---

### IMPLEMENTATION.md (Progress Tracker)

**Purpose**: Living todo list organized by phases

**Target size**: 400-600 lines total

**Structure**:

```markdown
# Implementation

## Phase Overview
| # | Name | Status | Commits |
|---|------|--------|---------|
| 0 | Foundation | ✅ Complete | abc-def |
| 1 | MVP | ✅ Complete | ghi-jkl |
| 2 | Features | 🔵 Current | mno-HEAD |
| 3 | Production | ⚪ Planned | - |

## Current Phase: Features

[DETAILED section with 200-300 lines]
[Task lists with checkboxes]
[Sub-phase breakdown]
[Notes and blockers]

## Completed Phases

### Phase 0: Foundation
- Set up project structure
- Implemented core models
- Basic CLI interface
- Testing framework
See: chronicles/phase-0-foundation.md

### Phase 1: MVP
- User authentication
- Basic search functionality
- Database migrations
- Initial deployment
See: chronicles/phase-1-mvp.md

## Future Phases

### Phase 3: Production
[High-level goals, 5-10 bullets]
```

**When to update**:
- ✅ **During session**: Update task checkboxes in current phase
- ✅ **End of phase**: Compress completed phase to 3-5 bullets
- ✅ **New phase starts**: Add new current phase section

**Size enforcement**:
- **Current phase**: 200-300 lines (detailed)
- **Completed phases**: 3-5 bullets each + link to chronicles
- **Future phases**: High-level only (5-10 bullets)

**What goes here**:
- Phase overview table
- Task lists with checkboxes
- High-level achievements
- Performance metrics
- Links to chronicles for details

**What DOESN'T go here**:
- Detailed implementation notes (goes in chronicles)
- Decision rationale (goes in DECISIONS.md)
- Session-by-session narrative (goes in chronicles)

---

### DECISIONS.md (Decision Registry)

**Purpose**: Single source of truth for all architectural decisions

**Format**: Heading-based (grep-friendly)

**Structure**:

```markdown
# Decisions

Architectural decisions for this project. Search with `grep -i "keyword" docs/DECISIONS.md`.

## Active Decisions

### DEC-001: Use PostgreSQL for primary database (2025-12-15)

**Status**: Active

**Context**: Need reliable storage for structured data with complex queries.

**Decision**: Use PostgreSQL as primary database instead of MongoDB or SQLite.

**Alternatives considered**:
- MongoDB: Better for unstructured data, but our data is highly relational
- SQLite: Simpler, but doesn't scale for multi-user access

**Consequences**: Requires PostgreSQL in deployment, adds migration complexity, but provides ACID guarantees and complex query support.

---

### DEC-002: Token-efficient documentation system (2025-12-31)

**Status**: Active

**Context**: Session pickup was reading ~200 lines from IMPLEMENTATION.md, slow and verbose for LLMs.

**Decision**: Implement CONTEXT.md-based system to reduce session pickup to ~50 lines.

**Alternatives considered**:
- Keep existing system: No token savings
- Eliminate documentation: Loses project context
- Use separate state file outside git: Harder to sync

**Consequences**: Migration effort for existing projects, but 75% reduction in session pickup tokens.

---

## Superseded/Deprecated

### DEC-000: Use MongoDB (2025-12-10)

**Status**: Superseded by DEC-001

**Context**: Initial assumption that unstructured data would dominate.

**Decision**: Originally chose MongoDB for flexibility.

**Why superseded**: Data became more structured and relational as project matured. Switched to PostgreSQL for better query support.
```

**When to update**:
- ✅ **New decision made**: Add new heading-based entry
- ✅ **Decision superseded**: Move to Superseded section, add reference

**What goes here**:
- All architectural decisions
- Full context and rationale
- Alternatives considered
- Consequences and trade-offs

**What DOESN'T go here**:
- Implementation details (goes in chronicles)
- Temporary notes (goes in CONTEXT.md)

**Rules**:
- One heading per decision (### DEC-XXX: Title)
- All detail in one place (no duplication)
- Chronicle entries just reference "See DEC-XXX"
- Searchable with: `grep -i "keyword" docs/DECISIONS.md`

**Migration from table format**:
- Convert each table row to heading-based entry
- Add context and consequences if missing
- Update chronicle entries to reference decisions

---

### chronicles/phase-N-name.md (Detailed History)

**Purpose**: Session-by-session implementation journal for each phase

**Entry template** (slim version):

```markdown
## Entry XX: Title (YYYY-MM-DD)

**What**: [1-2 sentences - what was accomplished]

**Why**: [1-2 sentences - context/motivation]

**How**: [Bullet points - key implementation details, max 5-7 bullets]

- Key change 1
- Key change 2
- Key change 3

**Decisions**: [Optional - only if DEC-XXX made, otherwise omit section]

- DEC-XXX: [one-line summary, detail in DECISIONS.md]

**Files**: [key files changed, or "see commit abc1234"]
```

**Target size**: 15-20 lines per entry (down from 36 lines)

**When to update**:
- ✅ **End of session** (if significant work done)
- NOT for trivial updates

**What goes here**:
- Session narrative (what happened and why)
- Implementation approach
- Key code changes
- Interesting discoveries
- References to decisions

**What DOESN'T go here**:
- Full decision details (goes in DECISIONS.md)
- Current status (goes in CONTEXT.md)
- Exhaustive file lists (use git commits)

**Rationale for slim template**:
- Chronicles are cold storage, rarely read during session pickup
- Write-fast and search-friendly > exhaustive
- Git commits capture file changes
- Decision details live in DECISIONS.md

**Full template still available**:
- Use `chronicle-entry-full.md` for complex entries if needed
- Slim template is default, not mandatory

---

## Session Workflows

### Session Pick-Up Process

**Goal**: Start working in < 2 minutes

#### Step 1: Read CONTEXT.md (30-50 lines)

```bash
cat docs/CONTEXT.md
```

This file contains:
- Current focus and active tasks
- Blockers preventing progress
- Key context to remember
- Where to pick up next

**If CONTEXT.md exists**: You're done! Start working.

**If CONTEXT.md missing or stale**: Fall back to IMPLEMENTATION.md (see below)

#### Step 2: Fall back to IMPLEMENTATION.md (if needed)

```bash
# Find current phase
grep -n "🔵" docs/IMPLEMENTATION.md

# Read current phase section
# (Use line number from grep, read ~200-300 lines)
```

#### Step 3: Check deeper context (optional)

Only if you need historical background:

```bash
# Find latest chronicle entries
ls -t docs/chronicles/

# Read recent entries in current phase file
```

**Time**: < 2 minutes (vs ~5 minutes in old system)

---

### Session Wrap-Up Process

**Goal**: Update CONTEXT.md and relevant docs in < 5 minutes

#### Step 1: Update CONTEXT.md (Required)

Update frontmatter:
- `updated`: Today's date
- `last_commit`: Latest git commit hash
- `last_entry`: Increment if adding chronicle entry

Update sections:
- **Current Focus**: What we're working on now
- **Active Tasks**: Current task list (check off completed)
- **Blockers**: Any impediments
- **Context**: 3-5 key things to remember
- **Next Session**: Where to pick up

**Keep under 50 lines total**

#### Step 2: Update IMPLEMENTATION.md (if tasks completed)

- Update checkboxes in current phase section
- Mark completed tasks as ✅
- Add new tasks discovered

#### Step 3: Add Chronicle Entry (if significant work)

Only if meaningful work completed:

- Add entry to `docs/chronicles/phase-N-name.md`
- Use slim template (15-20 lines)
- Reference decisions, don't duplicate them

#### Step 4: Update DECISIONS.md (if decisions made)

If architectural decisions were made:

- Add new heading-based entry
- Include context, alternatives, consequences
- Update chronicle to reference "See DEC-XXX"

#### Step 5: Commit Changes

```bash
git add docs/
git commit -m "docs: session wrapup - [brief summary]"
```

**Time**: < 5 minutes (vs ~15 minutes in old system)

---

## Size Targets & Limits

| File | Target Size | Maximum | Notes |
|------|-------------|---------|-------|
| CONTEXT.md | 30-50 lines | 50 lines | Strict limit |
| IMPLEMENTATION.md | 400-600 lines | 600 lines | Compress completed phases |
| Chronicle entry | 15-20 lines | 30 lines | Use slim template |
| DECISIONS.md | Variable | - | One heading per decision |

**Enforcement**:
- If CONTEXT.md exceeds 50 lines, you're tracking too much
- If IMPLEMENTATION.md exceeds 600 lines, compress completed phases
- If chronicle entry exceeds 30 lines, use bullets not paragraphs

---

## Migration from Legacy System

Use the `/project-tracking:migrate-to-token-efficient` command to migrate:

1. Creates CONTEXT.md from current phase
2. Compresses completed phases in IMPLEMENTATION.md
3. Converts DECISIONS.md to heading-based format
4. Eliminates CHRONICLES.md (preserves unique content)
5. Updates templates to slim versions

See: `commands/migrate-to-token-efficient.md`

---

## Templates

Templates are in `skills/project-tracking/templates/`:

- `CONTEXT.md` - Hot state template
- `chronicle-entry-template.md` - Slim entry (15-20 lines)
- `chronicle-entry-full.md` - Full entry (36 lines, optional)
- `decision-entry-template.md` - Heading-based decision
- `DECISIONS.md` - Full decisions file template

---

## Best Practices

### Do

- ✅ Update CONTEXT.md at end of every session
- ✅ Keep CONTEXT.md under 50 lines
- ✅ Use slim chronicle template by default
- ✅ Put decision details in DECISIONS.md, not chronicles
- ✅ Compress completed phases to 3-5 bullets
- ✅ Read only CONTEXT.md for session pickup

### Don't

- ❌ Let CONTEXT.md grow > 50 lines
- ❌ Skip updating CONTEXT.md (it becomes stale)
- ❌ Duplicate decision details across files
- ❌ Keep verbose completed phase summaries
- ❌ Create chronicle entries for trivial updates
- ❌ Read IMPLEMENTATION.md when CONTEXT.md exists

---

## Troubleshooting

### "CONTEXT.md is stale (updated > 7 days ago)"

**Problem**: CONTEXT.md hasn't been updated recently

**Solution**: Run session-wrapup to update it, or read IMPLEMENTATION.md current phase

### "CONTEXT.md is 65 lines"

**Problem**: File exceeded 50-line limit

**Solution**:
- Move completed tasks to IMPLEMENTATION.md
- Move finalized decisions to DECISIONS.md
- Reduce context bullets to top 5 most important
- Simplify "Next Session" to 1-2 sentences

### "Not sure if I should create a chronicle entry"

**Guideline**: Create entry if:
- Implemented a feature or fixed a bug
- Made an architectural decision
- Discovered something non-obvious
- Future you would want to know "how did we solve X?"

**Skip entry for**:
- Trivial updates (typo fixes, small tweaks)
- Work still in progress
- Just updating documentation

### "Where do I document this decision?"

**Always**: Put full details in DECISIONS.md

**Then**: Reference "See DEC-XXX" in chronicle entry

**Never**: Duplicate decision rationale across multiple files

---

## FAQ

### Why eliminate CHRONICLES.md?

**Old role**: Navigation index to chronicle files

**Why redundant**:
- `ls docs/chronicles/` lists all phase files
- `grep "^## Entry" docs/chronicles/*.md` lists all entries
- The index provided no value over file system + search

**Migration**: Unique content moved to project documentation

### Why slim chronicle template?

**Rationale**:
- Chronicles are cold storage, rarely read during pickup
- Write-fast > exhaustive documentation
- Git commits capture file changes
- Decision details live in DECISIONS.md
- 36-line template created metadata bloat

**Result**: 45% token savings per entry

### Why heading-based DECISIONS.md?

**Old system**: Table format with details in chronicles

**Problems**:
- Hard to search (grep doesn't work well on tables)
- Duplication (summary in table, details in chronicle)
- Not enough space in table for context

**New system**: Each decision is a heading with full details

**Benefits**:
- Grep-friendly: `grep -i "database" docs/DECISIONS.md`
- Single source of truth
- Room for context and consequences

### Can I use the old templates?

**Yes**: Full templates are still available:

- `chronicle-entry-full.md` - 36-line verbose template
- Use for complex entries if needed
- Slim template is default, not mandatory

### What if my project doesn't have phases?

**Alternative**: Use time-based organization

- chronicles/2025-Q1.md
- chronicles/2025-Q2.md

Or feature-based:

- chronicles/authentication.md
- chronicles/search-feature.md

**Core principle remains**: Separate hot state (CONTEXT.md) from cold storage (chronicles)

---

## Appendix: Migration Checklist

When migrating to token-efficient system:

- [ ] Create docs/CONTEXT.md from current phase
- [ ] Compress completed phases in IMPLEMENTATION.md to 3-5 bullets
- [ ] Convert DECISIONS.md to heading-based format
- [ ] Move unique content from CHRONICLES.md to project documentation
- [ ] Delete docs/CHRONICLES.md
- [ ] Update chronicle template to slim version
- [ ] Test session-pickup (should read CONTEXT.md first)
- [ ] Test session-wrapup (should update CONTEXT.md)
- [ ] Commit migration with comprehensive message

**Validation**:
- [ ] CONTEXT.md exists and is < 50 lines
- [ ] IMPLEMENTATION.md is < 600 lines
- [ ] DECISIONS.md uses heading-based format
- [ ] CHRONICLES.md is deleted
- [ ] Session pickup reads < 50 lines

---

## Version History

**v2.0 (2026-01-01)**: Token-efficient system

- Added CONTEXT.md for session state
- Slim chronicle templates (15-20 lines)
- Heading-based DECISIONS.md
- Eliminated CHRONICLES.md
- Compressed completed phases
- 75% reduction in session pickup tokens

**v1.0 (2025-12-25)**: Original split documentation system

- IMPLEMENTATION.md, CHRONICLES.md, DECISIONS.md
- Verbose chronicle entries (36 lines)
- Table-based decision registry
