---
name: work-review
description: |
  Review completed implementation against approved specs to ensure all requirements are
  satisfied. Use after finishing implementation work, before marking a task as done, or
  when a stakeholder asks to verify deliverables against requirements. Produces a review
  summary with pass/fail per requirement. Common triggers: "review my work", "check against
  spec", "did I miss anything", "is implementation complete".
---

# Work Review

Review completed implementation to confirm all spec requirements are satisfied and specs remain accurate.

## When to use

- After completing implementation of a spec-driven task
- Before marking a task as done
- When a stakeholder asks to verify completeness

## Steps

1. **Find relevant specs.** Identify all specs whose `targets:` match the files changed during implementation:
   ```bash
   # List changed files, then find specs targeting them
   git diff --name-only HEAD~1 | head -20
   grep -rl "targets:" specs/*.spec.md
   ```

2. **Check each requirement.** Walk through every requirement in the spec. For each one:
   - Read the target file and confirm the requirement is implemented
   - Record the **file path and line number** where it's implemented (e.g., `src/auth.py:42`)
   - Verify edge cases called out in the spec are handled
   - For each `[@test]` link, confirm the test exists and exercises the requirement

3. **Run linked tests.** Execute all `[@test]` paths and record results:
   ```bash
   grep -rh '\[@test\]' specs/*.spec.md | sed 's/.*\[@test\] *//' | sed 's/`$//'
   ```
   If any test fails, the review cannot pass — diagnose before continuing.

4. **Capture ALL discovered requirements.** Compare the implementation against the spec and identify every behavioral difference — not just new features, but also:
   - Functions or events in the code that the spec doesn't mention
   - Behavior that differs from what the spec describes (e.g., silent skip vs. raising an error)
   - New error handling paths, default values, or configuration not in the spec

   For each discovered requirement:
   - Add it to the relevant spec
   - Link any tests that were created for it

5. **Update spec metadata.** If implementation changed the file structure:
   - Update `targets:` for new, moved, or deleted files
   - Update `[@test]` links for restructured tests

6. **Produce review summary:**

   ```
   ## Review: [Spec Name]

   ### Requirements
   - [x] Requirement 1 — implemented in src/foo.py:42
   - [x] Requirement 2 — implemented in src/bar.py:18
   - [ ] Requirement 3 — MISSING: no error handling for empty input

   ### Discovered requirements
   - Added: timeout handling for API calls (not in original spec)

   ### Test results
   - Linked tests: 5 passed, 0 failed
   - New tests added: tests/test_timeout.py

   ### Spec updates
   - Added timeout requirement to section 3
   - Updated targets to include src/baz.py
   ```

   The review passes when all requirements are checked, all linked tests pass, and no discovered requirements are left undocumented.
