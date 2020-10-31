SET STATISTICS TIME ON;
SET STATISTICS IO ON;

SELECT [SP].[BusinessEntityID],
       [SP].[SalesQuota],
       [SOHFigures].[OrderDate],
	   [SOHFigures].[TotalAmt]
FROM [Sales].[SalesPerson] AS [SP]
CROSS APPLY
(
    SELECT TOP 3
           [SOH].[TotalAmt],
           [SOH].[OrderDate]
    FROM [Sales].[SalesOrderHeader] AS [SOH]
    WHERE [SOH].[SalesPersonID] = [SP].[BusinessEntityID]
) AS [SOHFigures];

SET STATISTICS TIME OFF;
SET STATISTICS IO OFF;