DROP DATABASE IF EXISTS student_performance;

CREATE DATABASE student_performance;

USE student_performance;

-- Students Table
CREATE TABLE Students (
    student_id INT PRIMARY KEY,
    name VARCHAR(50),
    age INT,
    course VARCHAR(50),
    city VARCHAR(50)
);

-- Courses Table
CREATE TABLE Courses (
    course_id INT PRIMARY KEY,
    course_name VARCHAR(50),
    duration VARCHAR(20)
);

-- Marks Table
CREATE TABLE Marks (
    student_id INT,
    course_id INT,
    marks INT,
    PRIMARY KEY (student_id, course_id),
    FOREIGN KEY (student_id) REFERENCES Students(student_id),
    FOREIGN KEY (course_id) REFERENCES Courses(course_id)
);

-- Attendance Table
CREATE TABLE Attendance (
    student_id INT PRIMARY KEY,
    attendance_percentage DECIMAL(5,2),
    FOREIGN KEY (student_id) REFERENCES Students(student_id)
);


-- Students Table
INSERT INTO Students VALUES
(1,'Amit',20,'BCA','Delhi'),
(2,'Riya',21,'BBA','Mumbai'),
(3,'Rahul',19,'BCA','Jaipur'),
(4,'Sneha',22,'BCom','Pune'),
(5,'Arjun',20,'BBA','Delhi'),
(6,'Priya',21,'BCA','Ahmedabad'),
(7,'Karan',23,'BCom','Surat'),
(8,'Neha',20,'BCA','Indore'),
(9,'Vikas',22,'BBA','Lucknow'),
(10,'Anjali',19,'BCA','Chandigarh'),
(11,'Rohit',21,'BCom','Delhi'),
(12,'Pooja',20,'BBA','Mumbai'),
(13,'Manish',22,'BCA','Jaipur'),
(14,'Simran',19,'BCom','Amritsar'),
(15,'Deepak',23,'BBA','Bhopal'),
(16,'Kavita',21,'BCA','Nagpur'),
(17,'Suresh',24,'BCom','Patna'),
(18,'Nisha',20,'BBA','Kolkata'),
(19,'Alok',22,'BCA','Ranchi'),
(20,'Meena',19,'BCom','Udaipur'),
(21,'Tarun',21,'BBA','Delhi'),
(22,'Isha',20,'BCA','Mumbai'),
(23,'Varun',23,'BCom','Jaipur'),
(24,'Divya',22,'BBA','Pune'),
(25,'Nitin',20,'BCA','Indore'),
(26,'Shreya',21,'BCom','Surat'),
(27,'Akash',22,'BBA','Lucknow'),
(28,'Ritu',19,'BCA','Chandigarh'),
(29,'Gaurav',23,'BCom','Delhi'),
(30,'Payal',20,'BBA','Ahmedabad');

-- Courses Table
INSERT INTO Courses VALUES
(101,'Database Management','6 months'),
(102,'Python Programming','4 months'),
(103,'Data Structures','5 months'),
(104,'Web Development','6 months'),
(105,'Machine Learning','8 months'),
(106,'Cloud Computing','6 months'),
(107,'Cyber Security','5 months'),
(108,'AI Basics','4 months'),
(109,'Networking','5 months'),
(110,'Software Engineering','6 months'),
(111,'Big Data','7 months'),
(112,'Operating Systems','5 months'),
(113,'Computer Graphics','6 months'),
(114,'Java Programming','4 months'),
(115,'C++ Programming','4 months'),
(116,'Digital Marketing','3 months'),
(117,'Data Analytics','6 months'),
(118,'UI/UX Design','5 months'),
(119,'Blockchain','6 months'),
(120,'IoT','5 months'),
(121,'Ethical Hacking','6 months'),
(122,'Mobile App Dev','5 months'),
(123,'Game Development','6 months'),
(124,'DevOps','6 months'),
(125,'SQL Advanced','4 months'),
(126,'Excel Analytics','3 months'),
(127,'Power BI','4 months'),
(128,'Linux Admin','5 months'),
(129,'AWS','6 months'),
(130,'Azure','6 months');

-- Marks Table
INSERT INTO Marks VALUES
(1,101,85),(2,102,78),(3,103,90),(4,104,67),(5,105,88),
(6,106,75),(7,107,82),(8,108,91),(9,109,69),(10,110,87),
(11,111,72),(12,112,80),(13,113,85),(14,114,77),(15,115,89),
(16,116,74),(17,117,68),(18,118,92),(19,119,81),(20,120,70),
(21,121,88),(22,122,76),(23,123,84),(24,124,79),(25,125,90),
(26,126,73),(27,127,86),(28,128,71),(29,129,83),(30,130,89);

-- Attendance Table
INSERT INTO Attendance VALUES
(1,82.5),(2,74.0),(3,88.0),(4,65.5),(5,91.0),
(6,72.0),(7,85.0),(8,79.5),(9,68.0),(10,92.0),
(11,76.5),(12,83.0),(13,69.5),(14,71.0),(15,87.5),
(16,90.0),(17,66.0),(18,78.5),(19,84.0),(20,73.5),
(21,88.5),(22,70.0),(23,81.5),(24,75.0),(25,89.0),
(26,67.5),(27,82.0),(28,74.5),(29,86.0),(30,91.5);


-- 1. Basic Queries

-- SELECT + WHERE
SELECT * FROM Students
WHERE city = 'Delhi';

-- ORDER BY
SELECT * FROM Students
ORDER BY age DESC;

-- 2. Aggregate Functions

SELECT AVG(marks) AS average_marks FROM Marks;

SELECT COUNT(*) AS total_students FROM Students;

SELECT SUM(marks) AS total_marks FROM Marks;

-- Grouping

-- Average marks per course
SELECT course_id, AVG(marks) AS avg_marks
FROM Marks
GROUP BY course_id;

-- Courses with avg marks > 80
SELECT course_id, AVG(marks) AS avg_marks
FROM Marks
GROUP BY course_id
HAVING AVG(marks) > 80;

-- JOINS

-- INNER JOIN (Student + Marks + Course)
SELECT s.name, c.course_name, m.marks
FROM Students s
INNER JOIN Marks m ON s.student_id = m.student_id
INNER JOIN Courses c ON m.course_id = c.course_id;

-- LEFT JOIN (All students even if no marks)
SELECT s.name, m.marks
FROM Students s
LEFT JOIN Marks m ON s.student_id = m.student_id;


-- Additionally, implement:

-- VIEW (Student Performance)
CREATE VIEW student_performance AS
SELECT s.student_id, s.name, c.course_name, m.marks, a.attendance_percentage
FROM Students s
JOIN Marks m ON s.student_id = m.student_id
JOIN Courses c ON m.course_id = c.course_id
JOIN Attendance a ON s.student_id = a.student_id;

-- to use view:-
SELECT * FROM student_performance;

-- STORED PROCEDURE (Top Performing Students)
DELIMITER $$

CREATE PROCEDURE TopStudents()
BEGIN
    SELECT s.name, m.marks
    FROM Students s
    JOIN Marks m ON s.student_id = m.student_id
    ORDER BY m.marks DESC
    LIMIT 5;
END $$

DELIMITER ;

-- to call it:-
CALL TopStudents();

-- TRIGGER (Restrict marks > 100)
DELIMITER $$

CREATE TRIGGER check_marks
BEFORE INSERT ON Marks
FOR EACH ROW
BEGIN
    IF NEW.marks > 100 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Marks cannot be greater than 100';
    END IF;
END $$

DELIMITER ;

