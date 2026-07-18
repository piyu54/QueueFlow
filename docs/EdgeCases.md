# System Edge Cases & Error Handling Specifications

This document defines critical edge cases across the Queue Management System, establishing the required backend handling mechanisms, database rollbacks, and fallback state behaviors.

---

## 1. Customer Operations

### Web/Mobile Application Session Interruptions
* **Scenario: Client disconnects, closes the browser, or experiences network dropouts.**
  * *System Action:* The token status remains active (`Waiting`) in the database. The queue does not drop the customer. A background heartbeat monitor sets a temporary `disconnected_at` flag. If the customer reconnects within a 15-minute window, the WebSocket session hooks back into the active token ID.
* **Scenario: Customer refreshes the ticket tracking webpage.**
  * *System Action:* The client application must not generate a new token request. The frontend must query the `/api/v1/tokens/active-session` endpoint using local device storage keys (or HTTP-only session cookies) to rehydrate the UI with the existing active token state.

### Duplication & Abandonment
* **Scenario: Multiple token request submissions.**
  * *System Action:* The API service enforces an isolation lock checking for active tokens (`Waiting`, `Calling`, `Serving`) mapped to the specific user profile ID. Duplicate creation requests are immediately rejected with a `400 Bad Request` ("Active token already exists").
* **Scenario: Customer physically leaves or fails to report to the counter.**
  * *System Action:* If the operator calls the token and receives no client confirmation, selecting "No-Show" transitions the token state to `Skipped`. The system increments a `recall_count` counter column. If `recall_count` exceeds 2, the system automatically transitions the token to `Expired` via a database trigger.

---

## 2. Operator Workflows

### Operational Missteps
* **Scenario: Operator accidentally triggers a service start or calls the incorrect token.**
  * *System Action:* Operators are blocked from manually choosing random token IDs from the backlog array. The system forces a sequential FIFO call string. If an operator mistakenly marks a present customer as a "No-Show", they must utilize the explicit `Recall` command to fetch the same token ID back into the active `Calling` slot.
* **Scenario: Operator logs out or closes their interface panel midway through active service.**
  * *System Action:* The system intercepts explicit logouts during active sessions, throwing a validation warning demanding service completion or suspension. In the event of an abrupt window closure or power failure, an automated server cron job identifies open counters with idle `Serving` statuses lasting longer than 30 minutes, automatically moving the token to a `Suspended` queue pool and updating the counter status to `Offline`.

---

## 3. Administrative Modifications

### Entity Deletion & Configuration Shifts
* **Scenario: Administrator deletes or deactivates an active Operator account.**
  * *System Action:* Soft-deletion logic is enforced. The database record sets an `is_active = false` flag rather than hard-deleting the row. If the operator was in the middle of serving a customer, the token state cascades to `Waiting` (returned to the front of the line) and the counter status drops to `Closed`.
* **Scenario: Administrator deactivates an entire operational Branch location.**
  * *System Action:* The system immediately blocks incoming token generation at all physical kiosks and mobile endpoints for that branch ID. All unserved active tokens are collectively changed to `Cancelled` with a system note attribute "Branch Deactivated". Notifications are issued to connected mobile applications via push notifications.

---

## 4. Infrastructure & System Core

### Concurrency & Data Resiliency
* **Scenario: Sudden server crash, container restart, or unexpected power outage.**
  * *System Action:* All core system states must be persisted in a transactional database (e.g., PostgreSQL) rather than transient in-memory caches. Upon application boot, an initialization script inspects active records. Tokens caught in a `Calling` or `Serving` state during the crash are safely downgraded to a high-priority `Waiting` state, ensuring zero data loss.
* **Scenario: High-concurrency collision where two customers issue tokens at the exact millisecond.**
  * *System Action:* Database-level sequence generation or isolated atomic database transactions (`SELECT ... FOR UPDATE`) are applied. The transaction engine serializes the inputs, processing one request at a time. The first processed entry claims token number $N$, and the colliding transaction safely increments to $N + 1$.
* **Scenario: High-volume days where the sequence limit hits the upper bound (e.g., 999).**
  * *System Action:* The sequence generator logic must not crash or loop back to 1 if 1 is still active. The database tracks sequences using custom sequence structures that scale beyond printing constraints, adding an alphabetical or timestamp extension (e.g., `A-999` rolls over dynamically to `B-001` or wraps smoothly based on explicit overflow exceptions).