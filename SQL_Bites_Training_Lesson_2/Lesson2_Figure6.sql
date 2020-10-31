USE [AdventureWorks2012];

SELECT
    [SalesOrderDetail].[SalesOrderID]
  , MAX([SalesOrderDetail].[UnitPrice])
FROM
    [Sales].[SalesOrderDetail]
GROUP BY
    [SalesOrderDetail].[SalesOrderID]
;