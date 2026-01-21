# Phase 5: Workflow Protection

Chronicle of git workflow protection features.

**Phase start**: 2026-01-20

---

## Entry 18: Git workflow hooks skill (2026-01-20)

**What**: Created git-workflow-hooks skill to prevent manual version tag pushes.

**Why**: User encountered issue where manually pushing a tag bypassed the entire releaserator process (no changelog, no version bump, no release notes). Need to enforce proper release workflow.

**How**:

- Created pre-push hook script that blocks v*.*.* tag pushes
- Hook displays clear error message directing to /plinth:releaserator
- Allows emergency override with --no-verify flag
- Skill handles existing hooks gracefully with backup option
- Tested on plinth repo: blocks version tags, allows normal pushes

**Files**: see commit 0f68b44
