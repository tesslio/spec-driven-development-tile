---
alwaysApply: true
---

# Spec Before Code

Never begin implementation without an approved spec.

## The rule

When receiving a new task that involves writing or modifying code:

1. Check if a `specs/` directory exists with relevant specs
2. If existing specs cover the work — verify they're still accurate before proceeding
3. If no specs exist or none cover the work — gather requirements and write a spec first
4. Get explicit stakeholder approval on the spec before writing any code

When no `specs/` directory exists, skip the review step and go straight to requirement gathering. Don't waste effort searching for specs that aren't there.

## What counts as approval

- Stakeholder says the spec is accurate (e.g., "looks good", "yes", "approved")
- Stakeholder makes corrections and then confirms the updated version

## What does NOT count as approval

- Silence or no response
- "Just do it" without reviewing the spec
- Your own judgment that the spec is probably fine

## Exceptions

- Trivial changes (typo fixes, formatting) that don't alter behavior
- Emergency hotfixes — but a spec must be written retroactively
