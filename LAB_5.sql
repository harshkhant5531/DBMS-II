-- Creating PersonInfo Table
CREATE TABLE PersonInfo (
 PersonID INT PRIMARY KEY,
 PersonName VARCHAR(100) NOT NULL,
 Salary DECIMAL(8,2) NOT NULL,
 JoiningDate DATETIME NULL,
 City VARCHAR(100) NOT NULL,
 Age INT NULL,
 BirthDate DATETIME NOT NULL
);

-- Creating PersonLog Table
CREATE TABLE PersonLog (
 PLogID INT PRIMARY KEY IDENTITY(1,1),
 PersonID INT NOT NULL,
 PersonName VARCHAR(250) NOT NULL,
 Operation VARCHAR(50) NOT NULL,
 UpdateDate DATETIME NOT NULL,
);

--  PART-A

--1.Create a trigger that fires on INSERT, UPDATE and DELETE operation on the PersonInfo table to display a message “Record is Affected.” 

CREATE OR ALTER TRIGGER TR_PERSONINFO_INSERT
ON PERSONINFO
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
	PRINT 'RECORD IS AFFECTED'
END

DROP TRIGGER TR_PERSONINFO_INSERT

--2.Create a trigger that fires on INSERT, UPDATE and DELETE operation on the PersonInfo table. For that,log all operations performed on the person table into PersonLog.

--INSERT

CREATE OR ALTER TRIGGER TR_PERSONINFO_INSERT
ON PERSONINFO
AFTER INSERT
AS
BEGIN
	DECLARE @PID INT, @PNAME VARCHAR(100)
	SELECT
		@PID = PersonID,
		@PNAME = PersonName
	FROM inserted

	INSERT INTO PERSONLOG VALUES
	(@PID, @PNAME, 'INSERTED', GETDATE())
END
--UPDATE

CREATE OR ALTER TRIGGER TR_PERSONINFO_UPDATE
ON PERSONINFO
AFTER UPDATE
AS
BEGIN
	DECLARE @PID INT, @PNAME VARCHAR(100);
	SELECT
		@PID = PersonID,
		@PNAME = PersonName
	FROM inserted

	INSERT INTO PERSONLOG VALUES
	(@PID, @PNAME, 'UPDATED', GETDATE())
END

DROP TRIGGER TR_PERSONINFO_UPDATE


--DELETED

CREATE OR ALTER TRIGGER TR_PERSONINFO_DELETE
ON PERSONINFO
AFTER DELETE
AS
BEGIN
	DECLARE @PID INT, @PNAME VARCHAR(100);
	SELECT
		@PID = PersonID,
		@PNAME = PersonName
	FROM deleted

	INSERT INTO PERSONLOG VALUES
	(@PID, @PNAME, 'DELETED', GETDATE())
END

--3.Create an INSTEAD OF trigger that fires on INSERT, UPDATE and DELETE operation on the PersonInfo table. For that, log all operations performed on the person table into PersonLog.

--INSERT

CREATE OR ALTER TRIGGER TR_PERSONINFO_LOG_INSERT
ON PERSONINFO
INSTEAD OF INSERT
AS
BEGIN
	DECLARE @PID INT, @PNAME VARCHAR(100)
	SELECT 
		@PID = PersonID,
		@PNAME = PersonName
	FROM inserted

	INSERT INTO PERSONLOG VALUES
	(@PID, @PNAME, 'INSERTED', GETDATE())
END

DROP TRIGGER TR_PERSONINFO_LOG_INSERT

--UPDATE

CREATE OR ALTER TRIGGER TR_PERSONINFO_LOG_UPDATE
ON PERSONINFO
INSTEAD OF UPDATE
AS
BEGIN
	DECLARE @PID INT, @PNAME VARCHAR(100)
	SELECT 
		@PID = PersonID,
		@PNAME = PersonName
	FROM inserted

	INSERT INTO PERSONLOG VALUES
	(@PID, @PNAME, 'INSERTED', GETDATE())
END

--DELETE

CREATE OR ALTER TRIGGER TR_PERSONINFO_LOG_DELETE
ON PERSONINFO
INSTEAD OF DELETE
AS
BEGIN
	DECLARE @PID INT, @PNAME VARCHAR(100)
	SELECT 
		@PID = PersonID,
		@PNAME = PersonName
	FROM deleted

	INSERT INTO PERSONLOG VALUES
	(@PID, @PNAME, 'INSERTED', GETDATE())
END
DROP TRIGGER TR_PERSONINFO_DELETE

--4.Create a trigger that fires on INSERT operation on the PersonInfo table to convert person name into uppercase whenever the record is inserted.

CREATE OR ALTER TRIGGER TR_PINFO_UPCASE
ON PERSONINFO 
AFTER INSERT
AS
BEGIN
DECLARE @PID INT, @PNAME VARCHAR(100)
	SELECT
		@PID = PersonID,
		@PNAME = PersonName
	FROM inserted

	UPDATE PERSONINFO
	SET PersonName=UPPER(@PNAME)
	WHERE PersonID=@PID
	
END

INSERT INTO PERSONINFO VALUES(2,'harsh',30000,'1999-01-30','Rajkot',18,'1999-01-30')


select * from PERSONLOG

--5.Create trigger that prevent duplicate entries of person name on PersonInfo table.
CREATE OR ALTER TRIGGER TR_PERSONINFO_DUPLICATE
ON PERSONINFO
AFTER INSERT
AS
BEGIN
    IF EXISTS (
        SELECT 1 FROM inserted i
        JOIN PersonInfo p ON i.PersonName = p.PersonName
        WHERE i.PersonID <> p.PersonID
    )
    BEGIN
        PRINT 'Duplicate person name is not allowed'
    END
END



--6.Create trigger that prevent Age below 18 years.
CREATE OR ALTER TRIGGER TR_PERSONINFO_18
ON PERSONINFO
INSTEAD OF INSERT
AS
BEGIN
    INSERT INTO PersonInfo (PersonID, PersonName, Salary, JoiningDate, City, Age, BirthDate)
    SELECT PersonID, PersonName, Salary, JoiningDate, City, Age, BirthDate
    FROM inserted
    WHERE Age >= 18;
END

INSERT INTO PersonInfo VALUES (5, 'ABC', 100000, '2020-08-18', 'PORBANDER', 17, '2007-08-18'); -- This will fail due to trigger

INSERT INTO PersonInfo VALUES (6, 'HARSH', 100000, '2020-08-18', 'WANKANER', 19, '2005-12-24');

SELECT * FROM PersonInfo;


-----------------------------------------------(PART-B)-----------------------------------------------------
---7. Create a trigger that fires on INSERT operation on person table, which calculates the age and update that age in Person table.
CREATE OR ALTER TRIGGER TR_UP_JDATE
ON PersonInfo
AFTER INSERT 
AS
BEGIN
	DECLARE @BDATE DATETIME
	SELECT @BDATE=BirthDate FROM inserted
	UPDATE PersonInfo
	SET Age=DATEDIFF(YEAR,@BDATE,GETDATE())
	WHERE PersonID IN (SELECT PersonID FROM PersonInfo)
END
---8. Create a Trigger to Limit Salary Decrease by a 10%.CREATE OR ALTER TRIGGER TR_SAL_DECON PersonInfoAFTER UPDATEAS BEGIN	DECLARE @NEWSALARY DECIMAL(8,2), @OLDSALARY DECIMAL(8,2), @PID INT	SELECT @NEWSALARY=SALARY,@PID=PersonID FROM inserted	SELECT @OLDSALARY=SALARY FROM deleted	IF @NEWSALARY < @OLDSALARY*0.90	BEGIN		UPDATE PersonInfo
		SET Salary=@OLDSALARY
		WHERE PersonID=@PID	ENDEND-----------------------------------------------(PART-C)--------------------------------------------------------9. Create Trigger to Automatically Update JoiningDate to Current Date on INSERT if JoiningDate is NULL during an INSERT.
CREATE OR ALTER TRIGGER TR_UP_JDATE
ON PersonInfo
AFTER UPDATE
AS
BEGIN
	UPDATE PersonInfo
	SET JoiningDate=GETDATE()
	WHERE PersonID IN (SELECT PersonID FROM PersonInfo where JoiningDate IS null)
END
---10. Create DELETE trigger on PersonLog table, when we delete any record of PersonLog table it prints ‘Record deleted successfully from PersonLog’.

CREATE OR ALTER TRIGGER TR_PERSONINFO_INSERT
ON PersonLog
AFTER  DELETE
AS
BEGIN
	PRINT 'Record deleted successfully from PersonLog'
END



-----------------------------------------------------(EXTRA AFTER TRIGGER)--------------------------------------------------------
CREATE TABLE EMPLOYEEDETAILS
(
	EmployeeID Int Primary Key,
	EmployeeName Varchar(100) Not Null,
	ContactNo Varchar(100) Not Null,
	Department Varchar(100) Not Null,
	Salary Decimal(10,2) Not Null,
	JoiningDate DateTime Null
)

CREATE TABLE EmployeeLogs (
    LogID INT PRIMARY KEY IDENTITY(1,1),
    EmployeeID INT NOT NULL,
    EmployeeName VARCHAR(100) NOT NULL,
    ActionPerformed VARCHAR(100) NOT NULL,
    ActionDate DATETIME NOT NULL
);



---1)Create a trigger that fires AFTER INSERT, UPDATE, and DELETE operations on the EmployeeDetails table to display the message "Employee record inserted", "Employee record updated", "Employee record deleted"

----INSERT
CREATE OR ALTER TRIGGER TR_EMPDETAIL_INSERT
ON EMPLOYEEDETAILS
AFTER INSERT
AS
BEGIN
	PRINT 'Employee record inserted'
END

DROP TRIGGER TR_EMPDETAIL_INSERT

----UPDATE
CREATE OR ALTER TRIGGER TR_EMPDETAIL_UPDATE
ON EMPLOYEEDETAILS
AFTER UPDATE
AS
BEGIN
	PRINT 'Employee record deleted'
END

DROP TRIGGER TR_EMPDETAIL_UPDATE

----DELETE
CREATE OR ALTER TRIGGER TR_EMPDETAIL_DELETE
ON EMPLOYEEDETAILS
AFTER DELETE
AS
BEGIN
	PRINT 'Employee record deleted'
END

DROP TRIGGER TR_EMPDETAIL_DELETE




---2)Create a trigger that fires AFTER INSERT, UPDATE, and DELETE operations on the EmployeeDetails table to log all operations into the EmployeeLog table.

--INSERT

CREATE OR ALTER TRIGGER TR_EMPDETAIL_INSERT
ON EMPLOYEEDETAILS
AFTER INSERT
AS
BEGIN
	DECLARE @EID INT, @ENAME VARCHAR(100)
	SELECT
		@EID = EmployeeID,
		@ENAME = EmployeeName
	FROM inserted

	INSERT INTO EmployeeLogs VALUES
	(@EID, @ENAME, 'INSERTED', GETDATE())
END

DROP TRIGGER TR_EMPDETAIL_INSERT

--UPDATE

CREATE OR ALTER TRIGGER TR_EMPDETAIL_UPDATE
ON EMPLOYEEDETAILS
AFTER UPDATE
AS
BEGIN
	DECLARE @EID INT, @ENAME VARCHAR(100)
	SELECT
		@EID = EmployeeID,
		@ENAME = EmployeeName
	FROM inserted

	INSERT INTO EmployeeLogs VALUES
	(@EID, @ENAME, 'UPDATED', GETDATE())
END

DROP TRIGGER TR_EMPDETAIL_UPDATE


--DELETED

CREATE OR ALTER TRIGGER TR_EMPDETAIL_DELETE
ON EMPLOYEEDETAILS
AFTER DELETE
AS
BEGIN
	DECLARE @EID INT, @ENAME VARCHAR(100)
	SELECT
		@EID = EmployeeID,
		@ENAME = EmployeeName
	FROM inserted

	INSERT INTO EmployeeLogs VALUES
	(@EID, @ENAME, 'DELETED', GETDATE())
END

DROP TRIGGER TR_EMPDETAIL_DELETE

---3)Create a trigger that fires AFTER INSERT to automatically calculate the joining bonus (10% of the salary) for new employees and update a bonus column in the EmployeeDetails table.
CREATE OR ALTER TRIGGER TR_SAL_DECON EMPLOYEEDETAILSAFTER UPDATEAS BEGIN	DECLARE @SALARY DECIMAL(10,2),@EID INT	SELECT @SALARY=SALARY FROM inserted	BEGIN	IF @SALARY=NULL		UPDATE EMPLOYEEDETAILS
		SET Salary=@SALARY*0.1
		WHERE EmployeeID=@EID	ENDEND
---4)Create a trigger to ensure that the JoiningDate is automatically set to the current date if it is NULL during an INSERT operation.
CREATE OR ALTER TRIGGER TR_UP_JDATE
ON EMPLOYEEDETAILS
AFTER UPDATE
AS
BEGIN
	UPDATE EMPLOYEEDETAILS
	SET JoiningDate=GETDATE()
	WHERE EmployeeID IN (SELECT EmployeeID FROM EMPLOYEEDETAILS where JoiningDate IS null)
END
---5)Create a trigger that ensure that ContactNo is valid during insert and update (Like ContactNo length is 10)
CREATE OR ALTER TRIGGER TR_CONTECT
ON EMPLOYEEDETAILS
AFTER INSERT,UPDATE
AS
BEGIN
	DECLARE @MNO VARCHAR(100),@EID int
	SELECT @MNO=ContactNo FROM inserted
	if Len(@MNO)=10
	begin
	UPDATE EMPLOYEEDETAILS
	SET ContactNo=@MNO
	WHERE  EmployeeID=@EID
	END
END