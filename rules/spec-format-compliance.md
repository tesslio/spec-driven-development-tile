---
alwaysApply: false
description: |
  Spec file formatting requirements. Use when creating, editing, or reviewing .spec.md files
  to ensure they follow the required format with YAML frontmatter, targets, and test links.
---

# Spec Format Compliance

All spec files must follow the `.spec.md` format.

## Required elements

1. **File extension**: `.spec.md`
2. **YAML frontmatter** with:
   - `name`: Human-readable feature name
   - `description`: One-line summary
   - `targets`: At least one relative path or glob pattern
3. **`[@test]` links** placed next to the requirements they verify

## Frontmatter example

```yaml
---
name: User Authentication
description: Login, logout, and session management requirements
targets:
  - ../src/auth/**/*.py
---
```

## Test link placement

Place `[@test]` links inline with requirements, not in a separate section:

```markdown
- Invalid passwords return 401
  `[@test] ../tests/test_auth_invalid_password.py`
```

## Structural rules

- One spec per logical unit of functionality
- Specs live in the project's `specs/` directory
- Targets use relative paths from the spec file location
- Test links use relative paths from the spec file location
