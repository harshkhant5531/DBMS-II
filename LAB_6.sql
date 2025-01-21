CREATE TABLE Products (
 Product_id INT PRIMARY KEY,
 Product_Name VARCHAR(250) NOT NULL,
 Price DECIMAL(10, 2) NOT NULL
);

CREATE TABLE INSPRODUCT (
 Product_id INT PRIMARY KEY,
 Product_Name VARCHAR(250) NOT NULL,
 Price DECIMAL(10, 2) NOT NULL
);

CREATE TABLE ArchivedProducts (
 Product_id INT PRIMARY KEY,
 Product_Name VARCHAR(250) NOT NULL,
 Price DECIMAL(10, 2) NOT NULL
);


INSERT INTO Products (Product_id, Product_Name, Price) VALUES
(1, 'Smartphone', 35000),
(2, 'Laptop', 65000),
(3, 'Headphones', 5500),
(4, 'Television', 85000),
(5, 'Gaming Console', 32000);

------------------------------------------------------------(PART-A)-----------------------------------------------------------------------------
---1. Create a cursor Product_Cursor to fetch all the rows from a products table.

DECLARE @PID INT,@PNAME VARCHAR(50),@PRICE DECIMAL(10,2)

DECLARE FC_TALL CURSOR
FOR SELECT Product_id,Product_Name,Price  FROM Products

OPEN FC_TALL

FETCH NEXT FROM FC_TALL INTO 
@PID,@PNAME,@PRICE

WHILE @@FETCH_STATUS=0
BEGIN
	PRINT CAST(@PID AS VARCHAR(50))+'-'+@PNAME+'-'+CAST(@PRICE AS VARCHAR(50))
	FETCH NEXT FROM FC_TALL INTO 
	@PID,@PNAME,@PRICE
END

CLOSE FC_TALL

DEALLOCATE FC_TALL

---2. Create a cursor Product_Cursor_Fetch to fetch the records in form of ProductID_ProductName.(Example: 1_Smartphone)

DECLARE @PID INT,@PNAME VARCHAR(50)

DECLARE FC_TALL_ID_NAME CURSOR
FOR SELECT Product_id,Product_Name  FROM Products

OPEN FC_TALL_ID_NAME

FETCH NEXT FROM FC_TALL_ID_NAME INTO 
@PID,@PNAME

WHILE @@FETCH_STATUS=0
BEGIN
	PRINT CAST(@PID AS VARCHAR(50))+'_'+@PNAME
	FETCH NEXT FROM FC_TALL_ID_NAME INTO 
	@PID,@PNAME
END

CLOSE FC_TALL_ID_NAME

DEALLOCATE FC_TALL_ID_NAME

---3. Create a Cursor to Find and Display Products Above Price 30,000.

DECLARE @PID INT,@PNAME VARCHAR(50),@PRICE DECIMAL(10,2)

DECLARE FC_TALL_PRICE CURSOR
FOR SELECT Product_id,Product_Name,Price  FROM Products

OPEN FC_TALL_PRICE

FETCH NEXT FROM FC_TALL_PRICE INTO 
@PID,@PNAME,@PRICE

WHILE @@FETCH_STATUS=0
BEGIN
	IF @PRICE>30000
	BEGIN
	PRINT CAST(@PID AS VARCHAR(50))+'-'+@PNAME+'-'+CAST(@PRICE AS VARCHAR(50))
	END 
	FETCH NEXT FROM FC_TALL_PRICE INTO 
	@PID,@PNAME,@PRICE
END

CLOSE FC_TALL_PRICE

DEALLOCATE FC_TALL_PRICE

---4. Create a cursor Product_CursorDelete that deletes all the data from the Products table

DECLARE @PID INT,@PNAME VARCHAR(50),@PRICE DECIMAL(10,2)

DECLARE FC_TALL_DELETE CURSOR
FOR SELECT Product_id,Product_Name,Price  FROM Products

OPEN FC_TALL_DELETE

FETCH NEXT FROM FC_TALL_DELETE INTO 
@PID,@PNAME,@PRICE

WHILE @@FETCH_STATUS=0
BEGIN

	 DELETE FROM Products
	 WHERE Product_id=@PID

	 FETCH NEXT FROM FC_TALL_DELETE INTO 
	 @PID,@PNAME,@PRICE
END

CLOSE FC_TALL_DELETE

DEALLOCATE FC_TALL_DELETE


-------------------------------------------------------------------------------------(PART-B)-------------------------------------------------------------------------------------------------
---5. Create a cursor Product_CursorUpdate that retrieves all the data from the products table and increases the price by 10%.

DECLARE @PID INT,@PNAME VARCHAR(50),@PRICE DECIMAL(10,2)

DECLARE Product_CursorUpdate CURSOR
FOR SELECT Product_id,Product_Name,Price  FROM Products

OPEN Product_CursorUpdate

FETCH NEXT FROM Product_CursorUpdate INTO 
@PID,@PNAME,@PRICE

WHILE @@FETCH_STATUS=0
BEGIN
	UPDATE Products
	SET @PRICE=@PRICE+@PRICE*0.1
	WHERE Product_id=@PID

	PRINT CAST(@PID AS VARCHAR(50))+'-'+@PNAME+'-'+CAST(@PRICE AS VARCHAR(50))

	FETCH NEXT FROM Product_CursorUpdate INTO 
	@PID,@PNAME,@PRICE
END

CLOSE Product_CursorUpdate

DEALLOCATE Product_CursorUpdate

SELECT *FROM Products

---6. Create a Cursor to Rounds the price of each product to the nearest whole number.
DECLARE @PID INT,@PNAME VARCHAR(50),@PRICE DECIMAL(10,2)

DECLARE Product_CursorUpdate_Round CURSOR
FOR SELECT Product_id,Product_Name,Price  FROM Products

OPEN Product_CursorUpdate_Round

FETCH NEXT FROM Product_CursorUpdate_Round INTO 
@PID,@PNAME,@PRICE

WHILE @@FETCH_STATUS=0
BEGIN
	UPDATE Products
	SET Price=ROUND(@PRICE,0)
	WHERE Product_id=@PID

	PRINT CAST(@PID AS VARCHAR(50))+'-'+@PNAME+'-'+CAST(@PRICE AS VARCHAR(50))+'-'+CAST(@PRICE AS VARCHAR(50))

	FETCH NEXT FROM Product_CursorUpdate_Round INTO 
	@PID,@PNAME,@PRICE
END

CLOSE Product_CursorUpdate_Round

DEALLOCATE Product_CursorUpdate_Round

-------------------------------------------------------------------------------------(PART-C)-------------------------------------------------------------------------------------------------

---7. Create a cursor to insert details of Products into the NewProducts table if the product is “Laptop”(Note: Create NewProducts table first with same fields as Products table)

DECLARE @PID INT,@PNAME VARCHAR(50),@PRICE DECIMAL(10,2)

DECLARE FC_TALL_INSERT CURSOR
FOR SELECT Product_id,Product_Name,Price  FROM Products

OPEN FC_TALL_INSERT

FETCH NEXT FROM FC_TALL_INSERT INTO 
@PID,@PNAME,@PRICE

WHILE @@FETCH_STATUS=0
BEGIN
	IF @PNAME='Laptop'
	BEGIN
	INSERT INTO INSPRODUCT VALUES(@PID,@PNAME,@PRICE)
	PRINT CAST(@PID AS VARCHAR(50))+'-'+@PNAME+'-'+CAST(@PRICE AS VARCHAR(50))
	END
	FETCH NEXT FROM FC_TALL_INSERT INTO 
	@PID,@PNAME,@PRICE
END

CLOSE FC_TALL_INSERT

DEALLOCATE FC_TALL_INSERT
---8. Create a Cursor to Archive High-Price Products in a New Table (ArchivedProducts), Moves productswith a price above 50000 to an archive table, removing them from the original Products table.
DECLARE @PID INT,@PNAME VARCHAR(50),@PRICE DECIMAL(10,2)

DECLARE FC_TALL_INSERT_Delete CURSOR
FOR SELECT Product_id,Product_Name,Price  FROM Products

OPEN FC_TALL_INSERT_Delete

FETCH NEXT FROM FC_TALL_INSERT_Delete INTO 
@PID,@PNAME,@PRICE

WHILE @@FETCH_STATUS=0
BEGIN
	IF @PRICE>50000
	BEGIN

	INSERT INTO ArchivedProducts VALUES(@PID,@PNAME,@PRICE)
	
	DELETE FROM Products
	WHERE Product_id=@PID

	PRINT CAST(@PID AS VARCHAR(50))+'-'+@PNAME+'-'+CAST(@PRICE AS VARCHAR(50))
	END
	FETCH NEXT FROM FC_TALL_INSERT_Delete INTO 
	@PID,@PNAME,@PRICE
END

CLOSE FC_TALL_INSERT_Delete

DEALLOCATE FC_TALL_INSERT_Delete

SELECT *FROM Products