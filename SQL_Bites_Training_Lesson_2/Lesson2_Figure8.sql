USE [AdventureWorks2012];

SELECT
    [SalesOrderDetail].[SalesOrderID]
  , COUNT([SalesOrderDetail].[UnitPrice]) AS CountOfUnitPrice
  , MIN([SalesOrderDetail].[UnitPrice]) AS MinUnitPrice
FROM
    [Sales].[SalesOrderDetail]
GROUP BY
    [SalesOrderDetail].[SalesOrderID]
HAVING COUNT([SalesOrderDetail].[UnitPrice]) > 70
 