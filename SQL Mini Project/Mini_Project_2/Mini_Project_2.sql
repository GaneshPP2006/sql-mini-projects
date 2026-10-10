USE classicmodels;

-- Customer Analysis

SELECT * FROM customers;

SELECT customerName, country
FROM customers;

SELECT *
FROM customers
WHERE country = 'USA';

SELECT customerName, creditLimit
FROM customers
WHERE creditLimit > 100000
ORDER BY creditLimit DESC;

SELECT customerName, country
FROM customers
WHERE customerName LIKE '%Auto%';

SELECT customerName, country
FROM customers
WHERE country IN ('USA', 'France', 'Germany');

-- Product Analysis

SELECT * FROM products;

SELECT productName, buyPrice
FROM products
WHERE buyPrice > 50
ORDER BY buyPrice DESC;

SELECT productLine, COUNT(*) AS total_products
FROM products
GROUP BY productLine;

SELECT productName, quantityInStock
FROM products
WHERE quantityInStock > 500;

-- Payment Analysis

SELECT * FROM payments;

SELECT *
FROM payments
WHERE YEAR(paymentDate) = 2004;

SELECT COUNT(*) AS total_payments
FROM payments;

SELECT customerNumber, SUM(amount) AS total_payment
FROM payments
GROUP BY customerNumber;

SELECT customerNumber, AVG(amount) AS average_payment
FROM payments
GROUP BY customerNumber;

SELECT MIN(amount) AS minimum_payment,
       MAX(amount) AS maximum_payment
FROM payments;