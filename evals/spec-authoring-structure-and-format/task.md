# Inventory Reservation Service Spec

## Problem Description

A warehouse management company is building an inventory reservation system to prevent overselling across multiple sales channels. Their engineering team recently confirmed requirements with the product owner and is ready to document them before writing any code.

The service exposes a Python module with three core operations: reserve stock for an order, release a reservation when an order is cancelled, and query the current reserved quantity for a product. The team already has a test suite planned. The service will live in `src/inventory/reservation.py`, and the tests will be in `tests/inventory/test_reservation.py` with a separate file `tests/inventory/test_reservation_edge_cases.py` for boundary condition tests.

The engineering lead wants a spec document written before any implementation begins. The requirements are already confirmed, so there is no need for further clarification — just write the spec.

## Confirmed Requirements

The following requirements were confirmed by the product owner:

**Core operations:**
- `reserve(product_id: str, quantity: int, order_id: str) -> Reservation` — atomically reserves stock; raises `InsufficientStockError` if available quantity is less than requested
- `release(reservation_id: str) -> None` — frees the reserved quantity back to available stock; raises `ReservationNotFoundError` if the ID doesn't exist
- `get_reserved(product_id: str) -> int` — returns total currently reserved quantity for the product (0 if none)

**Business rules:**
- Reservations expire after 15 minutes if not confirmed by the order system
- A product with zero available stock must never be reserved (even for quantity=0 requests)
- Releasing a reservation that is already expired should succeed silently (idempotent)

**Error handling:**
- `InsufficientStockError` must include both the requested quantity and the available quantity in its message
- All operations must be thread-safe

**Non-functional:**
- The service must not depend on any external network calls at reservation time

## Output Specification

Write the spec file for the inventory reservation service into the appropriate location in the project. The file should be ready for the team to use as a blueprint for implementation.
