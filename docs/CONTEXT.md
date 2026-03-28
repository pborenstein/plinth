---
phase: 6
phase_name: Spec Alignment
updated: 2026-03-28
last_commit: 66bfefe
---

## Current Focus

Updated macos-launchd-service skill to use modern `launchctl bootstrap/bootout` API. Templates now generate `dev.sh` with subcommands instead of the old prompt-on-exit pattern.

## Active Tasks

- [x] Modernize launchd templates (bootstrap/bootout)
- [x] Add dev.sh subcommands (start/stop/status)
- [x] Update SKILL.md and usage.md references
- [ ] Run releaserator to create version 1.3.0 release

## Blockers

None.

## Context

- All 3 script templates updated: dev.sh, install.sh, uninstall.sh
- dev.sh template now has subcommands: bare=dev, start, stop, status
- No more exit prompt in dev mode -- service stays stopped
- SKILL.md and references/usage.md updated to match
- Driven by fixes to temoa and apantli that revealed the skill was outdated

## Next Session

Run releaserator to create version 1.3.0 release.
