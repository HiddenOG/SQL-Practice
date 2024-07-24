USE BLACK_RONIN;
DELETE FROM employee;
DROP TABLE employee;
DELETE FROM branch;
DROP TABLE client;
DROP TABLE works_with;
DROP TABLE branch_supplier;

CREATE TABLE employee(
   emp_id INT PRIMARY KEY,
   first_name VARCHAR(40),
   last_name VARCHAR(40),
   birth_date DATE,
   sex VARCHAR(1),
   salary INT,
   super_id INT,
   branch_id INT
);

CREATE TABLE branch (
   branch_id INT PRIMARY KEY,
   branch_name VARCHAR(40),
   mgr_id INT,
   mgr_start_date DATE,
   FOREIGN KEY(mgr_id) REFERENCES employee(emp_id) ON DELETE SET NULL
   );
   
ALTER TABLE employee
ADD FOREIGN KEY(branch_id)
REFERENCES branch(branch_id)
ON DELETE SET NULL;
   
ALTER TABLE employee
ADD FOREIGN KEY(super_id)
REFERENCES employee(emp_id)
ON DELETE SET NULL;

CREATE TABLE client (
   client_id INT PRIMARY KEY,
   client_name VARCHAR(40),
   branch_id INT,
   FOREIGN KEY(branch_id) REFERENCES branch(branch_id) ON DELETE SET NULL
);


CREATE TABLE works_with (
   emp_id INT,
   client_id INT,
   total_sales INT,
   PRIMARY KEY(emp_id, client_id),
   FOREIGN KEY(emp_id) REFERENCES employee(emp_id) ON DELETE CASCADE,
   FOREIGN KEY(client_id) REFERENCES client(client_id) ON DELETE CASCADE
);

CREATE TABLE branch_supplier(
   branch_id INT,
   supplier_name VARCHAR(40),
   supply_type VARCHAR(40),
   PRIMARY KEY(branch_id, supplier_name),
   FOREIGN KEY(branch_id) REFERENCES branch(branch_id) ON DELETE CASCADE
);

-- Corporate
INSERT INTO employee VALUES(100, 'David', 'Wallace', '1967-11-17', 'M', 250000, NULL, NULL);
INSERT INTO branch VALUES(1, 'Corporate', 100, '2006-02-09');
UPDATE employee
SET branch_id = 1
WHERE emp_id = 100;
INSERT INTO employee VALUES(101, 'Jan', 'Levinson', '1961-05-11','F',110000,  100, 1);

-- Scranton
INSERT INTO employee VALUES(102, 'Micheal', 'Scott', '1964-03-15', 'M', 75000, 100, NULL);
INSERT INTO branch VALUES(2, 'Scranton', 102, '1992-04-06');
UPDATE employee
SET branch_id = 2
WHERE emp_id = 102;
INSERT INTO employee VALUES(103, 'Angela', 'Martin', '1971-06-25','F',61000,  102, 2);
INSERT INTO employee VALUES(104, 'Kelly', 'Kapoor', '1980-02-05','F',55000,  102, 2);
INSERT INTO employee VALUES(105, 'Stanley', 'Hudson', '1958-02-19','M',69000,  102, 2);

-- Stamford
INSERT INTO employee VALUES(106, 'Josh', 'Porter', '1969-09-05', 'M', 78000, 100, NULL);
INSERT INTO branch VALUES(3, 'Stamford', 106, '1998-02-13');
UPDATE employee
SET branch_id = 3
WHERE emp_id = 106;
INSERT INTO employee VALUES(107, 'Andy', 'Bernard', '1973-07-22','M',65000,  106, 3);
INSERT INTO employee VALUES(108, 'Jim', 'Halpert', '1978-10-01','M',71000,  106, 3);

-- BRANCH SUPPLIER
INSERT INTO branch_supplier VALUES(2, 'Hammer Mill', 'Paper');
INSERT INTO branch_supplier VALUES(2, 'Uni-Ball', 'Writing Utensils');
INSERT INTO branch_supplier VALUES(3, 'Patriot Paper', 'Paper');
INSERT INTO branch_supplier VALUES(2, 'J.T Forms & Labels', 'Custom Forms');
INSERT INTO branch_supplier VALUES(3, 'Uni-Ball', 'Writing Utensils');
INSERT INTO branch_supplier VALUES(3, 'Hammer Mill', 'Paper');
INSERT INTO branch_supplier VALUES(3, 'Stamford Labels', 'Custom Forms');

-- CLIENT
INSERT INTO client VALUES(400, 'Dunmore Highschool', 2);
INSERT INTO client VALUES(401, 'Lackawana Country', 2);
INSERT INTO client VALUES(402, 'FedEx', 3);
INSERT INTO client VALUES(403, 'John Daly Law LLC', 3);
INSERT INTO client VALUES(404, 'Scranton Whitepages', 2);
INSERT INTO client VALUES(405, 'Times Newspaper', 3);
INSERT INTO client VALUES(406, 'FedEx', 2);

-- WORKS WITH
INSERT INTO works_with VALUES(105, 400, 56000);
INSERT INTO works_with VALUES(102, 401, 247000);
INSERT INTO works_with VALUES(108, 402, 22000);
INSERT INTO works_with VALUES(107, 403, 5000);
INSERT INTO works_with VALUES(108, 403, 12000);
INSERT INTO works_with VALUES(105, 404, 33000);
INSERT INTO works_with VALUES(107, 405, 26000);
INSERT INTO works_with VALUES(102, 406, 15000);
INSERT INTO works_with VALUES(105, 406, 130000);

SET SQL_SAFE_UPDATES=0;
DELETE FROM works_with;

SELECT * FROM employee;

-- find all employees
SELECT * 
FROM employee;

SELECT * 
FROM client;

-- find all employees orderd by salary
SELECT * 
FROM employee
ORDER BY salary DESC;

SELECT first_name, last_name, salary
FROM employee
ORDER BY salary DESC;

SELECT * 
FROM employee
ORDER BY sex, first_name, last_name;

-- SQL QUERIES

-- find the first 5 employees in the table
SELECT * 
FROM employee
LIMIT 5;

-- Find the first and last names of all employees
SELECT first_name, last_name
FROM employee;
-- naming the columns differently
SELECT first_name AS forename, last_name AS surname
FROM employee;

-- find out all the different genders
SELECT DISTINCT sex
FROM employee;
-- branch_id
SELECT DISTINCT branch_id
FROM employee;

-- SQL FUNCTIONS

-- Find the number of employees
SELECT COUNT(emp_id)
FROM employee;
-- Find the number of supervisors
SELECT COUNT(super_id)
FROM employee;

-- Find the number of female employees born after 1970
SELECT COUNT(emp_id)
FROM employee
WHERE sex = 'F' AND birth_date > '1971-01-01';

-- Find the average of all employees salary
SELECT AVG(salary)
FROM employee;

SELECT salary
FROM employee;

-- Find the average of all male employees salary
SELECT AVG(salary)
FROM employee
WHERE sex = 'M';

-- Find the SUM of all employees salary
SELECT SUM(salary)
FROM employee;

-- Find out how many male and how many females there are
SELECT COUNT(sex)
FROM employee;
-- Find out how many male and how many females there are
SELECT COUNT(sex),sex
FROM employee
GROUP BY sex;

-- Find the total sales of each salesman(total that each employee sold
SELECT *
FROM works_with;

SELECT SUM(total_sales), emp_id
FROM works_with
GROUP BY emp_id;

-- Find the total sales of each salesman(total that each client sold
SELECT SUM(total_sales), client_id
FROM works_with
GROUP BY client_id;

-- WILDCARDS
-- % = any #(number of) characters, _ = one character

-- Find any client who is an LLC
SELECT * 
FROM client
WHERE client_name LIKE '%LLC';

-- Find any brach suppliers who are in the label buisness
SELECT * 
FROM branch_supplier
WHERE supplier_name LIKE '% Label%';

-- Find any employee born in october
SELECT * 
FROM employee
WHERE birth_date LIKE '____-10%'; -- its a 4 digit year(4 underscores(_)), a hyphen and a two digit month

-- Find any employee born in february
SELECT * 
FROM employee
WHERE birth_date LIKE '____-02%'; -- its a 4 digit year(4 underscores(_)), a hyphen and a two digit month

-- Find any client who are schools
SELECT * 
FROM client
WHERE client_name LIKE '%school%';

-- UNIONS
-- Find a list of employee and branch names
SELECT first_name AS Company_names
FROM employee
UNION
SELECT branch_name
FROM branch
UNION
SELECT client_name
FROM client;
-- 1St rule of union
-- you have to have thseame number of cols you are getting in each select statement(fitst_name(1), branch_name(1))
-- 2nd rule
-- they have to have similar datatype(first-name,branch-name are both strings)

-- Find a list of all clients and branch suppliers names
SELECT client_name AS Name_List
FROM client
UNION
SELECT supplier_name
FROM branch_supplier;
-- since both client and branch_supplier table both have branch_id column you can do it like this
SELECT client_name, branch_id -- or client.branch_id
FROM client
UNION
SELECT supplier_name, branch_id -- or supplier_name.branch_id
FROM branch_supplier;

-- Find a list of all money spent or earned by the company
SELECT salary
FROM employee
UNION
SELECT total_sales
FROM works_with;

-- JOINS (can be used to combine rows from 2 or more tables based on a related column between them)
INSERT INTO branch VALUES(4, 'Buffalo', NULL, NULL);
SELECT * FROM branch;
-- Find all branches and the names of their managers
SELECT employee.emp_id, employee.first_name, branch.branch_name
FROM employee
JOIN branch -- this is gonna join the employee table and branch table together on a specific col
ON employee.emp_id = branch.mgr_id;
-- only employees whos id match togerher with the mgr_id join together into the combined table
-- mgr_id is a column that is shared between the employee and branch table
-- both of those tables have a column that stores emp_id
-- use JOIN in such situation

-- Using a LEFT JOIN
SELECT employee.emp_id, employee.first_name, branch.branch_name
FROM employee
LEFT JOIN branch
ON employee.emp_id = branch.mgr_id;
-- All the employees got included in the results not just the employees who are branch managers
-- with the LEFT JOIN we include all of the rows from the left table
-- the left table is basically the one that is included in the FROM satement.
-- all of the rows from the employee table in the result but only the rows in the
-- branch table that matched are gonna get included because the branch is the RIGHT table

-- Using a RIGHT JOIN
SELECT employee.emp_id, employee.first_name, branch.branch_name
FROM employee
RIGHT JOIN branch
ON employee.emp_id = branch.mgr_id;
-- There is a FULL JOIN

-- NESTED QUERIES(Use results from one query to get resuts from another)
-- Find names of all employees who have sold ove $30,000 to a single client
SELECT works_with.emp_id
FROM works_with
WHERE works_with.total_sales > 30000; -- first figure out emp_id with over 30000 sales

SELECT employee.first_name, employee.last_name
FROM employee
WHERE employee.emp_id IN (
    SELECT works_with.emp_id
    FROM works_with
    WHERE works_with.total_sales > 30000  
);
-- alot of times use this IN Keyword for nested queries

-- Find all clients who are handled by the branch that Micheal Scott Manages
-- Assume to know Micheals ID
SELECT branch.branch_id
FROM branch
WHERE branch.mgr_id = 102; -- First figure out the  branch Micheal_scott manages

SELECT client.client_name 
FROM client
WHERE client.branch_id = (
    SELECT branch.branch_id
    FROM branch
	WHERE branch.mgr_id = 102
    LIMIT 1 -- Make sure we only get one instance, when using =
    -- unless its a situation where Micheal Scott is managing multiple branches
    -- in which case we could use IN instead
);
-- this equal to('=') statement isnt necessary guaranteed to only return one value
-- lets say Micheal Scott was the manager at multiple branches it would return multiple values
   
-- ON DELETE( Deleting entries in the database when they have foreign keys associated with them)
-- So imagine i deleted on of my employees in my employee tabel(Micheal Scott) with an emp_id 102
-- but if we delte micheal Scott all of a sudden mg_id '102' doesent mean anything because Micheal Scott is gone

-- First thing to do in this situation is ON DELETE SET NULL
-- which means if we delete one of the employees the mgr_id associated with to that employee
-- is going to get set to NULL
-- ON DELETE CASCADE
-- This is where if we delete the employee whose ID is stored in the mgr_ID column,
-- the we are just gonna delete the entire row in the Database

CREATE TABLE branch (
   branch_id INT PRIMARY KEY,
   branch_name VARCHAR(40),
   mgr_id INT,
   mgr_start_date DATE,
   FOREIGN KEY(mgr_id) REFERENCES employee(emp_id) ON DELETE SET NULL
   ); -- set mgr_id = NULL if employee_id gets deleted
   -- it was okay to use ON DELETE SET NULL here because the mgr-id on the branch is just a foreign Key
   -- not crucial for the branch table
	
DELETE FROM employee
WHERE emp_id =102;
SELECT * FROM branch;
SELECT * FROM employee; -- works with the employee table

CREATE TABLE branch_supplier(
   branch_id INT,
   supplier_name VARCHAR(40),
   supply_type VARCHAR(40),
   PRIMARY KEY(branch_id, supplier_name),
   FOREIGN KEY(branch_id) REFERENCES branch(branch_id) ON DELETE CASCADE
);-- if i delete branch_id = 2, then all the rows that had branch_id = 2 would just
  -- get deleted
  -- it was okay to use ON DELETE SET CASCADE here because the branch_id(foreign key) 
  -- is also part of the primary key making it crucial to the branch_supllier table
  
DELETE FROM branch
WHERE branch_id = 2;
SELECT * FROM branch_supplier;

-- TRIGGERS(A block of code that defines a certain action that should happen when a certain operation gets 
-- performed on the database
-- lets create a table to illustrate this better
DROP TABLE trigger_test;
CREATE TABLE trigger_test (
    message VARCHAR(100)
);

DELIMITER $$ -- this will change the MYSQL delimiter which is a simicolon ';' to '$$' which could be used to end
CREATE
     TRIGGER my_trigger BEFORE INSERT -- naming the trigger 'my_trigger'
     ON employee  -- before any item gets inserted in the employee table, for each of the new item that are getting inserted,
                  -- i want to insert into the trigger test table the values 'added new employee'
     FOR EACH ROW BEGIN 
         INSERT INTO trigger_test VALUES('added new employee');
	 END$$ -- which could be used to end the creation of the my_trigger after ';' on the INSERT query
DELIMITER ; -- change the delimiter back to ';'
-- its automate in the trigger_test table anytime some value gets inserted into the employee table

INSERT INTO employee
VALUES (109, 'Oscar', 'Martinez', '1968-02-19', 'M', 69000, 106, 3);

SELECT * FROM trigger_test;


CREATE TABLE trigger_table (
    message VARCHAR(100)
);

DELIMITER $$ -- this will change the MYSQL delimiter which is a simicolon ';' to '$$' which could be used to end
CREATE
     TRIGGER test_trigger BEFORE INSERT -- naming the trigger 'test_trigger'
     ON client  -- before any item gets inserted in the client table, for each of the new item that are getting inserted,
                  -- i want to insert into the trigger test table the values 'added new client'
     FOR EACH ROW BEGIN 
         INSERT INTO trigger_table VALUES('added new client');
	 END$$ -- which could be used to end the creation of the my_trigger after ';' on the INSERT query
DELIMITER ; -- change the delimiter back to ';'
-- its automate in the trigger_test table anytime some value gets inserted into the client table

INSERT INTO client
VALUES(409, 'Junior School', 3);
SELECT * FROM trigger_table;

DELIMITER $$ 
CREATE
     TRIGGER test_trigger1 BEFORE INSERT 
     ON client  
     FOR EACH ROW BEGIN 
         INSERT INTO trigger_table VALUES(NEW.client_name); -- this allows me to access a particular attribute
           -- about the thing we just inserted, so NEW.client_name will give me the firstname of the client thats getting inserted
	 END$$ 
DELIMITER ; 

INSERT INTO client
VALUES(408, 'Benin University', 3);
SELECT * FROM trigger_table; -- not only did we add new client, we added the clients name

DELIMITER $$ 
CREATE
     TRIGGER test_trigger3 BEFORE INSERT -- you can also create triggers for UPDATE, BEFORE DELETE
                                         -- AFTER DELETE,
     ON employee  
     FOR EACH ROW BEGIN 
		   IF NEW.sex = 'M' THEN
                 INSERT INTO trigger_table VALUES('added mew male employee');
		   ELSEIF NEW.sex = 'F' THEN
				 INSERT INTO trigger_table VALUES('added female');
		   ELSE
                 INSERT INTO trigger_table VALUES('added other employee');
		   END IF;
	 END$$ -- to drop TRIGGER in my terminal. (DROP TRIGGER trigger_name;)
DELIMITER ;


