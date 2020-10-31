USE [AdventureWorks2012];

SELECT
    [SalesOrderDetail].[SalesOrderID]
  , COUNT([SalesOrderDetail].[UnitPrice])
FROM
    [Sales].[SalesOrderDetail]
GROUP BY
    [SalesOrderDetail].[SalesOrderID]
;

