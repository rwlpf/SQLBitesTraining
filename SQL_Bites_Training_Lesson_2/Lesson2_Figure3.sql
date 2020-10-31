USE [AdventureWorks2012];

SELECT
    [SalesOrderDetail].[SalesOrderID]
  , SUM([SalesOrderDetail].[UnitPrice])
FROM
    [Sales].[SalesOrderDetail]
GROUP BY
    [SalesOrderDetail].[SalesOrderID]
;

