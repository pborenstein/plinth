---
phase: 6
phase_name: Spec Alignment
updated: 2026-03-28
last_commit: 2475b6c
---

## Current Focus

Removed hardcoded plugin.json dependency from releaserator skill. Now auto-detects version file type (plugin.json, package.json, pyproject.toml, Cargo.toml).

## Active Tasks

- [x] Modernize launchd templates (bootstrap/bootout)
- [x] Add dev.sh subcommands (start/stop/status)
- [x] Update SKILL.md and usage.md references
- [x] Make releaserator version-file agnostic
- [ ] Run releaserator to create next release

## Blockers

None.

## Context

- Releaserator SKILL.md and references/usage.md updated for multi-format version detection
- Detection order: plugin.json > package.json > pyproject.toml > Cargo.toml
- Step 1 detects, Step 2 parses, Step 7 updates, Step 8 stages the detected file
- Error messages and success criteria now reference VERSION_FILE instead of plugin.json

## Next Session

Create release with releaserator.
