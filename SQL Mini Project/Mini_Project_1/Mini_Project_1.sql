-- MINI PROJECT 01
-- SQL Foundations & Database Operations

-- 1. Create Database
CREATE DATABASE mini_project_1;

-- 2. Select Database
USE mini_project_1;

-- 3. Create Table
CREATE TABLE students (
    student_id INT PRIMARY KEY,
    name VARCHAR(50),
    age INT,
    department VARCHAR(50),
    marks INT,
    city VARCHAR(50)
);

-- 4. Insert Records
INSERT INTO students
(student_id, name, age, department, marks, city)
VALUES
(101, 'Rahul', 20, 'CSE', 85, 'Bhubaneswar'),
(102, 'Priya', 21, 'ECE', 72, 'Cuttack'),
(103, 'Aman', 19, 'CSE', 91, 'Puri'),
(104, 'Sneha', 20, 'IT', 65, 'Bhubaneswar'),
(105, 'Rohan', 22, 'ECE', 55, 'Sambalpur'),
(106, 'Anjali', 21, 'CSE', 78, 'Berhampur');

-- 5. Display Table
SELECT * FROM students;

-- 6. Add a New Column
ALTER TABLE students
ADD email VARCHAR(100);

-- 7. Update Email
UPDATE students
SET email = 'rahul@gmail.com'
WHERE student_id = 101;

UPDATE students
SET email = 'priya@gmail.com'
WHERE student_id = 102;

UPDATE students
SET email = 'aman@gmail.com'
WHERE student_id = 103;

UPDATE students
SET email = 'sneha@gmail.com'
WHERE student_id = 104;

UPDATE students
SET email = 'rohan@gmail.com'
WHERE student_id = 105;

UPDATE students
SET email = 'anjali@gmail.com'
WHERE student_id = 106;

-- 8. Rename Column
ALTER TABLE students
RENAME COLUMN city TO location;

-- 9. Update Existing Records
UPDATE students
SET marks = 90
WHERE student_id = 101;

UPDATE students
SET marks = 80
WHERE student_id = 102;

-- 10. Delete a Record
DELETE FROM students
WHERE student_id = 106;

-- 11. CASE Statement - Performance
SELECT student_id, name, marks,
CASE
    WHEN marks >= 80 THEN 'Excellent'
    WHEN marks >= 60 THEN 'Good'
    WHEN marks >= 40 THEN 'Average'
    ELSE 'Fail'
END AS performance
FROM students;

-- 12. CASE Statement - Age Category
SELECT student_id, name, age,
CASE
    WHEN age < 20 THEN 'Teenager'
    WHEN age BETWEEN 20 AND 21 THEN 'Young'
    ELSE 'Adult'
END AS age_category
FROM students;

-- 13. CASE Statement - Department
SELECT student_id, name, department,
CASE
    WHEN department = 'CSE' THEN 'Computer Department'
    WHEN department = 'ECE' THEN 'Electronics Department'
    WHEN department = 'IT' THEN 'Information Technology'
    ELSE 'Other Department'
END AS department_category
FROM students;


SELECT * FROM students;

-- 15. Total Students
SELECT COUNT(*) AS total_students
FROM students;

-- 16. Average Marks
SELECT AVG(marks) AS average_marks
FROM students;

-- 17. Highest Marks
SELECT MAX(marks) AS highest_marks
FROM students;

-- 18. Lowest Marks
SELECT MIN(marks) AS lowest_marks
FROM students;