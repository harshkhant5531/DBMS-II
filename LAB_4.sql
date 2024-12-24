-----------------------------------------------------(PART-A)-----------------------------------------------------------
---1. Write a function to print "hello world".
CREATE OR ALTER FUNCTION FN_HELLOWORLD()
RETURNS Varchar(50)
AS
BEGIN
RETURN 'HELLO WORLD'
END

SELECT dbo.FN_HELLOWORLD();

---2. Write a function which returns addition of two numbers.
CREATE OR ALTER FUNCTION FN_ADD(@NUM1 INT,@NUM2 INT)
RETURNS INT
AS 
BEGIN
RETURN @NUM1+@NUM2
END

SELECT dbo.FN_ADD(5,10)

---3. Write a function to check whether the given number is ODD or EVEN.
CREATE OR ALTER FUNCTION FN_ODD_EVEN(@NUM INT)
RETURNS VARCHAR(100)
AS
BEGIN
	DECLARE @ANS VARCHAR(100)
	IF @NUM%2=0
		SET @ANS='NUMBER IS EVEN'
	ELSE
		SET @ANS='NUMBER IS ODD'
RETURN @ANS
END

SELECT dbo.FN_ODD_EVEN(2)

---4. Write a function which returns a table with details of a person whose first name starts with B.
CREATE OR ALTER FUNCTION FN_FNAME(@FNAME VARCHAR(50))
RETURNS TABLE
AS

RETURN(
	SELECT * FROM Person
	WHERE  FirstName LIKE @FNAME + '%'
)

SELECT * FROM dbo.FN_FNAME('b')

---5. Write a function which returns a table with unique first names from the person table.
CREATE OR ALTER FUNCTION FN_FNAME_Unique()
RETURNS TABLE
AS

RETURN(SELECT DISTINCT(FirstName) FROM Person)

SELECT * FROM dbo. FN_FNAME_Unique()

---6. Write a function to print number from 1 to N. (Using while loop)
CREATE OR ALTER FUNCTION FN_1_TO_N(@N INT)
RETURNS VARCHAR(100)
AS

BEGIN
	DECLARE @I INT = 1
	DECLARE @RESULT VARCHAR(50) = 1
	
	WHILE @I<=@N
	BEGIN
	SET @I=@I+1
	SET @RESULT = @RESULT + '      '+ CAST(@I AS varchar)
	END
RETURN @RESULT
END

SELECT dbo.FN_1_TO_N (5)

---7. Write a function to find the factorial of a given integer.
CREATE OR ALTER FUNCTION FN_FACT(@N INT)
RETURNS INT
AS
BEGIN
	DECLARE @FACT BIGINT =1
	DECLARE @I INT =1

	WHILE @I <= @N
	BEGIN
	 SET @FACT *= @I
	 SET @I = @I + 1    
	END
RETURN  @FACT
END

SELECT dbo.FN_FACT(5)


--------------------------------------------------(PART-B)----------------------------------------------------------------
---8. Write a function to compare two integers and return the comparison result. (Using Case statement)
CREATE OR ALTER FUNCTION FN_COMPARE_TW0_INTEGER(@N1 INT,@N2 INT)
RETURNS VARCHAR(50)
AS
BEGIN
RETURN
	CASE
		WHEN @N1>@N2 THEN 'N1 IS GREATER'
		WHEN @N2>@N1 THEN 'N2 IS GRAEATER'
		WHEN @N1=@N2 THEN 'N1 AND N2 ARE EQUAL'
		ELSE 'ZERO'
	END
END

SELECT dbo.FN_COMPARE_TW0_INTEGER(2,1)

---9. Write a function to print the sum of even numbers between 1 to 20.
CREATE OR ALTER FUNCTION FN_SUM_EVEN_NUMBER()
RETURNS INT
AS
BEGIN
	DECLARE @SUM INT=0
	DECLARE @N INT=1
	WHILE @N<=20
	BEGIN
		IF @N%2=0
		SET @SUM=@SUM+@N
		SET @N=@N+1
	END
RETURN @SUM
END

SELECT dbo.FN_SUM_EVEN_NUMBER()

---10. Write a function that checks if a given string is a palindrome
CREATE OR ALTER FUNCTION FN_PALINDROME(@N INT)
RETURNS VARCHAR(50)
AS
BEGIN
	IF CAST(@N AS VARCHAR(50))=REVERSE(CAST(@N AS VARCHAR(50)))
		RETURN 'PALINDROME'
		RETURN 'NOT PALINDROME'
END

SELECT dbo.FN_PALINDROME(123)

--------STRING
CREATE OR ALTER FUNCTION FN_PALINDROME_ST(@N VARCHAR(50))
RETURNS VARCHAR(50)
AS
BEGIN
	IF @N=REVERSE(@N)
		RETURN 'PALINDROME'
	    RETURN 'NOT PALINDROME'
END

SELECT dbo.FN_PALINDROME_ST('ABA')

--------------------------------------------------(PART-C)----------------------------------------------------------------
---11. Write a function to check whether a given number is prime or not.
CREATE OR ALTER FUNCTION FN_PRIME_OR_NOT(@N INT)
RETURNS VARCHAR(50)
AS
BEGIN 
	RETURN
    CASE 
        WHEN @N <= 1 THEN 'NOT PRIME'
        WHEN @N= 2 THEN 'PRIME'
        WHEN @N % 2 = 0 THEN 'NOT PRIME'
        ELSE 'PRIME'
    END
END

SELECT dbo.FN_PRIME_OR_NOT(4)

---12. Write a function which accepts two parameters start date & end date, and returns a difference in days.
CREATE OR ALTER FUNCTION FN_SDATE_EDATE(@SDATE DATETIME,@EDATE DATETIME)
RETURNS INT
AS
BEGIN
RETURN DATEDIFF(DAY,@SDATE,@EDATE)
END

SELECT dbo.FN_SDATE_EDATE('2024-11-30','2024-12-30')

---13. Write a function which accepts two parameters year & month in integer and returns total days each year.

---14. Write a function which accepts departmentID as a parameter & returns a detail of the persons.
CREATE OR ALTER FUNCTION FN_ACCEPT_DID(@departmentID INT)
RETURNS TABLE
AS
RETURN
(
    SELECT 
        P.PersonID,
        P.FirstName,
        P.LastName,
        P.Salary,
        P.JoiningDate,
        P.DepartmentID AS PersonDepartmentID,
        P.DesignationID,
        D.DepartmentID AS DeptID,           
        D.DepartmentName
    FROM PERSON P
    INNER JOIN Department D
        ON P.DepartmentID = D.DepartmentID
    WHERE D.DepartmentID = @departmentID
);


---15. Write a function that returns a table with details of all persons who joined after 1-1-1991.
CREATE OR ALTER FUNCTION FN_PERSON_JDATE()
RETURNS TABLE
AS
RETURN ( SELECT * FROM PERSON WHERE JoiningDate>'1991-01-01')

SELECT * FROM FN_PERSON_JDATE()
