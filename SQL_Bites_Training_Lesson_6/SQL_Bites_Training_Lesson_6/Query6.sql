DBCC FREEPROCCACHE

SET STATISTICS TIME ON;
SET STATISTICS IO ON;

SELECT [AllSalesPersonOrders].[RN],
       [AllSalesPersonOrders].[SalesPersonID],
       [AllSalesPersonOrders].[TotalAmt],
       [AllSalesPersonOrders].[OrderDate],
       [AllSalesPersonOrders].[SalesQuota]
FROM
(
    SELECT ROW_NUMBER() OVER (PARTITION BY [SOH].[SalesPersonID] ORDER BY [SOH].[OrderDate]) AS [RN],
           [SOH].[SalesPersonID],
           [SOH].[TotalAmt],
           [SOH].[OrderDate],
           [SP].[SalesQuota]
    FROM [Sales].[SalesOrderHeader] AS [SOH]
        INNER JOIN [Sales].[SalesPerson] AS [SP]
            ON [SP].[BusinessEntityID] = [SOH].[SalesPersonID]
    WHERE [SOH].[SalesPersonID] IS NOT NULL
) AS [AllSalesPersonOrders]
WHERE [AllSalesPersonOrders].[RN] <= 3;

SET STATISTICS TIME OFF;
SET STATISTICS IO OFF;