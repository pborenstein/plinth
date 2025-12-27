# Plinth Project Instructions

## What This Project Is

Plinth is a Claude Code plugin containing reusable tools for working on software projects. It provides:

- Project documentation tracking system (IMPLEMENTATION.md, CHRONICLES.md, DECISIONS.md)
- Session management commands (pickup/wrapup)
- Templates and workflows for consistent project documentation

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
├── commands/          # Slash commands (session-pickup, session-wrapup)
├── skills/            # Skills (project-documentation-tracking)
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

This project **does not use** the project documentation tracking system (no docs/IMPLEMENTATION.md). That's a tool we provide for other projects.

For plinth itself:
- Use git commits to track changes
- Keep README.md current with available commands/skills
- Document new features clearly

## Common Tasks

### Adding a new command

1. Create `commands/new-command.md`
2. Write clear task list of what it does
3. Test on another project
4. Add to README.md
5. Commit with message: `feat: add /new-command`

### Updating documentation templates

1. Edit files in `skills/project-documentation-tracking/templates/`
2. Test templates on another project
3. Update DOCUMENTATION-GUIDE.md if workflow changes
4. Commit with message: `docs: update chronicle entry template`

### Fixing a bug in a command

1. Read the command file
2. Fix the issue
3. Test on another project
4. Commit with message: `fix: session-wrapup handles split docs correctly`

## Project Goals

- Provide reusable tools for consistent project documentation
- Reduce friction in session pickup/wrapup
- Maintain templates and workflows that actually work in practice
- Keep commands simple and focused
- Avoid over-engineering - solve real problems

## What to Avoid

- Don't add commands that aren't battle-tested
- Don't create abstraction layers or complex tooling
- Don't add features "just in case" - wait for actual need
- Don't duplicate functionality across commands/skills
- Don't make breaking changes to established templates without good reason
