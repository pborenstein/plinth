# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.4.0] - 2026-03-28

### Added

- Make releaserator version-file agnostic ([7cafaee](https://github.com/pborenstein/plinth/commit/7cafaee))
  - Auto-detect version file instead of hardcoding plugin.json
  - Support plugin.json, package.json, pyproject.toml, and Cargo.toml

## [1.3.0] - 2026-03-28

### Added

- Modernize macos-launchd-service templates with bootstrap/bootout API ([39ecb57](https://github.com/pborenstein/plinth/commit/39ecb57))
  - Replace deprecated launchctl load/unload with modern bootstrap/bootout
  - Rewrite dev.sh template with subcommands (start/stop/status/dev mode)

### Changed

- Extract project-tracking, session-pickup, and session-wrapup to standalone handoff plugin ([66bfefe](https://github.com/pborenstein/plinth/commit/66bfefe))
- Reorganize README - remove Commands section, everything is skills ([693e602](https://github.com/pborenstein/plinth/commit/693e602))

## [1.2.2] - 2026-02-13

### Changed

- Rename fastapi-scaffold to fastapi-sweetener, make it additive ([bb1730d](https://github.com/pborenstein/plinth/commit/bb1730d))
- Update python-project-init to use Click for subcommand support ([bb1730d](https://github.com/pborenstein/plinth/commit/bb1730d))
- Standardize skill documentation structure ([3ed069e](https://github.com/pborenstein/plinth/commit/3ed069e))
- Reorganize skill directories and documentation ([a3afefd](https://github.com/pborenstein/plinth/commit/a3afefd))
- Migrate session commands to skills, remove obsolete commands ([eea2372](https://github.com/pborenstein/plinth/commit/eea2372))
- Enforce uv-only and no-emoji rules in python-project-init ([e551eae](https://github.com/pborenstein/plinth/commit/e551eae))

### Fixed

- Correct session-pickup skill description ([ed63b2c](https://github.com/pborenstein/plinth/commit/ed63b2c))

## [1.2.1] - 2026-01-20

### Fixed

- Allow releaserator to push tags in pre-push hook ([1fb71b6](https://github.com/pborenstein/plinth/commit/1fb71b6))

## [1.2.0] - 2026-01-20

### Added

- Git workflow hooks skill to prevent manual version tag pushes ([0f68b44](https://github.com/pborenstein/plinth/commit/0f68b44))

## [1.1.5] - 2026-01-15

### Changed

- Remove redundant releaserator command - skills now directly slashable in Claude Code 2.1.3+ ([faa1539](https://github.com/pborenstein/plinth/commit/faa1539))
- Remove redundant version tracking from README and IMPLEMENTATION.md ([117560f](https://github.com/pborenstein/plinth/commit/117560f))

## [1.1.4] - 2026-01-15

### Changed

- Add allowed-tools frontmatter to releaserator and session-wrapup commands ([8b973ee](https://github.com/pborenstein/plinth/commit/8b973ee))
- Refactor python-project-init to delegate docs setup to project-tracking skill ([8b973ee](https://github.com/pborenstein/plinth/commit/8b973ee))

## [1.1.3] - 2026-01-15

### Changed

- Add installation instructions and contributing policy to README ([1b39ca6](https://github.com/pborenstein/plinth/commit/1b39ca6))
- Sync implementation tracker to reflect Phase 4 as current ([1b39ca6](https://github.com/pborenstein/plinth/commit/1b39ca6))

## [1.1.2] - 2026-01-15

### Fixed

- Scan chronicle files for entry numbers instead of using last_entry field ([0fd64d6](https://github.com/pborenstein/plinth/commit/0fd64d6))

## [1.1.1] - 2026-01-12

### Fixed

- Add explicit bash command permissions to releaserator skill ([4a144f2](https://github.com/pborenstein/plinth/commit/4a144f2))
- Remove backtick-exclamation pattern that triggers permission check ([21925d7](https://github.com/pborenstein/plinth/commit/21925d7))

## [1.1.0] - 2026-01-12

### Added

- Release management with releaserator ([#4](https://github.com/pborenstein/plinth/pull/4)) ([d1f6772](https://github.com/pborenstein/plinth/commit/d1f6772))
  - Automated semantic versioning from Conventional Commits
  - Keep A Changelog formatted CHANGELOG.md generation
  - GitHub release creation via gh CLI
  - Platform abstraction for future GitLab/Gitea support
- FastAPI project scaffolding skill ([814cf29](https://github.com/pborenstein/plinth/commit/814cf29))
  - Production-ready FastAPI project generation
  - uvicorn integration with auto-reload
  - OpenAPI documentation and configuration management
- macOS launchd service management skill ([9d42111](https://github.com/pborenstein/plinth/commit/9d42111))
  - Auto-start service infrastructure for Python applications
  - Service installation, logging, and management scripts
  - Service uninstall capability ([dae8977](https://github.com/pborenstein/plinth/commit/dae8977))
- Python development environment setup command ([fb06c14](https://github.com/pborenstein/plinth/commit/fb06c14))
  - uv-based package manager integration
  - Virtual environment and dependency management
- Permission-free skill operation with allowed-tools ([ee98e63](https://github.com/pborenstein/plinth/commit/ee98e63))
- Project documentation tracking system ([8c1d439](https://github.com/pborenstein/plinth/commit/8c1d439))
  - Session pickup and wrapup commands ([3ebe8d0](https://github.com/pborenstein/plinth/commit/3ebe8d0))
  - Token-efficient documentation with CONTEXT.md ([#2](https://github.com/pborenstein/plinth/pull/2)) ([7064be2](https://github.com/pborenstein/plinth/commit/7064be2))
  - Phase-based implementation tracking
  - Architectural decision registry

### Changed

- Renamed DOCUMENTATION-GUIDE to PROJECT-TRACKING ([#3](https://github.com/pborenstein/plinth/pull/3)) ([5d5680a](https://github.com/pborenstein/plinth/commit/5d5680a))
- Renamed project-documentation-tracking to project-tracking ([dff43d4](https://github.com/pborenstein/plinth/commit/dff43d4))
- launchd skill now uses provided parameters ([b3d9400](https://github.com/pborenstein/plinth/commit/b3d9400))
- session-pickup explicitly uses Grep+Read with offset ([a608246](https://github.com/pborenstein/plinth/commit/a608246))

### Fixed

- Testing guide rewritten to properly invoke skills ([e5c1513](https://github.com/pborenstein/plinth/commit/e5c1513))
- Service labels use {{DOMAIN}} parameter correctly ([1ac702c](https://github.com/pborenstein/plinth/commit/1ac702c))

### Performance

- Optimized session-pickup to reduce token consumption by 50-60% ([e9fff59](https://github.com/pborenstein/plinth/commit/e9fff59))

[Unreleased]: https://github.com/pborenstein/plinth/compare/v1.4.0...HEAD
[1.4.0]: https://github.com/pborenstein/plinth/releases/tag/v1.4.0
[1.3.0]: https://github.com/pborenstein/plinth/releases/tag/v1.3.0
[1.2.2]: https://github.com/pborenstein/plinth/releases/tag/v1.2.2
[1.2.1]: https://github.com/pborenstein/plinth/releases/tag/v1.2.1
[1.2.0]: https://github.com/pborenstein/plinth/releases/tag/v1.2.0
[1.1.5]: https://github.com/pborenstein/plinth/releases/tag/v1.1.5
[1.1.4]: https://github.com/pborenstein/plinth/releases/tag/v1.1.4
[1.1.3]: https://github.com/pborenstein/plinth/releases/tag/v1.1.3
[1.1.2]: https://github.com/pborenstein/plinth/releases/tag/v1.1.2
[1.1.1]: https://github.com/pborenstein/plinth/releases/tag/v1.1.1
[1.1.0]: https://github.com/pborenstein/plinth/releases/tag/v1.1.0
