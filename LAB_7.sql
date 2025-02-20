

-- Create the Customers table
CREATE TABLE Customers (
 Customer_id INT PRIMARY KEY,
 Customer_Name VARCHAR(250) NOT NULL,
 Email VARCHAR(50) UNIQUE
);
-- Create the Orders table
CREATE TABLE Orders (
 Order_id INT PRIMARY KEY,
 Customer_id INT,
 Order_date DATE NOT NULL,
 FOREIGN KEY (Customer_id) REFERENCES Customers(Customer_id)
);
---------------------------------------------------------------(PART-A)-----------------------------------------------------------------------

---1. Handle Divide by Zero Error and Print message like: Error occurs that is - Divide by zero error.
BEGIN TRY
	DECLARE @N1 INT =5,@N2 INT =0,@ANS INT
	SET @ANS=@N1/@N2
	PRINT @ANS
END TRY
BEGIN CATCH
	PRINT 'ERROR: Divide by zero error'
END CATCH

---2. Try to convert string to integer and handle the error using try…catch block.
BEGIN TRY
	DECLARE @N1 VARCHAR(50) ='HARSH',@ANS INT
	SET @ANS=CAST(@N1 AS INT)
	PRINT @ANS
END TRY
BEGIN CATCH
	PRINT 'ERROR: String not converted into integer'
END CATCH

---3. Create a procedure that prints the sum of two numbers: take both numbers as integer & handle exception with all error functions if any one enters string value in numbers otherwise print result.
CREATE OR ALTER PROCEDURE PR_EXC_TWO_NUM_INT
@N1 VARCHAR(50),
@N2 VARCHAR(50)
AS
BEGIN
	DECLARE @ANS INT
	BEGIN TRY
	SET @ANS=CAST(@N1 AS INT)+CAST(@N2 AS INT)
	PRINT @ANS
	END TRY
	
	BEGIN CATCH
	PRINT CAST(ERROR_MESSAGE() AS VARCHAR(50))
	PRINT CAST(ERROR_NUMBER() AS VARCHAR(50))
	PRINT CAST(ERROR_SEVERITY()  AS VARCHAR(50))
	PRINT CAST(ERROR_STATE() AS VARCHAR(50))
	PRINT CAST(ERROR_LINE() AS VARCHAR(50))
	END CATCH
END

EXEC PR_EXC_TWO_NUM_INT 5,'HARSH'

---4. Handle a Primary Key Violation while inserting data into customers table and print the error details such as the error message, error number, severity, and state.
BEGIN TRY
	INSERT INTO  Customers VALUES(1,'HARSH','abc@gmail.com')
	INSERT INTO  Customers VALUES(2,'MEET','jani@gmail.com')
END TRY
BEGIN CATCH
	PRINT CAST(ERROR_MESSAGE() AS VARCHAR(50))
	PRINT CAST(ERROR_NUMBER() AS VARCHAR(50))
	PRINT CAST(ERROR_SEVERITY()  AS VARCHAR(50))
	PRINT CAST(ERROR_STATE() AS VARCHAR(50))
	PRINT CAST(ERROR_LINE() AS VARCHAR(50))
END CATCH

---5. Throw custom exception using stored procedure which accepts Customer_id as input & that throws Error like no Customer_id is available in database.
CREATE OR ALTER PROCEDURE PR_INPUT_ERR_PRC
@PID INT
AS
BEGIN
	BEGIN TRY
	IF NOT EXISTS(SELECT Customer_id FROM Customers WHERE Customer_id=@PID)
	THROW 60000,'Error like no Customer_id is available in database',2
	END TRY
	BEGIN CATCH
	PRINT CAST(ERROR_MESSAGE() AS VARCHAR(50))
	PRINT CAST(ERROR_NUMBER() AS VARCHAR(50))
	PRINT CAST(ERROR_SEVERITY()  AS VARCHAR(50))
	PRINT CAST(ERROR_STATE() AS VARCHAR(50))
	PRINT CAST(ERROR_LINE() AS VARCHAR(50))
	END CATCH
END

EXEC PR_INPUT_ERR_PRC 1
SELECT * FROM Customers

---------------------------------------------------------(PART-B)----------------------------------------------------------------------------
---6. Handle a Foreign Key Violation while inserting data into Orders table and print appropriate error message.
	BEGIN TRY
		INSERT INTO Orders
		VALUES(1,1,'2025-02-12')
	END TRY
	BEGIN CATCH
		PRINT 'Foreign Key Violation while inserting data into Orders'
	END CATCH

	SELECT * FROM Customers
	SELECT * FROM Orders

--7. Throw custom exception that throws error if the data is invalid.
	CREATE OR ALTER PROCEDURE PR_CUSTOM_DATA_VALIDATON
	@CNAME VARCHAR(10)
	AS 
	BEGIN
			IF LEN(@CNAME) = 0
				BEGIN
				THROW 51000,'DATA INVALID',1
				END
			ELSE
				BEGIN
					PRINT 'DATA IS ALLOWED'
				END
	END

	EXEC PR_CUSTOM_DATA_VALIDATON ''
	EXEC PR_CUSTOM_DATA_VALIDATON 'HARSH'

--8. Create a Procedure to Update Customer’s Email with Error Handling
	CREATE OR ALTER PROCEDURE PR_CUSTOM_EMAIL_UPDATE
	@EMAIL VARCHAR(50),
	@UEMAIL VARCHAR(50)
	AS 
	BEGIN
			BEGIN TRY 
				update Customers
				set Email = @UEMAIL
				where Email = @EMAIL
			END TRY
			BEGIN CATCH
				PRINT ERROR_MESSAGE()
				PRINT ERROR_NUMBER()
				PRINT ERROR_STATE()
			END CATCH
	END

	EXEC PR_CUSTOM_EMAIL_UPDATE 'HASRH@GMAIL.COM','DEV@GMAIL.COM'
	EXEC PR_CUSTOM_EMAIL_UPDATE 'HARSHKHANT@GMAIL.COM','DEV@GMAIL.COM'

	select * from Customers


--Part – C

--9. Create a procedure which prints the error message that “The Customer_id is already taken. Try another one”.
	BEGIN TRY
		INSERT INTO Customers
		VALUES(2,'HASRGH','HASRFSH44@GMAIL.COM')
	END TRY
	BEGIN CATCH
		PRINT 'The Customer_id is already taken. Try another one'
	END CATCH

	SELECT * FROM Customers

--10. Handle Duplicate Email Insertion in Customers Table.
	BEGIN TRY
		INSERT INTO Customers
		VALUES(2,'HASRH','HASRFSH44@GMAIL.COM')
	END TRY
	BEGIN CATCH
		PRINT 'Email is already exists please Try another one'
	END CATCH

	SELECT * FROM Customers