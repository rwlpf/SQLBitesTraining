USE [AdventureWorks2012];

/*Find all SalesOrderID’s with an individual maximum value of over 2,100 order results, 
has more than 35 unit price records order by count of unit price records*/

SELECT
    [SalesOrderDetail].[SalesOrderID]
  , COUNT([SalesOrderDetail].[UnitPrice]) AS CountOfUnitPrice
  , MIN([SalesOrderDetail].[UnitPrice]) AS MinUnitPrice
FROM
    [Sales].[SalesOrderDetail]
GROUP BY
    [SalesOrderDetail].[SalesOrderID]
HAVING COUNT([SalesOrderDetail].[UnitPrice]) > 70
ORDER BY COUNT([SalesOrderDetail].[UnitPrice]) ASC
