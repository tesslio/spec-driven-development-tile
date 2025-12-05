# Spec Verification (Manual)

Spec verification ensures code and tests still reflect the documented requirements. Rely on deliberate review and targeted testing to detect drift.

## Manual Workflow

1. **Review changes**: Compare the spec diff with code/test diffs to confirm every requirement has a corresponding implementation and check.
2. **Run linked tests**: Execute the `[@test]` paths referenced in the spec. Add or adjust tests when requirements shift.
3. **Spot-check targets**: Open the files listed in `targets:` and skim for logic that might now contradict the spec (edge cases, error handling, data contracts).
4. **Update the spec first**: When code changes behaviour, update the spec in the same change so reviewers can approve both together.

## CI Recommendations

- Run the full test suite plus any spec-linked paths on every PR.
- Fail the build if `targets:` entries or `[@test]` links point to missing files.
- Surface a checklist in PR templates to confirm spec and tests were updated.

## Signs of Drift to Watch For

- Behavioural changes not mentioned in the spec
- Newly added tests without matching requirements (or vice versa)
- Deleted or renamed files that still appear in `targets:` or test links

Maintaining tight alignment between specs, tests, and implementation keeps specs useful and trustworthy.
