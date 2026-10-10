-- ============================================
-- MINI PROJECT 03
-- DATA CLEANING & TRANSFORMATION
-- ============================================

CREATE DATABASE mini_project_3;
USE mini_project_3;

-- ============================================
-- 1. CREATE TABLE
-- ============================================

CREATE TABLE customers (
    customer_id INT,
    customer_name VARCHAR(100),
    email VARCHAR(100),
    phone VARCHAR(30),
    city VARCHAR(50),
    order_status VARCHAR(30),
    product_code VARCHAR(30)
);

-- ============================================
-- 2. INSERT INCONSISTENT / INCOMPLETE DATA
-- ============================================

INSERT INTO customers VALUES
(1, '  Rahul Kumar  ', 'rahul@gmail.com', '98765-43210', 'Bhubaneswar', 'Shipped', 'CAR-001'),
(2, 'Priya Sharma', ' PRIYA@GMAIL.COM ', '98765 43211', 'bhubaneswar', 'shipped', 'CAR-002'),
(3, 'Aman Das', NULL, '(98765)43212', 'Cuttack', 'Pending', 'CAR-003'),
(4, 'Sneha  Mohanty', 'sneha@gmail.com', '9876543213', 'Cuttack', 'CANCELLED', 'CAR-004'),
(5, 'Rohan Das', 'rohan@gmail.com', NULL, 'Puri', 'Delivered', 'CAR-005'),
(6, 'Rahul Kumar', 'rahul@gmail.com', '98765-43210', 'Bhubaneswar', 'Shipped', 'CAR-001'),
(7, 'Anjali Patnaik', 'anjali @gmail.com', '98765-43215', 'puri', 'Pending', 'CAR-006'),
(8, '  Vikash Singh', 'vikash@gmail.com', '98765-43216', 'Cuttack', 'Delivered', 'CAR-007');


-- ============================================
-- 3. NULL HANDLING
-- ============================================

-- Find records with missing email
SELECT *
FROM customers
WHERE email IS NULL;

-- Find records with missing phone
SELECT *
FROM customers
WHERE phone IS NULL;

-- Replace missing email
UPDATE customers
SET email = 'not_available@gmail.com'
WHERE email IS NULL;

-- Replace missing phone
UPDATE customers
SET phone = 'Not Available'
WHERE phone IS NULL;


-- ============================================
-- 4. NAME CLEANING
-- ============================================

-- Remove unnecessary spaces
UPDATE customers
SET customer_name = TRIM(customer_name);

-- Check names
SELECT customer_id, customer_name
FROM customers;


-- ============================================
-- 5. EMAIL CLEANING
-- ============================================

-- Convert emails to lowercase
UPDATE customers
SET email = LOWER(TRIM(email));

-- Remove spaces from email
UPDATE customers
SET email = REPLACE(email, ' ', '');

-- Display cleaned emails
SELECT customer_id, email
FROM customers;


-- ============================================
-- 6. PHONE NUMBER CLEANING
-- ============================================

-- Remove hyphens
UPDATE customers
SET phone = REPLACE(phone, '-', '');

-- Remove spaces
UPDATE customers
SET phone = REPLACE(phone, ' ', '');

-- Remove brackets
UPDATE customers
SET phone = REPLACE(phone, '(', '');

UPDATE customers
SET phone = REPLACE(phone, ')', '');

-- Display cleaned phone numbers
SELECT customer_id, phone
FROM customers;


-- ============================================
-- 7. DUPLICATE DETECTION
-- ============================================

SELECT customer_name, email, COUNT(*) AS duplicate_count
FROM customers
GROUP BY customer_name, email
HAVING COUNT(*) > 1;


-- ============================================
-- 8. ORDER STATUS ANALYSIS
-- ============================================

-- Display all different order statuses
SELECT DISTINCT order_status
FROM customers;

-- Standardise order status
UPDATE customers
SET order_status = LOWER(TRIM(order_status));

-- Check order status
SELECT customer_id, order_status
FROM customers;


-- ============================================
-- 9. PRODUCT TRANSFORMATION
-- ============================================

-- Extract product category
SELECT
    product_code,
    SUBSTRING_INDEX(product_code, '-', 1) AS product_category
FROM customers;


-- Extract product number
SELECT
    product_code,
    SUBSTRING_INDEX(product_code, '-', -1) AS product_number
FROM customers;


-- ============================================
-- 10. DATA INCONSISTENCY
-- ============================================

-- Find invalid emails
SELECT *
FROM customers
WHERE email NOT LIKE '%@%.%';

-- Find phone numbers that are not 10 digits
SELECT *
FROM customers
WHERE phone <> 'Not Available'
AND LENGTH(phone) <> 10;


-- ============================================
-- 11. CITY STANDARDISATION
-- ============================================

UPDATE customers
SET city = LOWER(TRIM(city));

-- Convert Bhubaneswar consistently
UPDATE customers
SET city = 'Bhubaneswar'
WHERE city = 'bhubaneswar';

-- Convert Puri consistently
UPDATE customers
SET city = 'Puri'
WHERE city = 'puri';


-- ============================================
-- 12. CONDITIONAL LOGIC
-- ============================================

SELECT
    customer_id,
    customer_name,
    order_status,
    CASE
        WHEN order_status = 'shipped' THEN 'In Transit'
        WHEN order_status = 'pending' THEN 'Waiting'
        WHEN order_status = 'delivered' THEN 'Completed'
        WHEN order_status = 'cancelled' THEN 'Cancelled'
        ELSE 'Unknown'
    END AS status_category
FROM customers;


-- ============================================
-- 13. FINAL CLEAN DATA
-- ============================================

SELECT *
FROM customers
ORDER BY customer_id;


-- ============================================
-- END OF MINI PROJECT 03
-- ============================================