--- Create Department Table
CREATE TABLE Department (
 DepartmentID INT PRIMARY KEY,
 DepartmentName VARCHAR(100) NOT NULL UNIQUE
);

-- Create Designation Table
CREATE TABLE Designation (
 DesignationID INT PRIMARY KEY,
 DesignationName VARCHAR(100) NOT NULL UNIQUE
);

-- Create Person Table
CREATE TABLE Person (
 PersonID INT PRIMARY KEY IDENTITY(101,1),
 FirstName VARCHAR(100) NOT NULL,
 LastName VARCHAR(100) NOT NULL,
 Salary DECIMAL(8, 2) NOT NULL,
 JoiningDate DATETIME NOT NULL,
 DepartmentID INT NULL,
 DesignationID INT NULL,
 FOREIGN KEY (DepartmentID) REFERENCES Department(DepartmentID),
 FOREIGN KEY (DesignationID) REFERENCES Designation(DesignationID)
);


------------------------------------------------------(PART-A)-----------------------------------------------------------------------

-------------------------------------------------------(INSERT)-----------------------------------------------------------------------

---1. Department, Designation & Person Table’s INSERT, UPDATE & DELETE Procedures.

----DEPARTMENT

CREATE PROCEDURE PR_Department_Insert
	@DepartmentID int,
	@DepartmentName varchar(100)
AS
BEGIN
	INSERT INTO Department(DepartmentID,DepartmentName)
	VALUES(@DepartmentID,@DepartmentName)
END
EXEC PR_Department_Insert 1,'Admin'
EXEC PR_Department_Insert 2,'IT'
EXEC PR_Department_Insert 3,'HR'
EXEC PR_Department_Insert 4,'Account'
SELECT*FROM Department

----Designation

CREATE PROCEDURE PR_Designation_Insert
	@DesignationID int,
	@DesignationName varchar(100)
AS
BEGIN
	INSERT INTO Designation(DesignationID,DesignationName)
	VALUES(@DesignationID,@DesignationName)
END
EXEC PR_Designation_Insert 11,'Jobber'
EXEC PR_Designation_Insert 12,'Welder'
EXEC PR_Designation_Insert 13,'Clerk'
EXEC PR_Designation_Insert 14,'Manager'
EXEC PR_Designation_Insert 15,'CEO'

SELECT*FROM Designation

----Person

CREATE PROCEDURE PR_Person_Insert
	@FirstName varchar(100),
	@LastName varchar(100),
	@Salary Decimal (8,2),
	@JoiningDate Datetime,
	@DepartmentID int,
	@DesignationID int
	
AS
BEGIN
	INSERT INTO Person
	VALUES(@FirstName,@LastName,@Salary,@JoiningDate,@DepartmentID,@DesignationID)
END
EXEC  PR_Person_Insert 'Rahul','Anshu',56000,'01-01-1990',1,12 
EXEC  PR_Person_Insert 'Hardik','Hinsu',18000,'1990-09-25',2,11
EXEC  PR_Person_Insert 'Bhavin','Kamani',25000,'1991-05-14',NULL,11
EXEC  PR_Person_Insert 'Bhoomi','Patel',39000,'2014-02-20',1,13
EXEC  PR_Person_Insert 'Rohit','Rajgor',17000,'1990-07-23',2,15
EXEC  PR_Person_Insert 'Priya','Mehta',25000,'1990-10-18',2,NULL
EXEC  PR_Person_Insert 'Neha','Trivedi',18000,'2014-02-20',3,15


SELECT*FROM Person

-------------------------------------------------------(DELETE)-----------------------------------------------------------------------

----DEPARTMENT

CREATE OR ALTER PROCEDURE  PR_Department_Delete
	@DepartmentID int
AS
BEGIN 
	DELETE FROM Department
	WHERE DepartmentID=@DepartmentID
END
EXEC PR_Department_Delete @DepartmentID=1

----DESIGNATION

CREATE OR ALTER PROCEDURE PR_Designation_Delete
	@DesignationID int
AS 
BEGIN
	DELETE FROM Designation
	WHERE DesignationID=@DesignationID
END

EXEC PR_Designation_Delete @DesignationID=11

----PERSON

CREATE OR ALTER PROCEDURE PR_Person_Delete
	@PersonID int
AS
BEGIN
	DELETE FROM Person
	WHERE PersonID=@PersonID
END

EXEC PR_Person_Delete @PersonID=101

-------------------------------------------------------(UPDATE)-----------------------------------------------------------------------

----Department

 CREATE OR ALTER PROCEDURE  PR_Department_Update
	@DepartmentID int,
	@DepartmentName varchar(100)
 AS
 BEGIN
	UPDATE Department
	SET DepartmentName = @DepartmentName
	WHERE DepartmentID = @DepartmentID
 END

----Designation

CREATE OR ALTER PROCEDURE PR_Designation_Update
	@DesignationID int,
	@DesignationName varchar(100)
AS
BEGIN
	UPDATE Designation
	SET DesignationName=@DesignationName
	WHERE DesignationID=@DesignationID
END

----Person

CREATE OR ALTER PROCEDURE  PR_Person_Update
	@PersonID int,
	@FirstName varchar(100),
	@LastName varchar(100),
	@Salary Decimal (8,2),
	@JoiningDate Datetime,
	@DepartmentID int,
	@DesignationID int
AS
BEGIN
	UPDATE Person
	SET FirstName=@FirstName,
		LastName=@LastName,
		Salary=@Salary,
		JoiningDate=@JoiningDate,
		DepartmentID=@DepartmentID,
		DesignationID=@DesignationID
	WHERE PersonID=@PersonID
END


---2. Department, Designation & Person Table’s SELECTBYPRIMARYKEY

------------Person

CREATE OR ALTER PROCEDURE PR_PERSON_SELECT_BY_PRIMARYKEY
	@PersonID int
AS
BEGIN
	SELECT*FROM Person
	WHERE PersonID=@PersonID
END

-------------Department

CREATE OR ALTER PROCEDURE PR_DEPARTMENT_SELECT_BY_PRIMARYKEY
	@DepartmentID int
AS
BEGIN
	SELECT*FROM Person
	WHERE DepartmentID=@DepartmentID
END

--------------Designation

CREATE OR ALTER PROCEDURE PR_DESIGNATION_SELECT_BY_PRIMARYKEY
	@DesignationID int
AS
BEGIN
	SELECT*FROM Person
	WHERE DesignationID=@DesignationID
END


---3. Department, Designation & Person Table’s (If foreign key is available then do write join and take columns on select list)

CREATE or ALTER proc PR_Person_DEPT_DESG_COL
	@DepartmentName varchar(100),
	@DesignationName varchar(100)
AS
BEGIN
	SELECT Person.FirstName , Person.LastName , Person.Salary
	FROM Person
	INNER JOIN Department
	ON Person.DepartmentID = Department.DepartmentID
	INNER JOIN Designation
	ON Person.DesignationID = Designation.DesignationID
	WHERE Department.DepartmentName = @DepartmentName and
			Designation.DesignationName = @DesignationName
END

---4. Create a Procedure that shows details of the first 3 persons.

CREATE or ALTER PROCEDURE PR_Details_TOP_3_Person 
AS
BEGIN 
SELECT TOP 3* FROM Person
END

EXEC PR_Details_TOP_3_Person

------------------------------------------------------(PART-B)-----------------------------------------------------------------------
---5. Create a Procedure that takes the department name as input and returns a table with all workers working in that department.

CREATE or ALTER PROCEDURE PR_DEPT_ALLWORKERS
	@DepartmentName varchar(100)
AS
BEGIN
	SELECT 
	Person.PersonID,Person.FirstName,Person.LastName,Person.Salary,Person.JoiningDate,Person.DepartmentID,Person.DesignationID,Department.DepartmentName
	FROM Person
	INNER JOIN Department
	ON Person.DepartmentID=Department.DepartmentID
	WHERE DepartmentName=@DepartmentName
END

---6. Create Procedure that takes department name & designation name as input and returns a table with worker’s first name, salary, joining date & department name.
 
CREATE OR ALTER PROCEDURE PR_TAKES_DEPTNAME
	@DepartmentName varchar(100),
	@DesignationName  varchar(100)
AS
BEGIN
	SELECT Person.FirstName,Person.Salary,Person.JoiningDate,Department.DepartmentName
	FROM PERSON
	INNER JOIN Department
	ON Person.DepartmentID=Department.DepartmentID
	INNER JOIN Designation
	ON Person.DesignationID=Designation.DesignationID
	WHERE Department.DepartmentName=@DepartmentName AND  Designation.DesignationName=@DesignationName
END

---7. Create a Procedure that takes the first name as an input parameter and display all the details of the worker with their department & designation name.

CREATE OR ALTER PROCEDURE PR_TAKES_FIRSTNAME
	@firstname varchar(100)
AS
BEGIN
	SELECT Person.PersonID,Person.FirstName,Person.LastName,Person.Salary,Person.JoiningDate,Person.DepartmentID,Person.DesignationID,Department.DepartmentName, Designation.DesignationName
	FROM Person
	INNER JOIN Department
	ON Person.DepartmentID=Department.DepartmentID
	INNER JOIN Designation
	ON Person.DesignationID=Designation.DesignationID
	WHERE Person.FirstName=@firstname
END

---8. Create Procedure which displays department wise maximum, minimum & total salaries.

CREATE OR ALTER PROCEDURE PR_MAX_MIN_TOTAL
AS
BEGIN
	SELECT MAX(Person.Salary) AS MAX_SALARY,MIN(Person.Salary) AS MIN_SALARY,SUM(Person.Salary) AS TOTAL_SALARY
	FROM PERSON
	INNER JOIN Department
	ON Person.DepartmentID=Department.DepartmentID
	GROUP BY Department.DepartmentName
END

---9. Create Procedure which displays designation wise average & total salaries.

CREATE OR ALTER PROCEDURE PR_AVG_TOTAL_DESIGNATION
AS
BEGIN 
	SELECT AVG(Person.Salary) AS AVG_SALARY,SUM(Person.Salary) AS TOTAL_SALARY
	FROM Person
	INNER JOIN Designation
	ON Person.DesignationID=Designation.DesignationID
	GROUP BY Designation.DesignationName
END


------------------------------------------------------(PART-C)-----------------------------------------------------------------------

---10. Create Procedure that Accepts Department Name and Returns Person Count.

CREATE PROCEDURE GetPerson_Count_Department
    @DepartmentName VARCHAR(100)
AS
BEGIN
    SELECT COUNT(*) AS PersonCount
    FROM Person P
    INNER JOIN Department D ON P.DepartmentID = D.DepartmentID
    WHERE D.DepartmentName = @DepartmentName
END
	
---11. Create a procedure that takes a salary value as input and returns all workers with a salary greater than input salary value along with their department and designation details.

CREATE OR ALTER PROCEDURE PR_SALRAY_GREATER
	@salary int
AS
BEGIN
	SELECT Person.PersonID, Person.FirstName, Person.LastName, Person.Salary,Department.DepartmentName,Designation.DesignationName
    FROM Person 
    LEFT OUTER JOIN Department  
	ON Person.DepartmentID = Department.DepartmentID
    LEFT OUTER  JOIN Designation  
	ON Person.DesignationID = Designation.DesignationID
    WHERE  Person.Salary=@salary
END

---12. Create a procedure to find the department(s) with the highest total salary among all departments.

CREATE OR ALTER PROCEDURE PR_DEPTWISE_MAX_SALARY
AS
BEGIN
	SELECT Department.DepartmentID, Department.DepartmentName, SUM(Person.Salary) AS totalSalary
	FROM Person 
    INNER  JOIN Department  ON Person.DepartmentID = Department.DepartmentID
    GROUP BY Department.DepartmentID
    ORDER BY totalSalary DESC
END



---13. Create a procedure that takes a designation name as input and returns a list of all workers under that designation who joined within the last 10 years, along with their department.

CREATE OR ALTER PROCEDURE PR_DESIGNATION_NAME_INPUT
	@DesignationName varchar(100)
AS
BEGIN
	SELECT Person.PersonID, Person.FirstName, Person.LastName, Person.Salary,Department.DepartmentName,Designation.DesignationName
	FROM Person 
    INNER JOIN Department  
	ON Person.DepartmentID = Department.DepartmentID
    INNER JOIN Designation  
	ON Person.DesignationID = Designation.DesignationID
	WHERE DesignationName=@DesignationName AND  Person.JoiningDate
END

---14. Create a procedure to list the number of workers in each department who do not have a designation assigned.

CREATE OR ALTER PROCEDURE WorkersWithoutDesignationByDepartment
AS
BEGIN
	SELECT Department.DepartmentName,COUNT(Person.PersonID) AS WorkerCount
    FROM Person
    INNER JOIN Department ON Person.DepartmentID = Department.DepartmentID
    WHERE Person.DesignationID IS NULL
    GROUP BY Department.DepartmentName
END	

---15. Create a procedure to retrieve the details of workers in departments where the average salary is above 12000.

CREATE OR ALTER PROCEDURE Workers_HighSalary_Departments
AS
BEGIN
    SELECT Person.PersonID,Person.FirstName,Person.LastName,Person.Salary,Department.DepartmentName
    FROM Person 
    INNER JOIN Department  ON Person.DepartmentID = Department.DepartmentID
    WHERE Person.DepartmentID IN (
        SELECT 
            DepartmentID
        FROM Person
        WHERE DepartmentID IS NOT NULL
        GROUP BY DepartmentID
        HAVING AVG(Salary) > 12000
    )
END
