# Spec-Driven Development Tile

[![tessl](https://img.shields.io/endpoint?url=https%3A%2F%2Fapi.tessl.io%2Fv1%2Fbadges%2Ftessl-labs%2Fspec-driven-development)](https://tessl.io/registry/tessl-labs/spec-driven-development)

This repository contains the source code of the "Spec Driven Development" tile released by Tessl.

- **Published versions**: https://tessl.io/registry/tessl-labs/spec-driven-development/
- **Source code**: https://github.com/tesslio/spec-driven-development-tile/

---

A methodology tile that teaches AI coding agents to gather requirements, write specifications, and get approval before writing code.

## What This Tile Does

When installed, this tile changes how your AI coding agent approaches tasks. Instead of diving straight into code, the agent will:

1. **Ask clarifying questions** — Interview you about requirements, one question at a time
2. **Write specs first** — Create structured specification documents before any implementation
3. **Wait for your approval** — Pause for confirmation that the specs capture your intent
4. **Implement with guardrails** — Build against the approved specs, then verify the work

This is the difference between an agent that assumes what you want and one that asks.

## Installation

### Using Tessl CLI

```bash
tessl init
tessl install tessl-labs/spec-driven-development
```

### Using npx (no installation required)

```bash
npx @tessl/cli install tessl-labs/spec-driven-development
```

## Usage

After installation, include "use spec-driven development" in your prompt:

```
Create an API for managing user subscriptions. Use spec-driven development.
```

The agent will start by asking questions rather than writing code:

- What endpoints do you need?
- What authentication method?
- What data store?
- What error handling behavior?

Once requirements are clear, the agent creates specs in a `specs/` directory, waits for your approval, then implements.

## What's in This Tile

### Skills

| Skill | Purpose |
|-------|---------|
| `requirement-gathering` | Interview stakeholders to clarify ambiguous requirements before writing code |
| `spec-writer` | Create or update `.spec.md` files from clarified requirements |
| `spec-verification` | Verify implementation and tests remain synchronized with specs |
| `work-review` | Review completed work against approved specs |

### Rules

| Rule | Always Apply | Purpose |
|------|-------------|---------|
| `spec-before-code` | Yes | Never begin implementation without an approved spec |
| `one-question-at-a-time` | Yes | Ask exactly one question per message during requirement gathering |
| `spec-format-compliance` | No | Ensure `.spec.md` files follow the required format |

### Docs

| File | Purpose |
|------|---------|
| `docs/spec-format.md` | How to structure spec files: YAML frontmatter, targets, `[@test]` links |
| `docs/spec-styleguide.md` | Best practices for writing clear, maintainable specs |

### Scripts

| Script | Purpose |
|--------|---------|
| `scripts/validate-specs.sh` | Validate `.spec.md` files have required frontmatter and structure |
| `scripts/check-spec-links.sh` | Check that `[@test]` links and targets point to existing files |

### Evals

Nine evaluation scenarios covering:
- Spec authoring from confirmed requirements
- Requirements gap analysis against existing specs
- Work review catching implementation drift
- Spec drift detection after file refactoring
- Extending an existing spec with new requirements
- Decomposing a vague request into concrete gaps
- Interview question preparation (one-question-at-a-time)
- Handling code written without a spec
- Trivial changes that should bypass the full workflow

### CI

GitHub Actions workflows (via [`tesslio/setup-tessl`](https://github.com/tesslio/setup-tessl)):
- **Lint** — validates tile structure on every push and PR
- **Skill review** — runs `tessl skill review` on all skills
- **Evals** — runs all 9 scenarios on PRs
- **Version check** — ensures `tile.json` version is bumped on PRs
- **Publish** — publishes to the Tessl registry on merge to main

## The Spec Format

Specs are markdown files (`.spec.md`) with YAML frontmatter:

````markdown
---
name: User Authentication
description: Login and session management
targets:
  - ../src/auth/*.py
---

# User Authentication

Users can log in with email and password.

```python
def login(email: str, password: str) -> Session: ...
def logout(session_id: str) -> None: ...
```

[@test] ../tests/auth/test_login.py

## Error Handling

- Invalid credentials return 401
  [@test] ../tests/auth/test_invalid_credentials.py
- Expired sessions return 403
  [@test] ../tests/auth/test_expired_session.py
````

Key elements:
- **`targets`**: Files or glob patterns the spec describes
- **`[@test]` links**: Inline references to tests that verify each requirement

## Why Spec-Driven Development?

**Vibecoding** (prompting without structure) produces apps that:
- Hallucinate APIs from stale training data
- Have useless error handling ("Something went wrong, try again")
- Lack tests
- Can't be verified against intent

**Spec-driven development** produces apps where:
- Requirements are explicit and reviewable
- Implementation can be verified against specs
- Tests trace back to documented requirements
- You maintain control over what gets built

## How It Works

This is a **steering tile** — it provides guidance that becomes part of the agent's context. When you install it:

1. Tessl adds the tile's files to your project's `.tessl/` directory
2. Your MCP-compatible agent (Claude Code, Cursor, etc.) reads this context
3. The agent follows the methodology described in the tile's skills and rules

No special commands. No annotations. No framework. Skills provide the workflows, rules enforce the constraints, and docs give the reference material.

## Workflow Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                    REQUIREMENT GATHERING                        │
│  • Review existing specs                                        │
│  • Identify ambiguous areas                                     │
│  • Interview stakeholder (one question at a time)               │
│  • Create/update specs                                          │
└─────────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────────┐
│                    STAKEHOLDER APPROVAL                         │
│  • Review specs for accuracy                                    │
│  • Confirm requirements are complete                            │
│  • Approve to proceed with implementation                       │
└─────────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────────┐
│                      IMPLEMENTATION                             │
│  • Build against approved specs                                 │
│  • Create tests linked to requirements                          │
│  • Follow targets defined in specs                              │
└─────────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────────┐
│                        REVIEW                                   │
│  • Verify all requirements satisfied                            │
│  • Update specs with any discovered requirements                │
│  • Ensure tests are linked from specs                           │
└─────────────────────────────────────────────────────────────────┘
```

## Combining with Library Tiles

This methodology tile works well alongside library/framework tiles from the [Tessl Registry](https://tessl.io/registry). For example:

```bash
tessl install tessl-labs/spec-driven-development
tessl install tessl/maven-io-quarkus--quarkus-core
```

Now your agent knows *how to work* (spec-driven methodology) and *what tools to use correctly* (Quarkus APIs). This prevents both process chaos and API hallucination.

## Links

- **Tessl Registry**: https://tessl.io/registry
- **Tessl Discord**: https://discord.com/invite/jbb2vHnHZQ

## License

MIT License — see [LICENSE](LICENSE) for details.
