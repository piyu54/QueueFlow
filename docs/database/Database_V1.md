# QueueFlow Database Version 1 (Frozen Schema)

**Project:** QueueFlow – Smart Queue & Token Management System

**Version:** 1.0

**Status:** APPROVED

**Purpose:**
This document represents the finalized Version 1 database schema for QueueFlow. It serves as the official reference before implementation begins. Any structural changes after this point should be discussed and approved by the development team.

---

# Database Version

| Property | Value |
|----------|-------|
| Version | 1.0 |
| Status | Approved |
| Database | MySQL 8 |
| ORM | Hibernate ORM |
| Framework | Spring Boot |
| Review Status | Completed |

---

# Approved Entities

The following entities are approved for Version 1.

1. User
2. Customer
3. Branch
4. Counter
5. ServiceCategory
6. Token
7. OperatorSession
8. AuditLog

---

# Entity Responsibilities

## User

Stores authenticated system users.

Roles:

- Admin
- Operator
- Receptionist

---

## Customer

Stores customer information separately from authenticated users.

Customers do not require login credentials.

---

## Branch

Represents physical service locations.

---

## Counter

Represents service desks within a branch.

---

## ServiceCategory

Defines available services offered by a branch.

---

## Token

Core transaction entity representing customer queue lifecycle.

---

## OperatorSession

Tracks operator login sessions and counter assignments.

---

## AuditLog

Stores administrative and security-related activities.

---

# Primary Design Decisions

The team has agreed on the following architecture decisions.

## Authentication

Customers are **NOT** stored in the User table.

Only Admin, Operator, and Receptionist require authentication.

---

## Primary Key Strategy

All major entities use UUID Version 4.

---

## Queue Processing

Queue follows FIFO by default.

Priority handling is supported where applicable.

---

## Token Rules

- One active token per customer per branch.
- Completed tokens cannot be modified.
- Cancelled tokens cannot be recalled.
- Maximum recall count is two.

---

## Counter Rules

- One active operator per counter.
- Closed counters cannot process tokens.

---

## Branch Rules

Each branch manages its own:

- Counters
- Services
- Tokens

---

# Approved Relationships

- Branch → Counter (1:N)
- Branch → ServiceCategory (1:N)
- Branch → Token (1:N)
- Customer → Token (1:N)
- ServiceCategory → Token (1:N)
- Counter → Token (1:N)
- User → OperatorSession (1:N)
- Counter → OperatorSession (1:N)
- User → AuditLog (1:N)

---

# Future Scope (Not Included in V1)

The following entities are planned for future versions.

- Notification
- RefreshToken
- Feedback
- QueueAnalytics
- Announcement
- DisplayScreen

---

# Review Summary

The Version 1 database schema has been reviewed by the development team.

The following aspects have been validated:

- Entity identification
- Business rules
- Database relationships
- Scalability
- Maintainability
- Security considerations

This schema is now considered frozen for Version 1 implementation.

---

# Next Milestone

After Database Version 1 approval, development proceeds with:

1. API Design
2. Spring Boot Project Setup
3. Entity Creation (JPA)
4. Repository Layer
5. Service Layer
6. Controller Layer

---

**Document Status:** Approved

**Version:** 1.0

**Last Updated:** July 2026