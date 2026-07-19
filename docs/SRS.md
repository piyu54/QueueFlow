# Software Requirement Specification (SRS)

# 1. Introduction

## 1.1 Purpose

This Software Requirement Specification (SRS) defines the requirements of the QueueFlow project. It serves as a reference for developers, testers, stakeholders, and project managers to ensure a clear understanding of the system before development begins.

## 1.2 Project Overview

QueueFlow is a Smart Queue & Token Management System designed to digitize and simplify the queue management process for organizations such as hospitals, banks, clinics, government offices, diagnostic laboratories, and customer service centers. The system replaces traditional manual queue systems with a secure and efficient digital platform.

## 1.3 Scope of this Document

This document describes the objectives, scope, stakeholders, user roles, functional requirements, non-functional requirements, assumptions, constraints, and future scope of the QueueFlow system. It serves as a guide for the development team throughout the software development lifecycle.

# 2. Problem Statement

Many organizations such as hospitals, banks, clinics, government offices, and customer service centers still rely on manual queue management systems. These traditional methods often result in long waiting times, poor queue visibility, inefficient counter management, and customer dissatisfaction.

Customers often do not know their queue position or estimated waiting time, while staff struggle to manage large numbers of visitors efficiently. In addition, organizations lack proper reports and analytics to improve their services.

QueueFlow addresses these challenges by providing a secure digital queue management system that improves service efficiency, reduces waiting time, and enhances the overall customer experience.

# 3. Objectives

The main objectives of QueueFlow are:

- Digitize the queue management process.
- Reduce customer waiting time.
- Improve service efficiency.
- Provide real-time queue tracking.
- Enable efficient counter management.
- Generate reports and analytics.
- Enhance customer satisfaction.
- Improve resource utilization.

# 4. Scope

QueueFlow is designed for organizations that require efficient queue management, including hospitals, banks, clinics, government offices, and customer service centers.

The system includes digital token generation, queue tracking, counter management, user authentication, dashboards, and reporting features.

The current version does not include online appointment booking, payment processing, SMS notifications, or mobile applications. These features are considered part of the future scope.

# 5. Stakeholders

The major stakeholders of QueueFlow include:

- Customers/Patients
- Receptionists
- Service Operators
- Administrators
- Organization Management
- Development Team
- Testing Team

# 6. User Roles

The QueueFlow system supports four primary user roles. Each role has specific responsibilities and permissions to ensure secure and efficient operation of the system.

## 6.1 Customer / Patient

Responsibilities:

- Generate a digital token.
- View queue status and estimated waiting time.
- Wait for service.
- Receive service.

## 6.2 Receptionist

Responsibilities:

- Register customers.
- Generate tokens.
- Guide customers to the appropriate queue.
- View queue information.

## 6.3 Service Operator

Responsibilities:

- Call the next token.
- Provide the requested service.
- Update the token status.
- Mark services as completed.

## 6.4 Administrator

Responsibilities:

- Manage users and counters.
- Configure system settings.
- View reports and dashboards.
- Monitor overall system activities.

# 7. Functional Requirements

The functional requirements describe the core features and operations that QueueFlow must perform. These requirements define the expected behavior of the system to meet user and business needs.

## 7.1 User Authentication (FR-01)

The system shall allow authorized users to log in using a valid username and password.

Acceptance Criteria:

- Users must enter valid credentials.
- Invalid credentials should display an error message.
- Users shall be redirected to their respective dashboards based on their roles.

## 7.2 Token Generation (FR-02)

The system shall generate a unique digital token for every customer requesting a service.

Acceptance Criteria:

- Every token must have a unique number.
- Token generation should take less than 2 seconds.
- Generated tokens must be stored in the database.

## 7.3 Queue Management (FR-03)

The system shall maintain the queue automatically according to the generated token sequence.

Acceptance Criteria:

- Tokens shall be called in sequence.
- Skipped tokens should be marked accordingly.
- Completed tokens should be removed from the active queue.

## 7.4 Queue Tracking (FR-04)

The system shall display the customer's queue position and estimated waiting time in real time.

Acceptance Criteria:

- Customers should see their current queue position.
- Waiting time should update automatically.

## 7.5 Counter Management (FR-05)

The system shall allow administrators to create, update, activate, or deactivate service counters.

Acceptance Criteria:

- New counters can be added.
- Existing counters can be edited.
- Inactive counters shall not receive new tokens.

## 7.6 Service Management (FR-06)

The system shall allow service operators to call the next token, skip tokens when necessary, and mark services as completed.

Acceptance Criteria:

- Only active operators can call tokens.
- Completed tokens should not appear again.

## 7.7 Dashboard (FR-07)

The system shall provide dashboards displaying queue statistics, active counters, waiting customers, and completed services.

Acceptance Criteria:

- Dashboard data should refresh automatically.
- Administrators should have access to all reports.

## 7.8 Reports (FR-08)

The system shall generate daily and monthly operational reports.

Acceptance Criteria:

- Reports should include customer count.
- Reports should include average waiting time.
- Reports should include completed services.

## 7.9 Role-Based Access (FR-09)

The system shall provide access to features based on user roles.

Acceptance Criteria:

- Customers can only access customer features.
- Receptionists can generate tokens.
- Service Operators can manage queue operations.
- Administrators have full system access.

## 7.10 Notifications (FR-10)

The system shall notify customers when their token is approaching the service counter.

Acceptance Criteria:

- Notifications should appear before the customer's turn.
- The notification should display the assigned counter number.

# 8. Non-Functional Requirements

Non-functional requirements describe the quality attributes and performance standards that QueueFlow must satisfy. These requirements ensure that the system is secure, reliable, efficient, and user-friendly.

## 8.1 Performance

- The system shall generate a token within 2 seconds.
- Dashboard pages should load within 3 seconds.
- The system shall support at least 500 active users simultaneously.

## 8.2 Security

- User passwords shall be stored in encrypted form.
- Only authorized users shall access the system.
- Role-Based Access Control (RBAC) shall be implemented.
- Sessions should expire automatically after inactivity.

## 8.3 Reliability

- The system shall operate with high accuracy.
- Queue information shall not be lost unexpectedly.
- System failures shall be minimized.

## 8.4 Availability

- The system should be available during business hours.
- Planned maintenance should be scheduled outside working hours.

## 8.5 Scalability

- The system shall support additional counters.
- The system shall support increasing numbers of customers without major performance degradation.

## 8.6 Maintainability

- The application shall follow a modular architecture.
- Code should be properly documented.
- Future enhancements should be easy to implement.

## 8.7 Usability

- The user interface shall be simple and intuitive.
- Navigation should be clear and consistent.
- Error messages should be easy to understand.

# 9. Assumptions

The following assumptions are considered during the development of QueueFlow. These assumptions help define the environment and conditions under which the system is expected to operate.

## 9.1 Assumptions

- Users have basic computer knowledge.
- A stable internet connection is available.
- The MySQL database server is properly configured and accessible.
- Authorized users have valid login credentials.
- The organization provides the required hardware such as computers and printers.
- The system will be used during normal business hours.

# 10. Constraints

The following constraints define the limitations and restrictions that must be followed during the development and deployment of QueueFlow.

## 10.1 Constraints

- The application shall be developed using Java Spring Boot.
- MySQL shall be used as the database management system.
- The project shall be completed within the assigned timeline.
- The system shall run on the organization's existing hardware and network infrastructure.
- The project shall follow the allocated budget.

# 11. Future Scope

The current version of QueueFlow focuses on providing an efficient web-based queue and token management system. In future releases, the following enhancements can be implemented:

## 11.1 Future Enhancements

- Develop a mobile application for Android and iOS.
- Implement AI-based waiting time prediction.
- Add SMS and email notifications for customers.
- Introduce QR code-based token generation.
- Integrate online appointment booking.
- Deploy the application on cloud platforms.
- Provide advanced analytics and reporting dashboards.
- Support multiple branches from a single system.
