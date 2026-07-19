# QueueFlow - Database Design Document

**Project:** QueueFlow – Smart Queue & Token Management System

**Version:** 1.0

**Prepared By:** QueueFlow Development Team

**Document Type:** Database Design Specification

**Status:** Approved (Version 1)

**Last Updated:** July 2026

---

# 1. Introduction

The QueueFlow Database is designed to support a scalable, secure, and production-ready queue management platform for organizations such as hospitals, banks, government offices, service centers, and diagnostic laboratories.

The database serves as the foundation of the entire application by storing operational, transactional, and administrative information while maintaining data consistency, security, and high performance.

The design follows relational database principles and is optimized for implementation using **MySQL**, **Spring Boot**, **Hibernate ORM**, and **Spring Data JPA**.

This document defines the logical structure of the database before implementation.

---

# 2. Database Objectives

The primary objectives of the QueueFlow database are:

- Store all operational data securely.
- Support multiple branches under a single organization.
- Enable efficient queue processing.
- Maintain complete token history.
- Support real-time queue updates.
- Enable analytics and reporting.
- Provide high scalability for future expansion.
- Maintain data integrity through relational constraints.
- Support secure authentication and authorization.
- Ensure maintainability and extensibility.

---

# 3. Database Design Principles

The database is designed according to the following principles.

## 3.1 Normalization

The schema follows database normalization principles to eliminate redundancy while maintaining efficient querying.

Target normalization level:

- First Normal Form (1NF)
- Second Normal Form (2NF)
- Third Normal Form (3NF)

---

## 3.2 Data Integrity

All entities use:

- Primary Keys
- Foreign Keys
- NOT NULL constraints
- UNIQUE constraints
- Enumerations where applicable

to preserve consistency.

---

## 3.3 Security

Sensitive information is never stored in plain text.

Examples:

- Passwords are stored as BCrypt hashes.
- User authorization is role-based.
- Audit logs preserve sensitive administrative actions.
- Soft deletion is preferred over permanent deletion where appropriate.

---

## 3.4 Scalability

The database is designed to support:

- Multiple branches
- Hundreds of counters
- Thousands of daily tokens
- Future notification services
- Mobile applications
- Cloud deployment

without major schema changes.

---

## 3.5 Maintainability

The schema emphasizes:

- Clear naming conventions
- Minimal redundancy
- Logical entity separation
- Consistent relationships
- Easy future expansion

---

# 4. Database Overview

QueueFlow is built using a relational database model.

The database consists of independent entities connected using foreign key relationships.

Each entity represents a real-world business object.

The system separates authentication data, customer information, operational counters, queue processing, and audit information into dedicated tables to improve modularity and maintainability.

---

# 5. Database Architecture

The overall data flow is:

Customer
↓

Generates Token
↓

Token enters Queue

↓

Operator calls Token

↓

Customer served

↓

Transaction stored permanently

↓

Reports & Analytics generated

---

Administrative users manage:

- Branches
- Counters
- Operators
- Service Categories

while customers interact only with token generation and queue tracking.

---

# 6. Database Technology Stack

| Component | Technology |
|-----------|------------|
| Database | MySQL 8 |
| ORM | Hibernate ORM |
| Persistence | Spring Data JPA |
| Backend | Spring Boot |
| Authentication | Spring Security + JWT |
| Migration | Hibernate DDL Auto (Development) |
| Future Migration Tool | Flyway / Liquibase |

---

# 7. Naming Conventions

The following naming conventions are followed throughout the project.

## Tables

- Singular naming
- PascalCase in documentation
- Snake Case in SQL (optional implementation)

Example

User

Customer

Branch

ServiceCategory

---

## Columns

camelCase

Examples

firstName

createdAt

updatedAt

passwordHash

---

## Primary Keys

Every table contains

id

using UUID.

---

## Foreign Keys

Naming convention:

entityNameId

Examples

branchId

customerId

operatorId

counterId

serviceCategoryId

---

## Timestamp Fields

Every major entity contains:

createdAt

updatedAt

Some transactional entities additionally contain:

issuedAt

calledAt

servedAt

completedAt

---

# 8. Entity Summary

The QueueFlow Version 1 database contains the following core entities.

| Entity | Purpose |
|---------|----------|
| User | Stores authenticated system users such as Admins, Operators, and Receptionists |
| Customer | Stores customer information independently from authentication |
| Branch | Represents physical organization branches |
| Counter | Represents service counters inside a branch |
| ServiceCategory | Defines different services offered by a branch |
| Token | Represents a customer's queue transaction |
| OperatorSession | Tracks operator login sessions and counter assignments |
| AuditLog | Stores important administrative actions for auditing |

---

# 9. Why Customer is a Separate Entity

Customer information is intentionally separated from the User table.

Reasons include:

- Customers do not require authentication.
- Customers may generate tokens without logging in.
- Authentication remains isolated from operational data.
- Reduces unnecessary security complexity.
- Improves scalability for future kiosk and QR-based token generation.

This separation follows the Single Responsibility Principle and results in a cleaner architecture.

---

# 10. Version Information

Current Database Version

Version: 1.0

Status: Approved

Entities: 8

Future Planned Entities:

- Notification
- RefreshToken
- Feedback
- QueueAnalytics
- Announcement

---

**End of Part 1**

# 11. Entity Design Specification

---

# 11.1 User Entity

## Purpose

The **User** entity stores all authenticated system users responsible for operating and managing the QueueFlow platform.

Unlike customers, users require authentication and authorization to access protected system resources.

The User entity supports Role-Based Access Control (RBAC) through predefined system roles.

---

## Responsibilities

- Authenticate system users
- Store login credentials
- Manage user roles
- Support authorization
- Track account status
- Maintain audit information

---

## Attributes

| Field | Data Type | Constraints | Description |
|---------|-----------|------------|-------------|
| id | UUID | Primary Key | Unique identifier for the user |
| fullName | VARCHAR(100) | NOT NULL | User's full name |
| email | VARCHAR(150) | UNIQUE, NOT NULL | Login email |
| passwordHash | VARCHAR(255) | NOT NULL | BCrypt encrypted password |
| phoneNumber | VARCHAR(20) | UNIQUE | Contact number |
| role | ENUM | NOT NULL | ADMIN, OPERATOR, RECEPTIONIST |
| isActive | BOOLEAN | Default TRUE | Indicates account status |
| createdAt | TIMESTAMP | NOT NULL | Record creation timestamp |
| updatedAt | TIMESTAMP | NOT NULL | Last update timestamp |

---

## Business Rules

- Email must be unique.
- Passwords are never stored in plain text.
- Disabled users cannot log in.
- Every user must have exactly one role.
- Only Admin users can create new Operators or Receptionists.

---

## Relationships

- One User can have many Operator Sessions.
- One User may process many Tokens (Operator role).

---

# 11.2 Customer Entity

## Purpose

The Customer entity stores information about people receiving services from the organization.

Customers are intentionally separated from authenticated users because they do not require login credentials.

---

## Responsibilities

- Store customer information
- Associate customers with generated tokens
- Maintain customer history
- Support future customer analytics

---

## Attributes

| Field | Data Type | Constraints | Description |
|---------|-----------|------------|-------------|
| id | UUID | Primary Key | Unique customer identifier |
| fullName | VARCHAR(100) | NOT NULL | Customer name |
| phoneNumber | VARCHAR(20) | NOT NULL | Mobile number |
| email | VARCHAR(150) | Optional | Email address |
| createdAt | TIMESTAMP | NOT NULL | Registration timestamp |
| updatedAt | TIMESTAMP | NOT NULL | Last update timestamp |

---

## Business Rules

- Customers are not authenticated users.
- One customer may generate multiple tokens over time.
- Only one active token is allowed per branch.
- Phone number should remain unique whenever possible.

---

## Relationships

- One Customer can generate many Tokens.

---

# 11.3 Branch Entity

## Purpose

A Branch represents a physical service location where customers receive services.

Each branch manages its own counters, operators, services, and queues.

---

## Responsibilities

- Isolate branch operations
- Manage counters
- Configure services
- Generate branch-specific reports

---

## Attributes

| Field | Data Type | Constraints | Description |
|---------|-----------|------------|-------------|
| id | UUID | Primary Key | Unique branch identifier |
| branchCode | VARCHAR(20) | UNIQUE | Internal branch code |
| branchName | VARCHAR(100) | NOT NULL | Branch name |
| address | TEXT | NOT NULL | Branch location |
| timezone | VARCHAR(50) | NOT NULL | Branch timezone |
| status | ENUM | NOT NULL | ACTIVE, INACTIVE |
| createdAt | TIMESTAMP | NOT NULL | Creation time |
| updatedAt | TIMESTAMP | NOT NULL | Last update |

---

## Business Rules

- Every branch must have a unique branch code.
- Inactive branches cannot issue new tokens.
- Branches cannot be deleted if counters exist.

---

## Relationships

- One Branch has many Counters.
- One Branch has many Service Categories.
- One Branch has many Tokens.

---

# 11.4 Counter Entity

## Purpose

A Counter represents a physical workstation where operators provide services to customers.

---

## Responsibilities

- Serve customers
- Call next token
- Skip token
- Recall token
- Track counter activity

---

## Attributes

| Field | Data Type | Constraints | Description |
|---------|-----------|------------|-------------|
| id | UUID | Primary Key | Counter identifier |
| branchId | UUID | Foreign Key | Parent branch |
| counterNumber | INT | NOT NULL | Display number |
| counterType | ENUM | NOT NULL | NORMAL, VIP, PRIORITY |
| status | ENUM | NOT NULL | OPEN, CLOSED, ON_BREAK, OFFLINE |
| createdAt | TIMESTAMP | NOT NULL | Created timestamp |
| updatedAt | TIMESTAMP | NOT NULL | Updated timestamp |

---

## Business Rules

- Closed counters cannot call tokens.
- Every counter belongs to one branch.
- Counter numbers must be unique within a branch.
- Only one active operator session is allowed per counter.

---

## Relationships

- Many Counters belong to one Branch.
- One Counter has many Operator Sessions.
- One Counter serves many Tokens.

---

# 11.5 ServiceCategory Entity

## Purpose

Service Categories define the different services offered by a branch.

Each category maintains its own queue and estimated service time.

---

## Responsibilities

- Categorize services
- Define token prefixes
- Estimate waiting time
- Separate queues

---

## Attributes

| Field | Data Type | Constraints | Description |
|---------|-----------|------------|-------------|
| id | UUID | Primary Key | Service identifier |
| branchId | UUID | Foreign Key | Parent branch |
| serviceName | VARCHAR(100) | NOT NULL | Name of service |
| tokenPrefix | CHAR(2) | NOT NULL | Token prefix (A, B, L, etc.) |
| averageHandlingTime | INT | Default 10 | Average service duration (minutes) |
| priorityEnabled | BOOLEAN | Default FALSE | Allows priority handling |
| createdAt | TIMESTAMP | NOT NULL | Creation timestamp |
| updatedAt | TIMESTAMP | NOT NULL | Last update |

---

## Business Rules

- Service names must be unique within a branch.
- Token prefixes must remain unique within a branch.
- Estimated waiting time is calculated using the average handling time.
- Priority services are processed before normal services when applicable.

---

## Relationships

- Many Service Categories belong to one Branch.
- One Service Category has many Tokens.

---

# 11.6 Token Entity

## Purpose

The **Token** entity represents a customer's position in the queue and records the complete lifecycle of a service request.

It is the primary transactional entity of QueueFlow and is responsible for tracking customer flow, service progress, waiting time, operator performance, and historical analytics.

Every generated token creates one unique transaction within the system.

---

## Responsibilities

- Generate unique queue numbers
- Track customer waiting status
- Maintain queue lifecycle
- Store service timestamps
- Calculate service metrics
- Support reporting and analytics

---

## Attributes

| Field | Data Type | Constraints | Description |
|---------|-----------|------------|-------------|
| id | UUID | Primary Key | Unique identifier |
| tokenNumber | VARCHAR(20) | UNIQUE, NOT NULL | Display token (A-101, B-205) |
| customerId | UUID | Foreign Key | Customer who owns the token |
| branchId | UUID | Foreign Key | Branch where token was generated |
| serviceCategoryId | UUID | Foreign Key | Requested service |
| counterId | UUID | Nullable FK | Counter serving the customer |
| operatorId | UUID | Nullable FK | Operator handling the customer |
| status | ENUM | NOT NULL | WAITING, CALLING, SERVING, COMPLETED, SKIPPED, CANCELLED |
| estimatedWaitTime | INTEGER | Nullable | Estimated waiting time (minutes) |
| recallCount | INTEGER | Default 0 | Number of recalls |
| issuedAt | TIMESTAMP | NOT NULL | Token generation time |
| calledAt | TIMESTAMP | Nullable | Time when called |
| servedAt | TIMESTAMP | Nullable | Service start time |
| completedAt | TIMESTAMP | Nullable | Service completion time |

---

## Token Lifecycle

A token progresses through the following states:

WAITING

↓

CALLING

↓

SERVING

↓

COMPLETED

Alternative flows:

WAITING → SKIPPED

SKIPPED → CALLING (Recall)

WAITING → CANCELLED

---

## Business Rules

- Token numbers are unique within a branch for each day.
- Only one active token is allowed per customer in the same branch.
- Completed tokens cannot be modified.
- Cancelled tokens cannot be recalled.
- Maximum recall limit is two.
- Tokens are processed using FIFO unless priority rules apply.
- Estimated waiting time is dynamically recalculated.

---

## Relationships

- Many Tokens belong to one Customer.
- Many Tokens belong to one Branch.
- Many Tokens belong to one Service Category.
- Many Tokens may be processed by one Counter.
- Many Tokens may be served by one Operator.

---

# 11.7 OperatorSession Entity

## Purpose

The **OperatorSession** entity records when an operator logs into a counter and when they log out.

This entity provides accurate operational tracking and supports productivity analytics.

---

## Responsibilities

- Track operator login
- Track operator logout
- Map operators to counters
- Support performance reports
- Maintain historical session records

---

## Attributes

| Field | Data Type | Constraints | Description |
|---------|-----------|------------|-------------|
| id | UUID | Primary Key | Session identifier |
| operatorId | UUID | Foreign Key | Logged-in operator |
| counterId | UUID | Foreign Key | Assigned counter |
| loginTime | TIMESTAMP | NOT NULL | Session start |
| logoutTime | TIMESTAMP | Nullable | Session end |

---

## Business Rules

- One operator may have multiple sessions over time.
- One counter can have only one active operator session at a time.
- Session history is never deleted.
- Logout time must always be greater than login time.

---

## Relationships

- Many Sessions belong to one Operator.
- Many Sessions belong to one Counter.

---

# 11.8 AuditLog Entity

## Purpose

The **AuditLog** entity records important administrative and security-related actions performed within the system.

It provides traceability, accountability, and supports compliance requirements.

---

## Responsibilities

- Track administrative activities
- Record sensitive updates
- Store historical changes
- Assist in troubleshooting
- Support security investigations

---

## Attributes

| Field | Data Type | Constraints | Description |
|---------|-----------|------------|-------------|
| id | UUID | Primary Key | Audit record identifier |
| userId | UUID | Foreign Key | User performing the action |
| action | VARCHAR(100) | NOT NULL | CREATE, UPDATE, DELETE, LOGIN, etc. |
| entityName | VARCHAR(100) | NOT NULL | Target entity |
| entityId | UUID | NOT NULL | Affected record |
| oldValue | JSON | Nullable | Previous value |
| newValue | JSON | Nullable | Updated value |
| ipAddress | VARCHAR(45) | Nullable | User IP address |
| createdAt | TIMESTAMP | NOT NULL | Action timestamp |

---

## Business Rules

- Audit logs are immutable.
- Audit logs cannot be edited.
- Only Admin users can access audit history.
- Login attempts should also be logged.

---

## Relationships

- Many Audit Logs belong to one User.

---

# 12. Primary Key Strategy

QueueFlow uses **UUID Version 4** as the primary key strategy for all major entities.

### Advantages

- Globally unique identifiers
- Improved security by preventing sequential ID enumeration
- Better compatibility with distributed systems
- Easier future migration to microservices

---

# 13. Foreign Key Relationships

| Parent Entity | Child Entity |
|---------------|--------------|
| Branch | Counter |
| Branch | ServiceCategory |
| Branch | Token |
| Customer | Token |
| User | OperatorSession |
| Counter | OperatorSession |
| Counter | Token |
| User | AuditLog |
| ServiceCategory | Token |

---

# 14. Indexing Strategy

The following fields should be indexed to improve query performance.

| Entity | Indexed Columns |
|----------|----------------|
| User | email |
| Customer | phoneNumber |
| Branch | branchCode |
| Counter | branchId |
| ServiceCategory | branchId |
| Token | tokenNumber |
| Token | status |
| Token | customerId |
| Token | branchId |
| Token | issuedAt |
| AuditLog | userId |
| OperatorSession | operatorId |

---

# 15. Security Considerations

The database follows security best practices.

- Passwords stored using BCrypt hashing.
- UUIDs prevent predictable identifiers.
- Role-Based Access Control (RBAC).
- Soft deletion where applicable.
- Immutable audit records.
- JWT-based authentication.
- Database constraints enforce integrity.

---

# 16. Future Database Enhancements

Future versions may introduce additional entities:

- Notification
- RefreshToken
- Feedback
- QueueAnalytics
- DisplayScreen
- Announcement
- SMSHistory
- EmailHistory

The current schema is designed to accommodate these enhancements without major structural changes.

---

# 17. Database Version History

| Version | Date | Description |
|----------|------|-------------|
| 1.0 | July 2026 | Initial database schema approved |

---

# 18. Conclusion

The QueueFlow database has been designed following modern software engineering practices and relational database principles.

The schema emphasizes scalability, maintainability, security, and performance while supporting real-world queue management operations.

This design serves as the official database blueprint for implementing the backend using Spring Boot, Hibernate ORM, Spring Data JPA, and MySQL.

All future development should follow this specification unless superseded by a newer approved database version.
