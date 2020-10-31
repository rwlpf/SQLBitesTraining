/*Use a temporary table
 and UPDATE statment using a FROM Clause*/

 CREATE TABLE #SalesOrderTotal
 (
 [SalesOrderID] INT,
 [TotalAmt]  MONEY
 )

 INSERT INTO [#SalesOrderTotal]
     (
         [SalesOrderID]
       , [TotalAmt]
     )
  SELECT
  [SalesOrderID],
  [SubTotal] + [TaxAmt] + [Freight] AS [TotalAmt] 
  FROM    [Sales].[SalesOrderHeader]

UPDATE [Sales].[SalesOrderHeader]
SET [SalesOrderHeader].[TotalAmt] = [#SalesOrderTotal].[TotalAmt] 
FROM [#SalesOrderTotal]
WHERE [SalesOrderHeader].[SalesOrderID] = [#SalesOrderTotal].[SalesOrderID]

/*Tidy up after yourself, there is not magic SQL fairy to do it*/
DROP TABLE #SalesOrderTotal
;