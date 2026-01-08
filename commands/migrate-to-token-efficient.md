---
description: Migrate project documentation from legacy system to token-efficient tracking
---

# Migrate to Token-Efficient Documentation

Migrate an existing project-tracking setup to the new token-efficient system.

**This command should be run ONCE per project.**

## What This Migration Does

Converts legacy documentation (split or traditional) to the token-efficient system:

- Creates `docs/CONTEXT.md` with current session state
- Compresses completed phases in `docs/IMPLEMENTATION.md`
- Converts `docs/DECISIONS.md` from table format to heading-based format
- Eliminates `docs/CHRONICLES.md` (preserves unique content)
- Updates templates to slim versions

## Pre-Migration Checklist

Before running this migration, ensure:

- [ ] All current work is committed (clean git status)
- [ ] You have a recent backup or can easily revert
- [ ] You've read the new system documentation

## Migration Tasks

### 1. Create CONTEXT.md

**Read** the current phase section from `docs/IMPLEMENTATION.md`:
- Find the current phase marker (🔵)
- Extract current focus, active tasks, and next steps
- Get latest commit hash and entry number from git/chronicles

**Write** `docs/CONTEXT.md`:
- Use template from `skills/project-tracking/templates/CONTEXT.md`
- Fill in frontmatter (phase, phase_name, updated, last_commit, last_entry)
- Populate Current Focus from phase description
- Populate Active Tasks from unchecked items in current phase
- Populate Context with 3-5 key points from recent work
- Populate Next Session with "Continue with [current focus]"
- Keep under 50 lines

### 2. Compress IMPLEMENTATION.md Completed Phases

**Read** `docs/IMPLEMENTATION.md` to identify completed phases

For each completed phase:
- If it's more than 10 lines, compress to 3-5 bullet summary
- Add "See: chronicles/phase-N-name.md" reference
- Keep only the high-level outcomes

**Keep**:
- Phase overview table
- Current phase (detailed, 200-300 lines)
- Future phases (high-level goals)

**Target**: Reduce file from 800-1000 lines to 400-600 lines

### 3. Convert DECISIONS.md Format

**Read** existing `docs/DECISIONS.md`

**If it uses table format**:
- Extract each decision from the table
- For each decision, create heading-based entry:
  ```markdown
  ### DEC-XXX: Title (YYYY-MM-DD)
  **Status**: Active
  **Context**: [from chronicle entry or table]
  **Decision**: [what was decided]
  **Alternatives considered**: [if available]
  **Consequences**: [impact]
  ```

**Write** new `docs/DECISIONS.md`:
- Use template from `skills/project-tracking/templates/DECISIONS.md`
- Convert all decisions to new format
- Separate Active from Superseded sections
- Ensure grep-friendly (each decision is a heading)

**If decisions are currently in chronicle entries only**:
- Extract them and add to DECISIONS.md
- Update chronicle entries to reference "See DEC-XXX"

### 4. Handle CHRONICLES.md

**Read** `docs/CHRONICLES.md` if it exists

**Check for unique content**:
- Reading guide or usage instructions
- Project-specific context not in chronicles/*.md files
- Anything that's not just a navigation index

**If unique content exists**:
- Add it to project documentation (README.md, CLAUDE.md, or dedicated docs)
- Update with section header like "Historical Context" or "Reading the Chronicles"

**If using split documentation** (chronicles/ directory exists):
- The index is redundant with `ls docs/chronicles/`
- All navigation value is gone

**Delete** `docs/CHRONICLES.md`:
- Move unique content first
- Remove the file
- Commit with message noting content was preserved

### 5. Update Chronicle Template References

**Check** if project has custom templates

If `docs/templates/` or `.project-templates/` exists:
- Copy slim templates from `skills/project-tracking/templates/`
- Replace old chronicle-entry-template.md
- Keep old one as chronicle-entry-full.md if desired

### 6. Verify Migration

**Check** the following:

- [ ] `docs/CONTEXT.md` exists and is < 50 lines
- [ ] `docs/IMPLEMENTATION.md` is < 600 lines
- [ ] `docs/DECISIONS.md` uses heading-based format
- [ ] `docs/CHRONICLES.md` is deleted
- [ ] Completed phases in IMPLEMENTATION.md are compressed
- [ ] All unique content from CHRONICLES.md is preserved

### 7. Commit Migration

**Create commit**:
```
refactor: migrate to token-efficient documentation system

- Created CONTEXT.md for session pickup (~40 lines vs ~200)
- Compressed completed phases in IMPLEMENTATION.md
- Converted DECISIONS.md to heading-based format
- Eliminated CHRONICLES.md (preserved unique content in project docs)
- Updated to slim chronicle templates

Migration reduces session pickup from ~200 lines to ~50 lines.
See: docs/PLAN-token-efficient-tracking.md
```

### 8. Test New System

**Run** session-pickup command:
- Should read CONTEXT.md first
- Should report current focus and tasks
- Should be fast (< 50 lines read)

**Run** session-wrapup command next session:
- Should update CONTEXT.md
- Should use slim chronicle template
- Should use heading-based DECISIONS.md

## Post-Migration

**Update team/collaborators**:
- Session pickup is now much faster
- CONTEXT.md is the new "where we are" file
- Chronicle entries are now slim (15-20 lines vs 36)
- No more CHRONICLES.md index file

**Adjust workflow**:
- Always update CONTEXT.md at end of session
- Keep CONTEXT.md current (< 50 lines)
- Use slim chronicle template for new entries
- Add decisions to DECISIONS.md (not chronicle)

## Rollback

If you need to rollback:

```bash
git revert HEAD  # Revert migration commit
```

Or manually:

1. Delete `docs/CONTEXT.md`
2. Restore `docs/CHRONICLES.md` from git history
3. Restore `docs/DECISIONS.md` from git history
4. Restore `docs/IMPLEMENTATION.md` from git history

---

$ARGUMENTS
