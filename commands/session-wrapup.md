---
description: Update project documentation and commit changes after a work session
---

# Session Wrap-up

Update project documentation to prepare to clear context or start a new session.

## Documentation System Detection

**Detect which documentation system is in use**:

1. **Token-efficient system** (new):
   - `docs/CONTEXT.md` exists
   - No `docs/CHRONICLES.md` file
   - Follow token-efficient workflow below

2. **Split documentation system** (legacy):
   - `docs/chronicles/` directory exists
   - `docs/CHRONICLES.md` exists as index
   - Follow split documentation pattern

3. **Traditional system** (legacy):
   - Single `docs/CHRONICLES.md` file
   - No split chronicles directory
   - Follow traditional pattern

## Tasks to complete:

NOTE: Some of these tasks may have been completed already.

### Token-Efficient System Workflow

#### 1. Update CONTEXT.md (Required)

**File**: `docs/CONTEXT.md`

- Update frontmatter:
  - `updated`: today's date
  - `last_commit`: latest git commit hash
  - `last_entry`: increment if adding chronicle entry
  - `phase` and `phase_name`: current phase info

- Update sections:
  - **Current Focus**: 1-2 sentences on what we're working on now
  - **Active Tasks**: Current task list with status
  - **Blockers**: Any impediments (empty if none)
  - **Context**: 3-5 bullet points of key things to remember
  - **Next Session**: 1-2 sentences on where to pick up

- **Keep total file under 50 lines**

#### 2. Update Task Status in IMPLEMENTATION.md

**File**: `docs/IMPLEMENTATION.md`

- Update checkboxes in current phase section only
- Mark completed tasks as ✅
- Add new tasks discovered during work
- Keep current phase section detailed, compress completed phases

#### 3. Add Chronicle Entry (if significant work done)

**File**: `docs/chronicles/phase-N-name.md`

- Use **slim template** (15-20 lines):
  - Entry number, title, date
  - What/Why/How (brief)
  - Decisions (reference only)
  - Files (key files or commit hash)

- Only create entry if:
  - Meaningful work completed
  - Something worth recording for future reference
  - NOT for trivial updates

#### 4. Update DECISIONS.md (if decisions made)

**File**: `docs/DECISIONS.md`

- Add new decision as heading-based entry:
  - `### DEC-XXX: Title (YYYY-MM-DD)`
  - Status, Context, Decision, Alternatives, Consequences
  - All detail goes here, chronicle just references it

- Update existing decision status if superseded

#### 5. Commit Changes

- Stage all documentation changes
- Create comprehensive commit message
- Follow conventional commit format

---

### Legacy System Workflows

### 1. Update Implementation Status

**File**: `docs/IMPLEMENTATION.md`

**If using split documentation**:
- Update only the "Current Status: Phase X" section
- Mark completed sub-phases as ✅
- Update current sub-phase status
- Add any new files created to the list
- **Keep this file slim** (< 300 lines) - overview only, not detailed history

**If using traditional documentation**:
- Update to reflect all work done in this session
- Include information on how to continue in a new session

### 2. Add Chronicle Entry

**If using split documentation**:
- Determine which phase file to update:
  - Check `docs/chronicles/` directory
  - Add entry to current phase file (e.g., `phase-2-don-draper.md`)
  - Create new phase file if starting a new phase
- Add new entry with:
  - Entry number (sequential within phase)
  - Session date
  - What was built/discovered
  - Key decisions made
  - Interesting episodes or lessons learned
- **Keep entries narrative** - tell the story of what happened and why

**If using traditional documentation**:
- Update `docs/CHRONICLES.md` directly with new entry
- Include decisions and interesting episodes

### 3. Update Decision Table (Split Documentation Only)

**File**: `docs/CHRONICLES.md`

If there are **new decisions**, add them to the "Quick Reference: Key Decisions" table:
- Use next DEC-xxx number
- Include date, decision name, summary
- Group under appropriate phase header
- **Do not** duplicate full decision details here - they go in the phase file

### 4. Commit Changes

Make sure the git repo is clean:
- Stage all documentation changes
- Create comprehensive commit message describing:
  - What was accomplished
  - What files were created/modified
  - Any architectural changes
- Follow conventional commit format if applicable

### 5. Verify Structure (Split Documentation Only)

Quick check:
- [ ] IMPLEMENTATION.md still slim (< 300 lines)?
- [ ] CHRONICLES.md still slim (< 100 lines)?
- [ ] New chronicle entry added to correct phase file?
- [ ] Decision table updated if needed?
- [ ] Git committed?

---

## Pattern Examples

### Good wrap-up (token-efficient system):
```
✅ Updated docs/CONTEXT.md with current focus and next session info
✅ Updated task checkboxes in docs/IMPLEMENTATION.md Phase 3 section
✅ Added Entry 12 to docs/chronicles/phase-3-production.md
✅ Added DEC-008 to docs/DECISIONS.md
✅ Committed: "feat: implement caching layer with Redis"
```

### Good wrap-up (split documentation - legacy):
```
✅ Updated docs/IMPLEMENTATION.md Phase 2.7 status
✅ Added Entry 30 to docs/chronicles/phase-2-don-draper.md
✅ Added DEC-018 to decision table in docs/CHRONICLES.md
✅ Committed: "feat: implement shared workspace for Joan/Don collaboration"
```

### Good wrap-up (traditional documentation - legacy):
```
✅ Updated docs/IMPLEMENTATION.md with session progress
✅ Added chronicle entry to docs/CHRONICLES.md
✅ Committed: "feat: implement new feature"
```

### Avoid:
- Making CONTEXT.md exceed 50 lines (token-efficient system)
- Adding detailed history to IMPLEMENTATION.md when using split docs (goes in phase file)
- Adding full decision rationale to CHRONICLES.md table (goes in phase file)
- Making the index files grow large when using split docs

---

$ARGUMENTS
