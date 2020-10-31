Use AdventureWorks2012;

WITH [Step1]
  AS
  (
  SELECT    TOP 100 PERCENT
            [SalesOrderHeader].[OrderDate]
          , [SalesOrderHeader].[CustomerID]
          , [SalesOrderHeader].[TotalAmt]
  /*cast the date to a suitable format to allow sorting*/
          , CAST(FORMAT([SalesOrderHeader].[OrderDate], 'yyyy') + FORMAT([SalesOrderHeader].[OrderDate], 'MM') AS NVARCHAR(6)) AS [YearMonth]
  FROM        [AdventureWorks2012].[Sales].[SalesOrderHeader]
  WHERE       [SalesOrderHeader].[CustomerID] = 11501
  ORDER BY    [SalesOrderHeader].[OrderDate]
  )
   , [Step2]  AS
  (
  SELECT [Step1].[CustomerID]
       , [Step1].[YearMonth]
       , SUM([Step1].[TotalAmt]) AS [Monthly_Total]
  FROM   [Step1]
  GROUP BY
      [Step1].[CustomerID]
    , [Step1].[YearMonth]
  )
SELECT
    [Step2].[CustomerID] 
  , [Step2].[YearMonth]
  , [Step2].[Monthly_Total]
  , FIRST_VALUE([Step2].[Monthly_Total]) OVER (PARTITION BY [Step2].[CustomerID] ORDER BY [Step2].[YearMonth]) AS [First_Value]
  , LAST_VALUE([Step2].[Monthly_Total]) OVER (ORDER BY [Step2].[YearMonth] ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS [Last_Value]

FROM    [Step2]
