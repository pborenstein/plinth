---
description: Update project documentation and commit changes after a work session
---

# Session Wrap-up

Update project documentation to prepare to clear context or start a new session.

## Documentation Structure Awareness

**Check if project uses split documentation** (like temoa and tequitl):
- Look for `docs/chronicles/` and/or `docs/phases/` directories
- If present, follow the split documentation pattern below
- If not present, use the traditional pattern (update docs directly)

## Tasks to complete:

NOTE: Some of these tasks may have been completed already.

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

### Good wrap-up (split documentation):
```
✅ Updated docs/IMPLEMENTATION.md Phase 2.7 status
✅ Added Entry 30 to docs/chronicles/phase-2-don-draper.md
✅ Added DEC-018 to decision table in docs/CHRONICLES.md
✅ Committed: "feat: implement shared workspace for Joan/Don collaboration"
```

### Good wrap-up (traditional documentation):
```
✅ Updated docs/IMPLEMENTATION.md with session progress
✅ Added chronicle entry to docs/CHRONICLES.md
✅ Committed: "feat: implement new feature"
```

### Avoid:
- Adding detailed history to IMPLEMENTATION.md when using split docs (goes in phase file)
- Adding full decision rationale to CHRONICLES.md table (goes in phase file)
- Making the index files grow large when using split docs

---

$ARGUMENTS
