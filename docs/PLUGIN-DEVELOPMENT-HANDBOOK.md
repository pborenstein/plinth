# Claude Code Plugin Development Handbook

> Comprehensive reference for developing Claude Code plugins, skills, agents, commands, and hooks.
> Generated from official documentation to reduce need for repeated web searches.

## Overview

Claude Code provides a powerful, extensible plugin system that allows you to create reusable components that can be shared across projects and teams. The system is built around five core concepts: **Plugins**, **Commands**, **Skills**, **Agents**, and **Hooks**, with optional **MCP Servers** and **LSP Servers** for deeper integrations.

---

## 1. PLUGINS - The Container System

### What Are Plugins?

Plugins are self-contained, versioned packages that extend Claude Code. They're the distribution mechanism for sharing reusable functionality across projects and teams. Each plugin is identified by a unique manifest file (`.claude-plugin/plugin.json`) and can include multiple components.

### When to Use Plugins vs. Standalone Configuration

| Aspect | Plugins | Standalone (`.claude/`) |
|--------|---------|------------------------|
| Slash command names | Namespaced: `/plugin-name:hello` | Short: `/hello` |
| Sharing | Distribute via marketplaces | Project-specific only |
| Versioning | Semantic versioning, easy updates | Manual copying |
| Scope | Reusable across projects | Single project |
| Best for | Team/community sharing | Personal workflows, quick experiments |

### Plugin File Structure

```
my-plugin/
├── .claude-plugin/                 # Metadata only (required)
│   └── plugin.json                # Plugin manifest
├── commands/                       # Optional: slash commands
│   ├── deploy.md
│   └── status.md
├── agents/                         # Optional: custom subagents
│   ├── code-reviewer.md
│   └── debugger.md
├── skills/                         # Optional: agent skills
│   ├── code-review/
│   │   └── SKILL.md
│   └── pdf-processor/
│       ├── SKILL.md
│       ├── reference.md
│       └── scripts/
├── hooks/                          # Optional: event handlers
│   └── hooks.json
├── .mcp.json                       # Optional: MCP servers
├── .lsp.json                       # Optional: LSP servers
├── scripts/                        # Optional: utility scripts
└── README.md                       # Documentation
```

**Critical Rule**: Only `plugin.json` goes in `.claude-plugin/`. All other directories (`commands/`, `agents/`, `skills/`, `hooks/`) must be at the plugin root level.

### Plugin Manifest: `plugin.json`

```json
{
  "name": "my-plugin",
  "version": "1.0.0",
  "description": "Brief description of what this plugin does",
  "author": {
    "name": "Your Name",
    "email": "your@email.com",
    "url": "https://github.com/yourname"
  },
  "homepage": "https://docs.example.com/plugin",
  "repository": "https://github.com/yourname/my-plugin",
  "license": "MIT",
  "keywords": ["keyword1", "keyword2"],
  "commands": ["./commands/"],
  "agents": "./agents/",
  "skills": "./skills/",
  "hooks": "./hooks/hooks.json",
  "mcpServers": "./mcp-config.json",
  "lspServers": "./.lsp.json",
  "outputStyles": "./styles/"
}
```

#### Required Fields

- **`name`**: Unique identifier (kebab-case, no spaces). Becomes the slash command namespace.

#### Metadata Fields

- **`version`**: Semantic versioning (`MAJOR.MINOR.PATCH`)
- **`description`**: Brief explanation shown in plugin manager
- **`author`**: Author information object
- **`homepage`**, **`repository`**, **`license`**: Standard metadata
- **`keywords`**: Discovery tags for marketplaces

#### Component Path Fields

- **`commands`**: Path(s) to slash command definitions
- **`agents`**: Path(s) to agent definitions
- **`skills`**: Path(s) to skill directories
- **`hooks`**: Path to hooks configuration
- **`mcpServers`**: Path to MCP server config
- **`lspServers`**: Path to LSP server config
- **`outputStyles`**: Path to output style configurations

**Path Rules**:

- Must be relative and start with `./`
- Can be strings or arrays of strings
- Supplement default directories, don't replace them
- Support `${CLAUDE_PLUGIN_ROOT}` variable for absolute references

#### Example from Plinth

```json
{
  "name": "plinth",
  "description": "A plugin to set the table",
  "version": "1.0.0",
  "author": {
    "name": "Philip Borenstein"
  }
}
```

Your plinth plugin uses defaults, so `commands/`, `agents/`, and `skills/` directories are automatically discovered without explicit path declarations.

---

## 2. COMMANDS - Slash Commands

### What Are Slash Commands?

Slash commands are Markdown files that define custom prompts or workflows invoked with `/command-name`. They're the most straightforward way to create reusable prompts.

### Command Types

#### Project Commands (Shared with Team)

- **Location**: `.claude/commands/`
- **Scope**: All team members in that repository
- **Namespace**: Shows as "(project)" in `/help`

#### Personal Commands (Your Machine)

- **Location**: `~/.claude/commands/`
- **Scope**: You, across all projects
- **Namespace**: Shows as "(user)" in `/help`

#### Plugin Commands (Distributed)

- **Location**: `commands/` directory in plugin root
- **Invocation**: `/plugin-name:command-name`
- **Scope**: Anyone with plugin installed

### Command Syntax

```
/<command-name> [arguments]
```

**Example**: `/optimize performance` where `optimize` is the command and `performance` is an argument.

### Command File Format

```markdown
---
description: Brief description of what the command does
argument-hint: "[arg1] [arg2]"
allowed-tools: Bash(git:*), Read, Write
model: claude-3-5-sonnet-20241022
disable-model-invocation: false
---

# Command Name

Detailed instructions for Claude on how to execute this command.
Include specific guidance on parameters, expected outcomes, and constraints.

## Examples

- Example usage 1
- Example usage 2
```

### Frontmatter Fields

| Field | Required | Purpose |
|-------|----------|---------|
| `description` | Yes | Shown in `/help` and used by SlashCommand tool |
| `argument-hint` | No | Hint for CLI auto-completion |
| `allowed-tools` | No | Tools the command can use without asking |
| `model` | No | Specific model for this command |
| `disable-model-invocation` | No | Prevent SlashCommand tool from calling this |

### Command Arguments

#### `$ARGUMENTS` - All Arguments

Captures all arguments passed after the command:

```markdown
---
description: Fix issue with ID and priority
---

Fix issue #$ARGUMENTS following our coding standards.
```

Usage: `/fix-issue 123 high-priority` → `$ARGUMENTS` becomes `"123 high-priority"`

#### `$1`, `$2`, etc. - Individual Arguments

Access specific arguments by position:

```markdown
---
description: Review PR
argument-hint: "[pr-number] [priority] [assignee]"
---

Review PR #$1 with priority $2 and assign to $3.
Focus on security, performance, and code style.
```

Usage: `/review-pr 456 high alice` → `$1="456"`, `$2="high"`, `$3="alice"`

### Advanced Features

#### Bash Command Execution

Execute shell commands before the prompt with `!` prefix:

```markdown
---
allowed-tools: Bash(git:*), Bash(grep:*)
---

## Context

- Current branch: !`git branch --show-current`
- Recent changes: !`git diff HEAD~1`
- Changed files: !`git diff --name-only HEAD~1`

## Task

Based on the above changes, create a descriptive commit message.
```

#### File References

Include file contents with `@` prefix:

```markdown
Review the implementation in @src/utils/helpers.js

Compare @src/old-version.js with @src/new-version.js
```

#### Thinking Mode

Include extended thinking keywords:

```markdown
Let me think deeply about this code architecture
using extended thinking to analyze the implications.
```

### Real-World Example: Plinth's Session Pickup

```markdown
# Session Pick-up

Read context from previous session to prepare for new work.

## Tasks to complete:

1. Find the current phase in docs/IMPLEMENTATION.md:
   - Use Grep to search for "🔵" to find the current phase
   - Use Read with offset/limit to read ~200-300 lines
   - Understand what phase/sub-phase is active

2. Make a plan for what to do next based on the current phase section
```

This command uses Grep and Read tools to efficiently find and load context without reading the entire file.

---

## 3. SKILLS - Agent Skills

### What Are Agent Skills?

Skills are model-invoked capabilities that teach Claude how to do something specific. Unlike slash commands (which you explicitly invoke), Claude automatically uses Skills when your request matches the skill's description.

**Key characteristic**: Skills are **discovered and activated by Claude**, not explicitly called by the user.

### Skill File Structure

```
my-skill/
├── SKILL.md              # Required: metadata + instructions
├── reference.md          # Optional: detailed documentation
├── examples.md           # Optional: usage examples
└── scripts/              # Optional: utility scripts
    ├── validate.py
    └── process.sh
```

### SKILL.md Format

```yaml
---
name: skill-name
description: What this skill does and when to use it (Claude uses this to decide when to apply the skill)
allowed-tools: Read, Grep, Bash(python:*)
model: claude-opus-4-20250805
---

# Skill Name

## Overview

Essential instructions here.

## When to Use

Clear trigger criteria.

## Process

Step-by-step instructions.

## Additional Resources

- [Detailed API docs](reference.md)
- [Usage examples](examples.md)

## Utility Scripts

To validate files, run:

```bash
python scripts/validate.py input.txt
```
```

### SKILL.md Frontmatter Fields

| Field | Required | Purpose |
|-------|----------|---------|
| `name` | Yes | Skill identifier (lowercase, hyphens, max 64 chars) |
| `description` | Yes | What it does + when to use (max 1024 chars) |
| `allowed-tools` | No | Tools Claude can use without asking |
| `model` | No | Specific model to use for this skill |

### Writing Effective Skill Descriptions

**Poor**: "Helps with documents"

**Good**: "Extract text and tables from PDF files, fill forms, merge documents. Use when working with PDF files or when the user mentions PDFs, forms, or document extraction."

The description should:

1. Name specific capabilities (extract, validate, merge)
2. Include keywords users would naturally say
3. Define when Claude should apply the skill

### Skill Discovery and Activation

**Step 1: Discovery**

- Claude loads skill names and descriptions at startup
- This keeps startup fast while enabling skill matching

**Step 2: Activation**

- When your request matches a skill's description, Claude asks permission
- You see a confirmation before the full `SKILL.md` is loaded

**Step 3: Execution**

- Claude follows the skill's instructions
- Loads referenced files as needed
- Executes bundled scripts

### Where Skills Live

| Type | Location | Scope | Priority |
|------|----------|-------|----------|
| Enterprise | See managed settings | All users in org | Highest |
| Personal | `~/.claude/skills/` | You, all projects | High |
| Project | `.claude/skills/` | Team in repo | Medium |
| Plugin | `plugin/skills/` | Plugin users | Lowest |

**Precedence**: Enterprise > Personal > Project > Plugin

### Progressive Disclosure Pattern

For complex skills with extensive documentation:

```
my-skill/
├── SKILL.md                 # Keep under 500 lines
│   ├── Overview
│   ├── Quick start
│   └── Links to supporting files
├── DETAILED-API.md          # Loaded when needed
├── EXAMPLES.md              # Loaded when needed
└── scripts/
    └── helper.py            # Executed, not read
```

In `SKILL.md`, reference supporting files so Claude knows they exist:

```markdown
## Complete API Reference

For detailed API documentation, see [DETAILED-API.md](DETAILED-API.md).

For usage examples, see [EXAMPLES.md](EXAMPLES.md).

## Utility Scripts

To validate your work:

```bash
python scripts/helper.py input.txt
```
```

Claude loads referenced files only when the task requires them.

### Restricting Tool Access

Use `allowed-tools` to limit which tools Claude can use:

```yaml
---
name: safe-file-reader
description: Read files safely without making changes
allowed-tools: Read, Grep, Glob
---

# Safe File Reader

This skill provides read-only file access.
```

When this skill is active, Claude can only use Read, Grep, and Glob without needing permission.

### Real-World Example: Plinth's Project Documentation Tracking

From `/Users/philip/projects/plinth/skills/project-tracking/SKILL.md`:

```yaml
---
name: project-tracking
description: Establish the files used to track and manage progress.
allowed-tools: Read, Write, Bash, Glob
---
```

This skill teaches Claude how to set up the four-file documentation system (IMPLEMENTATION.md, CHRONICLES.md, DECISIONS.md, chronicle entries). It includes:

- Instructions for new projects (simple setup)
- Instructions for existing projects (retroactive documentation)
- Step-by-step processes for analyzing git history
- Templates for creating documentation files
- Progressive disclosure with separate template files

### Skills vs. Slash Commands

| Aspect | Skills | Slash Commands |
|--------|--------|-----------------|
| **How invoked** | Automatic (Claude decides) | Explicit (`/command`) |
| **Structure** | Directory with SKILL.md + files | Single .md file |
| **Complexity** | Complex workflows, multiple files | Simple prompts |
| **Discovery** | Semantic matching on description | Listed in `/help` |
| **Files** | Multiple with supporting resources | One file only |

---

## 4. AGENTS - Subagents

### What Are Subagents?

Subagents are specialized AI personalities with their own context window, tool access, and system prompts. Claude can delegate tasks to subagents when appropriate, or you can explicitly request a specific subagent.

**Key benefits**:

- **Context preservation**: Main conversation stays clean
- **Specialized expertise**: Fine-tuned for specific tasks
- **Flexible permissions**: Different tool access per agent
- **Reusability**: Use across projects, share with teams

### Subagent File Structure

```
.claude/agents/
├── code-reviewer/
│   └── AGENT.md
├── test-runner/
│   └── AGENT.md
└── debugger/
    └── AGENT.md
```

Personal agents go in `~/.claude/agents/`
Project agents go in `.claude/agents/`

### AGENT.md Format

```markdown
---
name: code-reviewer
description: Expert code review specialist. Reviews code for quality, security, and maintainability. Use immediately after writing or modifying code.
tools: Read, Grep, Glob, Bash
model: inherit
permissionMode: default
skills: code-quality, security-check
---

You are a senior code reviewer ensuring high standards of code quality and security.

## When Invoked

1. Run git diff to see recent changes
2. Focus on modified files
3. Begin review immediately

## Review Checklist

- Code is clear and readable
- Functions and variables are well-named
- No duplicated code
- Proper error handling
- No exposed secrets or API keys
- Input validation implemented
- Good test coverage
- Performance considerations addressed

## Feedback Organization

- **Critical issues** (must fix)
- **Warnings** (should fix)
- **Suggestions** (consider improving)
```

### AGENT.md Frontmatter Fields

| Field | Required | Description |
|-------|----------|-------------|
| `name` | Yes | Unique identifier (lowercase, hyphens) |
| `description` | Yes | Purpose and when Claude should use it |
| `tools` | No | Comma-separated list of allowed tools; omit to inherit all |
| `model` | No | `sonnet`, `opus`, `haiku`, or `'inherit'`; defaults to sonnet |
| `permissionMode` | No | `default`, `acceptEdits`, `bypassPermissions`, `plan`, `ignore` |
| `skills` | No | Comma-separated list of skill names to auto-load |

### Model Selection

```yaml
model: inherit    # Use same model as main conversation
model: sonnet     # Use Claude Sonnet
model: opus       # Use Claude Opus
model: haiku      # Use Claude Haiku
```

If omitted, defaults to Sonnet for custom subagents.

### Available Tools

Subagents can access any Claude Code tool. Common choices:

- **Read, Grep, Glob**: Codebase exploration
- **Write, Edit**: File modifications
- **Bash**: Command execution
- **WebFetch, WebSearch**: Web access
- **MCP tools**: From connected MCP servers

### Managing Subagents

#### Via `/agents` Command (Recommended)

```bash
/agents
```

Provides interactive interface for:

- Viewing all subagents
- Creating new agents
- Editing tools, model, permissions
- Deleting agents

#### Via Direct File Management

```bash
mkdir -p .claude/agents
cat > .claude/agents/my-agent.md << 'EOF'
---
name: my-agent
description: What this agent specializes in
tools: Read, Write, Bash
---

System prompt and instructions here.
EOF
```

### Built-in Subagents

#### Plan Subagent

- **Model**: Sonnet
- **Tools**: Read, Glob, Grep, Bash (read-only)
- **Purpose**: Research codebase in plan mode before presenting plans
- **Auto-invoked**: When in plan mode and research is needed

#### Explore Subagent

- **Model**: Haiku (fast, lightweight)
- **Mode**: Strictly read-only
- **Tools**: Glob, Grep, Read, Bash (read-only commands only)
- **Purpose**: Fast codebase exploration without bloating main context
- **Thoroughness levels**: Quick, Medium, Very thorough

#### General-Purpose Subagent

- **Model**: Sonnet
- **Tools**: All tools
- **Purpose**: Complex research + modification tasks
- **When used**: Claude delegates for multi-step operations

### Using Subagents

#### Automatic Delegation

Claude automatically delegates when a task matches a subagent's description:

```
You: Fix failing tests

Claude: [Invokes test-runner subagent]
[Agent runs tests, analyzes failures, fixes them]
[Returns results to main conversation]
```

#### Explicit Invocation

```
You: Use the code-reviewer subagent to check my recent changes
```

### Resumable Subagents

Subagents can be resumed to continue previous conversations:

```
> Use code-analyzer to start reviewing authentication module
[Returns with agentId: "abc123"]

> Resume agent abc123 and now analyze the authorization logic
[Agent continues with full previous context]
```

Each execution gets a unique `agentId` and transcript file (`agent-{agentId}.jsonl`).

---

## 5. HOOKS - Event Handlers

### What Are Hooks?

Hooks automatically respond to Claude Code events. They run scripts or prompts when specific actions occur.

### Supported Hook Events

| Event | When It Fires |
|-------|---------------|
| `PreToolUse` | Before Claude uses any tool |
| `PostToolUse` | After Claude successfully uses a tool |
| `PostToolUseFailure` | After tool execution fails |
| `PermissionRequest` | When permission dialog is shown |
| `UserPromptSubmit` | When user submits a prompt |
| `Notification` | When Claude Code sends notifications |
| `PreCompact` | Before conversation compaction |
| `SessionStart` | At session beginning |
| `SessionEnd` | At session end |
| `SubagentStart` | When subagent starts |
| `SubagentStop` | When subagent stops |
| `Stop` | When Claude attempts to stop |

### Hook Configuration: `hooks.json`

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [
          {
            "type": "command",
            "command": "${CLAUDE_PLUGIN_ROOT}/scripts/format-code.sh"
          }
        ]
      }
    ],
    "SessionStart": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "bash ~/.claude/hooks/session-start.sh"
          }
        ]
      }
    ]
  }
}
```

### Hook Types

#### Command Hooks

Execute shell scripts or programs:

```json
{
  "type": "command",
  "command": "/path/to/script.sh"
}
```

#### Prompt Hooks

Evaluate LLM prompts (uses `$ARGUMENTS` for context):

```json
{
  "type": "prompt",
  "prompt": "Is this change safe? Evaluate potential security implications."
}
```

#### Agent Hooks

Run agentic verification with full tool access:

```json
{
  "type": "agent",
  "prompt": "Verify this change is correct"
}
```

### Hook Configuration in `.claude-plugin/plugin.json`

Hooks can be inline or in a separate file:

```json
{
  "name": "my-plugin",
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write",
        "hooks": [
          {
            "type": "command",
            "command": "${CLAUDE_PLUGIN_ROOT}/scripts/validate.sh"
          }
        ]
      }
    ]
  }
}
```

Or reference a separate file:

```json
{
  "name": "my-plugin",
  "hooks": "./hooks/hooks.json"
}
```

---

## 6. MCP SERVERS - External Tool Integration

### What Are MCP Servers?

MCP (Model Context Protocol) servers connect Claude Code to external tools, databases, APIs, and services.

### MCP Configuration: `.mcp.json`

```json
{
  "mcpServers": {
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_TOKEN": "${GITHUB_TOKEN}"
      }
    },
    "database": {
      "command": "${CLAUDE_PLUGIN_ROOT}/servers/db-server",
      "args": ["--config", "${CLAUDE_PLUGIN_ROOT}/config.json"],
      "env": {
        "DB_PATH": "${CLAUDE_PLUGIN_ROOT}/data"
      }
    }
  }
}
```

### Common MCP Servers

- **GitHub**: Access repositories, issues, PRs
- **Slack**: Send messages, read channels
- **PostgreSQL**: Direct database queries
- **Sentry**: Monitor errors and exceptions
- **Custom servers**: Build your own with MCP SDK

### Using MCP Tools in Subagents

Subagents inherit MCP tools from parent when `tools` field is omitted:

```yaml
---
name: github-reviewer
description: Review pull requests using GitHub MCP
# tools omitted = inherits all tools including MCP tools
---

You have access to GitHub tools through MCP.
```

Or explicitly restrict:

```yaml
tools: Read, mcp__github__*, Bash
```

---

## 7. LSP SERVERS - Code Intelligence

### What Are LSP Servers?

LSP (Language Server Protocol) servers provide real-time code intelligence: go-to-definition, find references, hover information, and diagnostics.

### LSP Configuration: `.lsp.json`

```json
{
  "go": {
    "command": "gopls",
    "args": ["serve"],
    "extensionToLanguage": {
      ".go": "go"
    }
  },
  "rust": {
    "command": "rust-analyzer",
    "extensionToLanguage": {
      ".rs": "rust"
    }
  }
}
```

### Inline in `plugin.json`

```json
{
  "name": "go-support",
  "lspServers": {
    "go": {
      "command": "gopls",
      "args": ["serve"],
      "extensionToLanguage": {
        ".go": "go"
      }
    }
  }
}
```

### Official LSP Plugins

| Plugin | Language | Install |
|--------|----------|---------|
| `pyright-lsp` | Python | `pip install pyright` |
| `typescript-lsp` | TypeScript | `npm install -g typescript-language-server typescript` |
| `rust-lsp` | Rust | [rust-analyzer installation](https://rust-analyzer.github.io/) |

**Important**: LSP plugins configure connections but don't include the servers. Install the language server binary separately.

---

## 8. OUTPUT STYLES

### What Are Output Styles?

Output styles customize Claude's response formatting without changing the underlying behavior.

**Comparable to**: CLAUDE.md instructions but more focused on response format
**Different from**: Custom slash commands (which are full workflows)

Configure in plugin.json:

```json
{
  "outputStyles": "./styles/"
}
```

---

## How All Elements Work Together

### Architecture Diagram

```
Plugin (plugin.json manifest)
│
├─ Commands (slash commands)
│  └─ User invokes: /plugin:command
│     └─ Can use any tool with allowed-tools
│
├─ Skills (SKILL.md files)
│  └─ Claude auto-invokes based on description
│     └─ Can restrict tools with allowed-tools
│     └─ Can load supporting files progressively
│
├─ Agents (AGENT.md files)
│  └─ Claude can delegate tasks automatically
│     └─ Can be explicitly invoked by user
│     └─ Can use subset of tools
│     └─ Can load specific skills
│
├─ Hooks (hooks.json)
│  └─ Auto-triggered on Claude Code events
│     └─ Can execute scripts, prompts, or agents
│
├─ MCP Servers (.mcp.json)
│  └─ Provide external tools for Claude
│     └─ Appear as standard tools in context
│     └─ Can be restricted per agent
│
└─ LSP Servers (.lsp.json)
   └─ Provide code intelligence
      └─ Real-time diagnostics and navigation
```

### Practical Example: Code Review Workflow

1. **User creates code**: Invokes `/my-plugin:draft-pr` command
   - Command has `allowed-tools: Write, Read, Bash`
   - Creates PR draft

2. **Auto-invoked skill**: "code-review" skill description matches
   - Claude asks to use code-review skill
   - Skill loads SECURITY.md and STYLE.md files progressively
   - Outputs detailed review

3. **Auto-invoked agent**: "code-reviewer" agent description matches
   - Claude delegates to code-reviewer agent
   - Agent has `tools: Read, Grep, Glob, Bash` only
   - Agent runs linters via MCP server tool
   - Agent returns findings

4. **Hook fires**: PostToolUse on Edit action
   - Formatting script runs
   - Changes are auto-formatted

5. **Final result**: Well-reviewed, formatted, linted code

---

## Plugin Development Workflow

### Creating Your First Plugin

1. **Create directory structure**:

```bash
mkdir -p my-plugin/.claude-plugin
```

2. **Create manifest** (`my-plugin/.claude-plugin/plugin.json`):

```json
{
  "name": "my-plugin",
  "description": "Plugin description",
  "version": "1.0.0"
}
```

3. **Add components** as needed:

```bash
mkdir -p my-plugin/commands my-plugin/skills
```

4. **Test locally**:

```bash
claude --plugin-dir ./my-plugin
```

5. **Deploy to marketplace** for distribution

### Testing Multiple Plugins

```bash
claude --plugin-dir ./plugin-one --plugin-dir ./plugin-two
```

### Debugging Plugin Issues

```bash
claude --debug
```

Shows plugin loading details, errors, and component registration.

---

## Plugin Installation Scopes

| Scope | Settings File | Availability | Use Case |
|-------|---------------|--------------|----------|
| `user` | `~/.claude/settings.json` | All projects | Personal plugins |
| `project` | `.claude/settings.json` | Team in repo | Shared plugins |
| `local` | `.claude/settings.local.json` | This machine only | Gitignored testing |
| `managed` | `managed-settings.json` | Enterprise | Org-wide (read-only) |

---

## Environment Variables in Plugin Paths

### `${CLAUDE_PLUGIN_ROOT}`

Expands to absolute path of plugin directory:

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "${CLAUDE_PLUGIN_ROOT}/scripts/format.sh"
          }
        ]
      }
    ]
  }
}
```

This ensures paths work correctly regardless of installation location.

---

## Distribution Through Plugin Marketplaces

### Marketplace Entry Format

```json
{
  "name": "my-plugin",
  "description": "What this plugin does",
  "source": "https://github.com/yourname/my-plugin",
  "version": "1.0.0"
}
```

### Marketplace JSON Structure

```json
{
  "plugins": [
    {
      "name": "code-formatter",
      "source": "./plugins/code-formatter",
      "description": "Auto-format code"
    },
    {
      "name": "github-integration",
      "source": "https://github.com/team/gh-plugin",
      "description": "GitHub PR tools"
    }
  ]
}
```

### Installing from Marketplace

```bash
claude /plugin install code-formatter@my-marketplace --scope project
```

---

## Real-World Example: Plinth Plugin Architecture

Your plinth plugin demonstrates best practices:

### Plugin Manifest

```json
{
  "name": "plinth",
  "description": "A plugin to set the table",
  "version": "1.0.0",
  "author": { "name": "Philip Borenstein" }
}
```

### Components Used

1. **Commands** (`.claude/commands/`):
   - `/plinth:session-pickup`: Efficiently read session context
   - `/plinth:session-wrapup`: Update docs and create commits
   - `/plinth:hello`: Greet users

2. **Skills** (`.claude/skills/`):
   - `project-tracking`: Complex workflow with:
     - Multi-file structure (SKILL.md + DOCUMENTATION-GUIDE.md)
     - Progressive disclosure (templates separate from main instructions)
     - Tool restrictions (Read, Write, Bash, Glob)

3. **Supporting Files**:
   - Templates for chronicle entries, decisions
   - README.md with usage documentation
   - CLAUDE.md with project-specific instructions

---

## Best Practices Summary

### Plugin Design

- Keep plugins focused on one responsibility
- Use semantic versioning
- Document with comprehensive README
- Test locally before distributing

### Commands

- Write clear descriptions (used in `/help`)
- Use `allowed-tools` to restrict access
- Support arguments with `$1`, `$2`, or `$ARGUMENTS`
- Link to documentation files

### Skills

- Make descriptions specific (Claude uses these for matching)
- Use progressive disclosure for complex content
- Keep SKILL.md under 500 lines
- Include keywords users would say

### Agents

- Design focused agents with single responsibility
- Write detailed system prompts
- Only grant necessary tools
- Use `model: inherit` for consistency

### Hooks

- Use matchers to target specific tools
- Provide clear error messages
- Test scripts independently
- Use `${CLAUDE_PLUGIN_ROOT}` for paths

---

## Quick Reference

### File Locations

```
Plugin Root
├── .claude-plugin/plugin.json      # Required manifest
├── commands/*.md                    # Slash commands
├── skills/*/SKILL.md                # Agent skills
├── agents/*/AGENT.md                # Subagents
├── hooks/hooks.json                 # Event handlers
├── .mcp.json                        # MCP servers
└── .lsp.json                        # LSP servers
```

### Common Patterns

**Namespace plugin commands**:
`/plugin-name:command-name`

**Allow specific tools in commands**:
```yaml
allowed-tools: Read, Write, Bash(git:*)
```

**Reference command arguments**:
- `$ARGUMENTS` - all args as single string
- `$1`, `$2`, etc. - individual args

**Progressive disclosure in skills**:
- Keep SKILL.md under 500 lines
- Reference supporting docs
- Claude loads them when needed

**Tool restrictions in agents**:
```yaml
tools: Read, Grep, Glob  # Read-only agent
```

**Use environment variables**:
`${CLAUDE_PLUGIN_ROOT}` for plugin-relative paths
