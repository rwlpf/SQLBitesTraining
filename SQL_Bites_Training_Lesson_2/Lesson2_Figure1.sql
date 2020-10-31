USE [AdventureWorks2012];

SELECT
    [SalesOrderDetail].[SalesOrderID]
  , [SalesOrderDetail].[UnitPrice]
FROM
    [Sales].[SalesOrderDetail]
ORDER BY [SalesOrderDetail].[SalesOrderID]

;