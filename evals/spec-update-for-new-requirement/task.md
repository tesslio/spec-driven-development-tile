# Spec Update: Add Rate Limiting to Existing API

## Problem Description

The team needs to add rate limiting to their API. An existing spec covers the API endpoints. The product manager has already confirmed the rate limiting requirements in a meeting — no further clarification is needed.

Your task is to update the existing spec to include the new rate limiting requirements, preserving all existing content. Write the updated spec file.

## Confirmed Rate Limiting Requirements

- All endpoints are rate-limited per API key
- Default limit: 100 requests per minute
- `/search` endpoint has a lower limit: 20 requests per minute
- When rate-limited, the API returns HTTP 429 with a `Retry-After` header (seconds)
- Rate limit state is tracked in Redis with a sliding window
- Admin API keys have a 10x multiplier on all limits

## Input Files

Extract the following files before beginning.

=============== FILE: specs/api.spec.md ===============
---
name: REST API
description: Public API endpoints for the task management service
targets:
  - ../src/api/routes.py
  - ../src/api/handlers.py
---

# REST API

## Endpoints

```python
def create_task(title: str, assignee: str) -> Task: ...
def get_task(task_id: str) -> Task: ...
def list_tasks(project_id: str, page: int = 1) -> TaskPage: ...
def search(query: str, filters: dict = None) -> SearchResult: ...
def delete_task(task_id: str) -> None: ...
```

`[@test] ../tests/api/test_routes.py`

## Authentication

- All endpoints require a valid API key in the `X-API-Key` header
- Invalid or missing keys return 401
  `[@test] ../tests/api/test_auth.py`

## Pagination

- `list_tasks` returns pages of 50 items
- Response includes `total`, `page`, and `pages` fields
  `[@test] ../tests/api/test_pagination.py`

## Error handling

- Missing resources return 404 with `{"error": "not_found"}`
- Validation failures return 400 with `{"error": "validation_error", "details": [...]}`
  `[@test] ../tests/api/test_errors.py`
