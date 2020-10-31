USE AdventureWorks2012;
GO
-- First Subquery rewritten as CTE
WITH Sales AS
(
    SELECT SalesPersonID
         , SUM(TotalDue) AS TotalSales
         , YEAR(OrderDate) AS SalesYear
    FROM Sales.SalesOrderHeader
    WHERE SalesPersonID IS NOT NULL
    GROUP BY SalesPersonID, YEAR(OrderDate)
),
-- Second Subquery rewritten as CTE
Sales_Quota AS
( 
    SELECT BusinessEntityID
         , SUM(SalesQuota)AS SalesQuota
         , YEAR(QuotaDate) AS SalesQuotaYear
    FROM Sales.SalesPersonQuotaHistory
    GROUP BY BusinessEntityID, YEAR(QuotaDate)
)  
-- SELECT using multiple CTEs
SELECT SalesPersonID
     , SalesYear
     , TotalSales
     , SalesQuotaYear
     , SalesQuota
FROM Sales
  JOIN Sales_Quota 
    ON Sales_Quota.BusinessEntityID = Sales.SalesPersonID
        AND Sales_Quota.SalesQuotaYear = Sales.SalesYear  
ORDER BY SalesPersonID, SalesYear;