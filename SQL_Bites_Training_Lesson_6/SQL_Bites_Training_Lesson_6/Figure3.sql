SELECT [P].[ProductID],
       [P].[Name],
       [P].[ProductNumber],
	   [PS].[TotalOrdered]
FROM [Production].[Product] AS [P]
CROSS APPLY [dbo].[fn_TotalSoldToDate]([P].ProductID) AS [PS]
WHERE [P].[FinishedGoodsFlag] = 1;