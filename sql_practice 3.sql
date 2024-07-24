USE MYDB;
SET SQL_SAFE_UPDATES=0;
Create Table EmployeeDemographics (
   EmployeeID int , 
   FirstName varchar(50), 
   LastName varchar(50), 
   Age int, 
   Gender varchar(50)
);

Create Table EmployeeSalary (
   EmployeeID int, 
   JobTitle varchar(50), 
   Salary int
);

Insert into EmployeeDemographics VALUES
(1001, 'Jim', 'Halpert', 30, 'Male'),
(1002, 'Pam', 'Beasley', 30, 'Female'),
(1003, 'Dwight', 'Schrute', 29, 'Male'),
(1004, 'Angela', 'Martin', 31, 'Female'),
(1005, 'Toby', 'Flenderson', 32, 'Male'),
(1006, 'Michael', 'Scott', 35, 'Male'),
(1007, 'Meredith', 'Palmer', 32, 'Female'),
(1008, 'Stanley', 'Hudson', 38, 'Male'),
(1009, 'Kevin', 'Malone', 31, 'Male');

Insert Into EmployeeSalary VALUES
(1001, 'Salesman', 45000),
(1002, 'Receptionist', 36000),
(1003, 'Salesman', 63000),
(1004, 'Accountant', 47000),
(1005, 'HR', 50000),
(1006, 'Regional Manager', 65000),
(1007, 'Supplier Relations', 41000),
(1008, 'Salesman', 48000),
(1009, 'Accountant', 42000);


-- SELECT
SELECT DISTINCT (Gender) FROM EmployeeDemographics;

-- CASE STATEMENT
-- it allows you to specify a a condition, it also allows you to specify what you ant returned when
-- that condition is met

SELECT FirstName, LastName, Age,
CASE 
    WHEN Age > 30 THEN 'Old'
    ELSE 'Young'
END
FROM EmployeeDemographics
WHERE Age is NOT NULL
ORDER BY Age;

SELECT FirstName, LastName, Age,
CASE 
    WHEN Age > 30 THEN 'Old'
    WHEN Age BETWEEN 27 AND 30 THEN 'Young'
    ELSE 'Baby'
END
FROM EmployeeDemographics
WHERE Age is NOT NULL
ORDER BY Age;

SELECT FirstName, LastName, Age,
CASE 
    WHEN Age > 30 THEN 'Old'-- its gonna return the condition that was stated first
    WHEN Age = 38 THEN 'Stanley'
    ELSE 'Baby'
END
FROM EmployeeDemographics
WHERE Age is NOT NULL
ORDER BY Age;

SELECT FirstName, LastName, Age,
CASE 
    WHEN Age = 38 THEN 'Stanley'-- its gonna return the condition that was stated first
    WHEN Age > 30 THEN 'Old'
    ELSE 'Baby'
END
FROM EmployeeDemographics
WHERE Age is NOT NULL
ORDER BY Age;

-- calculate what salesman salry would be after their raise
SELECT FirstName, LastName, JobTitle, Salary,
CASE
    WHEN JobTitle = 'Salesman' THEN Salary + (Salary * .10) -- 10 percent raise
    WHEN JobTitle = 'Accountant' THEN Salary + (Salary * .05) -- 5 percent raise
    WHEN JobTitle = 'HR' THEN Salary + (Salary * .000001) --  percent raise
    ELSE Salary + (Salary * .03) -- 3 percent raise
END AS salary_after_raise
FROM  EmployeeDemographics
JOIN EmployeeSalary ON
EmployeeDemographics.EmployeeID = EmployeeSalary.EmployeeID;

-- use the case staement to categorize things or label things

-- HAVING CLAUSE
SELECT JobTitle, COUNT(JobTitle)
FROM  EmployeeDemographics
JOIN EmployeeSalary ON
EmployeeDemographics.EmployeeID = EmployeeSalary.EmployeeID
GROUP BY JobTitle
HAVING COUNT(JobTitle) > 1;

SELECT JobTitle, AVG(Salary)
FROM  EmployeeDemographics
JOIN EmployeeSalary ON
EmployeeDemographics.EmployeeID = EmployeeSalary.EmployeeID
GROUP BY JobTitle
HAVING AVG(Salary) > 45000
ORDER BY AVG(Salary);

-- Aliasing
-- tempoary changing the column name or table name in your script and its not gonna impact your
-- output at all

SELECT FirstName AS Fname
FROM EmployeeDemographics;

SELECT CONCAT(FirstName, ' ', LastName) AS Fullname
FROM EmployeeDemographics;

SELECT Demo.EmployeeID
 FROM EmployeeDemographics AS Demo
 JOIN EmployeeSalary AS Sal
 ON Demo. EmployeeID = Sal.EmployeeID;
 
 -- PARTITION BY 
 -- divides the results set into partitions and changes how the window function is calulated
 -- so it doesnt reduce the number of rows returned
 SELECT FirstName, LastName, Gender, Salary,
 COUNT(Gender) OVER (PARTITION BY Gender) AS total_gender
 FROM EmployeeDemographics AS Demo
 JOIN EmployeeSalary AS Sal
 ON Demo. EmployeeID = Sal.EmployeeID;
 
 SELECT FirstName, LastName, Gender, Salary,COUNT(Gender)
 FROM EmployeeDemographics AS Demo
 JOIN EmployeeSalary AS Sal
 ON Demo. EmployeeID = Sal.EmployeeID
 GROUP BY FirstName, LastName, Gender, Salary;
 
 -- IF we want to get thesame output where we got 3 for females and 6 for males
 
 SELECT Gender, COUNT(Gender)
 FROM EmployeeDemographics AS Demo
 JOIN EmployeeSalary AS Sal
 ON Demo. EmployeeID = Sal.EmployeeID
 GROUP BY Gender;
 -- so what PARTITION BY is doing right here is taking this querey up here and sticking
 -- on one line in the select statement
 
 -- CTE
 -- this is a common table expression and its a nmamed tempoary result set which is used to manipulate the 
 -- complex subquerirs data, a CTE is only craeted in memory and it very ,much acts like a subquery
WITH CTE_Employee AS
(SELECT FirstName, LastName, Gender, Salary
, COUNT(Gender) OVER (PARTITION BY Gender) AS total_gender
, AVG(Salary) OVER (PARTITION BY Gender) AS avg_salary
 FROM EmployeeDemographics AS Demo
 JOIN EmployeeSalary AS Sal
      ON Demo. EmployeeID = Sal.EmployeeID
 WHERE Salary > '45000')
SELECT FirstName, avg_salary FROM CTE_Employee;-- if i tried to run this just by itself its not gonna work
-- its onlygonna work with a select staement down next to the CTE youve created
 -- CTE is gonna put this statement at a tempoary place where we can query or go and grab that data
 
 -- Temp tables
 -- these are tempoary tables and you can hit off of this table multiple times which you
 -- cannot do with a CTE or a subquerey 
 
 CREATE TEMPORARY TABLE temp_Employee (
     Employees_ID INT,
	 JobTitle varchar(100),
     Salary int)
-- Google about it for more info

SELECT * FROM temp_Employee;
INSERT INTO temp_Employee
SELECT * FROM EmployeeSalary; -- we select all the data from employee salary and stuck it in this table
-- useful when woking with large data with billions of rows to alter them tempoary

DROP TABLE IF EXISTS temp_Employee2;
CREATE TEMPORARY TABLE temp_Employee2(
JobTitle varchar(50),
EmployeePerJob int,
AvgAge int,
AvgSalary int);

INSERT INTO temp_Employee2
SELECT JobTitle, COUNT(JobTitle), AVG(Age), AVG(Salary)
FROM  EmployeeDemographics AS Demo
JOIN EmployeeSalary AS Sal
ON Demo.EmployeeID = Sal.EmployeeID
GROUP BY JobTitle;

SELECT * FROM temp_Employee2;

-- STRING FUNCTIONS
CREATE TABLE EmployeeErrors (
EmployeeID varchar(50)
,FirstName varchar(50)
,LastName varchar(50)
);

Insert into EmployeeErrors Values 
('1001  ', 'Jimbo', 'Halbert')
,('  1002', 'Pamela', 'Beasely')
,('1005', 'TOby', 'Flenderson - Fired');

Select *
From EmployeeErrors;

-- Using Trim, LTRIM, RTRIM

Select EmployeeID, TRIM(employeeID) AS IDTRIM
FROM EmployeeErrors;-- TRIM gets rid off blankspaces on either front or back, left or right

Select EmployeeID, RTRIM(employeeID) as IDRTRIM
FROM EmployeeErrors;

Select EmployeeID, LTRIM(employeeID) as IDLTRIM
FROM EmployeeErrors;

-- Using Replace
Select LastName, REPLACE(LastName, '- Fired', '') as LastNameFixed
FROM EmployeeErrors;-- replacing the - Fired with blank

-- Using Substring
Select Substring(FirstName,1,3)
FROM EmployeeErrors; -- this returns the first 3 letters and starts with the first letter

Select Substring(FirstName,3,3)
FROM EmployeeErrors; -- this returns the first 3 letters and starts with the third letter

Select err.FirstName, dem.FirstName
FROM EmployeeErrors as err
JOIN EmployeeDemographics as dem
	on err.FirstName = dem.FirstName;-- its gonna return 'toby' because its the only row that matches

Select Substring(err.FirstName,1,3), Substring(dem.FirstName,1,3), Substring(err.LastName,1,3), Substring(dem.LastName,1,3)
FROM EmployeeErrors as err
JOIN EmployeeDemographics as dem
	on Substring(err.FirstName,1,3) = Substring(dem.FirstName,1,3)
	and Substring(err.LastName,1,3) = Substring(dem.LastName,1,3);

-- Using UPPER and lower

Select firstname, LOWER(firstname)
from EmployeeErrors;

Select Firstname, UPPER(FirstName)
from EmployeeErrors;

-- SUBQUERY
Select EmployeeID, JobTitle, Salary
From EmployeeSalary;

-- Subquery in Select
Select EmployeeID, Salary, (Select AVG(Salary) From EmployeeSalary) as AllAvgSalary
From EmployeeSalary;

-- How to do it with Partition By
Select EmployeeID, Salary, AVG(Salary) over () as AllAvgSalary
From EmployeeSalary;

-- Why Group By doesn't work
Select EmployeeID, Salary, AVG(Salary) as AllAvgSalary
From EmployeeSalary
Group By EmployeeID, Salary
order by EmployeeID;


-- Subquery in From
Select a.EmployeeID, AllAvgSalary
From 
	(Select EmployeeID, Salary, AVG(Salary) over () as AllAvgSalary
	 From EmployeeSalary) as a
Order by a.EmployeeID; -- much preferrable to use a temp table or a CTE

-- Subquery in Where
-- We only want to return the salary of employees if they are over the age of 30

Select EmployeeID, JobTitle, Salary
From EmployeeSalary
where EmployeeID in (
	Select EmployeeID 
	From EmployeeDemographics
	where Age > 30); -- if you wanted to return the age you would have to JOIN 