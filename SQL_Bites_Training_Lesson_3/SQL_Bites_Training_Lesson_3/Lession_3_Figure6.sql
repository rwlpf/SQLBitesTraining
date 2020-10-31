/*Using a Common table expression https://www.red-gate.com/simple-talk/sql/t-sql-programming/sql-server-cte-basics/
 and UPDATE statment using a FROM Clause*/

WITH [SalesOrderTotal]
  AS
  (
  SELECT
  [SalesOrderID],
  [SubTotal] + [TaxAmt] + [Freight] AS [TotalAmt] 
  FROM    [Sales].[SalesOrderHeader]
  )

UPDATE  [Sales].[SalesOrderHeader]
SET [SalesOrderHeader].[TotalAmt] = [SalesOrderTotal].[TotalAmt] 
FROM [SalesOrderTotal]
WHERE [SalesOrderHeader].[SalesOrderID] = [SalesOrderTotal].[SalesOrderID]
;