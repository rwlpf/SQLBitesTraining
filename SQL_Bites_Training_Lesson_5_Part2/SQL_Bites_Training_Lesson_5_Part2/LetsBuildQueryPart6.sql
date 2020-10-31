USE [AdventureWorks2012];
;
WITH
[Step1]
AS (SELECT [SalesOrderHeader].[OrderDate]
         , [SalesOrderHeader].[TotalAmt]
         /*cast the date to a suitable format to allow sorting*/
         , CAST(FORMAT([SalesOrderHeader].[OrderDate], 'yyyy') + FORMAT([SalesOrderHeader].[OrderDate], 'MM') AS NVARCHAR(6)) AS [YearMonth]
		 , CAST(FORMAT([SalesOrderHeader].[OrderDate], 'yyyy')AS NVARCHAR(4)) AS [Year]
    FROM [AdventureWorks2012].[Sales].[SalesOrderHeader])
,
[Step2]
AS (SELECT [Step1].[YearMonth]
         , SUM([Step1].[TotalAmt]) AS [Monthly_Total]
		 , [Step1].[Year]
    FROM [Step1]
    GROUP BY [Step1].[YearMonth], [Step1].[Year])
SELECT 
	   [Step2].[Year]
	 , [Step2].[YearMonth]
     , [Step2].[Monthly_Total]
	 , SUM([Step2].[Monthly_Total]) OVER (ORDER BY [Step2].[YearMonth] 
	 ROWS BETWEEN 5 PRECEDING AND CURRENT ROW) AS Rolling6MonthSum
FROM [Step2]
ORDER BY [Step2].[YearMonth];
