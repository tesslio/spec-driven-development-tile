---
name: requirement-gathering
description: |
  Interview stakeholders to clarify ambiguous or underspecified requirements before writing
  code. Use when receiving a new task, feature request, or bug report that lacks clear
  acceptance criteria. Produces clarified requirements ready for spec authoring. Common
  triggers: "new feature", "build me", "implement", "add support for", or any task where
  requirements are vague or incomplete.
---

# Requirement Gathering

Structured interview process that turns vague requests into clear, actionable requirements.

## When to use

- A new task arrives from a stakeholder (feature, bugfix, refactor)
- The request has ambiguous or missing acceptance criteria
- Existing specs don't cover the requested change
- Before running `spec-writer` to create or update specs

## Rules

- Ask ONE question at a time (see `one-question-at-a-time` rule)
- Never begin implementation until requirements are confirmed
- Base questions on gaps found in existing specs, not assumptions

## Inputs

- The stakeholder's initial request
- Existing specs in the project's `specs/` folder (if any)

## Steps

1. **Review existing specs.** Scan the `specs/` directory for any specs related to the request. Note what's already documented and what's missing.

2. **Identify gaps.** List the ambiguous or underspecified areas:
   - Unclear scope boundaries (what's in vs. out)
   - Missing edge cases or error handling expectations
   - Unspecified behavior for boundary conditions
   - Unclear integration points with existing functionality
   - Missing non-functional requirements (performance, security)

3. **Interview the stakeholder.** Ask ONE question at a time. Wait for the answer before asking the next question. Prioritize questions by impact — ask about scope and core behavior first, edge cases second.

   Good questions are specific and bounded:
   - "Should the API return a 404 or an empty list when no results match?"
   - "Is this endpoint authenticated, and if so, which roles have access?"

   Bad questions are open-ended or bundled:
   - "What should the API do?" (too vague)
   - "What about errors, pagination, auth, and rate limits?" (too many at once)

4. **Summarize requirements.** After all questions are answered, present a concise summary of the clarified requirements back to the stakeholder for confirmation.

5. **Get explicit approval.** Do not proceed until the stakeholder confirms the summary is accurate. If they correct anything, update the summary and re-confirm.

## Output

A confirmed requirements summary ready to be turned into specs by `spec-writer`. The summary should include:
- Scope: what's included and excluded
- Core behavior: the happy path
- Edge cases: boundary conditions and error handling
- Constraints: performance, security, compatibility requirements

## Success criteria

- Zero ambiguous requirements remain after the interview
- Stakeholder explicitly confirmed the summary
- No implementation work began before confirmation
