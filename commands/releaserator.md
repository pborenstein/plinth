---
description: Create a new release with changelog, version bump, and GitHub release
allowed-tools: Read, Write, Bash, Glob
---

# Releaserator - Release Automation

Create a new plugin release with semantic versioning, changelog generation, and GitHub release creation.

## Tasks to complete:

### 1. Pre-flight Checks

Before creating a release, verify the repository state:

- **Verify clean working directory**
  - Run `git status` to ensure no uncommitted changes
  - Check that current branch is main or a release branch
  - Warn if uncommitted work exists

- **Verify session is wrapped up**
  - Check docs/CONTEXT.md updated date is recent (within 24 hours)
  - Suggest running `/session-wrapup` if stale

- **Verify prerequisites**
  - Check `gh` CLI is installed (for GitHub operations)
  - Check we're in a git repository
  - Check .claude-plugin/plugin.json exists

### 2. Version Bump Strategy

Determine version bump type by analyzing commits since last release using Conventional Commits:

**Bump rules** (highest priority wins):

- **MAJOR bump** (X.0.0): Any commit with:
  - `BREAKING CHANGE:` in commit body/footer
  - Exclamation mark before colon (e.g., `feat!: change API`)

- **MINOR bump** (x.X.0): Any `feat:` commits (new features)

- **PATCH bump** (x.x.X): Any `fix:` or `perf:` commits

- **No bump**: Only `docs:`, `refactor:`, `chore:`, `test:`, `ci:` commits

If multiple bump types exist, use highest priority: MAJOR > MINOR > PATCH

### 3. Changelog Generation

1. **Parse conventional commits** since last tag (or all commits if no tags exist)
2. **Group commits** by type into Keep A Changelog sections:
   - `feat:` → Added
   - `refactor:` (behavior changes) → Changed
   - Deprecation mentions → Deprecated
   - Feature removals → Removed
   - `fix:` → Fixed
   - Security mentions → Security
3. **Generate changelog entry** for new version
4. **Prepend to CHANGELOG.md** (or create if missing)

**Format per line**:
```markdown
- Brief description ([#123](PR-link)) ([abc1234](commit-link))
```

**Breaking changes** are marked with ⚠️ and include details.

### 4. Update Version Files

1. **Update .claude-plugin/plugin.json** with new version
2. **Commit version bump**: `chore: bump version to X.Y.Z`

### 5. Git Tagging

1. **Create annotated tag**: `git tag -a vX.Y.Z -m "Release vX.Y.Z"`
2. **Push tag**: `git push origin vX.Y.Z` (after user confirmation)

### 6. GitHub Release

Use `gh release create` with:

- Tag name: `vX.Y.Z`
- Title: `vX.Y.Z`
- Body: Changelog entry for this version
- Auto-generate additional notes: `--generate-notes`

### 7. Post-Release

1. **Report release URL**
2. **Suggest next steps**: announcement, plugin registry update, etc.

---

## Workflow

**Recommended usage**:

```bash
# 1. Complete your work
/session-wrapup

# 2. Verify clean state
git status

# 3. Make release
/releaserator
```

---

## Pattern Examples

### Good release workflow:

```
✅ Working directory clean
✅ CONTEXT.md updated today (2026-01-11)
✅ gh CLI installed
✅ Found last release: v1.2.3
✅ Analyzed 5 commits: 3 feat, 2 fix → MINOR bump
✅ Generated CHANGELOG.md entry for v1.3.0
✅ Updated plugin.json (1.2.3 → 1.3.0)
✅ Committed: "chore: bump version to 1.3.0"
✅ Created tag v1.3.0
✅ Pushed to remote
✅ Created GitHub release: https://github.com/user/repo/releases/tag/v1.3.0
```

### Avoid:

- Running with uncommitted changes (may include unintended files)
- Creating releases with stale documentation (run session-wrapup first)
- Releasing when tests are failing (verify builds pass first)
- Force-pushing tags (creates confusion, use new version instead)

---

$ARGUMENTS
