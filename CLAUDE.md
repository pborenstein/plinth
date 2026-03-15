# Plinth Project Instructions

## What This Project Is

Plinth is a Claude Code plugin containing reusable tools for working on software projects. It provides:

- Development environment setup (python-project-init, fastapi-sweetener)
- macOS service management (macos-launchd-service)
- Release management (releaserator)
- Git workflow protection (git-workflow-hooks)

Session tracking and project documentation have moved to the [handoff](https://github.com/pborenstein/handoff) plugin.

This is the **source repository** for the plugin. Changes here get installed to other projects.

## Development Standards

### Code Style

- Markdown files: Add blank line before all lists
- Commands: Use clear, imperative descriptions
- Templates: Include examples and clear instructions
- No emojis unless in user-facing templates that specifically request them

### File Organization

```
plinth/
├── skills/            # Skills (python-project-init, fastapi-sweetener, macos-launchd-service, releaserator, git-workflow-hooks)
├── docs/              # Project documentation
│   ├── chronicles/    # Phase-specific chronicle files
│   └── archive/       # Archived documentation
├── .claude/           # This file (project-specific instructions)
├── .claude-plugin/    # Plugin metadata
└── README.md          # User documentation
```

## Working on Plinth

### Adding New Commands

1. Create `commands/command-name.md`
2. Use clear task lists for what the command should do
3. Test on a project before committing
4. Update README.md to document the new command

### Adding New Skills

1. Create `skills/skill-name/` directory
2. Add `SKILL.md` with frontmatter (name, description)
3. Add supporting docs and templates
4. Test on a project before committing
5. Update README.md to document the new skill

### Testing

Commands and skills should be tested on real projects (like temoa, tequitl) before being committed to plinth.

**Testing workflow**:
1. Make changes in plinth
2. Test on another project
3. Refine based on actual usage
4. Commit to plinth when working correctly

### Documentation Workflow

This project uses the [handoff](https://github.com/pborenstein/handoff) plugin for session tracking:

- **CONTEXT.md**: Current session state (hot state, 30-50 lines)
- **IMPLEMENTATION.md**: Current phase with tasks, design questions
- **DECISIONS.md**: Architectural decision registry
- **chronicles/phase-N-name.md**: Detailed session-by-session history

Use session commands:
- **/handoff:session-pickup**: Read current phase context to resume work
- **/handoff:session-wrapup**: Update tasks, create chronicle entry, commit docs

Also maintain:
- README.md with current commands/skills documentation
- Git commits for all changes

## Common Tasks

### Adding a new command

1. Create `commands/new-command.md`
2. Write clear task list of what it does
3. Test on another project
4. Add to README.md
5. Commit with message: `feat: add /new-command`

### Fixing a bug in a command

1. Read the command file
2. Fix the issue
3. Test on another project
4. Commit with message: `fix: describe what was fixed`

### Making a release

1. Ensure all work is committed and documentation is current (`/handoff:session-wrapup`)
2. Verify working directory is clean (`git status`)
3. Run `/releaserator` to create release
4. Command will:
   - Analyze commits since last release
   - Determine version bump (MAJOR.MINOR.PATCH)
   - Generate/update CHANGELOG.md
   - Update plugin.json version
   - Create git tag and push to remote
   - Create GitHub release

**When to make a release**:

- After completing a major phase
- When significant features or fixes have accumulated
- Before announcing plugin updates
- When ready to publish version to users

**Pre-release checklist**:

- All documentation current (run `/handoff:session-wrapup`)
- Working directory clean (no uncommitted changes)
- On main branch (or confirm release from current branch)
- GitHub CLI installed and authenticated (`gh auth status`)

## Project Goals

- Provide reusable tools for setting up and enhancing Python projects
- Keep skills simple and focused
- Avoid over-engineering - solve real problems

## What to Avoid

- Don't add commands that aren't battle-tested
- Don't create abstraction layers or complex tooling
- Don't add features "just in case" - wait for actual need
- Don't duplicate functionality across commands/skills
- Don't make breaking changes to established templates without good reason
