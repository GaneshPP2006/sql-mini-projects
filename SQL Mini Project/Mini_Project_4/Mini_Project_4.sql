CREATE DATABASE mini_project_4;
USE mini_project_4;

-- =========================
-- CREATE TABLES
-- =========================

CREATE TABLE offices (
    officeCode INT PRIMARY KEY,
    city VARCHAR(50),
    country VARCHAR(50)
);

CREATE TABLE employees (
    employeeNumber INT PRIMARY KEY,
    firstName VARCHAR(50),
    lastName VARCHAR(50),
    jobTitle VARCHAR(50),
    reportsTo INT,
    officeCode INT
);

CREATE TABLE customers (
    customerNumber INT PRIMARY KEY,
    customerName VARCHAR(100),
    salesRepEmployeeNumber INT
);

CREATE TABLE orders (
    orderNumber INT PRIMARY KEY,
    customerNumber INT,
    orderDate DATE
);

CREATE TABLE products (
    productCode VARCHAR(20) PRIMARY KEY,
    productName VARCHAR(100),
    productLine VARCHAR(50)
);

CREATE TABLE orderdetails (
    orderNumber INT,
    productCode VARCHAR(20),
    quantityOrdered INT,
    priceEach DECIMAL(10,2)
);

CREATE TABLE payments (
    customerNumber INT,
    checkNumber VARCHAR(30),
    paymentDate DATE,
    amount DECIMAL(10,2)
);

-- =========================
-- INSERT DATA
-- =========================

INSERT INTO offices VALUES
(1, 'Bhubaneswar', 'India'),
(2, 'Delhi', 'India'),
(3, 'Mumbai', 'India');

INSERT INTO employees VALUES
(1001, 'Rahul', 'Sharma', 'Manager', NULL, 1),
(1002, 'Priya', 'Das', 'Sales Rep', 1001, 1),
(1003, 'Aman', 'Patnaik', 'Sales Rep', 1001, 2),
(1004, 'Sneha', 'Mohanty', 'Sales Rep', 1001, 3);

INSERT INTO customers VALUES
(101, 'ABC Motors', 1002),
(102, 'XYZ Cars', 1003),
(103, 'Global Auto', 1002),
(104, 'Classic Cars', NULL),
(105, 'Auto World', 1004);

INSERT INTO orders VALUES
(5001, 101, '2024-01-10'),
(5002, 102, '2024-02-15'),
(5003, 103, '2024-03-20'),
(5004, 101, '2024-04-12');

INSERT INTO products VALUES
('P001', 'Ford Mustang', 'Classic Cars'),
('P002', 'BMW 320i', 'Classic Cars'),
('P003', 'Toyota Corolla', 'Cars'),
('P004', 'Honda Civic', 'Cars'),
('P005', 'Mercedes Benz', 'Luxury Cars');

INSERT INTO orderdetails VALUES
(5001, 'P001', 2, 55000),
(5001, 'P003', 3, 45000),
(5002, 'P002', 1, 65000),
(5003, 'P003', 2, 45000),
(5004, 'P004', 4, 40000);

INSERT INTO payments VALUES
(101, 'CHK001', '2024-01-20', 50000),
(102, 'CHK002', '2024-02-25', 65000),
(103, 'CHK003', '2024-03-25', 45000),
(105, 'CHK004', '2024-04-20', 70000);

-- =========================
-- 1. CUSTOMER & PAYMENT
-- =========================

SELECT
    c.customerName,
    p.checkNumber,
    p.paymentDate,
    p.amount
FROM customers c
INNER JOIN payments p
ON c.customerNumber = p.customerNumber;

-- Total payment by each customer

SELECT
    c.customerName,
    SUM(p.amount) AS total_payment
FROM customers c
INNER JOIN payments p
ON c.customerNumber = p.customerNumber
GROUP BY c.customerNumber, c.customerName;

-- =========================
-- 2. EMPLOYEE & OFFICE
-- =========================

SELECT
    e.employeeNumber,
    e.firstName,
    e.lastName,
    e.jobTitle,
    o.city,
    o.country
FROM employees e
INNER JOIN offices o
ON e.officeCode = o.officeCode;

-- =========================
-- 3. ORDER & PRODUCT
-- =========================

SELECT
    o.orderNumber,
    o.orderDate,
    p.productName,
    od.quantityOrdered,
    od.priceEach
FROM orders o
INNER JOIN orderdetails od
ON o.orderNumber = od.orderNumber
INNER JOIN products p
ON od.productCode = p.productCode;

-- Total sales of each product

SELECT
    p.productName,
    SUM(od.quantityOrdered * od.priceEach) AS total_sales
FROM products p
INNER JOIN orderdetails od
ON p.productCode = od.productCode
GROUP BY p.productCode, p.productName;

-- =========================
-- 4. OFFICE ANALYSIS
-- =========================

SELECT
    o.city,
    COUNT(e.employeeNumber) AS total_employees
FROM offices o
LEFT JOIN employees e
ON o.officeCode = e.officeCode
GROUP BY o.officeCode, o.city;

-- =========================
-- 5. SALES REPRESENTATIVE
-- =========================

SELECT
    c.customerName,
    e.firstName,
    e.lastName,
    e.jobTitle
FROM customers c
INNER JOIN employees e
ON c.salesRepEmployeeNumber = e.employeeNumber;

-- =========================
-- 6. EMPLOYEE HIERARCHY
-- SELF JOIN
-- =========================

SELECT
    e.firstName AS employee,
    e.lastName AS employee_lastname,
    m.firstName AS manager,
    m.lastName AS manager_lastname
FROM employees e
LEFT JOIN employees m
ON e.reportsTo = m.employeeNumber;

-- =========================
-- 7. CUSTOMERS WITHOUT ORDERS
-- =========================

SELECT
    c.customerNumber,
    c.customerName
FROM customers c
LEFT JOIN orders o
ON c.customerNumber = o.customerNumber
WHERE o.orderNumber IS NULL;

-- =========================
-- 8. PRODUCTS NEVER SOLD
-- =========================

SELECT
    p.productCode,
    p.productName
FROM products p
LEFT JOIN orderdetails od
ON p.productCode = od.productCode
WHERE od.productCode IS NULL;

-- =========================
-- 9. RECORDS WITHOUT MATCHING CUSTOMER
-- =========================

SELECT
    o.orderNumber,
    o.customerNumber
FROM orders o
LEFT JOIN customers c
ON o.customerNumber = c.customerNumber
WHERE c.customerNumber IS NULL;

-- =========================
-- 10. RIGHT JOIN
-- =========================

SELECT
    e.employeeNumber,
    e.firstName,
    e.lastName,
    c.customerName
FROM customers c
RIGHT JOIN employees e
ON c.salesRepEmployeeNumber = e.employeeNumber;

-- =========================
-- 11. CROSS JOIN
-- =========================

SELECT
    e.firstName,
    e.lastName,
    o.city
FROM employees e
CROSS JOIN offices o;
