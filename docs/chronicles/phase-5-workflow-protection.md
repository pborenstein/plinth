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

## Entry 19: Released v1.2.0 and fixed hook self-blocking (2026-01-20)

**What**: Released v1.2.0 with git-workflow-hooks skill. Discovered and fixed issue where hook blocked releaserator itself.

**Why**: Ran releaserator to create v1.2.0 release. Hook blocked the tag push because it couldn't distinguish between manual tags and releaserator-created tags. Needed to make hook smart enough to detect legitimate releaserator workflow.

**How**:

- Ran releaserator successfully creating commit and tag
- Hook blocked tag push during Step 10
- Fixed hook to check last commit message for "chore: bump version to X.Y.Z" pattern
- If tag version matches commit message version, allow push (it's from releaserator)
- Tested: hook now allows releaserator tags, still blocks manual tags
- Released v1.2.0 successfully with updated hook

**Files**: see commits 0426b0b (version bump), 1fb71b6 (hook fix)
