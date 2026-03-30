---
name: spec-writer
description: |
  Create or update .spec.md files from clarified requirements. Use when requirements have
  been gathered and confirmed, and specs need to be written or updated before implementation
  begins. Produces well-structured spec files with frontmatter, requirements, and test links.
  Common triggers: "write the spec", "update the spec", "create a spec for", or after
  requirement-gathering completes.
---

# Spec Writer

Create and maintain `.spec.md` files that capture functional requirements and link to their verification tests.

## When to use

- After `requirement-gathering` produces confirmed requirements
- When existing specs need updating due to changed requirements
- When implementation revealed gaps that need documenting

## Steps

1. **Determine scope.** Decide whether to create a new spec or update an existing one. One spec per logical unit of functionality — don't combine unrelated features.

2. **Write frontmatter.** Every spec requires YAML frontmatter:

   ```yaml
   ---
   name: Feature Name
   description: Brief description of what this spec covers
   targets:
     - ../src/path/to/implementation.py
     - ../src/path/to/related/**/*.py
   ---
   ```

   - `name`: Human-readable feature name
   - `description`: One-line summary
   - `targets`: Relative paths or glob patterns to implementation files. At least one required.

3. **Document requirements.** Write clear, scannable requirements:
   - Start with an API contract code block if there's a public interface
   - Use headings to organize by feature area
   - Be specific about expected behavior and edge cases
   - Describe error handling expectations

4. **Link tests.** Add `[@test]` links inline, next to the requirements they verify:

   ```markdown
   - Invalid passwords return 401
     `[@test] ../tests/test_auth_invalid_password.py`
   ```

5. **Review against styleguide.** Check the spec against the [Spec Styleguide](../../docs/spec-styleguide.md): concise, scannable, context around test links, clear headings, specific about behavior, granular test files.

6. **Save the spec.** Place spec files in the project's `specs/` directory with a `.spec.md` extension.

## Complete example

```markdown
---
name: Shopping Cart
description: Add, remove, and checkout operations for the shopping cart
targets:
  - ../src/cart.py
  - ../src/checkout.py
---

# Shopping Cart

## Core operations

```python
def add_item(cart_id: str, product_id: str, quantity: int) -> Cart: ...
def remove_item(cart_id: str, product_id: str) -> Cart: ...
def checkout(cart_id: str, payment_method: str) -> Order: ...
```

`[@test] ../tests/cart/test_cart_operations.py`

## Quantity rules

- Quantity must be >= 1; values <= 0 raise `ValueError`
  `[@test] ../tests/cart/test_quantity_validation.py`
- Adding an existing item increments quantity instead of duplicating
  `[@test] ../tests/cart/test_add_existing_item.py`

## Checkout

- Empty cart raises `CheckoutError`
  `[@test] ../tests/cart/test_empty_checkout.py`
- Out-of-stock items are removed and the user is notified
  `[@test] ../tests/cart/test_stock_check.py`
```

## Spec format reference

See [Spec Format](../../docs/spec-format.md) for the complete format specification.
