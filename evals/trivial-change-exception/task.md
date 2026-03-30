# Trivial Change: Fix Typo in Error Message

## Problem Description

A user reported that when they enter an invalid email during registration, the error message says "Invlaid email format" instead of "Invalid email format." The team wants this fixed.

Fix the typo and produce a file named `changes.md` describing what you changed and why you did or did not create/update a spec.

## Input Files

Extract the following files before beginning.

=============== FILE: src/validation.py ===============
"""Input validation utilities."""

import re

EMAIL_PATTERN = re.compile(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')

def validate_email(email: str) -> str:
    """Validate and normalize an email address."""
    if not email or not isinstance(email, str):
        raise ValueError("Email is required")
    email = email.strip().lower()
    if not EMAIL_PATTERN.match(email):
        raise ValueError("Invlaid email format")
    return email

def validate_password(password: str) -> str:
    """Validate password meets minimum requirements."""
    if not password or len(password) < 8:
        raise ValueError("Password must be at least 8 characters")
    return password

=============== FILE: specs/registration.spec.md ===============
---
name: User Registration
description: New user registration flow
targets:
  - ../src/registration.py
  - ../src/validation.py
---

# User Registration

## Input validation

- Email must be a valid email format; invalid emails raise ValueError
  `[@test] ../tests/test_validation.py`
- Password must be at least 8 characters
  `[@test] ../tests/test_validation.py`

## Registration flow

- Duplicate emails return 409 Conflict
  `[@test] ../tests/test_registration.py`
- Successful registration returns 201 with user object
  `[@test] ../tests/test_registration.py`
