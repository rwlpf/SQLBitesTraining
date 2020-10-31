USE [AdventureWorks2012];

SELECT
    [SalesOrderDetail].[SalesOrderID]
  , SUM([SalesOrderDetail].[UnitPrice]) AS TotalUnitPrice
FROM
    [Sales].[SalesOrderDetail]
GROUP BY
    [SalesOrderDetail].[SalesOrderID]
HAVING SUM([SalesOrderDetail].[UnitPrice]) > 25000
;