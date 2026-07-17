# QueueFlow – Smart Queue & Token Management System
## Functional & Non-Functional Requirements Document
*(Extract of the Software Requirement Specification)*

**Prepared by:** Chinmay
**Document Version:** 1.0
**Date:** July 2026

---

## 1. Introduction

QueueFlow is a digital queue and token management platform designed to replace manual token systems used in banks, hospitals, government offices, diagnostic labs, and other service centers. This document lists the Functional Requirements (FR) — what the system must do — and the Non-Functional Requirements (NFR) — the quality attributes the system must satisfy — covering all core modules: Authentication, Branch & Counter Management, Queue Management, Dashboard, and Reports.

---

## 2. Functional Requirements

Functional requirements describe specific behaviors and features of the system, expressed as "the system shall..." statements. Each requirement below is tagged with a priority indicating its importance for the MVP.

### 2.1 Authentication & Authorization

| ID | Requirement | Description | Priority |
|---|---|---|---|
| FR-01 | User Login | System shall allow Admin and Operator to log in using email/username and password. | High |
| FR-02 | JWT Token Issuance | System shall issue a signed JWT access token upon successful authentication. | High |
| FR-03 | Refresh Token | System shall allow a valid refresh token to be exchanged for a new access token without re-login. | Medium |
| FR-04 | Role-Based Access Control | System shall restrict endpoint access based on role: ADMIN or OPERATOR. | High |
| FR-05 | Password Security | System shall store passwords using BCrypt hashing; plain text storage is not permitted. | High |
| FR-06 | Logout | System shall allow a user to invalidate their session/token on logout. | Medium |

### 2.2 Branch & Counter Management

| ID | Requirement | Description | Priority |
|---|---|---|---|
| FR-07 | Create Branch | Admin shall be able to create a new branch with name, address, and contact details. | High |
| FR-08 | Update/Delete Branch | Admin shall be able to update branch details or soft-delete an inactive branch. | Medium |
| FR-09 | Create Counter | Admin shall be able to create counters under a branch. | High |
| FR-10 | Assign Operator to Counter | Admin shall be able to assign a specific operator to a specific counter. | High |
| FR-11 | Open/Close Counter | Operator or Admin shall be able to toggle a counter's status between OPEN and CLOSED. | High |
| FR-12 | View Counter Status | System shall display real-time status (open/closed, current token) for every counter. | Medium |

### 2.3 Queue Management (Core)

| ID | Requirement | Description | Priority |
|---|---|---|---|
| FR-13 | Generate Token | Customer shall be able to generate a token for a chosen branch/service. | High |
| FR-14 | Auto Token Numbering | System shall auto-generate a unique, sequential token number per branch, resetting daily. | High |
| FR-15 | Prevent Duplicate Tokens | System shall prevent a customer from holding more than one active token at a time. | High |
| FR-16 | Priority Token Support | System shall allow generation of priority tokens (e.g., senior citizens, emergencies) that are served ahead of general tokens per a defined interleaving rule. | Medium |
| FR-17 | Call Next Token | Operator shall be able to call the next token in the queue to their counter (FIFO, priority-aware). | High |
| FR-18 | Mark Token Served | Operator shall be able to mark the current token as served, closing that token's lifecycle. | High |
| FR-19 | Skip Token | Operator shall be able to skip a token that does not respond, moving it to a skipped state. | Medium |
| FR-20 | Recall Token | Operator shall be able to recall a previously skipped token back into the active queue. | Medium |
| FR-21 | Mark Token Missed | System shall automatically mark a token as missed after a configurable number of skips or a timeout. | Low |
| FR-22 | View Live Queue | Customer and Operator shall be able to view the live queue and current token being served. | High |
| FR-23 | Queue Position & ETA | System shall calculate and display a customer's queue position and estimated waiting time. | High |
| FR-24 | Token History | System shall maintain a historical record of all tokens with their final status. | Medium |

### 2.4 Dashboard, Analytics & Reports

| ID | Requirement | Description | Priority |
|---|---|---|---|
| FR-25 | Today's Summary Widgets | Dashboard shall show today's visitors, tokens generated, tokens served, and pending tokens. | Medium |
| FR-26 | Average Wait/Service Time | Dashboard shall display average waiting time and average service time, updated in real time. | Medium |
| FR-27 | Counter Performance | Dashboard shall show tokens-served-per-counter for performance comparison. | Low |
| FR-28 | Peak Hour Analytics | System shall identify and display peak hours based on historical token generation trends. | Low |
| FR-29 | Daily/Monthly Reports | System shall generate daily and monthly analytical reports of queue and counter activity. | Medium |
| FR-30 | PDF Report Export | System shall allow reports to be