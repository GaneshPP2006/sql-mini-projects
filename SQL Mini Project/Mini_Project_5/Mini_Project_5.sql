CREATE DATABASE mini_project_5;
USE mini_project_5;

-- =========================================
-- CREATE TABLES
-- =========================================

CREATE TABLE products (
    productCode VARCHAR(20) PRIMARY KEY,
    productName VARCHAR(100),
    productLine VARCHAR(50),
    price DECIMAL(10,2)
);

CREATE TABLE payments (
    customerNumber INT,
    paymentDate DATE,
    amount DECIMAL(10,2)
);

-- =========================================
-- INSERT PRODUCT DATA
-- =========================================

INSERT INTO products VALUES
('P001', 'Ford Mustang', 'Classic Cars', 55000),
('P002', 'BMW 320i', 'Classic Cars', 65000),
('P003', 'Toyota Corolla', 'Cars', 45000),
('P004', 'Honda Civic', 'Cars', 40000),
('P005', 'Mercedes Benz', 'Luxury Cars', 95000),
('P006', 'Audi A6', 'Luxury Cars', 85000),
('P007', 'Ford Explorer', 'SUVs', 75000),
('P008', 'Toyota Fortuner', 'SUVs', 70000);

-- =========================================
-- INSERT PAYMENT DATA
-- =========================================

INSERT INTO payments VALUES
(101, '2024-01-15', 25000),
(102, '2024-01-20', 30000),
(103, '2024-02-10', 40000),
(104, '2024-02-18', 35000),
(105, '2024-03-12', 50000),
(106, '2024-03-20', 45000),
(107, '2024-04-15', 60000),
(108, '2024-04-25', 55000),
(109, '2024-05-10', 70000),
(110, '2024-05-20', 65000),
(111, '2024-06-15', 80000),
(112, '2024-06-25', 75000);

-- =========================================
-- 1. ROW_NUMBER()
-- Rank products within each product line
-- =========================================

SELECT
    productName,
    productLine,
    price,
    ROW_NUMBER() OVER (
        PARTITION BY productLine
        ORDER BY price DESC
    ) AS row_number_rank
FROM products;

-- =========================================
-- 2. RANK()
-- =========================================

SELECT
    productName,
    productLine,
    price,
    RANK() OVER (
        PARTITION BY productLine
        ORDER BY price DESC
    ) AS product_rank
FROM products;

-- =========================================
-- 3. DENSE_RANK()
-- =========================================

SELECT
    productName,
    productLine,
    price,
    DENSE_RANK() OVER (
        PARTITION BY productLine
        ORDER BY price DESC
    ) AS dense_rank
FROM products;

-- =========================================
-- 4. TOP PRODUCTS
-- Highest-ranked product in each product line
-- =========================================

WITH ranked_products AS (
    SELECT
        productName,
        productLine,
        price,
        RANK() OVER (
            PARTITION BY productLine
            ORDER BY price DESC
        ) AS rnk
    FROM products
)
SELECT
    productName,
    productLine,
    price
FROM ranked_products
WHERE rnk = 1;

-- =========================================
-- 5. MONTHLY PAYMENT TOTAL
-- =========================================

WITH monthly_payments AS (
    SELECT
        DATE_FORMAT(paymentDate, '%Y-%m') AS payment_month,
        SUM(amount) AS monthly_total
    FROM payments
    GROUP BY DATE_FORMAT(paymentDate, '%Y-%m')
)
SELECT
    payment_month,
    monthly_total
FROM monthly_payments
ORDER BY payment_month;

-- =========================================
-- 6. RUNNING TOTAL
-- =========================================

WITH monthly_payments AS (
    SELECT
        DATE_FORMAT(paymentDate, '%Y-%m') AS payment_month,
        SUM(amount) AS monthly_total
    FROM payments
    GROUP BY DATE_FORMAT(paymentDate, '%Y-%m')
)
SELECT
    payment_month,
    monthly_total,
    SUM(monthly_total) OVER (
        ORDER BY payment_month
    ) AS running_total
FROM monthly_payments
ORDER BY payment_month;

-- =========================================
-- 7. LAG()
-- Compare current month with previous month
-- =========================================

WITH monthly_payments AS (
    SELECT
        DATE_FORMAT(paymentDate, '%Y-%m') AS payment_month,
        SUM(amount) AS monthly_total
    FROM payments
    GROUP BY DATE_FORMAT(paymentDate, '%Y-%m')
)
SELECT
    payment_month,
    monthly_total,
    LAG(monthly_total) OVER (
        ORDER BY payment_month
    ) AS previous_month
FROM monthly_payments
ORDER BY payment_month;

-- =========================================
-- 8. MONTH-OVER-MONTH ANALYSIS
-- =========================================

WITH monthly_payments AS (
    SELECT
        DATE_FORMAT(paymentDate, '%Y-%m') AS payment_month,
        SUM(amount) AS monthly_total
    FROM payments
    GROUP BY DATE_FORMAT(paymentDate, '%Y-%m')
)
SELECT
    payment_month,
    monthly_total,
    LAG(monthly_total) OVER (
        ORDER BY payment_month
    ) AS previous_month,
    monthly_total -
    LAG(monthly_total) OVER (
        ORDER BY payment_month
    ) AS monthly_change
FROM monthly_payments
ORDER BY payment_month;

-- =========================================
-- 9. GROWTH ANALYSIS
-- =========================================

WITH monthly_payments AS (
    SELECT
        DATE_FORMAT(paymentDate, '%Y-%m') AS payment_month,
        SUM(amount) AS monthly_total
    FROM payments
    GROUP BY DATE_FORMAT(paymentDate, '%Y-%m')
)
SELECT
    payment_month,
    monthly_total,
    LAG(monthly_total) OVER (
        ORDER BY payment_month
    ) AS previous_month,
    ROUND(
        (
            monthly_total -
            LAG(monthly_total) OVER (
                ORDER BY payment_month
            )
        )
        /
        LAG(monthly_total) OVER (
            ORDER BY payment_month
        ) * 100,
        2
    ) AS growth_percentage
FROM monthly_payments
ORDER BY payment_month;

-- =========================================
-- 10. THREE-MONTH MOVING AVERAGE
-- =========================================

WITH monthly_payments AS (
    SELECT
        DATE_FORMAT(paymentDate, '%Y-%m') AS payment_month,
        SUM(amount) AS monthly_total
    FROM payments
    GROUP BY DATE_FORMAT(paymentDate, '%Y-%m')
)
SELECT
    payment_month,
    monthly_total,
    ROUND(
        AVG(monthly_total) OVER (
            ORDER BY payment_month
            ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
        ),
        2
    ) AS three_month_moving_average
FROM monthly_payments
ORDER BY payment_month;

-- =========================================
-- 11. CUMULATIVE PAYMENT FOR EACH CUSTOMER
-- =========================================

SELECT
    customerNumber,
    paymentDate,
    amount,
    SUM(amount) OVER (
        PARTITION BY customerNumber
        ORDER BY paymentDate
    ) AS cumulative_payment
FROM payments
ORDER BY customerNumber, paymentDate;