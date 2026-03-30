# Feature Request With Spec Bypass Attempt

## Problem Description

A developer on the team wants to add a new caching layer to the API. They've already written the code and just want it merged. They've asked you to review it — but there is no spec covering this feature, and the existing API spec makes no mention of caching.

Your task is to assess the situation and produce a document explaining what needs to happen before this code can be considered complete under the spec-driven development workflow.

## Output Specification

Produce a file named `caching-assessment.md` that:

1. Identifies that this work was done without a spec
2. Lists the specific requirements that need to be captured in a spec based on what the code does
3. Provides a draft spec section (not a full spec file) covering the caching behavior that the team should review and approve
4. Notes any gaps or questions the code raises that a spec would normally have caught upfront

Do NOT create the actual spec file — only the assessment document. The team needs to review and approve the spec content first.

## Input Files

Extract the following files before beginning.

=============== FILE: specs/api.spec.md ===============
---
name: REST API
description: Public API for the project management service
targets:
  - ../src/api/routes.py
  - ../src/api/handlers.py
---

# REST API

## Endpoints

```python
def get_project(project_id: str) -> Project: ...
def list_projects(user_id: str, page: int = 1) -> ProjectPage: ...
def create_project(name: str, owner_id: str) -> Project: ...
```

`[@test] ../tests/api/test_routes.py`

## Authentication

- All endpoints require Bearer token
  `[@test] ../tests/api/test_auth.py`

## Error handling

- 404 for missing resources
- 400 for validation errors
  `[@test] ../tests/api/test_errors.py`

=============== FILE: src/api/cache.py ===============
"""Response caching layer — added by developer without spec."""

import hashlib
import json
import time

CACHE = {}
DEFAULT_TTL = 300  # 5 minutes

def cache_key(endpoint: str, params: dict) -> str:
    raw = f"{endpoint}:{json.dumps(params, sort_keys=True)}"
    return hashlib.sha256(raw.encode()).hexdigest()

def get_cached(endpoint: str, params: dict):
    key = cache_key(endpoint, params)
    entry = CACHE.get(key)
    if entry and time.time() - entry["ts"] < entry["ttl"]:
        return entry["value"]
    return None

def set_cached(endpoint: str, params: dict, value, ttl: int = DEFAULT_TTL):
    key = cache_key(endpoint, params)
    CACHE[key] = {"value": value, "ts": time.time(), "ttl": ttl}

def invalidate(endpoint: str, params: dict):
    key = cache_key(endpoint, params)
    CACHE.pop(key, None)

def invalidate_all():
    CACHE.clear()

=============== FILE: src/api/handlers.py ===============
"""API handlers — now using cache for read endpoints."""

from api.cache import get_cached, set_cached, invalidate

def get_project(project_id: str):
    cached = get_cached("get_project", {"project_id": project_id})
    if cached:
        return cached
    project = db.get_project(project_id)
    if not project:
        raise NotFoundError(f"Project {project_id} not found")
    set_cached("get_project", {"project_id": project_id}, project)
    return project

def create_project(name: str, owner_id: str):
    project = db.create_project(name=name, owner_id=owner_id)
    invalidate("list_projects", {"user_id": owner_id})
    return project

def list_projects(user_id: str, page: int = 1):
    cached = get_cached("list_projects", {"user_id": user_id, "page": page})
    if cached:
        return cached
    result = db.list_projects(user_id=user_id, page=page)
    set_cached("list_projects", {"user_id": user_id, "page": page}, result, ttl=60)
    return result
