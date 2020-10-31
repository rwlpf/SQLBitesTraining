IF OBJECT_ID (N'fn_TotalSoldToDate', N'IF') IS NOT NULL
  DROP FUNCTION dbo.fn_TotalSoldToDate
GO
CREATE FUNCTION fn_TotalSoldToDate (@ProductID int)
RETURNS TABLE
AS
RETURN
(
SELECT [SODT].ProductID,
       SUM([SODT].OrderQty) AS TotalOrdered
FROM [Sales].[SalesOrderDetail] AS [SODT]
GROUP BY ProductID
HAVING
    [SODT].ProductID = @ProductID
)
GO