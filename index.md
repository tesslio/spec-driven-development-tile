# Spec-driven development

Spec-driven development creates and maintains natural language specifications as an integral, versioned component of software projects.

## Spec Format

Specs are markdown files that define the functional requirements and validation strategy for a unit of software. Specs can describe a single file or many.

Specs add lightweight syntax to enable a broad array of tooling. The core elements are:

- YAML frontmatter describing the `name`, `description`, and `targets` list of the spec.
- `[@test]` links defining unit tests that verify functional requirements described in the spec.

See [Spec Format](./spec-format.md) for more details.

## Requirement Gathering

A key element of spec-driven development is the initial requirement-gathering phase. When receiving a new task from a stakeholder, you MUST start with the following steps before beginning the implementation:

- Review the existing specs, usually stored in a top-level `specs/` folder
- Make a list of ambiguous or underspecified areas
- Interview the stakeholder (ONE question at a time) to clarify these areas
- Create or update specs as needed to capture the final requirements

Once the stakeholder confirms the accuracy of the specs, you may begin your implementation.

## Reviewing Completed Work
Once you complete the implemenation, perform the following review:

- Ensure that all of the requested requirements have been satisfied
- Update relevant specs with any new requirements that were discovered during development
- If any tests were created, make sure that they are linked from the relevant specs

## Spec Verification

After generating or modifying code from specs, make sure implementation and tests remain synchronized:

- Re-run the tests referenced by the spec to confirm behaviour
- Update specs when requirements change or gaps are discovered
- Keep `targets` and `[@test]` links accurate so reviewers can trace coverage

See [Spec Verification](./spec-verification.md) for manual verification workflow.

## Spec Styleguide

Specs should be concise and scannable. They serve as technical documentation and requirements documents. Focus on capturing functional requirements, key user flows, and edge cases that must be supported in the final implementation.

See [Spec Styleguide](./spec-styleguide.md) for more details.
