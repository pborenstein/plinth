---
description: Initialize complete Python project with docs, dev environment, and tooling
---

# Python Project Initialization

Create a new Python project with comprehensive documentation system, development tooling, and workflow infrastructure.

Use the **python-project-init** skill to set up:

**Documentation System:**

- README.md, CLAUDE.md for project context
- docs/CONTEXT.md for current session state
- docs/IMPLEMENTATION.md for phase tracking
- docs/DECISIONS.md for architectural decisions
- docs/chronicles/ for session history

**Python Infrastructure:**

- pyproject.toml with uv package manager
- Package structure with CLI placeholder
- Test suite with pytest
- Development tools (mypy, ruff)

**Workflow Support:**

- Integrates with `/plinth:session-pickup` and `/plinth:session-wrapup`
- Phase-based implementation tracking
- Decision logging with rationale

The skill will ask for project details and create a production-ready Python project following established patterns.
