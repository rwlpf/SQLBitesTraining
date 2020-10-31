USE [AdventureWorks2012];

SELECT
    [SalesOrderDetail].[SalesOrderID]
  , MIN([SalesOrderDetail].[UnitPrice])
FROM
    [Sales].[SalesOrderDetail]
GROUP BY
    [SalesOrderDetail].[SalesOrderID]
;

