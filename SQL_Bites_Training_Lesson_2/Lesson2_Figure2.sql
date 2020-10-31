USE [AdventureWorks2012];

SELECT
   DISTINCT([SalesOrderDetail].[SalesOrderID])
FROM
    [Sales].[SalesOrderDetail]
GROUP BY
    [SalesOrderDetail].[SalesOrderID]
;