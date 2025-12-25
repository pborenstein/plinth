---
name: project-documentation-tracking
description: Establish the files used to track and manage progress.
---

# Project Documentation Tracking Setup

This skill establishes a four-file documentation tracking system for software projects.

## When to Use This Skill

- **New codebases**: Set up tracking from day one
- **Existing codebases**: Retroactively document project history and establish tracking

## Quick Start

[DOCUMENTATION-GUIDE.md](./DOCUMENTATION-GUIDE.md) describes the project tracking documentation system.


### For New Projects

1. Create base structure (no git history to analyze)
2. Initialize Phase 0 in IMPLEMENTATION.md
3. Ready to document first session

### For Existing Projects (Retroactive)

1. **Use TodoWrite** to track setup progress
2. **Analyze project history** (see commands below)
3. **Identify phase boundaries** based on major milestones
4. **Create documentation structure** in order
5. **Document retroactively** with appropriate detail level

## Step-by-Step Process for Existing Projects

### Step 1: Analyze Project History

Run these commands to understand the codebase:

```bash
# Full git history
git log --all --oneline --decorate

# Identify major refactors/features
git log --all --oneline --grep="refactor\|feat\|major"

# Check existing documentation
find . -name "*.md" -type f | grep -v node_modules

# Review changelog if exists
cat CHANGELOG.md

# Get commit count and timeline
git log --oneline | wc -l
git log --reverse --format="%ai %s" | head -5
git log --format="%ai %s" | head -5
```

### Step 2: Identify Phase Boundaries

Look for natural breakpoints:

**Good phase boundaries**:
- Major architectural refactors ("legendary refactor", "restructure")
- Feature milestones (v1.0.0, v2.0.0 releases)
- Significant pivots (monolith → microservices)
- Technology changes (rewrite in new language)

**Aim for 3-6 phases** for most projects:
- Too few: Loses meaningful structure
- Too many: Fragmented, hard to navigate

**Example phase progressions**:
- Foundation → Architecture → Features → Production
- MVP → Scale → Polish → Maintenance
- Prototype → Refactor → Features → Optimization

### Step 3: Create Files in This Order

**Use TodoWrite to track**:
```
1. Create docs/IMPLEMENTATION.md
2. Create docs/CHRONICLES.md
3. Create docs/DECISIONS.md
4. Create docs/chronicles/ directory
5. Create chronicle files for each phase
6. Update docs/README.md (if exists)
```

### Step 4: File Creation Details

#### IMPLEMENTATION.md

**For existing projects**:
- Phase Overview table (all phases)
- Completed phases: 80-120 line summaries
  - High-level achievements
  - Key deliverables
  - Commit range
  - Link to chronicle file
- Current phase: Detailed (200-300 lines)
  - Active tasks with checkboxes
  - What's completed so far
  - What's next
- Future phases: High-level plans (if any)

**Template sections**:
- Phase Overview table
- One section per phase
- Development Workflow section
- Quick Reference section

#### CHRONICLES.md

**For existing projects**:
- Chronicle Organization table (links to phase files)
- Entry Index by phase (one-line summaries)
- Create retroactive entries for:
  - 1 entry per completed phase minimum
  - More entries if phase had multiple major features
  - Don't over-document - summaries are fine

**Keep it brief**: This is navigation, not content

#### DECISIONS.md

**For existing projects**:
- Extract major architectural decisions from:
  - Commit messages mentioning "decision", "choose", "vs"
  - Architecture changes (modular refactor, tech choices)
  - Configuration format choices
  - UI/UX pattern choices
- Number sequentially (DEC-001, DEC-002, etc.)
- **Aim for 5-10 decisions** for retroactive docs
  - Focus on decisions still relevant today
  - Don't document every minor choice

**Decision Categories** to look for:
- Architecture (structure, modules, patterns)
- Configuration (formats, storage)
- Display/UX (interaction patterns, visual design)
- Technology (language, framework, library choices)

#### chronicles/phase-X-name.md

**For existing projects** (retroactive entries):

**Balance detail vs. effort**:
- **Older phases** (completed long ago):
  - One summary entry per phase
  - High-level "what and why"
  - Light on implementation details
  - Focus on decisions and outcomes

- **Recent phases** (last 3-6 months):
  - More detailed entries
  - Can document specific features
  - Include code examples if relevant

- **Current phase**:
  - Full detail from this point forward
  - Document each session

**Retroactive entry format**:
```markdown
## Entry N: [Phase Name] - [Brief Description] (YYYY-MM-DD)

**Context**: Why this phase happened

### The Problem
[What drove this work]

### The Solution
[What was built - high level]

### Implementation Details
[Key changes - bullet points fine for retroactive]

### Key Decisions
[Extract major decisions - link to DECISIONS.md]

---
**Entry created**: YYYY-MM-DD (retroactive documentation)
**Author**: [Original author if known], [Your name] documenting
**Type**: [Phase Summary/Feature/Refactor]
**Impact**: HIGH/MEDIUM/LOW
**Commits**: [commit range]
**Decision IDs**: DEC-XXX, DEC-YYY

**Note**: This entry was documented retroactively based on [git history/changelog/code inspection].
```

### Step 5: Extract Decisions from Code/History

**Commands to find decisions**:
```bash
# Search commit messages
git log --all --grep="decide\|choose\|vs\|instead\|alternative" --oneline

# Find architectural changes
git log --all --grep="refactor\|architecture\|structure" --oneline

# Check for design docs
find . -name "*DESIGN*" -o -name "*ARCHITECTURE*" -o -name "*ADR*"

# Look for configuration choices
git log --all --grep="config\|yaml\|json\|toml" --oneline
```

**In code**, look for:
- Major abstraction choices (OOP vs functional, monolith vs modular)
- Technology selections (which library, which format)
- Pattern implementations (how errors handled, how config loaded)
- Interface designs (API structure, CLI commands)

### Step 6: Update Existing Documentation

If project has docs/README.md or similar:
- Add "Development Documentation" section
- Link to IMPLEMENTATION.md, CHRONICLES.md, DECISIONS.md
- Add quick paths for contributors

## File Size Guidelines

| File | Target Size | Purpose |
|------|-------------|---------|
| IMPLEMENTATION.md | 800-1000 lines | Fast session pickup |
| CHRONICLES.md | 150-200 lines | Navigation only |
| DECISIONS.md | Grows naturally | One row per decision |
| chronicles/phase-X.md | No limit | Permanent record |

## Common Pitfalls for Existing Projects

❌ **Don't**: Try to document every commit
✅ **Do**: Document major milestones and decisions

❌ **Don't**: Create 20+ phases for a 2-year project
✅ **Do**: Aim for 3-6 meaningful phases

❌ **Don't**: Write novel-length retroactive entries
✅ **Do**: Write summaries with links to code/commits

❌ **Don't**: Document every decision ever made
✅ **Do**: Focus on architectural decisions still relevant

❌ **Don't**: Spend weeks on retroactive docs
✅ **Do**: Spend 2-4 hours, then track going forward

## Success Criteria

After setup, you should have:
- ✅ Clear phase progression in IMPLEMENTATION.md
- ✅ Navigation index in CHRONICLES.md
- ✅ 5-10 key decisions in DECISIONS.md
- ✅ One chronicle file per phase
- ✅ 1-2 entries per phase (more detail for recent/current)
- ✅ All files cross-referenced
- ✅ Current phase ready for ongoing tracking

## What to Tell the User

After setup, summarize:
1. Number of phases identified
2. Number of decisions documented
3. Number of chronicle entries created
4. Where to start for next session (IMPLEMENTATION.md current phase)
5. How to use the system going forward

## Templates

See template files for detailed formats:
- chronicle-entry-template.md
- decision-template.md
- decision-table-row-template.md

## References

- See DOCUMENTATION-GUIDE.md for complete system explanation
- See example project (Temoa) for real-world usage
