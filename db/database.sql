-- Create Database
CREATE DATABASE employee_info_system;
USE employee_info_system;

-- Table: Departments
CREATE TABLE departments (
    department_id INT AUTO_INCREMENT PRIMARY KEY,
    department_name VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table: Employees
CREATE TABLE employees (
    employee_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    gender ENUM('Male', 'Female', 'Other'),
    birth_date DATE,
    email VARCHAR(150) UNIQUE,
    phone VARCHAR(20),
    address TEXT,
    hire_date DATE,
    department_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (department_id) REFERENCES departments(department_id)
    ON DELETE SET NULL
    ON UPDATE CASCADE
);

-- Table: Positions
CREATE TABLE positions (
    position_id INT AUTO_INCREMENT PRIMARY KEY,
    position_name VARCHAR(100) NOT NULL,
    base_salary DECIMAL(10,2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table: Employee Positions (History)
CREATE TABLE employee_positions (
    emp_pos_id INT AUTO_INCREMENT PRIMARY KEY,
    employee_id INT,
    position_id INT,
    start_date DATE,
    end_date DATE,
    
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id)
    ON DELETE CASCADE,
    
    FOREIGN KEY (position_id) REFERENCES positions(position_id)
    ON DELETE CASCADE
);

-- Table: Attendance
CREATE TABLE attendance (
    attendance_id INT AUTO_INCREMENT PRIMARY KEY,
    employee_id INT,
    date DATE,
    check_in TIME,
    check_out TIME,
    
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id)
    ON DELETE CASCADE
);

-- Table: Payroll
CREATE TABLE payroll (
    payroll_id INT AUTO_INCREMENT PRIMARY KEY,
    employee_id INT,
    salary DECIMAL(10,2),
    bonus DECIMAL(10,2) DEFAULT 0,
    deductions DECIMAL(10,2) DEFAULT 0,
    net_salary DECIMAL(10,2),
    pay_date DATE,
    
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id)
    ON DELETE CASCADE
);

-- Sample Data

INSERT INTO departments (department_name) VALUES
('Human Resources'),
('IT Department'),
('Finance'),
('Marketing');

INSERT INTO positions (position_name, base_salary) VALUES
('Manager', 50000),
('Developer', 30000),
('Accountant', 28000),
('HR Staff', 25000);

INSERT INTO employees 
(first_name, last_name, gender, email, phone, hire_date, department_id)
VALUES
('John', 'Doe', 'Male', 'john@example.com', '09123456789', '2023-01-10', 2),
('Jane', 'Smith', 'Female', 'jane@example.com', '09987654321', '2023-02-15', 1);

INSERT INTO employee_positions 
(employee_id, position_id, start_date)
VALUES
(1, 2, '2023-01-10'),
(2, 4, '2023-02-15');