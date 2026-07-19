CREATE DATABASE queueflow;

USE queueflow;

CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    phone VARCHAR(15),
    role ENUM('ADMIN','RECEPTIONIST','OPERATOR') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE services (
    service_id INT AUTO_INCREMENT PRIMARY KEY,
    service_name VARCHAR(100) NOT NULL,
    description TEXT
);

CREATE TABLE counters (
    counter_id INT AUTO_INCREMENT PRIMARY KEY,
    counter_name VARCHAR(50) NOT NULL,
    status ENUM('ACTIVE','INACTIVE') DEFAULT 'ACTIVE'
);

CREATE TABLE tokens (
    token_id INT AUTO_INCREMENT PRIMARY KEY,
    token_number VARCHAR(20) UNIQUE NOT NULL,

    user_id INT NOT NULL,
    service_id INT NOT NULL,
    counter_id INT,

    status ENUM(
        'WAITING',
        'CALLED',
        'IN_PROGRESS',
        'COMPLETED',
        'CANCELLED'
    ) DEFAULT 'WAITING',

    created_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    served_time DATETIME,

    FOREIGN KEY (user_id)
        REFERENCES users(user_id),

    FOREIGN KEY (service_id)
        REFERENCES services(service_id),

    FOREIGN KEY (counter_id)
        REFERENCES counters(counter_id)
);