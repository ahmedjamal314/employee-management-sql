CREATE DATABASE employee_management;
USE employee_management;

CREATE TABLE employees
(employee_id INT PRIMARY KEY AUTO_INCREMENT,
first_name VARCHAR(50),
last_name VARCHAR(50),
email VARCHAR(50) UNIQUE,
phone_number VARCHAR(15),
hire_date DATE,
job_title VARCHAR(50),
department_id INT);

CREATE TABLE department
(department_id INT PRIMARY KEY AUTO_INCREMENT,
department_name VARCHAR(100),
manager_id INT);

CREATE TABLE salaries
(salary_id INT PRIMARY KEY AUTO_INCREMENT,
employee_id INT,
basic_salary DECIMAL(10,2),
bonus DECIMAL(10,2),
total_salary DECIMAL(10,2)); 

CREATE TABLE projects
(project_id INT PRIMARY KEY AUTO_INCREMENT,
project_name VARCHAR(100),
start_date DATE,
end_date DATE,
status ENUM ('Ongoing', 'Completed', 'ON Hold'));

CREATE TABLE  employee_projects
(employee_id INT,
project_id INT,
assigned_date DATE);

CREATE TABLE leaves
(leave_id INT PRIMARY KEY AUTO_INCREMENT,
employee_id INT,
leave_type ENUM ('Sick', 'Casual', 'Paid', 'Unpaid'),
start_date DATE,
end_date DATE,
status ENUM ('Pending', 'Approved', 'Rejected'));

ALTER TABLE employees
ADD FOREIGN KEY (department_id) REFERENCES department(department_id);

ALTER TABLE department
ADD FOREIGN KEY (manager_id) REFERENCES employees(employee_id);

ALTER TABLE salaries
ADD FOREIGN KEY (employee_id) REFERENCES employees(employee_id);

ALTER TABLE employee_projects
ADD FOREIGN KEY (employee_id) REFERENCES employees(employee_id);

ALTER TABLE employee_projects
ADD FOREIGN KEY (project_id) REFERENCES projects(project_id);

ALTER TABLE leaves
ADD FOREIGN KEY (employee_id) REFERENCES employees(employee_id);

INSERT INTO department (department_name)
VALUES
('HR'), ('Finance'), ('Engineering');

SELECT * FROM department;

INSERT INTO employees (first_name, last_name, email, phone_number, hire_date, job_title, department_id)
VALUES
('Alice', 'Smith', 'alice@example.com', '1234567890', '2023-01-01', 'Manager', 1),
('Bob', 'Brown', 'bob@example.com', '1234567891', '2023-02-01', 'Developer', 3),
('Carol', 'White', 'carol@example.com', '1234567892', '2023-03-01', 'Analyst', 2);

SELECT * FROM employees;
SELECT * FROM department;

INSERT INTO department (manager_id)
VALUES
(NULL),
(NULL),
(NULL);

UPDATE department SET manager_id = 4 WHERE department_id = 1;



SELECT * from department;

UPDATE department SET manager_id = 5 WHERE department_id = 3;
UPDATE department SET department_id = 6 WHERE department_id = 2;

UPDATE department
SET manager_id = 6
WHERE department_id = 3; 

ALTER TABLE salaries
ADD FOREIGN KEY (employee_id) REFERENCES employees(employee_id);

INSERT INTO salaries (employee_id, basic_salary, bonus)
VALUES
(4, 5000, 500),
(5, 4000, 300),
(6, 4500, 400);

ALTER TABLE salaries
MODIFY COLUMN total_salary DECIMAL(10,2) GENERATED ALWAYS AS (basic_salary + bonus) STORED;

SELECT * FROM projects;

INSERT INTO projects (project_name, start_date, status)
VALUES
('Project Alpha', '2023-04-01', 'Ongoing'),
('Project Beta', '2023-05-15', 'On Hold');

INSERT INTO employee_projects (employee_id, project_id, assigned_date)
VALUES
(5, 1, '2023-04-05'),
(6, 1, '2023-04-07'),
(4, 2, '2023-05-20');

INSERT INTO leaves (employee_id, leave_type, start_date, end_date, status)
VALUES
(5, 'Sick', '2023-06-01', '2023-06-03', 'Pending'),
(6, 'Paid', '2023-07-10', '2023-07-12', 'Approved');

SELECT 
e.employee_id,
e.first_name,
e.last_name,
d.department_name,
s.basic_salary,
s.bonus,
s.total_salary
FROM employees AS e
JOIN department AS d ON d.department_id = e.department_id
JOIN salaries AS s ON s.employee_id = e.employee_id;

SELECT 
e.employee_id,
e.first_name,
e.last_name,
p.project_name
FROM employees AS e
JOIN employee_projects AS ep ON ep.employee_id = e.employee_id
JOIN projects AS p ON p.project_id = ep.project_id
WHERE p.project_name = 'Project Alpha';

select
sum(total_salary) as 'Monthly_Expenses'
from salaries;

select * from leaves;

select 
e.employee_id,
e.first_name,
e.last_name,
l.status
from employees as e
join leaves as l on l.employee_id = e.employee_id
where l.status = 'Pending'; 

select * from department;

select
d.department_name, 
count(e.employee_id) as employee_count
from department as d
left join employees as e on e.department_id = d.department_id
group by d.department_name;
