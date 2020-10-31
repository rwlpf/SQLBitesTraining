USE AdventureWorks2012;
GO
SELECT SalesPersonID
  , SalesYear
  , TotalSales
  , SalesQuotaYear
  , SalesQuota
FROM ( -- First Subquery
       SELECT SalesPersonID
            , SUM(TotalDue) AS TotalSales
            , YEAR(OrderDate) AS SalesYear
       FROM Sales.SalesOrderHeader
       WHERE SalesPersonID IS NOT NULL
       GROUP BY SalesPersonID, YEAR(OrderDate)
	) AS Sales 
JOIN ( -- Second Subquery
       SELECT BusinessEntityID
            , SUM(SalesQuota)AS SalesQuota
            , YEAR(QuotaDate) AS SalesQuotaYear
       FROM Sales.SalesPersonQuotaHistory
       GROUP BY BusinessEntityID, YEAR(QuotaDate)
	) AS Sales_Quota 
ON Sales_Quota.BusinessEntityID = Sales.SalesPersonID
AND Sales_Quota.SalesQuotaYear = Sales.SalesYear   
ORDER BY SalesPersonID, SalesYear;