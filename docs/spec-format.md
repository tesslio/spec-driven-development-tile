# Spec Format

Specs are markdown files that define functional requirements and unit tests that verify correct implementation of those requirements. Where appropriate, specs typically begin with a code block describing any public API contracts in a compact, scannable format. All spec files end with `.spec.md`.

## Frontmatter

Specs include YAML frontmatter at the beginning of the file to clarify what they document. For example:

```yaml
---
name: Database Architecture
description: Key design patterns used across our data models
targets:
  - ../src/models/**/*.py
---
```

### `targets`

A list of relative file paths or glob patterns described by the spec. They can include:
- Specific file paths: `./src/auth/login.py`
- Glob patterns: `**/*.py`, `src/**/*.ts`

**Required:** All specs must have at least one target.

## `[@test]` Links

Specs should contain links to the tests that verify their behaviour. Test links are intermingled with the requirements they verify, with context dictating what content is verified.

### Example

<calculator.spec.md>
---
name: Calculator
description: Functional requirements for the calculator module
targets:
  - ../src/calculator.py
---

# Calculator

Performs basic arithmetic operations to two digits of precision.

```python
def add(a: int, b: int) -> int: ...
def subtract(a: int, b: int) -> int: ...
def multiply(a: int, b: int) -> int: ...
def divide(a: int, b: int) -> float: ...
```

`[@test] ../tests/calculator/test_basic_arithmetic.py`

## Error handling

- Division by zero should return `Nan`
  `[@test] ../tests/calculator/test_divide_by_zero.py`
- Non-numeric input should raise `TypeError`
  `[@test] ../tests/calculator/test_invalid_input_type.py`
</calculator.spec.md>
