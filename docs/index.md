# Spec-Driven Development

Spec-driven development creates and maintains natural language specifications as an integral, versioned component of software projects. Specs capture functional requirements and link to the tests that verify them, creating a traceable chain from requirements to implementation.

## How it works

1. **Gather requirements** — Interview stakeholders to clarify ambiguous areas before writing code
2. **Write specs** — Create `.spec.md` files that document requirements and link to tests
3. **Get approval** — Stakeholder confirms specs capture the intended requirements
4. **Implement** — Build against approved specs
5. **Review** — Verify all requirements are satisfied, update specs with discoveries
6. **Verify** — Ensure specs, code, and tests stay synchronized over time

## Reference documentation

- [Spec Format](./spec-format.md) — File structure, frontmatter, targets, and `[@test]` link syntax
- [Spec Styleguide](./spec-styleguide.md) — Best practices for writing clear, maintainable specs
