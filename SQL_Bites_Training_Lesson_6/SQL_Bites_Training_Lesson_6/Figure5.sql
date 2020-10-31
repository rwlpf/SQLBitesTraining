/*Method 1 - Inline function call*/

SELECT [P].[ProductID],
       [P].[Name],
       [P].[ProductNumber],
	   [dbo].[ufnGetStock]([P].[ProductID]) AS [StockLevel]
FROM [Production].[Product] AS [P]
WHERE [P].[FinishedGoodsFlag] = 1;

/*Method 2 - Call function using cross apply*/

SELECT [P].[ProductID],
       [P].[Name],
       [P].[ProductNumber],
	   [Stock].[Level]
FROM [Production].[Product] AS [P]
CROSS APPLY 
(SELECT [dbo].[ufnGetStock]([P].[ProductID]) AS [Level]) AS [Stock]
WHERE [P].[FinishedGoodsFlag] = 1;
