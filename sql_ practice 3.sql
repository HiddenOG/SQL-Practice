USE OGBASE;
DROP TABLE Employees;
CREATE TABLE Employees(
	employees_id INT,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    hourly_pay DECIMAL(5,2),
    hire_date DATE
);

SELECT * FROM Employees;
RENAME TABLE Employees TO workers;
RENAME TABLE workers TO Employees;

ALTER TABLE Employees
ADD phone_number VARCHAR(40);

ALTER TABLE Employees
RENAME COLUMN phone_number TO email; 

ALTER TABLE Employees
MODIFY COLUMN email VARCHAR(100);-- cahnge the email size VARCHAR

-- Move Columns around (lets move our email column so its after our last name column
ALTER TABLE employees
MODIFY email VARCHAR(100)
AFTER last_name;

-- if you modify a column and need it to be first you just say
ALTER TABLE employees
MODIFY email VARCHAR(100)
FIRST;

-- TO drop column
ALTER TABLE employees
DROP COLUMN email;

SELECT * FROM Employees; -- lets insert rows into table at once.
INSERT INTO employees
VALUES (1,'Eugene','Krabs', 25.30, '2023-01-02'),
        (2, 'Squidward', 'Tentacles', 15.00, '2023-01-03'),
        (3, 'Spongebob', 'Squarepants', 12.50, '2023-01-04'),
        (4,'Patrick', 'Star', 12.50,'2023-01-05'),
        (5, 'Sandy', 'Cheeks', 17.25, '2023-01-06');

SET SQL_SAFE_UPDATES=0;
DELETE FROM Employees;

-- insert data into a row by omitting certain columns
INSERT INTO employees(employees_id, first_name, last_name) VALUES (6,'Sheldon','Plankton');

SELECT * FROM Employees;
-- select the full name of all th employees
SELECT last_name, first_name
FROM Employees;

SELECT * FROM Employees
WHERE employees_id = 1;

-- find all the data from employees where the first name = 'spomgebob'
SELECT * FROM Employees
WHERE first_name = 'spongebob';

-- select where hourly pay greater than 15
SELECT * FROM Employees
WHERE hourly_pay >= 15;

SELECT * FROM Employees
WHERE hire_date <= '2023-01-03';

-- where employee_id does not equal 1
SELECT * FROM Employees 
WHERE employees_id != 1;

-- where emplpoyees do not have a hire_date.
SELECT * FROM Employees
WHERE hire_date IS NULL;

SELECT * FROM Employees
WHERE hire_date IS NOT NULL;

SELECT first_name FROM Employees
WHERE hire_date IS NOT NULL;

-- UPDATE DATA IN TABLE
UPDATE Employees 
SET hourly_pay = 10.25,
    hire_date = '2023-01-07'
WHERE employees_id = 6;
SELECT * FROM Employees;

UPDATE Employees 
SET hourly_pay = NULL
WHERE employees_id = 6;

-- set all employees hourly pay = 10.25
UPDATE Employees 
SET hourly_pay = 10.25;

-- To delete a row from a table
DELETE FROM Employees
WHERE employees_id = 6;

-- AUTOCOMMIT, COMMIT, ROLLBACK
-- AUTOCOMMIT is a mode, by default it is set ton ON, any tansaction done in MSQL is saved
-- what if we want to undo that transaction for example what if we accidentally delete all
-- the rows in the table

SET AUTOCOMMIT = OFF;
COMMIT;
SELECT * FROM Employees;
DELETE FROM Employees; -- to undo these changes i can execute the ROLLBACK statement.
 
ROLLBACK;
SELECT * FROM Employees; -- our table is back to what it previously was

SELECT * FROM Employees;
DELETE FROM Employees; -- if i want to save this change i will COMMIT
COMMIT;

-- CURRENT_DATE() & CURRENT_TIME()
CREATE TABLE test(
	my_date DATE,
    my_time TIME,
    my_datetime DATETIME
    );
    
SELECT * FROM test;
-- so how do we get the current_date, maybe we need to create a timestamp of when some event happened
-- maybe a hire_date for our employees
INSERT INTO test
VALUES(CURRENT_DATE(), CURRENT_TIME(), NOW());-- for the datetime you could just say NOW
-- datetime would probably be needed for some tranaction you need to record
SELECT * FROM test;

INSERT INTO test
VALUES(CURRENT_DATE() + 1, NULL, NULL);-- if you add plus one to CURRET_DATE, this satement would
-- refer to tomorrow, if you take your CURRENT_DATE - 1, That would refer to yesterday

DROP TABLE test; 

-- UNIQUE CONSTRAINT
CREATE TABLE products (
    product_id INT,
    product_name VARCHAR(25) UNIQUE, -- with this we cant insert any product names that are thesam, tehy have to be unique
    price DECIMAL(4, 2)
);
-- lets say you forget the UNIQUE keyword when you create the table
ALTER TABLE products
ADD CONSTRAINT UNIQUE(product_name);

SELECT * FROM products;
INSERT INTO products
VALUES (100, 'Hamburger', 3.99),
	   (101, 'Fries', 1.89),
       (102, 'Soda', 1.00 ),
       (103, 'ice cream', 1.49),
       (104, 'Fries', 1.75);-- since we added the UNIQUE CONSTRAINT all values in this product_name
                            -- must be different
INSERT INTO products
VALUES (100, 'Hamburger', 3.99),
	   (101, 'Fries', 1.89),
       (102, 'Soda', 1.00 ),
       (103, 'ice cream', 1.49);
       
-- NOT NULL CONSTRAINT
CREATE TABLE products (
    product_id INT,
    product_name VARCHAR(25), 
    price DECIMAL(4, 2) NOT NULL
);
-- Add the NOT NULL to a table that already exists
ALTER TABLE products
MODIFY price DECIMAL(4, 2) NOT NULL;
-- a little bit diffrent syntax from the UNIQUE CONSTRAINT

INSERT INTO products
VALUES (104, 'cookie', NULL); -- We could set the price to be 0. but not NULL

-- CHECK CONSTRAINT
-- a situation where employees hourly_pay should not be less than minimum wage which is '10'
CREATE TABLE Employees(
	employees_id INT,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    hourly_pay DECIMAL(5,2),
    hire_date DATE,
    CONSTRAINT chk_hour_pay CHECK(hourly_pay >= 10.00) -- 'chk_hour_pay' is the name of the constarint 
);
-- to add a CHECK CONSTRAINT to a table that already exists
ALTER TABLE Employees
ADD CONSTRAINT chk_hour_pay CHECK(hourly_pay >= 10.00);

INSERT INTO Employees
VALUES (6, 'Sheldon','Plankton', 10.00, '2023-01-07'); -- doesent work because of the CHECK CONSTRAINT

-- if you want to DELETE A CHECK
ALTER TABLE Employees
DROP CHECK chk_hour_pay;

-- DEFAULT CONSTRAINT, when inserting a new row if we do not specify a value for a column
-- by default we could add some value that we set
SELECT * FROM products;
INSERT INTO products
VALUES (104, 'straw', 0.00),
       (105, 'napkin', 0.00),
       (106, 'fork', 0.0),
       (107, 'spoon', 0.00);
DELETE FROM products WHERE 
product_id >= 104;

CREATE TABLE products (
    product_id INT,
    product_name VARCHAR(25), 
    price DECIMAL(4, 2) DEFAULT 0
);
-- For table already created
ALTER TABLE products
ALTER price SET DEFAULT 0;
INSERT INTO products (product_id, product_name)
VALUES (104, 'straw'),
       (105, 'napkin'),
       (106, 'fork'),
       (107, 'spoon'); -- the value of price was not specified so default was used
SELECT * FROM products;

CREATE TABLE transactions(
	transaction_id INT,
    amount DECIMAL (5, 2),
    transaction_date DATETIME DEFAULT NOW()
    );
INSERT INTO transactions (transaction_id, amount)
VALUES (1, 4.99);

SELECT * FROM transactions;
DROP TABLE transactions;    

-- PRIMARY KEYS -- each value in that column must both be unique and NOT NULL
-- you can only have one PRIMARY KEY per table
CREATE TABLE transactions(
	transaction_id INT PRIMARY KEY,
    amount DECIMAL (5, 2) -- max size of 5 digits and precision 2
    );
-- adding it to a table that already exists
ALTER TABLE transactions
ADD CONSTRAINT PRIMARY KEY(transaction_id);

INSERT INTO transactions 
VALUES (1000, 4.99),
	   (1001, 2.89),
       (1002, 3.38);
       
SELECT amount FROM transactions
WHERE transaction_id = 1000;

-- AUTO INCREMENT we could set our primary KEY to begin at a different value
ALTER TABLE transactions
AUTO_INCREMENT = 1000;

DELETE FROM transactions;
SELECT * FROM transactions;

INSERT INTO transactions(amount) VALUES (4.99);

-- FOREIGN KEY
CREATE TABLE customers (
	customer_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50),
    last_name VARCHAR(50)
);
INSERT INTO customers (first_name, last_name)
VALUES ('Fred', 'Fish'),
       ('Larry', 'Lobster'),
       ('Bubble', 'Bass');
DROP TABLE transactions;

CREATE TABLE transactions(
	transaction_id INT PRIMARY KEY AUTO_INCREMENT,
    amount DECIMAL (5, 2),
    customer_id INT,
    FOREIGN KEY(customer_id) REFERENCES customers(customer_id)
    );
-- to drop foriegn key
ALTER TABLE transactions
DROP FOREIGN KEY transactions_ibfk_1;

-- to apply a foreign Key to a table that already exists
ALTER TABLE transactions
ADD CONSTRAINT fk_customer_id -- you can name your foreign key(you dont necessary need to name the constraint)
FOREIGN KEY(customer_id) REFERENCES customers(customer_id);

DELETE FROM transactions;
ALTER TABLE transactions
AUTO_INCREMENT = 1000;

INSERT INTO transactions(amount, customer_id)
 VALUES (4.99, 3),
        (2.89, 2),
        (3.38, 3),
        (4.99, 1);
SELECT * FROM transactions;

-- JOINS
INSERT INTO transactions(amount, customer_id)
VALUES(1.00, NULL); -- not all rows have a transaction ID

INSERT INTO customers (first_name, last_name)
VALUES ('Poppy', 'Puff'); -- not all customers have ever initiated a transaction
SELECT * FROM customers;

SELECT *
FROM transactions INNER JOIN customers
ON transactions.customer_id = customers.customer_id;
-- select all row from these two table that have matching customer_ids
-- thats why some data is excluded.

SELECT transaction_id, amount, first_name, last_name
FROM transactions INNER JOIN customers
ON transactions.customer_id = customers.customer_id;

SELECT *
FROM transactions LEFT JOIN customers
ON transactions.customer_id = customers.customer_id;
-- We are displaying every value from table on the left

SELECT *
FROM transactions RIGHT JOIN customers
ON transactions.customer_id = customers.customer_id;
-- We are displaying every value from table on the right

-- FUNCTIONS
-- lets count how many transactions took place on a certain date
SELECT COUNT(amount) AS count -- you could give the column an alias even tho its not necessary
FROM transactions;

SELECT MAX(amount) AS maximum
FROM transactions;

SELECT MIN(amount) AS minimum
FROM transactions;

SELECT AVG(amount) AS average
FROM transactions;

SELECT SUM(amount) AS sum
FROM transactions;

-- We are going to concatenate the first and last name of our employees
SELECT * FROM Employees;
SELECT CONCAT(first_name," " ,last_name) AS full_name
FROM Employees;

-- Logical Operators 
-- lets add a jon column
ALTER TABLE Employees
ADD COLUMN job VARCHAR(50) AFTER hourly_pay;

-- lets add values to the job column
UPDATE Employees
SET job = 'manager'
WHERE employees_id = 1;

UPDATE Employees
SET job = 'cashier'
WHERE employees_id = 2;

UPDATE Employees
SET job = 'cook'
WHERE employees_id = 3;

UPDATE Employees
SET job = 'cook'
WHERE employees_id = 4;

UPDATE Employees
SET job = 'asst.manager'
WHERE employees_id = 5;

UPDATE Employees
SET job = 'janitor'
WHERE employees_id = 6;
INSERT INTO Employees
VALUES (6, 'Sheldon','Plankton', 10.00, 'janitor', '2023-01-07'); 

UPDATE Employees
SET hire_date = '2023-01-04'
WHERE employees_id = 3;

SELECT * FROM Employees;
-- lets find any cook that was hired before january 5th '2023-01-05'
SELECT * FROM Employees
WHERE hire_date < '2023-01-05' AND job = 'cook';-- both conditions must be true

SELECT * FROM Employees
WHERE job = 'cook' OR job = 'cashier'; -- one condition needs to be true
 
 -- any employees that are not a manager
 SELECT * FROM Employees
 WHERE NOT job = 'manager';
 
SELECT * FROM Employees
WHERE NOT job = 'manager' AND NOT job = 'asst.manager';

 SELECT * FROM Employees
 WHERE hire_date BETWEEN '2023-01-04' AND '2023-01-07';
 
 SELECT * FROM Employees
 WHERE job IN ('cook', 'cashier', 'janitor');
 
 -- WILD CARDS
 -- these chracters _ %
 -- are used to substitute one or more characters in a string
 SELECT * FROM Employees
 WHERE first_name LIKE 's%'; -- if we need to find a first_name that begins with the character s we add '%' character
-- it represents any number of random characters

 SELECT * FROM Employees
 WHERE hire_date LIKE '2023%';
 
SELECT * FROM Employees
WHERE last_name LIKE '%r'; -- last name that end with the character r.. notice how '%' position comes before r

 SELECT * FROM Employees
 WHERE first_name LIKE 'sp%';
 
SELECT * FROM Employees
WHERE job LIKE '_ook'; -- "_" allows mySQL to fill any blanks with the random character

 SELECT * FROM Employees
 WHERE hire_date LIKE '____-__-02';
 
 -- lets find any jobs where the second character is an 'a'
SELECT * FROM Employees
WHERE job LIKE '_a%';

-- ORDER BY 
SELECT * FROM Employees
ORDER BY last_name; -- by default they would be odered in ascending order

SELECT * FROM Employees
ORDER BY last_name DESC;

SELECT * FROM transactions
ORDER BY amount, customer_id; -- if we have thesame amount, order by another col(customer_id)
                              -- you can add ASC or DESC
                              
-- LIMIT clause is used to limit the number of records
-- useful if you are working with a lot of data
-- Can be used to display a large data on diff pages(pagnation)
SELECT * FROM customers
LIMIT 2;

SELECT * FROM customers
ORDER BY last_name DESC LIMIT 4;

SELECT * FROM customers
LIMIT 1, 2; -- the first number is the offset you omit, the second is the limit you can display

SELECT * FROM customers
LIMIT 2, 1;

-- UNION combines the results of two or more SELECT statements
SELECT * FROM Employees
UNION -- In order to join two SELECT statements together they need to have thesame number of columns
SELECT * FROM customers;

SELECT first_name, last_name FROM Employees
UNION -- this dosent allow duplicates 
SELECT first_name, last_name FROM customers;

SELECT first_name, last_name FROM Employees
UNION ALL -- this would include any duplicates if more than one value is found within each table
SELECT first_name, last_name FROM customers;

-- SELF JOIN
-- join another copy of a table to itself
-- used to compare rows of the same table
-- helps to display a heirachcy of data
ALTER TABLE customers
ADD referral_id INT;

UPDATE customers
SET referral_id = 1
WHERE customer_id = 2;

UPDATE customers
SET referral_id = 2
WHERE customer_id = 3;

UPDATE customers
SET referral_id = 2
WHERE customer_id = 4;

SELECT * 
FROM customers AS a -- it duplicates the customer table and 
INNER JOIN customers AS b -- to link these table by the customer_id and referral_id
ON a.referral_id = b.customer_id;

SELECT a.customer_id, a.first_name, a.last_name,
       b.first_name, b.last_name
FROM customers AS a
INNER JOIN customers AS b -- to link these table by the customer_id and referral_id
ON a.referral_id = b.customer_id;


SELECT a.customer_id, a.first_name, a.last_name,
       CONCAT(b.first_name,' ', b.last_name) AS 'referred_by'
FROM customers AS a
INNER JOIN customers AS b 
ON a.referral_id = b.customer_id;

SELECT a.customer_id, a.first_name, a.last_name,
       CONCAT(b.first_name,' ', b.last_name) AS 'referred_by'
FROM customers AS a
LEFT JOIN customers AS b -- This displays all of our customers on the left table
ON a.referral_id = b.customer_id;-- if one of these customer was referred by another customer, join those rows as well

-- Create a new column of supervisors for the employees
-- and display the names of the supevisors and employees

SELECT * FROM Employees;
ALTER TABLE Employees
ADD supervisor_id INT;

UPDATE Employees
SET supervisor_id = 5
WHERE employees_id = 2;

UPDATE Employees
SET supervisor_id = 5
WHERE employees_id = 3;

UPDATE Employees
SET supervisor_id = 5
WHERE employees_id = 4;

UPDATE Employees
SET supervisor_id = 5
WHERE employees_id = 6;

UPDATE Employees
SET supervisor_id = 1
WHERE employees_id = 5;

SELECT * FROM 
Employees AS a
INNER JOIN Employees as b
ON a.supervisor_id = b.employees_id;


SELECT a.first_name, a.last_name,
       CONCAT(b.first_name,' ', b.last_name) AS 'reports_to'
FROM Employees AS a
INNER JOIN Employees AS b 
ON a.supervisor_id = b.employees_id;

SELECT a.first_name, a.last_name,
       CONCAT(b.first_name,' ', b.last_name) AS 'reports_to'
FROM Employees AS a
LEFT JOIN Employees AS b 
ON a.supervisor_id = b.employees_id;

-- VIEWS
-- a virtual table based on the results - set of na SQL statement
-- The fields in a view are fields from one or more real tables in the database
-- They are not real tables but can be interacted with as if they were

-- create an Employee attendant sheet made up of just the first names and last names of all the employees
-- Any change in the values of the real table wil also be updated in the view
CREATE VIEW employee_attendance AS
SELECT first_name, last_name
FROM Employees;

SELECT * FROM employee_attendance -- it can be interacted with as if its a real table
ORDER BY last_name ASC;

DROP VIEW employee_attendance;
 
 -- lets add one column to customers table ( customer-emails)
 ALTER TABLE customers
 ADD  COLUMN email VARCHAR(50);
 
 UPDATE customers
 SET email = 'FFish@gmail.com'
 WHERE customer_id = 1;
 
UPDATE customers
SET email = 'LLobster@gmail.com'
WHERE customer_id = 2;

 UPDATE customers
 SET email = 'BBass@gmail.com'
 WHERE customer_id = 3;
 
UPDATE customers
SET email = 'PPuff@gmail.com'
WHERE customer_id = 4;

CREATE VIEW customer_email AS
SELECT email FROM customers;
SELECT * FROM customer_email;

-- lets insert a new cutomer to see if the VIEW would be updated as well
INSERT INTO customers
VALUES(5, 'Pearl', 'Krabs', NULL, 'PKrabs@gamil.com');
SELECT * FROM customers;
SELECT * FROM customer_email;-- its up to date so you dont have to repeat data

-- INDEX(BTree data structure)
-- indxes are used to find values within a specific column more quickly
-- MySQL normally seraches sequentially through a column
-- The longer the column, the longer the operation is
-- UDATE takes more time, SELECT takes less time
-- there is some pros and cons of using an index and it really depends on the table

 SELECT * FROM transactions; -- transactions are being updated all the time, so i dont think
                            -- this table would be a good example for an INDEX
SELECT * FROM customers; -- you dont update customers that often, lets reduce the time it takes to search
						-- for a customer, a customer may give you their last_name or first_name, lets create an index for this
-- show current index for table
SHOW INDEXES FROM customers;-- we do have one already and tahts for our customer_id(primary key)	
 -- lets apply an index to first_name and last_name
 
 CREATE INDEX last_name_idx
 ON customers(last_name);
 -- this dataset is already small to begin with so you wont notice any significant difference
 -- but if i am working witha million customers, using an index would be much faster
SELECT *FROM customers
WHERE last_name = 'Puff';

-- to create a multi-column index
CREATE INDEX last_name_first_name_idx
ON customers(last_name, first_name); -- list the columns in order the odrer is very important
SHOW INDEXES FROM customers;

ALTER TABLE customers
DROP INDEX last_name_idx;
SELECT *FROM customers
WHERE last_name = 'Puff' AND first_name = 'Poppy';

-- SUBQUERIES
-- a query within another query
-- query(subquery)

-- Compare every employees hourly pay with the avg hourly pay of our employees table
-- first step is to find the avg hourlpay
SELECT first_name, last_name, hourly_pay,
(SELECT AVG(hourly_pay) FROM Employees) AS avg_pay
FROM Employees;

-- find every employee that has an hourly pay greater than the avg pay
SELECT first_name, last_name, hourly_pay
FROM Employees
WHERE hourly_pay > (SELECT AVG(hourly_pay) FROM employees);

-- find the first and last name of every customer that has ever placed an order
SELECT * FROM transactions;

SELECT first_name, last_name
FROM customers WHERE customer_id IN
(SELECT DISTINCT customer_id FROM transactions-- Add the distinct keyword to remove repeats
WHERE customer_id IS NOT NULL);

-- return customers that has not placed an order
SELECT first_name, last_name
FROM customers WHERE customer_id NOT IN
(SELECT DISTINCT customer_id FROM transactions
WHERE customer_id IS NOT NULL);

-- GROUP BY = aggregate all rows by a specific column
--            often used with aggregate functions
--            ex. SUM(), MAX(), MIN(), AVG(), COUNT()

SELECT * FROM transactions;
ALTER TABLE transactions
ADD COLUMN order_date DATE;

UPDATE transactions
SET order_date = '2023-01-03'
WHERE transaction_id = 1004;

INSERT INTO transactions 
VALUES (1005, 2.49, 4, '2023-01-03'),
	   (1006, 5.48, NULL, '2023-01-03');
       
-- Our boss Mr Krabs needs us to tell us how much monery he made per day
SELECT SUM(amount), order_date
FROM transactions
GROUP BY order_date;

SELECT MAX(amount), order_date
FROM transactions
GROUP BY order_date;

SELECT MIN(amount), order_date
FROM transactions
GROUP BY order_date;

SELECT AVG(amount), order_date
FROM transactions
GROUP BY order_date;

SELECT COUNT(amount), order_date
FROM transactions
GROUP BY order_date;

-- How much has each customer spent in total
SELECT SUM(amount), customer_id
FROM transactions
GROUP BY customer_id;

SELECT COUNT(amount), customer_id
FROM transactions
GROUP BY customer_id
WHERE COUNT(amount) > 1; -- WHERE dosent work with GROUP BY

-- find customers that has visited more than once
SELECT COUNT(amount), customer_id
FROM transactions
GROUP BY customer_id
HAVING COUNT(amount) > 1 AND customer_id IS NOT NULL; -- use the word HAVING

-- ROLLUP, extension of the GROUP BY clause
-- produes another row and shows the GRAND TOTAL (super_aggregate value)
 
 -- lets group each transaction by the order date and produce a GRAND TOTAL
 SELECT SUM(amount), order_date
 FROM transactions
 GROUP BY order_date WITH ROLLUP;-- WITH ROLLUP returns the summation of the group by

SELECT COUNT(amount), order_date
FROM transactions
GROUP BY order_date WITH ROLLUP;
 
SELECT COUNT(transaction_id) AS '# of orders', customer_id
FROM transactions
GROUP BY customer_id WITH ROLLUP;

-- as a buisness how much are we spending on all of our employees per hour
SELECT SUM(hourly_pay) 'hourly_pay', employees_id
FROM Employees
GROUP BY employees_id WITH ROLLUP;
SELECT * FROM Employees;

-- ON DELETE SET NULL = When a Foreign Key is deleted, replace FK with NULL
-- ON DELETE SET CASCADE = When a Foreign Key is deleted, delete row
SELECT * FROM transactions;
SET foreign_key_checks = 0; -- allows you to delete a row from a foreign key

DELETE FROM customers
WHERE customer_id = 4;
SELECT * FROM customers;

-- lets reinsert customer_id 4
INSERT INTO customers VALUES( 4, 'Poppy', 'Puff', 2, 'PPuff@gmail.com');
CREATE TABLE transactions(
	transaction_id INT PRIMARY KEY AUTO_INCREMENT,
    amount DECIMAL (5, 2),
    customer_id INT,
    order_date DATE,
    FOREIGN KEY(customer_id) REFERENCES customers(customer_id)
    ON DELETE SET NULL
    );
    
-- TO ALTER an existing table
ALTER TABLE transactions DROP FOREIGN KEY fk_customer_id;

ALTER TABLE transactions
ADD CONSTRAINT fk_customer_id
FOREIGN KEY(customer_id) REFERENCES customers(customer_id)
ON DELETE SET NULL;

-- lets try deleting a row from the foreign key
DELETE FROM customers
WHERE customer_id = 4;
SELECT * FROM transactions;

ALTER TABLE transactions
ADD CONSTRAINT fk_customer_id
FOREIGN KEY(customer_id) REFERENCES customers(customer_id)
ON DELETE CASCADE ;

-- STORED PROCEDURE = is prepared SQL code that you can save
--                    great if there's a query that you can write often

SELECT DISTINCT first_name, last_name
FROM transactions
INNER JOIN customers
ON transactions.customer_id = customers.customer_id;
-- this statement is very verbose, if i want to write this often i could save it as a 
-- stored procedure

DELIMITER $$
CREATE PROCEDURE get_customers() -- name of the procedure
BEGIN
	SELECT * FROM customers;
END $$
DELIMITER ; -- Refresh your schema and see the stored_procedure

-- to invoke the stored procedure call the name of the procedure
CALL get_customers();

DROP PROCEDURE get_customers;

-- to create a stored procedure to call or index a customer_id
DELIMITER $$
CREATE PROCEDURE find_customers(IN id INT)-- id = variable of the input value
BEGIN
    SELECT *
    FROM customers
    WHERE customer_id = id;
END $$
DELIMITER ;

CALL find_customers(1); -- returns customer_id = 1
DROP PROCEDURE find_customers;

DELIMITER $$
CREATE PROCEDURE find_customer(IN f_name VARCHAR(50), IN l_name VARCHAR(50))
BEGIN
    SELECT * FROM customers
    WHERE first_name = f_name AND last_name = l_name;
END $$
DELIMITER ;

CALL find_customer('Larry', 'Lobster');
-- importance/downsides of stored procedure
--        reduces network traffic
--        increases performance
--        secure, admin can grant persmission to use
--        increases memory useage of every connection

-- TRIGGERS = When an event happens, do something
--            example (INSERT, UPDATE, DELETE)
--            checks data, handles errors, auditing tables

SELECT * FROM Employees;
-- Maybe i would like a salary column whenever we add an employee or update our hourlpay
-- the employee salary would be changed automatically
ALTER TABLE Employees
ADD COLUMN salary DECIMAL(10, 2) AFTER hourly_pay;

UPDATE Employees
-- EXMPLE; 10 dollar per hour * 40 hours in a work week * 25 weeks in a year= 20800
-- or simply put there are 2080 work hours in a typical year
SET salary = hourly_pay * 2080;

CREATE TRIGGER before_hourly_pay_updated -- name of the trigger
BEFORE UPDATE ON Employees
FOR EACH ROW -- we may be working with mor than one row so thats why we included this line
SET NEW.salary = (NEW.hourly_pay * 2080); -- we are calculating a new salary us the new hourly pay
-- when thats changed in place of the old one

UPDATE Employees
SET hourly_pay = 50
WHERE employees_id = 1;
SELECT * FROM Employees;
SHOW TRIGGERS;

-- lets increase every employees pay by 1 dollar per hour
UPDATE Employees
SET hourly_pay = hourly_pay + 1;

-- we will calculate a new salary whenever we insert a new employee or hourly_pay
-- LETS delete plankton
DELETE FROM Employees
WHERE employees_id = 6;

CREATE TRIGGER before_hourly_insert
BEFORE INSERT ON Employees
FOR EACH ROW
SET NEW.salary = (NEW.hourly_pay * 2080);

INSERT INTO Employees
VALUES(6, 'Sheldon', 'Plankton', 10, NULL, 'janitor', '2023-01-07', 5);
SELECT * FROM Employees;

CREATE TABLE expenses(
     expense_id INT PRIMARY KEY,
     expense_name VARCHAR(50),
     expense_total DECIMAL(10, 2)
);

INSERT INTO expenses
VALUES(1, 'salaries', 0),
      (2, 'supplies', 0),
      (3, 'taxes', 0);
SELECT * FROM expenses;

-- lets use nested queries
UPDATE expenses
SET expense_total = (SELECT SUM(salary) FROM Employees)
WHERE expense_name = 'salaries';

-- whenever we delete an employee we will update this value found within another table
-- our expenses table

CREATE TRIGGER after_salary_delete
AFTER DELETE ON Employees
FOR EACH ROW
UPDATE expenses
SET expense_total = expense_total - OLD.salary
WHERE expense_name = 'salaries';

DELETE FROM Employees
WHERE employees_id = 6;
SELECT * FROM expenses; -- our expense total changed

CREATE TRIGGER after_salary_insert
AFTER INSERT ON Employees
FOR EACH ROW
UPDATE expenses
SET expense_total = expense_total + NEW.salary
WHERE expense_name = 'salaries';

INSERT INTO Employees
VALUES(6, 'Sheldon', 'Plankton', 10, NULL, 'janitor', '2023-01-07', 5);
SELECT * FROM expenses; -- our expense total changed as well


CREATE TRIGGER after_salary_update
AFTER UPDATE ON Employees
FOR EACH ROW
UPDATE expenses
SET expense_total = expense_total + (NEW.salary - OLD.salary)
WHERE expense_name = 'salaries';

UPDATE Employees
SET hourly_pay = 100
WHERE employees_id = 1;
SELECT * FROM expenses; 