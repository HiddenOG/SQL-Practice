USE OGBASE;
DROP TABLE student;
CREATE TABLE student(
    student_id INT PRIMARY KEY AUTO_INCREMENT, -- the auto_increment faeture can only be set to
    name VARCHAR(20),                          -- a column that identifies as a key
    major VARCHAR(20) DEFAULT 'undecided'
    
);

DESCRIBE student;
 
ALTER TABLE student ADD gpa DECIMAL(3, 2);-- this adds a new column
ALTER TABLE student DROP gpa;

SELECT * FROM student;
SET SQL_SAFE_UPDATES=0;
UPDATE student
SET major='Undecided';

DELETE FROM student;

SELECT name, major
FROM student
WHERE major <> 'Chemistry';

SELECT *
FROM student
WHERE major IN('Biology', 'Chemistry') AND student_id > 2 ;

-- this is a comment
INSERT INTO student(name, major) VALUES('Jack', 'Biology');
INSERT INTO student(name, major) VALUES('Kate', 'Sociology');
INSERT INTO student(name, major) VALUES('Clarie', 'Chemistry');
INSERT INTO student(name, major) VALUES('Jack', 'Biology');
INSERT INTO student(name, major) VALUES('Mike', 'Computer Science');




INSERT INTO student VALUES(2, 'Kate', 'Sociology');
INSERT INTO student(student_id, name) VALUES(3, 'Claire');
INSERT INTO student VALUES(3, NULL, 'Chemistry');
INSERT INTO student VALUES(4, 'Jack', 'Biology');
INSERT INTO student VALUES(5, 'Mike', 'Computer Science');
