# Work Review: Notification Service Implementation

## Problem Description

A backend team has just finished implementing a notification service and needs a review performed before the feature is merged. The service sends email and SMS alerts to users when certain account events occur. The spec was approved before implementation began, and the developer believes the work is complete — but the tech lead wants a thorough review to confirm all spec requirements are met and the spec accurately reflects what was actually built.

Your job is to review the implementation against the spec and produce a written review document summarizing your findings.

## Output Specification

Produce a file named `review.md` containing your complete work review. Also update `specs/notifications.spec.md` if you determine it needs changes.

## Input Files

Extract the following files before beginning.

=============== FILE: specs/notifications.spec.md ===============
---
name: Notification Service
description: Email and SMS delivery for account lifecycle events
targets:
  - ../src/notifications/sender.py
  - ../src/notifications/templates.py
---

# Notification Service

## Delivery methods

```python
def send_email(user_id: str, event: str, payload: dict) -> DeliveryResult: ...
def send_sms(user_id: str, event: str, payload: dict) -> DeliveryResult: ...
```

`[@test] ../tests/notifications/test_delivery.py`

## Supported events

- `account.created` triggers a welcome email and welcome SMS
  `[@test] ../tests/notifications/test_events.py`
- `password.reset` triggers an email with a reset link; no SMS
  `[@test] ../tests/notifications/test_events.py`
- `account.suspended` triggers an email and SMS
  `[@test] ../tests/notifications/test_events.py`

## Error handling

- If the user has no email address on file, `send_email` raises `MissingContactError`
- If the SMS provider is unreachable, retry up to 3 times before raising `DeliveryError`
  `[@test] ../tests/notifications/test_retry.py`

## Templates

- Each event has a dedicated template in `templates/`
- Templates use Jinja2 syntax
  `[@test] ../tests/notifications/test_templates.py`

=============== FILE: src/notifications/sender.py ===============
from notifications.templates import render_template
from notifications.providers import email_provider, sms_provider
from notifications.exceptions import MissingContactError, DeliveryError
import time

SUPPORTED_EVENTS = ["account.created", "password.reset", "account.suspended", "account.reactivated"]

def send_email(user_id: str, event: str, payload: dict):
    user = payload.get("user", {})
    email = user.get("email")
    if not email:
        raise MissingContactError(f"No email for user {user_id}")
    body = render_template(event, "email", payload)
    return email_provider.send(to=email, body=body)

def send_sms(user_id: str, event: str, payload: dict):
    phone = payload.get("user", {}).get("phone")
    if not phone:
        return None  # silently skip if no phone number
    body = render_template(event, "sms", payload)
    for attempt in range(3):
        try:
            return sms_provider.send(to=phone, body=body)
        except Exception:
            if attempt == 2:
                raise DeliveryError(f"SMS failed after 3 attempts for user {user_id}")
            time.sleep(1)

def send_notification(user_id: str, event: str, payload: dict):
    """Dispatch both email and SMS for an event, based on event type."""
    results = {}
    if event in ["account.created", "account.suspended", "account.reactivated"]:
        results["email"] = send_email(user_id, event, payload)
        results["sms"] = send_sms(user_id, event, payload)
    elif event == "password.reset":
        results["email"] = send_email(user_id, event, payload)
    return results

=============== FILE: src/notifications/templates.py ===============
from jinja2 import Environment, FileSystemLoader
import os

_env = Environment(loader=FileSystemLoader(os.path.join(os.path.dirname(__file__), "../../templates")))

def render_template(event: str, channel: str, payload: dict) -> str:
    template_name = f"{event.replace('.', '_')}_{channel}.j2"
    tmpl = _env.get_template(template_name)
    return tmpl.render(**payload)

=============== FILE: tests/notifications/test_delivery.py ===============
# Tests for send_email and send_sms basic delivery
def test_send_email_success(): pass
def test_send_sms_success(): pass
def test_send_email_missing_email_raises(): pass

=============== FILE: tests/notifications/test_events.py ===============
# Tests for supported events routing
def test_account_created_sends_email_and_sms(): pass
def test_password_reset_sends_email_only(): pass
def test_account_suspended_sends_email_and_sms(): pass
def test_account_reactivated_sends_email_and_sms(): pass

=============== FILE: tests/notifications/test_retry.py ===============
# Tests for SMS retry logic
def test_sms_retries_three_times_on_failure(): pass
def test_sms_raises_delivery_error_after_max_retries(): pass

=============== FILE: tests/notifications/test_templates.py ===============
# Tests for Jinja2 template rendering
def test_render_email_template(): pass
def test_render_sms_template(): pass
