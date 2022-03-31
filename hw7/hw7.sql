
SELECT 2 + 2;

-- -------------------------------------- 1 --------------------------------
-- Write the following script: 
-- Add new number not nullable column to SalesOrderDetail table
-- Populate added column using DML with values from SalesOrderID column 
-- Display  from SalesOrderHeader: SalesOrderId, CustomerId,
-- from SalesOrderDetail: SalesOrderDetailId
-- (write two queries to join using existing column and new added)
-- Compare execution plans for two queries and explain the difference:
-- which one will be more optimal and why
-- Delete added column

ALTER TABLE Sales.SalesOrderDetail
ADD bh_new_number INT NULL;
GO

UPDATE Sales.SalesOrderDetail
SET bh_new_number = SalesOrderID
-- for whole table for some reason this works ridiculously long
WHERE SalesOrderID BETWEEN 44000 AND 44100;
GO

-- using the clustered index and merge join. Note that
-- Merge join is used when projections of the joined tables are sorted on the join columns.
SELECT h.SalesOrderID, CustomerID, SalesOrderDetailId
FROM Sales.SalesOrderHeader AS h
JOIN Sales.SalesOrderDetail AS d
ON h.SalesOrderID = d.SalesOrderID
WHERE h.SalesOrderID BETWEEN 44000 AND 44100;

-- this uses nested loops for inner join, which is a logical structure
-- in which one loop (iteration) resides inside another one
-- so basically insted of merge join we do complete scan here
SELECT h.SalesOrderID, CustomerID, SalesOrderDetailId
FROM Sales.SalesOrderHeader AS h
JOIN Sales.SalesOrderDetail AS d
ON h.SalesOrderID = d.bh_new_number
WHERE h.SalesOrderID BETWEEN 44000 AND 44100;

-- Clearly the first one will be more optimal, as it uses much more efficient 
-- way to conduct a join (merge is conduccted over sorted columns)

ALTER TABLE Sales.SalesOrderDetail
DROP COLUMN bh_new_number;
GO

-- -------------------------------- 2 ------------------------------------
-- Write the following script and run it as one transaction
-- (it is not required to write it as stored procedure,
-- pass only necessary columns’ values or leave default)
--      Insert new order into SalesOrderHeader
--      Using one of system functions: @@IDENTITY, SCOPE_IDENTITY(), IDENT_CURRENT() 
--      insert new order’s detail into SalesOrderDetail
--      Returns SalesOrderId

SELECT TOP 1 * FROM Sales.SalesOrderHeader;

BEGIN TRANSACTION

INSERT INTO Sales.SalesOrderHeader (
    RevisionNumber, OrderDate, DueDate,
    ShipDate, [Status], OnlineOrderFlag,
    CustomerID, BillToAddressID, ShipToAddressID,
    ShipMethodID)
VALUES (
    12, GETDATE(), GETDATE(), GETDATE(), 5, 0, 1, 1, 1, 1
);
GO

UPDATE Sales.SalesOrderHeader
SET TerritoryID = 1
WHERE SalesOrderID = @@IDENTITY
GO

SELECT * FROM Sales.SalesOrderHeader WHERE SalesOrderID = @@IDENTITY;

COMMIT TRANSACTION;
