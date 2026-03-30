# Requirements Preparation: "Make Search Better"

## Problem Description

A product manager sent the following message to the engineering team:

> "Users are complaining the search is slow and doesn't find what they need. Make it better."

The team has an existing spec for the search feature. Before meeting with the PM, they need to prepare a structured requirements document that identifies what the existing spec already covers, what's genuinely ambiguous in the PM's request, and what specific questions need answers.

Your task is to analyze the existing spec against the vague request and produce a requirements preparation document.

## Output Specification

Produce a file named `search-improvement-prep.md` containing:

1. **Existing coverage** — what the current spec already documents about search
2. **Ambiguity analysis** — what "better" could mean, and which interpretations are supported or contradicted by the existing spec
3. **Gap list** — specific unknowns that must be resolved before writing a spec update
4. **Interview questions** — ordered list of specific, bounded questions (one per item) the team should ask the PM

## Input Files

Extract the following files before beginning.

=============== FILE: specs/search.spec.md ===============
---
name: Search
description: Full-text search across documents and projects
targets:
  - ../src/search/engine.py
  - ../src/search/indexer.py
---

# Search

## Query interface

```python
def search(query: str, filters: dict = None, page: int = 1) -> SearchResult: ...
def reindex(project_id: str) -> None: ...
```

`[@test] ../tests/search/test_search.py`

## Behavior

- Searches across document title, body, and tags
- Results are ranked by relevance (TF-IDF)
- Supports filtering by project_id, created_after, created_before
  `[@test] ../tests/search/test_filters.py`

## Pagination

- Returns 20 results per page
- Includes total_count in response
  `[@test] ../tests/search/test_pagination.py`

## Indexing

- Documents are indexed on create and update
- Reindex rebuilds the search index for a project
  `[@test] ../tests/search/test_indexer.py`
