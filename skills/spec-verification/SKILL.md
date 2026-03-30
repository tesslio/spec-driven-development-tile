---
name: spec-verification
description: |
  Verify that implementation and tests remain synchronized with specs after code changes.
  Use when code has been generated or modified from specs, after implementation is complete,
  or when reviewing a PR that touches spec-covered code. Reports mismatched targets, broken
  test links, and undocumented behavioral changes. Common triggers: "verify the spec",
  "check spec alignment", "are specs up to date", or after completing implementation work.
---

# Spec Verification

Ensure code and tests still reflect the documented requirements. Detect and fix drift between specs, implementation, and tests.

## When to use

- After implementation is complete (before marking work as done)
- When reviewing PRs that touch spec-covered code
- When `work-review` flags potential spec drift
- Periodically as a maintenance check

## Steps

1. **Find all specs.** Locate `.spec.md` files in the project's `specs/` directory:
   ```bash
   find specs/ -name "*.spec.md" 2>/dev/null
   ```

2. **Validate structural integrity.** For each spec, check that links resolve:
   - Verify each `targets:` path exists (expand globs, confirm matches)
   - Verify each `[@test]` link points to an existing test file
   - Confirm frontmatter has `name`, `description`, and at least one target
   ```bash
   # Use the bundled validation scripts:
   ./scripts/validate-specs.sh specs/
   ./scripts/check-spec-links.sh specs/
   ```
   If either script reports failures, record them as broken-link findings.

3. **Run linked tests.** Execute the test files referenced by `[@test]` links:
   ```bash
   # Extract test paths from specs and run them
   grep -rh '\[@test\]' specs/*.spec.md | sed 's/.*\[@test\] *//' | sed 's/`$//'
   ```
   If tests fail, diagnose the failure. Determine whether the test, the code, or the spec is wrong before proceeding.

4. **Spot-check targets for drift.** Read the files listed in `targets:` and compare against spec requirements:
   - For each requirement in the spec, confirm the target file implements it
   - Look for logic in target files that contradicts the spec (edge cases, error handling, data contracts)
   - Look for new behavior in target files not mentioned in any spec

5. **Check for drift signals:**
   - Behavioral changes in code not mentioned in the spec
   - Newly added tests without matching requirements (or vice versa)
   - Deleted or renamed files that still appear in `targets:` or `[@test]` links
   - New code paths in target files that aren't covered by any requirement

6. **Fix drift.** When drift is detected:
   - If code changed behavior: update the spec first, then re-verify
   - If spec is stale: update the spec to match current implementation
   - If links are broken: update paths in frontmatter and `[@test]` links
   - After fixes, re-run steps 2-3 to confirm everything resolves

## Output

A verification report:

```
## Spec Verification: [date]

### Specs checked
- specs/auth.spec.md — OK
- specs/payments.spec.md — 2 issues

### Broken links
- specs/payments.spec.md: target `src/billing/old.py` not found (renamed to `src/billing/processor.py`)
- specs/payments.spec.md: [@test] `tests/test_refund.py` not found

### Drift detected
- specs/auth.spec.md: `login()` now accepts OAuth tokens — not documented in spec

### Actions taken
- Updated targets in specs/payments.spec.md
- Added OAuth requirement to specs/auth.spec.md
- All linked tests pass after fixes
```
