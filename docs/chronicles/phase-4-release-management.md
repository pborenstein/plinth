# Phase 4: Release Management

## Entry 6: Releaserator Implementation and First Release (2026-01-12)

**What**: Implemented complete release management system (releaserator) and created plinth's first official release (v1.1.0).

**Why**: Project lacked automated release workflow. Needed semantic versioning, changelog generation, and GitHub release creation to publish versions consistently.

**How**:

- Created `/releaserator` command and skill with 12-step implementation
- Built Keep A Changelog formatted CHANGELOG.md generation
- Implemented Conventional Commits parsing for version bump determination
- Added GitHub platform adapter (isolated for future GitLab/Gitea support)
- Created templates for changelog entries and release notes
- Updated README.md and CLAUDE.md with release workflow documentation
- Tested on plinth itself: analyzed 44 commits, determined MINOR bump (1.0.0 → 1.1.0)
- Created v1.1.0 release successfully (manual execution due to skill bug)
- Discovered bash error in SKILL.md: "or: command not found" when run via skill

**Decisions**: None (used established patterns)

**Files**: commands/releaserator.md, skills/releaserator/SKILL.md, skills/releaserator/README.md, skills/releaserator/templates/, skills/releaserator/platforms/github.md, CHANGELOG.md, .claude-plugin/plugin.json (1.0.0 → 1.1.0)

## Entry 7: Diagnosed Releaserator Permission Error (2026-01-12)

**What**: Investigated bash permission error blocking `/plinth:releaserator` skill execution. Identified root cause and applied fix.

**Why**: Skill invocation failed with "Bash command permission check failed for pattern `!` before `"`. Manual execution worked, proving bug was in markdown parsing, not release logic.

**How**:

- Traced error message to skill permission system scanning for bash command patterns
- Discovered inline code `` `!` before `:` `` triggers bash command validator
- Per PLUGIN-DEVELOPMENT-HANDBOOK.md, `!` prefix executes bash commands in markdown
- Skill parser misinterpreted inline code as bash command pattern
- Found pattern in SKILL.md (3 locations), README.md, commands/releaserator.md
- Replaced all with plain text "exclamation mark before colon"
- Committed fix but error persists - possible caching or different file loading mechanism

**Decisions**: None

**Files**: Commit 21925d7

## Entry 8: Fixed Skill Permissions and Released v1.1.1 (2026-01-12)

**What**: Identified real permission issue - skills need explicit bash command patterns. Fixed SKILL.md and successfully created v1.1.1 release using releaserator.

**Why**: Previous fix addressed wrong problem. Real issue: plain `Bash` in allowed-tools doesn't grant access to all commands. Skills require explicit patterns like `Bash(git:*)`.

**How**:

- Consulted PLUGIN-DEVELOPMENT-HANDBOOK.md showing `allowed-tools: Bash(git:*), Bash(grep:*)` syntax
- Updated SKILL.md: `Bash` → `Bash(git:*), Bash(gh:*), Bash(command:*), Bash(test:*)`
- Committed fix (4a144f2)
- Restarted session to clear cache
- Invoked `/plinth:releaserator` - ran without errors
- Completed full release workflow: parsed 4 commits, determined PATCH bump (1.1.0 → 1.1.1)
- Generated changelog with 2 bug fixes
- Created release successfully: https://github.com/pborenstein/plinth/releases/tag/v1.1.1

**Decisions**: None

**Files**: Commit 600afe9, skills/releaserator/SKILL.md, CHANGELOG.md, .claude-plugin/plugin.json (1.1.0 → 1.1.1)
