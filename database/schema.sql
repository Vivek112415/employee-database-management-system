-- =====================================================
-- EMPLOYEE DATABASE MANAGEMENT SYSTEM
-- MySQL Schema
-- Author: [Your Name] | BCA Final Year Project
-- =====================================================

CREATE DATABASE IF NOT EXISTS employee_db_system;
USE employee_db_system;

-- ---------------------------------------------------
-- Table: users  (Login/Authentication for Admin & HR)
-- ---------------------------------------------------
CREATE TABLE IF NOT EXISTS users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    role ENUM('admin', 'hr', 'viewer') DEFAULT 'hr',
    email VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_login DATETIME
);

-- ---------------------------------------------------
-- Table: departments
-- ---------------------------------------------------
CREATE TABLE IF NOT EXISTS departments (
    dept_id INT AUTO_INCREMENT PRIMARY KEY,
    dept_name VARCHAR(100) UNIQUE NOT NULL,
    dept_head VARCHAR(100),
    description VARCHAR(255)
);

-- ---------------------------------------------------
-- Table: employees
-- ---------------------------------------------------
CREATE TABLE IF NOT EXISTS employees (
    emp_id INT AUTO_INCREMENT PRIMARY KEY,
    emp_code VARCHAR(20) UNIQUE NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(15),
    gender ENUM('Male', 'Female', 'Other'),
    dob DATE,
    address VARCHAR(255),
    dept_id INT,
    designation VARCHAR(100),
    date_of_joining DATE,
    basic_salary DECIMAL(10,2) DEFAULT 0,
    allowance DECIMAL(10,2) DEFAULT 0,
    deduction DECIMAL(10,2) DEFAULT 0,
    photo VARCHAR(255) DEFAULT 'default.png',
    status ENUM('Active', 'Inactive', 'Resigned') DEFAULT 'Active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (dept_id) REFERENCES departments(dept_id) ON DELETE SET NULL
);

-- ---------------------------------------------------
-- Table: salary_history (for payslip / salary records)
-- ---------------------------------------------------
CREATE TABLE IF NOT EXISTS salary_history (
    salary_id INT AUTO_INCREMENT PRIMARY KEY,
    emp_id INT NOT NULL,
    month VARCHAR(20) NOT NULL,
    year INT NOT NULL,
    basic_salary DECIMAL(10,2),
    allowance DECIMAL(10,2),
    deduction DECIMAL(10,2),
    net_salary DECIMAL(10,2),
    generated_on TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (emp_id) REFERENCES employees(emp_id) ON DELETE CASCADE
);

-- ---------------------------------------------------
-- Table: attendance (bonus advanced feature)
-- ---------------------------------------------------
CREATE TABLE IF NOT EXISTS attendance (
    att_id INT AUTO_INCREMENT PRIMARY KEY,
    emp_id INT NOT NULL,
    att_date DATE NOT NULL,
    status ENUM('Present', 'Absent', 'Leave', 'Half-Day') DEFAULT 'Present',
    FOREIGN KEY (emp_id) REFERENCES employees(emp_id) ON DELETE CASCADE,
    UNIQUE KEY unique_attendance (emp_id, att_date)
);

-- ---------------------------------------------------
-- Table: activity_log (audit trail - advanced feature)
-- ---------------------------------------------------
CREATE TABLE IF NOT EXISTS activity_log (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    action VARCHAR(255),
    log_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE SET NULL
);

-- =====================================================
-- SAMPLE / SEED DATA
-- =====================================================

INSERT INTO departments (dept_name, dept_head, description) VALUES
('Human Resources', 'Priya Sharma', 'Handles recruitment and employee welfare'),
('Information Technology', 'Rahul Verma', 'Software development and IT support'),
('Finance', 'Anjali Mehta', 'Manages company accounts and payroll'),
('Sales & Marketing', 'Vikram Singh', 'Handles client acquisition and branding'),
('Operations', 'Sneha Patel', 'Day-to-day business operations');

-- Default admin login -> username: admin | password: admin123
-- (password_hash generated using werkzeug.security in app.py on first run)
INSERT INTO users (username, password_hash, full_name, role, email) VALUES
('admin', 'scrypt:32768:8:1$PLACEHOLDER$0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000', 'System Administrator', 'admin', 'admin@company.com');

INSERT INTO employees (emp_code, first_name, last_name, email, phone, gender, dob, address, dept_id, designation, date_of_joining, basic_salary, allowance, deduction, status) VALUES
('EMP001', 'Aarav', 'Kumar', 'aarav.kumar@company.com', '9876543210', 'Male', '1995-03-12', 'Delhi, India', 2, 'Software Engineer', '2022-06-01', 45000, 5000, 2000, 'Active'),
('EMP002', 'Diya', 'Singh', 'diya.singh@company.com', '9876543211', 'Female', '1997-07-22', 'Mumbai, India', 1, 'HR Executive', '2021-01-15', 35000, 4000, 1500, 'Active'),
('EMP003', 'Karan', 'Patel', 'karan.patel@company.com', '9876543212', 'Male', '1993-11-05', 'Ahmedabad, India', 3, 'Accountant', '2020-09-10', 40000, 3500, 1800, 'Active'),
('EMP004', 'Neha', 'Gupta', 'neha.gupta@company.com', '9876543213', 'Female', '1996-02-18', 'Pune, India', 4, 'Marketing Manager', '2023-03-20', 50000, 6000, 2200, 'Active'),
('EMP005', 'Rohan', 'Mehta', 'rohan.mehta@company.com', '9876543214', 'Male', '1994-09-30', 'Bangalore, India', 2, 'Senior Developer', '2019-05-12', 65000, 8000, 3000, 'Active');

-- =====================================================
-- USEFUL VIEWS (Advanced SQL feature for resume)
-- =====================================================
CREATE OR REPLACE VIEW employee_full_view AS
SELECT
    e.emp_id, e.emp_code, CONCAT(e.first_name, ' ', e.last_name) AS full_name,
    e.email, e.phone, e.gender, e.dob, d.dept_name, e.designation,
    e.date_of_joining, e.basic_salary, e.allowance, e.deduction,
    (e.basic_salary + e.allowance - e.deduction) AS net_salary,
    e.status, e.photo
FROM employees e
LEFT JOIN departments d ON e.dept_id = d.dept_id;

CREATE OR REPLACE VIEW department_stats AS
SELECT
    d.dept_id, d.dept_name, COUNT(e.emp_id) AS total_employees,
    COALESCE(AVG(e.basic_salary), 0) AS avg_salary,
    COALESCE(SUM(e.basic_salary + e.allowance - e.deduction), 0) AS total_payroll
FROM departments d
LEFT JOIN employees e ON d.dept_id = e.dept_id AND e.status = 'Active'
GROUP BY d.dept_id, d.dept_name;
