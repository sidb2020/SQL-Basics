-- Q1. Create a table called employees with the following structure:
--  * emp_id (integer, should not be NULL and should be a primary key).
--  * emp_name (text, should not be NULL).
--  * age (integer, should have a check constraint to ensure the age is at least 18).
--  * email (text, should be unique for each employee).
--  * salary (decimal, with a default value of 30,000).
-- Write the SQL query to create the above table with all constraints.

CREATE TABLE employees (
    emp_id INT NOT NULL PRIMARY KEY,
    emp_name VARCHAR(100) NOT NULL,
    age INT CHECK (age >= 18),
    email VARCHAR(255) UNIQUE,
    salary DECIMAL(10,2) DEFAULT 30000.00
);

-- Q2. Explain the purpose of constraints and how they help maintain data integrity in a database. Provide examples of common types of constraints.

-- **Constraints** are rules applied to table columns to enforce **data integrity, consistency, and reliability** in a relational database. They define how data should be stored, inserted, or modified, preventing the entry of invalid or inconsistent records.

-- **Types of constraints and their purpose:**

-- 1. **NOT NULL**
--    Ensures a column cannot have a NULL value.
--    *Example: name TEXT NOT NULL*

-- 2. **UNIQUE**
--    Prevents duplicate values in a column.
--    *Example: email TEXT UNIQUE*

-- 3. **PRIMARY KEY**
--    Combines *UNIQUE* and *NOT NULL*; uniquely identifies each row.
--    *Example: id INTEGER PRIMARY KEY*

-- 4. **FOREIGN KEY**
--    Ensures referential integrity between tables.
--    *Example*: A *department_id* in *employees* must exist in *departments*.

-- 5. **CHECK**
--    Validates data based on conditions.
--    *Example: CHECK (age >= 18)*

-- 6. **DEFAULT**
--    Assigns default values when none are provided.
--    *Example: salary DECIMAL DEFAULT 30000*

-- **Benefits:**

-- * Prevent invalid entries.
-- * Avoid duplicates and inconsistencies.
-- * Enforce business rules at the database level.
-- * Reduce the need for complex application-level validations.

-- Constraints act as a **guardrail** that ensures only valid, logical, and consistent data enters the database.

-- Q3. Why would you apply the NOT NULL constraint to a column? Can a primary key contain NULL values? Justify your answer.

-- The *NOT NULL* constraint is used when a column **must always contain a value**. It is applied to ensure **completeness of data**. For example, in an **employees** table, the **emp_name** should not be null because every employee must have a name.

-- **Reasons to use *NOT NULL*:**

-- * Enforces mandatory data.
-- * Prevents partial or undefined entries.
-- * Improves data quality and usability.

-- **Can a primary key contain NULL values ?**

-- **No**, a primary key **cannot contain NULL values**. This is because:

-- * A primary key must uniquely identify every record.
-- * NULL signifies an unknown or undefined value, which contradicts uniqueness.
-- * Allowing NULL in a primary key would permit multiple rows to have the same NULL, violating uniqueness.

-- **Justification:**
-- The SQL standard enforces that a primary key must be both **unique** and **not null**. This ensures that each row can be reliably accessed and referenced.

-- Q4. Explain the steps and SQL commands used to add or remove constraints on an existing table. Provide an example for both adding and removing a constraint.

-- **Modifying constraints** on an existing table involves *ALTER TABLE* statements. Depending on the DBMS, some constraints can be added or removed easily; others may require workarounds.

-- **Adding a constraint:**

-- To add a *CHECK* constraint:

-- ALTER TABLE employees
-- ADD CONSTRAINT chk_age CHECK (age >= 18);

-- To add a *UNIQUE* constraint:

-- ALTER TABLE employees
-- ADD CONSTRAINT uniq_email UNIQUE (email);

-- **Removing a constraint:**

-- To remove a constraint (e.g., *chk_age*):

-- ALTER TABLE employees
-- DROP CONSTRAINT chk_age;

-- > In MySQL, it might require using the *DROP INDEX* or modifying table structure, as constraint names may be system-generated.

-- **Note:** Some constraints like *NOT NULL* are altered like this:

-- ALTER TABLE employees
-- MODIFY emp_name TEXT NULL;

-- **Important steps:**

-- 1. Identify the constraint name (often shown in system tables).
-- 2. Use *ALTER TABLE* with *ADD* or *DROP*.
-- 3. For certain constraints (like *PRIMARY KEY*), you must first drop dependent foreign keys.

-- Proper handling of constraints allows schema evolution while maintaining data integrity.

-- Q5. Explain the consequences of attempting to insert, update, or delete data in a way that violates constraints. Provide an example of an error message that might occur when violating a constraint.

-- When operations (INSERT, UPDATE, DELETE) violate **constraints**, the DBMS **throws an error** and **rejects the operation**. This safeguards the database from inconsistent or invalid data.

-- **Common consequences:**

-- 1. **INSERT violating NOT NULL**

-- INSERT INTO employees (emp_id, emp_name) VALUES (101, NULL);

-- **Error:** *ERROR: null value in column "emp_name" violates not-null constraint*

-- 2. **INSERT violating UNIQUE**

-- INSERT INTO employees (email) VALUES ('john@example.com');  -- Already exists

-- **Error:** *ERROR: duplicate key value violates unique constraint "uniq_email"*

-- 3. **UPDATE violating CHECK**

-- UPDATE employees SET age = 15 WHERE emp_id = 101;

-- **Error:** *ERROR: new row for relation "employees" violates check constraint "chk_age"*

-- 4. **DELETE violating FOREIGN KEY**

-- DELETE FROM departments WHERE dept_id = 2; -- Referenced by employees

-- **Error:** *ERROR: update or delete on table "departments" violates foreign key constraint*

-- **Impact:**

-- * Operation is aborted.
-- * Transaction may be rolled back.
-- * Prevents propagation of invalid data.

-- Constraints are like **contracts**: violating them invalidates the action. They ensure that only valid, meaningful data resides in the database.

-- Q6. You created a products table without constraints as follows:

    CREATE TABLE products (
      product_id INT,
      product_name VARCHAR(50),
      price DECIMAL(10, 2));

-- Now, you realise that:
-- * The product_id should be a primary key.
-- * The price should have a default value of 50.00

-- Step 1: Add PRIMARY KEY constraint to product_id
ALTER TABLE products
ADD PRIMARY KEY (product_id);

-- Step 2: Add DEFAULT value to price column
ALTER TABLE products
MODIFY COLUMN price DECIMAL(10,2) DEFAULT 50.00;

-- Q7. You have two tables:
--   - Students:

-- | students_id | students_name | class_id |
-- | ----------- | ------------- | -------- |
-- | 1           | Alice         | 101      |
-- |             |               |          |
-- | 2           | Bob           | 102      |
-- |             |               |          |
-- | 3           | Charlie       | 101      |


--   - Classes:

-- | class_id    | class_name    |
-- | ----------- | ------------- |
-- | 101         | Math          |
-- |             |               |
-- | 102         | Science       |
-- |             |               |
-- | 103         | History       |

-- Write a query to fetch the student_name and class_name for each student using an INNER JOIN.

-- Drop tables if they already exist
DROP TABLE IF EXISTS students;
DROP TABLE IF EXISTS classes;

-- Create the classes table
CREATE TABLE classes (
    class_id INT PRIMARY KEY,
    class_name VARCHAR(50)
);

-- Create the students table
CREATE TABLE students (
    student_id INT PRIMARY KEY,
    student_name VARCHAR(50),
    class_id INT,
    FOREIGN KEY (class_id) REFERENCES classes(class_id)
);

-- Insert data into classes
INSERT INTO classes (class_id, class_name) VALUES
(101, 'Math'),
(102, 'Science'),
(103, 'History');

-- Insert data into students
INSERT INTO students (student_id, student_name, class_id) VALUES
(1, 'Alice', 101),
(2, 'Bob', 102),
(3, 'Charlie', 101);

-- INNER JOIN: Fetch student_name and class_name
SELECT s.student_name, c.class_name
FROM students s
INNER JOIN classes c ON s.class_id = c.class_id;

-- Q8. Consider the following three tables:
--   - Orders:

-- | order_id | order_date    | customer_id |
-- | -------- | ------------- | ----------- |
-- | 1        | 2024-01-01    | 101         |
-- |          |               |             |
-- | 2        | 2024-01-01    | 102         |

--   - Customers:

-- | customer_id | customer_name |
-- | ----------- | ------------- |
-- | 1           | Alice         |
-- |             |               |
-- | 2           | Bob           |

--   - Products:

-- | product_id | product_name    | order_id |
-- | ---------- | --------------- | -------- |
-- | 1          | Laptop          | 1        |
-- |            |                 |          |
-- | 2          | Phone           | NULL     |

-- Write a query that shows all order_id, customer_name, and product_name, ensuring that all products are listed even if they are not associated with an order
-- Hint: (use INNER JOIN and LEFT JOIN).

-- Drop tables if they already exist
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS customers;

-- Create customers table
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(50)
);

-- Create orders table
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    order_date DATE,
    customer_id INT,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- Create products table
CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(50),
    order_id INT,
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

-- Insert data into customers
INSERT INTO customers (customer_id, customer_name) VALUES
(1, 'Alice'),
(2, 'Bob');

-- Insert data into orders
INSERT INTO orders (order_id, order_date, customer_id) VALUES
(1, '2024-01-01', 1),
(2, '2024-01-01', 2);

-- Insert data into products
INSERT INTO products (product_id, product_name, order_id) VALUES
(1, 'Laptop', 1),
(2, 'Phone', NULL);

-- Query: Get all products, including those not associated with any order
SELECT 
    p.order_id,
    c.customer_name,
    p.product_name
FROM products p
LEFT JOIN orders o ON p.order_id = o.order_id
LEFT JOIN customers c ON o.customer_id = c.customer_id;

-- Q9. Given the following tables:
--   - Sales:

-- | sale_id | product_id    | amount |
-- | ------- | ------------- | ------ |
-- | 1       | 101           | 500    |
-- |         |               |        |
-- | 2       | 102           | 30     |
-- |         |               |        |
-- | 3       | 101           | 700    |

--   - Products:

-- | product_id | product_name    |
-- | ---------- | --------------- |
-- | 1          | Laptop          |
-- |            |                 |
-- | 2          | Phone           |

-- Write a query to find the total sales amount for each product using an INNER JOIN and the SUM() function.

-- Drop tables if they already exist
DROP TABLE IF EXISTS sales;
DROP TABLE IF EXISTS products;

-- Create products table
CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(50)
);

-- Create sales table
CREATE TABLE sales (
    sale_id INT PRIMARY KEY,
    product_id INT,
    amount DECIMAL(10,2),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- Insert data into products
INSERT INTO products (product_id, product_name) VALUES
(101, 'Laptop'),
(102, 'Phone');

-- Insert data into sales
INSERT INTO sales (sale_id, product_id, amount) VALUES
(1, 101, 500),
(2, 102, 30),
(3, 101, 700);

-- Query: Total sales amount for each product
SELECT 
    p.product_name,
    SUM(s.amount) AS total_sales
FROM sales s
INNER JOIN products p ON s.product_id = p.product_id
GROUP BY p.product_name;

-- Q10. You are given three tables:
--   - Orders:

-- | order_id | order_date    | customer_id |
-- | -------- | ------------- | ----------- |
-- | 1        | 2024-01-02    | 1           |
-- |          |               |             |
-- | 2        | 2024-01-05    | 2           |

--   - Customers:

-- | customer_id | customer_name |
-- | ----------- | ------------- |
-- | 1           | Alice         |
-- |             |               |
-- | 2           | Bob           |

--   - Order_Details:

-- | order_id   | product_id      | quantity |
-- | ---------- | --------------- | -------- |
-- | 1          | 101             | 2        |
-- |            |                 |          |
-- | 1          | 102             | 1        |
-- |            |                 |          |
-- | 2          | 101             | 3        |

-- Write a query to display the order_id, customer_name, and the quantity of products ordered by each customer using an INNER JOIN between all three tables.

-- Drop tables if they already exist
DROP TABLE IF EXISTS order_details;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS customers;

-- Create customers table
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(50)
);

-- Create orders table
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    order_date DATE,
    customer_id INT,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- Create order_details table
CREATE TABLE order_details (
    order_id INT,
    product_id INT,
    quantity INT,
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

-- Insert data into customers
INSERT INTO customers (customer_id, customer_name) VALUES
(1, 'Alice'),
(2, 'Bob');

-- Insert data into orders
INSERT INTO orders (order_id, order_date, customer_id) VALUES
(1, '2024-01-02', 1),
(2, '2024-01-05', 2);

-- Insert data into order_details
INSERT INTO order_details (order_id, product_id, quantity) VALUES
(1, 101, 2),
(1, 102, 1),
(2, 101, 3);

-- Query: Get order_id, customer_name, and quantity using INNER JOINs
SELECT 
    o.order_id,
    c.customer_name,
    od.quantity
FROM order_details od
INNER JOIN orders o ON od.order_id = o.order_id
INNER JOIN customers c ON o.customer_id = c.customer_id;

-- SQL Commands

-- Q1: Identify the primary keys and foreign keys in maven movies db. Discuss the differences

-- Primary Key (PK):
--   - A primary key uniquely identifies each record in a table.
--   - It must contain unique, non-null values.
--   - Example tables with primary keys in Maven Movies:
--       - actor.actor_id
--       - customer.customer_id
--       - film.film_id
--       - rental.rental_id

-- Foreign Key (FK):
--   - A foreign key creates a relationship between two tables.
--   - It points to a primary key in another table.
--   - Foreign keys can have duplicate values and can sometimes be null (if optional).
--   - Example tables with foreign keys in Maven Movies:
--       - rental.customer_id → customer.customer_id
--       - rental.inventory_id → inventory.inventory_id
--       - inventory.film_id → film.film_id
--       - payment.customer_id → customer.customer_id
--       - film.language_id → language.language_id

-- Key Differences:
--   - A primary key ensures **uniqueness** and **non-null values** within its own table.
--   - A foreign key enforces **referential integrity** by linking to a primary key in another table.
--   - There is **one primary key** per table (can be composite), but **multiple foreign keys** allowed.

-- Q2: List all details of actors

SELECT * FROM actor;

-- Q3: List all customer information from the database

SELECT * FROM customer;

-- Q4: List different countries

SELECT DISTINCT country FROM country;

-- Q5: Display all active customers

SELECT * FROM customer
WHERE active = 1;

-- Q6: List of all rental IDs for customer with ID 1

SELECT rental_id FROM rental
WHERE customer_id = 1;

-- Q7: Display all the films whose rental duration is greater than 5

SELECT * FROM film
WHERE rental_duration > 5;

-- Q8: List the total number of films whose replacement cost is greater than $15 and less than $20

SELECT COUNT(*) AS total_films
FROM film
WHERE replacement_cost > 15 AND replacement_cost < 20;

-- Q9: Display the count of unique first names of actors

SELECT COUNT(DISTINCT first_name) AS unique_first_names
FROM actor;

-- Q10: Display the first 10 records from the customer table

SELECT * FROM customer
LIMIT 10;

-- Q11: Display the first 3 records from the customer table whose first name starts with ‘b’

SELECT * FROM customer
WHERE first_name LIKE 'B%'
LIMIT 3;

-- Q12: Display the names of the first 5 movies which are rated as ‘G’

SELECT title FROM film
WHERE rating = 'G'
LIMIT 5;

-- Q13: Find all customers whose first name starts with "a"

SELECT * FROM customer
WHERE first_name LIKE 'A%';

-- Q14: Find all customers whose first name ends with "a"

SELECT * FROM customer
WHERE first_name LIKE '%a';

-- Q15: Display the list of first 4 cities which start and end with ‘a’

SELECT city FROM city
WHERE city LIKE 'A%a'
LIMIT 4;

-- Q16: Find all customers whose first name has "NI" in any position

SELECT * FROM customer
WHERE first_name LIKE '%NI%';

-- Q17: Find all customers whose first name has "r" in the second position

SELECT * FROM customer
WHERE first_name LIKE '_r%';

-- Q18: Find all customers whose first name starts with "a" and are at least 5 characters in length

SELECT * FROM customer
WHERE first_name LIKE 'A%' AND LENGTH(first_name) >= 5;

-- Q19: Find all customers whose first name starts with "a" and ends with "o"

SELECT * FROM customer
WHERE first_name LIKE 'A%o';

-- Q20: Get the films with PG and PG-13 rating using IN operator

SELECT * FROM film
WHERE rating IN ('PG', 'PG-13');

-- Q21: Get the films with length between 50 to 100 using BETWEEN operator

SELECT * FROM film
WHERE length BETWEEN 50 AND 100;

-- Q22: Get the top 50 actors using LIMIT operator

SELECT * FROM actor
LIMIT 50;

-- Q23: Get the distinct film IDs from inventory table

SELECT DISTINCT film_id FROM inventory;

-- Functions

-- Basic Aggregate Functions:

-- Q1: Retrieve the total number of rentals made in the Sakila database.
-- Hint: Use the COUNT() function.

SELECT COUNT(*) AS total_rentals
FROM rental;

-- Q2: Find the average rental duration (in days) of movies rented from the Sakila database.
-- Hint: Utilize the AVG() function.

SELECT AVG(rental_duration) AS average_rental_duration
FROM film;

-- Q3: Display the first name and last name of customers in uppercase.
-- Hint: Use the UPPER () function.

SELECT UPPER(first_name) AS first_name_upper, UPPER(last_name) AS last_name_upper
FROM customer;

-- Q4: Extract the month from the rental date and display it alongside the rental ID.
-- Hint: Employ the MONTH() function.

SELECT rental_id, MONTH(rental_date) AS rental_month
FROM rental;

-- Q5: Retrieve the count of rentals for each customer (display customer ID and the count of rentals).
-- Hint: Use COUNT () in conjunction with GROUP BY.

SELECT customer_id, COUNT(*) AS rental_count
FROM rental
GROUP BY customer_id;

-- Q6: Find the total revenue generated by each store.
-- Hint: Combine SUM() and GROUP BY.

SELECT c.store_id, SUM(p.amount) AS total_revenue
FROM payment p
JOIN customer c ON p.customer_id = c.customer_id
GROUP BY c.store_id;

-- Q7: Determine the total number of rentals for each category of movies.
-- Hint: JOIN film_category, film, and rental tables, then use cOUNT () and GROUP BY.

SELECT c.name AS category_name, COUNT(r.rental_id) AS total_rentals
FROM category c
JOIN film_category fc ON c.category_id = fc.category_id
JOIN inventory i ON fc.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY c.name;

-- Q8: Find the average rental rate of movies in each language.
-- Hint: JOIN film and language tables, then use AVG () and GROUP BY.

SELECT l.name AS language_name, AVG(f.rental_rate) AS average_rental_rate
FROM film f
JOIN language l ON f.language_id = l.language_id
GROUP BY l.name;

-- Joins

-- Q9: Display the title of the movie, customer's first name, and last name who rented it.
-- Hint: Use JOIN between the film, inventory, rental, and customer tables.

SELECT f.title, c.first_name, c.last_name
FROM rental r
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
JOIN customer c ON r.customer_id = c.customer_id;

-- Q10: Retrieve the names of all actors who have appeared in the film "Gone with the Wind".
-- Hint: Use JOIN between the film actor, film, and actor tables.

SELECT a.first_name, a.last_name
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
JOIN film f ON fa.film_id = f.film_id
WHERE f.title = 'Gone with the Wind';

-- Q11: Retrieve the customer names along with the total amount they've spent on rentals.
-- Hint: JOIN customer, payment, and rental tables, then use SUM() and GROUP BY.

SELECT c.first_name, c.last_name, SUM(p.amount) AS total_spent
FROM customer c
JOIN payment p ON c.customer_id = p.customer_id
GROUP BY c.customer_id;

-- Q12: List the titles of movies rented by each customer in a particular city (e.g., 'London').
-- Hint: JOIN customer, address, city, rental, inventory, and film tables, then use GROUP BY.

SELECT c.first_name, c.last_name, ci.city, f.title
FROM customer c
JOIN address a ON c.address_id = a.address_id
JOIN city ci ON a.city_id = ci.city_id
JOIN rental r ON c.customer_id = r.customer_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
WHERE ci.city = 'London'
GROUP BY c.customer_id, f.film_id;

-- Advanced Joins and GROUP BY:

-- Q13: Display the top 5 rented movies along with the number of times they've been rented.
-- Hint: JOIN film, inventory, and rental tables, then use COUNT () and GROUP BY, and limit the results.

SELECT f.title, COUNT(r.rental_id) AS rental_count
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY f.film_id
ORDER BY rental_count DESC
LIMIT 5;

-- Q14: Determine the customers who have rented movies from both stores (store_id 1 and 2).
-- Hint: Use JOINS with rental, inventory, and customer tables and consider COUNT() and GROUP BY.

SELECT customer_id
FROM rental r
JOIN inventory i ON r.inventory_id = i.inventory_id
GROUP BY customer_id
HAVING COUNT(DISTINCT i.store_id) = 2;

-- Windows Function

-- Q1: Rank the customers based on the total amount they've spent on rentals.

SELECT customer_id, first_name, last_name,
       SUM(amount) AS total_spent,
       RANK() OVER (ORDER BY SUM(amount) DESC) AS spending_rank
FROM customer
JOIN payment USING (customer_id)
GROUP BY customer_id;

-- Q2: Calculate the cumulative revenue generated by each film over time.

SELECT f.title, p.payment_date, SUM(p.amount) OVER (PARTITION BY f.film_id ORDER BY p.payment_date) AS cumulative_revenue
FROM payment p
JOIN rental r ON p.rental_id = r.rental_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id;

-- Q3: Determine the average rental duration for each film, considering films with similar lengths.

SELECT film_id, title, length,
       AVG(rental_duration) OVER (PARTITION BY length) AS avg_duration_for_length
FROM film;

-- Q4: Identify the top 3 films in each category based on their rental counts.

WITH ranked_films AS (
    SELECT 
        c.name AS category_name, 
        f.title, 
        COUNT(r.rental_id) AS rental_count,
        RANK() OVER (PARTITION BY c.name ORDER BY COUNT(r.rental_id) DESC) AS rank_in_category
    FROM category c
    JOIN film_category fc ON c.category_id = fc.category_id
    JOIN film f ON fc.film_id = f.film_id
    JOIN inventory i ON f.film_id = i.film_id
    JOIN rental r ON i.inventory_id = r.inventory_id
    GROUP BY c.name, f.title
)
SELECT *
FROM ranked_films
WHERE rank_in_category <= 3;

-- Q5: Calculate the difference in rental counts between each customer's total rentals and the average rentals across all customers.

WITH customer_rentals AS (
    SELECT customer_id, COUNT(*) AS total_rentals
    FROM rental
    GROUP BY customer_id
)
SELECT customer_id, total_rentals,
       total_rentals - AVG(total_rentals) OVER () AS difference_from_avg
FROM customer_rentals;

-- Q6: Find the monthly revenue trend for the entire rental store over time.

WITH monthly_revenue AS (
    SELECT 
        DATE_FORMAT(payment_date, '%Y-%m') AS month,
        SUM(amount) AS monthly_revenue
    FROM payment
    GROUP BY month
)
SELECT 
    month,
    monthly_revenue,
    SUM(monthly_revenue) OVER (ORDER BY month) AS cumulative_revenue
FROM monthly_revenue
ORDER BY month;

-- Q7: Identify the customers whose total spending on rentals falls within the top 20% of all customers.

WITH customer_totals AS (
    SELECT customer_id, SUM(amount) AS total_spent
    FROM payment
    GROUP BY customer_id
)
SELECT customer_id, total_spent
FROM (
    SELECT customer_id, total_spent,
           CUME_DIST() OVER (ORDER BY total_spent DESC) AS percentile
    FROM customer_totals
) ranked
WHERE percentile <= 0.2;

-- Q8: Calculate the running total of rentals per category, ordered by rental count.

WITH category_rentals AS (
    SELECT c.name AS category_name, COUNT(r.rental_id) AS rental_count
    FROM category c
    JOIN film_category fc ON c.category_id = fc.category_id
    JOIN inventory i ON fc.film_id = i.film_id
    JOIN rental r ON i.inventory_id = r.inventory_id
    GROUP BY c.name
)
SELECT category_name, rental_count,
       SUM(rental_count) OVER (ORDER BY rental_count DESC) AS running_total
FROM category_rentals;

-- Q9: Find the films that have been rented less than the average rental count for their respective categories.

WITH film_rentals AS (
    SELECT c.name AS category_name, f.title, COUNT(r.rental_id) AS rental_count
    FROM category c
    JOIN film_category fc ON c.category_id = fc.category_id
    JOIN film f ON fc.film_id = f.film_id
    JOIN inventory i ON f.film_id = i.film_id
    JOIN rental r ON i.inventory_id = r.inventory_id
    GROUP BY c.name, f.title
)
SELECT * FROM (
    SELECT *, 
           AVG(rental_count) OVER (PARTITION BY category_name) AS avg_in_category
    FROM film_rentals
) AS stats
WHERE rental_count < avg_in_category;

-- Q10: Identify the top 5 months with the highest revenue and display the revenue generated in each month.

SELECT month, monthly_revenue
FROM (
    SELECT DATE_FORMAT(payment_date, '%Y-%m') AS month,
           SUM(amount) AS monthly_revenue,
           RANK() OVER (ORDER BY SUM(amount) DESC) AS revenue_rank
    FROM payment
    GROUP BY month
) AS ranked_months
WHERE revenue_rank <= 5;

-- Normalisation and CTE

-- Q1. First Normal Form (1NF):
--  a: Identify a table in the Sakila database that violates 1NF. Explain how you would normalize it to achieve 1NF.

-- Table: Hypothetical modification of the 'address' table.
-- Issue: If 'address' stored multiple phone numbers in a single column (e.g., '123-4567, 789-0000'), it would violate 1NF.
-- 1NF Violation: Repeating values in a single column.
-- Solution: Create a separate table 'customer_phone' with columns (customer_id, phone_number), one phone number per row.

-- Q2. Second Normal Form (2NF):
--  a. Choose a table in Sakila and describe how you would determine whether it is in 2NF. If it violates 2NF, explain the steps to normalize it.

-- Table: Suppose we create a denormalized table 'rental_details' with columns (rental_id, film_id, title, customer_id, customer_name).
-- Issue: Composite key = (rental_id, film_id), but customer_name depends only on rental_id.
-- 2NF Violation: Partial dependency — customer_name depends only on part of the composite key.
-- Solution: Move customer_name and customer_id into a separate 'customer' table and link by customer_id.

-- Q3. Third Normal Form (3NF):
--  a. Identify a table in Sakila that violates 3NF. Describe the transitive dependencies present and outline the steps to normalize the table to 3NF.

-- Table: Suppose a denormalized version of 'address' includes (address_id, city_name, postal_code, country_name).
-- Issue: postal_code depends on city_name, which depends on address_id.
-- 3NF Violation: Transitive dependency — postal_code depends on city_name, not the primary key.
-- Solution: Split city and postal_code into a separate 'city' table, already done in Sakila with city_id and country_id keys.

-- Q4. Normalization Process:
--  a. Take a specific table in Sakila and guide through the process of normalizing it from the initial unnormalized form up to at least 2NF.

-- Table: Imagine a flat 'customer_orders' table with (customer_name, address, email, rental_id, film_title).
-- Step 1 (1NF): Ensure atomic values — split film_titles into separate rows if multiple films per rental.
-- Step 2 (2NF): Eliminate partial dependencies — move customer info into 'customer' and 'address' tables.
-- Normalized: Sakila already separates these into 'customer', 'address', 'rental', and 'film' tables.

-- Q5. CTE Basics:
--  a. Write a query using a CTE to retrieve the distinct list of actor names and the number of films they have acted in from the actor and film_actor tables.

WITH actor_film_count AS (
    SELECT a.actor_id, a.first_name, a.last_name, COUNT(fa.film_id) AS film_count
    FROM actor a
    JOIN film_actor fa ON a.actor_id = fa.actor_id
    GROUP BY a.actor_id
)
SELECT * FROM actor_film_count;

-- Q6. CTE with Joins:
--  a. Create a CTE that combines information from the film and language tables to display the film title, language name, and rental rate.

WITH film_language AS (
    SELECT f.title, l.name AS language_name, f.rental_rate
    FROM film f
    JOIN language l ON f.language_id = l.language_id
)
SELECT * FROM film_language;

-- Q7. CTE for Aggregation:
--  a. Write a query using a CTE to find the total revenue generated by each customer (sum of payments) from the customer and payment tables.

WITH customer_revenue AS (
    SELECT c.customer_id, c.first_name, c.last_name, SUM(p.amount) AS total_spent
    FROM customer c
    JOIN payment p ON c.customer_id = p.customer_id
    GROUP BY c.customer_id
)
SELECT * FROM customer_revenue;

-- Q8. CTE with Window Functions:
--  a. Utilize a CTE with a window function to rank films based on their rental duration from the film table.

WITH film_ranks AS (
    SELECT film_id, title, rental_duration,
           RANK() OVER (ORDER BY rental_duration DESC) AS duration_rank
    FROM film
)
SELECT * FROM film_ranks;

-- Q9. CTE and Filtering:
--  a. Create a CTE to list customers who have made more than two rentals, and then join this CTE with the customer table to retrieve additional customer details.

WITH frequent_customers AS (
    SELECT customer_id, COUNT(*) AS rental_count
    FROM rental
    GROUP BY customer_id
    HAVING COUNT(*) > 2
)
SELECT c.customer_id, c.first_name, c.last_name, fc.rental_count
FROM customer c
JOIN frequent_customers fc ON c.customer_id = fc.customer_id;

-- Q10. CTE for Date Calculations:
--  a. Write a query using a CTE to find the total number of rentals made each month, considering the rental_date from the rental table

WITH monthly_rentals AS (
    SELECT DATE_FORMAT(rental_date, '%Y-%m') AS rental_month, COUNT(*) AS total_rentals
    FROM rental
    GROUP BY rental_month
)
SELECT * FROM monthly_rentals
ORDER BY rental_month;

-- Q11. CTE and Self-Join:
--  a. Create a CTE to generate a report showing pairs of actors who have appeared in the same film together, using the film_actor table.

WITH actor_pairs AS (
    SELECT fa1.film_id, fa1.actor_id AS actor1, fa2.actor_id AS actor2
    FROM film_actor fa1
    JOIN film_actor fa2 ON fa1.film_id = fa2.film_id AND fa1.actor_id < fa2.actor_id
)
SELECT a1.first_name AS actor1_first, a1.last_name AS actor1_last,
       a2.first_name AS actor2_first, a2.last_name AS actor2_last,
       ap.film_id
FROM actor_pairs ap
JOIN actor a1 ON ap.actor1 = a1.actor_id
JOIN actor a2 ON ap.actor2 = a2.actor_id;

-- Q12. CTE for Recursive Search:
--  a. Implement a recursive CTE to find all employees in the staff table who report to a specific manager, considering the reports_to column

-- Create a custom staff_hierarchy table with manager relationships
DROP TABLE IF EXISTS staff_hierarchy;

CREATE TABLE staff_hierarchy (
    staff_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    reports_to INT
);

-- Insert sample data
INSERT INTO staff_hierarchy VALUES
(1, 'Alice', 'Smith', NULL),    -- Top manager
(2, 'Bob', 'Jones', 1),
(3, 'Charlie', 'Brown', 2),
(4, 'David', 'White', 1),
(5, 'Eva', 'Green', 4);

-- Recursive CTE to find all staff under Alice (staff_id = 1)
WITH RECURSIVE hierarchy AS (
    SELECT staff_id, first_name, last_name, reports_to
    FROM staff_hierarchy
    WHERE reports_to IS NULL

    UNION ALL

    SELECT s.staff_id, s.first_name, s.last_name, s.reports_to
    FROM staff_hierarchy s
    JOIN hierarchy h ON s.reports_to = h.staff_id
)
SELECT * FROM hierarchy;