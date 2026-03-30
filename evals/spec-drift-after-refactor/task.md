# Spec Drift Detection After Refactor

## Problem Description

A team refactored their authentication module — renaming files and moving functions. The spec was not updated. Your job is to audit the spec against the current implementation, identify all drift, and produce an updated spec that accurately reflects the code.

Produce two files:
1. `drift-report.md` — a report listing every discrepancy found between the spec and the implementation
2. An updated `specs/auth.spec.md` — the corrected spec with accurate targets, test links, and requirements

## Input Files

Extract the following files before beginning.

=============== FILE: specs/auth.spec.md ===============
---
name: Authentication
description: Login, token refresh, and session management
targets:
  - ../src/auth/login.py
  - ../src/auth/session.py
---

# Authentication

## Login

```python
def login(email: str, password: str) -> TokenPair: ...
def refresh_token(refresh: str) -> TokenPair: ...
```

`[@test] ../tests/auth/test_login.py`

- Invalid credentials return 401
  `[@test] ../tests/auth/test_login_errors.py`
- Accounts locked after 5 failed attempts
  `[@test] ../tests/auth/test_lockout.py`

## Sessions

- Sessions expire after 24 hours
  `[@test] ../tests/auth/test_session_expiry.py`
- Refresh tokens are single-use; reuse invalidates the entire session
  `[@test] ../tests/auth/test_refresh_reuse.py`

=============== FILE: src/identity/authentication.py ===============
"""Authentication module — refactored from src/auth/login.py"""

def login(email: str, password: str) -> TokenPair:
    """Authenticate user and return access + refresh tokens."""
    user = find_user_by_email(email)
    if not user or not verify_password(password, user.password_hash):
        record_failed_attempt(email)
        if get_failed_attempts(email) >= 3:
            lock_account(email)
        raise AuthenticationError("Invalid credentials", status=401)
    clear_failed_attempts(email)
    return generate_token_pair(user)

def refresh_token(refresh: str) -> TokenPair:
    """Issue new token pair from a valid refresh token. Single-use."""
    session = validate_refresh_token(refresh)
    if session.refresh_used:
        invalidate_session(session.id)
        raise AuthenticationError("Refresh token reuse detected")
    mark_refresh_used(session.id)
    return generate_token_pair(session.user)

=============== FILE: src/identity/sessions.py ===============
"""Session management — refactored from src/auth/session.py"""

SESSION_TTL_HOURS = 8  # Changed from 24 to 8 hours

def create_session(user_id: str) -> Session: ...
def validate_session(session_id: str) -> Session: ...
def invalidate_session(session_id: str) -> None: ...

=============== FILE: tests/identity/test_authentication.py ===============
# Refactored from tests/auth/test_login.py
def test_login_success(): pass
def test_login_invalid_credentials_returns_401(): pass
def test_login_locks_after_three_failures(): pass

=============== FILE: tests/identity/test_authentication_errors.py ===============
# Refactored from tests/auth/test_login_errors.py
def test_invalid_email_returns_401(): pass
def test_invalid_password_returns_401(): pass

=============== FILE: tests/identity/test_lockout.py ===============
# Refactored from tests/auth/test_lockout.py
def test_account_locks_after_three_failed_attempts(): pass
def test_locked_account_returns_403(): pass

=============== FILE: tests/identity/test_session_expiry.py ===============
# Refactored from tests/auth/test_session_expiry.py
def test_session_expires_after_ttl(): pass

=============== FILE: tests/identity/test_refresh_reuse.py ===============
# Refactored from tests/auth/test_refresh_reuse.py
def test_refresh_reuse_invalidates_session(): pass
