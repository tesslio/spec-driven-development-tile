# Requirement Analysis: Bulk User Export Feature

## Problem Description

A B2B SaaS company manages enterprise accounts with thousands of users. Their customer success team has requested a new bulk user export feature so account admins can download a CSV of all users in their organization. The product manager has sent the following request to the engineering team:

> "We need a way for admins to export all users in their org. Should support filtering by role and status. Needs to work for large orgs — some have 50,000+ users."

The project already has specs for related features. Before gathering requirements from the PM, the engineering team wants to prepare: understand what the existing specs already cover (so they don't ask redundant questions), identify exactly what's unknown, and plan their structured requirements interview.

Your task is to analyze the existing specs and produce a thorough requirements preparation document that the team can use before their PM meeting.

## Output Specification

Produce a single markdown file named `requirements-prep.md` that contains:

1. **Existing coverage summary** — what the existing specs already document that is relevant to this feature
2. **Gap analysis** — specific areas that are ambiguous or undocumented
3. **Interview questions** — the ordered list of questions the team should ask, presented as a numbered sequence where each question stands alone (as it would be asked in a real turn-by-turn interview)
4. **Preliminary scope** — what can be reasonably inferred is in scope vs out of scope, based on the request and existing specs

## Input Files

Extract the following files before beginning.

=============== FILE: specs/user-management.spec.md ===============
---
name: User Management
description: CRUD operations for users within an organization
targets:
  - ../src/users/user_service.py
  - ../src/users/models.py
---

# User Management

## Core operations

```python
def create_user(org_id: str, email: str, role: str) -> User: ...
def update_user(user_id: str, fields: dict) -> User: ...
def deactivate_user(user_id: str) -> None: ...
def get_user(user_id: str) -> User: ...
def list_users(org_id: str, role: str = None, status: str = None, page: int = 1) -> UserPage: ...
```

`[@test] ../tests/users/test_user_service.py`

## User model

- Users have: id, org_id, email, role (admin|member|viewer), status (active|suspended|pending)
- Email must be unique within an org
  `[@test] ../tests/users/test_user_constraints.py`

## Pagination

- `list_users` returns pages of 100 users by default
- Callers may request a specific page number
- Total count is included in the response
  `[@test] ../tests/users/test_pagination.py`

## Roles

- Admins can manage all users in their org
- Members and viewers cannot modify other users
  `[@test] ../tests/users/test_permissions.py`

=============== FILE: specs/auth.spec.md ===============
---
name: Authentication
description: Session management and access control
targets:
  - ../src/auth/session.py
  - ../src/auth/middleware.py
---

# Authentication

## Access control

- All API endpoints require a valid session token
- Admin role required for user management endpoints
  `[@test] ../tests/auth/test_access_control.py`

## Sessions

- Sessions expire after 8 hours of inactivity
  `[@test] ../tests/auth/test_sessions.py`
