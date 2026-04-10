-- Create Database
CREATE DATABASE IF NOT EXISTS employee_info_system;
USE employee_info_system;

-- =========================
-- TABLE: Departments
-- =========================
CREATE TABLE IF NOT EXISTS departments (
    department_id INT AUTO_INCREMENT PRIMARY KEY,
    department_name VARCHAR(100) NOT NULL
);

-- =========================
-- TABLE: Employees
-- =========================
CREATE TABLE IF NOT EXISTS employees (
    employee_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    gender ENUM('Male', 'Female', 'Other'),
    email VARCHAR(150) UNIQUE,
    phone VARCHAR(20),
    hire_date DATE,
    department_id INT,
    
    CONSTRAINT fk_department
    FOREIGN KEY (department_id) 
    REFERENCES departments(department_id)
    ON DELETE SET NULL
    ON UPDATE CASCADE
);

-- =========================
-- TABLE: Positions
-- =========================
CREATE TABLE IF NOT EXISTS positions (
    position_id INT AUTO_INCREMENT PRIMARY KEY,
    position_name VARCHAR(100) NOT NULL,
    salary DECIMAL(10,2)
);

-- =========================
-- TABLE: Employee Positions
-- =========================
CREATE TABLE IF NOT EXISTS employee_positions (
    emp_pos_id INT AUTO_INCREMENT PRIMARY KEY,
    employee_id INT,
    position_id INT,
    start_date DATE,
    end_date DATE,

    CONSTRAINT fk_emp
    FOREIGN KEY (employee_id) 
    REFERENCES employees(employee_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,

    CONSTRAINT fk_pos
    FOREIGN KEY (position_id) 
    REFERENCES positions(position_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

-- =========================
-- TABLE: Attendance
-- =========================
CREATE TABLE IF NOT EXISTS attendance (
    attendance_id INT AUTO_INCREMENT PRIMARY KEY,
    employee_id INT,
    date DATE,
    check_in TIME,
    check_out TIME,

    CONSTRAINT fk_attendance_emp
    FOREIGN KEY (employee_id) 
    REFERENCES employees(employee_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

-- =========================
-- TABLE: Payroll
-- =========================
CREATE TABLE IF NOT EXISTS payroll (
    payroll_id INT AUTO_INCREMENT PRIMARY KEY,
    employee_id INT,
    salary DECIMAL(10,2),
    bonus DECIMAL(10,2) DEFAULT 0,
    deductions DECIMAL(10,2) DEFAULT 0,
    net_salary DECIMAL(10,2),

    CONSTRAINT fk_payroll_emp
    FOREIGN KEY (employee_id) 
    REFERENCES employees(employee_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);