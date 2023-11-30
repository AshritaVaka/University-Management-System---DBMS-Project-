--PART - 1
-- Table creation

CREATE TABLE Students (
    StudentID INT PRIMARY KEY,
    FirstName VARCHAR(15),
    LastName VARCHAR(15),
    Age INT,
    DepartmentID INT
);

CREATE TABLE Courses (
    CourseID INT PRIMARY KEY,
    CourseName VARCHAR(50),
    DepartmentID INT
);

CREATE TABLE Grades (
    GradeID INT PRIMARY KEY,
    StudentID INT,
    CourseID INT,
    Grade DECIMAL(5, 3),
    CONSTRAINT FK_Student FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
    CONSTRAINT FK_Course FOREIGN KEY (CourseID) REFERENCES Courses(CourseID)
);

-- Insertion of data in Students

INSERT INTO Students (StudentID, FirstName, LastName, Age, DepartmentID)
VALUES (1, 'John', 'Doe', 20, 1);
INSERT INTO Students (StudentID, FirstName, LastName, Age, DepartmentID)
VALUES (2, 'Jane', 'Smith', 22, 2);
INSERT INTO Students (StudentID, FirstName, LastName, Age, DepartmentID)
VALUES (3, 'Bob', 'Johnson', 21, 1);
INSERT INTO Students (StudentID, FirstName, LastName, Age, DepartmentID)
VALUES (4, 'Alice', 'Williams', 23, 2);
INSERT INTO Students (StudentID, FirstName, LastName, Age, DepartmentID)
VALUES (5, 'Charlie', 'Brown', 19, 3);

--Insertion of data in Courses

INSERT INTO Courses (CourseID, CourseName, DepartmentID)
VALUES (101, 'Mathematics', 1);
INSERT INTO Courses (CourseID, CourseName, DepartmentID)
VALUES (102, 'Physics', 2);
INSERT INTO Courses (CourseID, CourseName, DepartmentID)
VALUES (103, 'Computer Science', 3);
INSERT INTO Courses (CourseID, CourseName, DepartmentID)
VALUES (104, 'History', 1);
INSERT INTO Courses (CourseID, CourseName, DepartmentID)
VALUES (105, 'Biology', 2);

--Insertion of data in Grades

INSERT INTO Grades (GradeID, StudentID, CourseID, Grade)
VALUES
    (1, 1, 101, 9.5);
INSERT INTO Grades (GradeID, StudentID, CourseID, Grade)
VALUES    (2, 2, 102, 8.0);
INSERT INTO Grades (GradeID, StudentID, CourseID, Grade)
VALUES    (3, 3, 103, 7.5);
INSERT INTO Grades (GradeID, StudentID, CourseID, Grade)
VALUES    (4, 4, 104, 8.0);
INSERT INTO Grades (GradeID, StudentID, CourseID, Grade)
VALUES    (5, 5, 105, 9.5);

-- PART - 2

UPDATE Students
SET Age = 26
WHERE Age > 23;
--
UPDATE Courses
SET CourseName = 'Advanced Mathematics'
WHERE CourseID = 101;
--
UPDATE Grades
SET Grade = 9.0
WHERE StudentID = 2 AND CourseID = 102;
--
UPDATE Courses
SET departmentid = 4
WHERE CourseID = 101;
--
UPDATE students
SET firstname = 'Joe'
WHERE lastname = 'Smith';

-- PART - 3
-- Query with GROUP BY, ORDER BY, and HAVING

SELECT CourseID, CourseName, DepartmentID
FROM Courses
ORDER BY CourseName;

SELECT DepartmentID, COUNT(*) AS StudentCount
FROM Students
GROUP BY DepartmentID
ORDER BY StudentCount DESC
LIMIT 1;

SELECT g.CourseID, c.CourseName, AVG(g.Grade) AS AvgGrade
FROM Grades g
INNER JOIN Courses c ON g.CourseID = c.CourseID
GROUP BY g.CourseID, c.CourseName
HAVING  AVG(g.Grade) > 7;

SELECT DepartmentID, AVG(Age) AS AvgAge
FROM Students
GROUP BY DepartmentID
HAVING AVG(Age) > 22;

SELECT StudentID, FirstName, LastName, Age
FROM Students
WHERE Age > (SELECT AVG(Age) FROM Students);

-- PART - 4
-- Join Students with Grades to Get Student Grades:

SELECT s.FirstName, s.LastName, c.CourseName, g.Grade
FROM Students s
JOIN Grades g ON s.StudentID = g.StudentID
JOIN Courses c ON g.CourseID = c.CourseID;

--Join Courses with Grades to Get Average Course Grades:

SELECT c.CourseName, AVG(g.Grade) AS AvgGrade
FROM Courses c
LEFT JOIN Grades g ON c.CourseID = g.CourseID
GROUP BY c.CourseName;

--Join Students with Courses and Filter by Department:

SELECT s.FirstName, s.LastName, c.CourseName
FROM Students s
JOIN Grades g ON s.StudentID = g.StudentID
JOIN Courses c ON g.CourseID = c.CourseID
WHERE s.DepartmentID = 1;

--Join Students with Courses to Get Enrollment Count by Course:

SELECT c.CourseName, COUNT(g.StudentID) AS EnrollmentCount
FROM Courses c
LEFT JOIN Grades g ON c.CourseID = g.CourseID
GROUP BY c.CourseName;

--Join Courses with Departments and Calculate Highest Course Grade:

SELECT s.FirstName, s.LastName, MAX(g.Grade) AS HighestGrade
FROM Students s
JOIN Grades g ON s.StudentID = g.StudentID
GROUP BY s.FirstName, s.LastName;

--Join Courses with Departments and Calculate Lowest Course Grade:

SELECT s.FirstName, s.LastName, MIN(g.Grade) AS LowestGrade
FROM Students s
JOIN Grades g ON s.StudentID = g.StudentID
GROUP BY s.StudentID, s.FirstName, s.LastName;

-- PART - 5

SELECT C.CourseID, C.CourseName, COUNT(G.StudentID) AS CourseCount, MAX(S.Age) AS MaxAge
FROM Courses C
LEFT JOIN Grades G ON C.CourseID = G.CourseID
LEFT JOIN Students S ON G.StudentID = S.StudentID
GROUP BY C.CourseID, C.CourseName
ORDER BY C.CourseID;


SELECT s.StudentID, s.FirstName, s.LastName, SUM(g.Grade) AS TotalGrade, MAX(g.Grade) AS MaxGrade
FROM Students s
INNER JOIN Grades g ON s.StudentID = g.StudentID
GROUP BY s.StudentID, s.FirstName, s.LastName;


SELECT DepartmentID, AVG(Age) AS AverageAge, MIN(Age) AS MinAge
FROM Students
GROUP BY DepartmentID;

SELECT DepartmentID, COUNT(*) AS StudentCount, SUM(Age) AS TotalAge
FROM Students
GROUP BY DepartmentID;


SELECT c.CourseID, c.CourseName, AVG(g.Grade) AS AverageGrade, MIN(g.Grade) AS MinGrade
FROM Courses c
LEFT JOIN Grades g ON c.CourseID = g.CourseID
GROUP BY c.CourseID, c.CourseName;

-- PART - 6
--From Students table
--to retrieve students who belong to the same department as "John Doe."

SELECT StudentID, FirstName, LastName, DepartmentID
FROM Students
WHERE DepartmentID = (SELECT DepartmentID FROM Students WHERE FirstName = 'John' AND LastName = 'Doe');

--to retrieve students of above average

SELECT StudentID, FirstName, LastName, Age
FROM Students
WHERE Age > (SELECT AVG(Age) FROM Students);

--From Courses table
--retrieve courses witht the same department id as physics

SELECT CourseID, CourseName
FROM Courses
WHERE DepartmentID = (SELECT DepartmentID FROM Courses WHERE CourseID = 102);

--to retrieve courses with average grade greater than 8

SELECT CourseID, CourseName
FROM Courses
WHERE CourseID IN (
    SELECT CourseID
    FROM Grades
    GROUP BY CourseID
    HAVING AVG(Grade) > 8.0
);

--from Grades table
--To retrieve highest grades in each course

SELECT StudentID, CourseID, Grade
FROM Grades g1
WHERE Grade = (
    SELECT MAX(Grade)
    FROM Grades g2
    WHERE g1.CourseID = g2.CourseID
);

--To retrieve grades lower than average

SELECT StudentID, CourseID, Grade
FROM Grades
WHERE Grade < (SELECT AVG(Grade) FROM Grades);

--showing of tables

select * from students;
select * from courses;
select * from grades;
