# Business Rules Document (BRD) - Queue Management System

This document outlines the strict business logic, validation constraints, and state transitions required for the Queue Management System. These rules must be enforced at the service/domain layer of the backend application.

---

## 1. Token Rules

### Lifecycle & State
* **Daily Reset:** Token sequence numbers (e.g., 001 to 999) must reset to `1` or their initial prefix value at the start of every business day.
* **Immutability (Unchangeable History):** Once a token transitions to a final state (`Completed` or `Cancelled`), its data attributes (associated customer, service type, creation timestamp) become strictly read-only and cannot be altered or edited.
* **Uniqueness (No Line Hogging):** A customer can hold only **one active token** (`Waiting` or `Calling` state) per branch at any given time. They cannot generate a second token until their current one is `Completed`, `Cancelled`, or marked as a `No-Show`.

### State Transitions
* **Anti-Recall Restriction:** A token that has been marked as `Served/Completed` cannot be recalled or pushed back into the active queue. If a customer has a new inquiry, they must issue a brand-new token.
* **Skipped/No-Show Recall:** A token marked as `Skipped` (No-Show) can be recalled up to a maximum of **2 times** within the same business day before its status automatically updates to `Expired/Cancelled`.
* **Linear Flow:** A token must strictly transition through allowed states sequentially: `Issued` ➔ `Waiting` ➔ `Calling` ➔ `Serving` ➔ `Completed`. It cannot jump states (e.g., straight from `Waiting` to `Completed`).

---

## 2. Counter Rules

### Operational Constraints
* **Operator Mapping:** One employee/operator can be actively assigned to manage only **one counter** at a time. An operator cannot log into or operate multiple counters simultaneously.
* **State Validation:** A counter must have an active status of `Open` to call, serve, or skip a token. Counters marked as `Closed`, `On Break`, or `Offline` must be physically blocked from executing any queue actions.
* **Hierarchical Belonging:** Every counter must permanently belong to a specific branch entity in the database. A counter cannot exist as an independent or orphaned record.

---

## 3. Queue & Routing Rules

### Processing Logic
* **Standard Routing (FIFO):** Normal customer tokens must be processed strictly on a First-In, First-Out (FIFO) basis within their selected service category. 
* **Priority Override:** Emergency or VIP tokens must bypass the standard FIFO line. When an operator calls the next customer, the system algorithm must prioritize tokens flagged as `High Priority`, sorting them by creation time *before* evaluating standard tokens.
* **Dynamic Time Estimation:** The estimated waiting time for a token must be dynamically calculated using the formula:
  $$\text{Estimated Time} = \frac{\text{Active Tokens Ahead in Sub-Queue} \times \text{Average Service Time for Category}}{\text{Number of Active Counters Handling Category}}$$
* **Daily Clean Slate:** The active queue array/table must start fresh each business day. Any lingering active tokens from the previous day must be automatically transitioned to `Expired` during the midnight/end-of-day system routine.

---

## 4. Authentication & Authorization Rules

### Role-Based Access Control (RBAC)
* **User Management:** Only users with the `Admin` role possess permissions to create, update, or deactivate `Operator` accounts.
* **Destructive Actions:** `Operators` and `Receptionists` are explicitly restricted from deleting any user profiles, branch records, or historical token data from the database.
* **Dashboard Isolation:** Users flagged with the `Customer` role must be strictly blocked at the API layer from accessing or querying routes designated for the `Admin` or `Operator` dashboards. Any unauthorized attempt must return a `403 Forbidden` response.

---

## 5. Summary Matrix of Allowed Token Transitions

| Current State | Target State | Allowed? | Triggered By |
| :--- | :--- | :--- | :--- |
| `Issued / Waiting` | `Calling` | **Yes** | Operator clicks "Call Next" |
| `Calling` | `Serving` | **Yes** | Operator clicks "Start Service" |
| `Calling` | `Skipped` | **Yes** | Operator clicks "No-Show" |
| `Skipped` | `Calling` | **Yes** | Operator clicks "Recall" (Max 2x) |
| `Serving` | `Completed` | **Yes** | Operator clicks "End Service" |
| `Completed` | `Calling` | **No** | *Strictly Prohibited* |