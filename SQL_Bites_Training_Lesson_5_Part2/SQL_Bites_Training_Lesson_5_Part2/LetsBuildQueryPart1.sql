SELECT    TOP (100) PERCENT
            [SalesOrderHeader].[OrderDate]
          , [SalesOrderHeader].[CustomerID]
          , [SalesOrderHeader].[TotalAmt]
  /*cast the date to a suitable format to allow sorting*/
          , CAST(FORMAT([SalesOrderHeader].[OrderDate], 'yyyy') 
+ FORMAT([SalesOrderHeader].[OrderDate], 'MM') AS NVARCHAR(6)) AS [YearMonth]
  FROM        [AdventureWorks2012].[Sales].[SalesOrderHeader]
  WHERE       [SalesOrderHeader].[CustomerID] = 11501
  ORDER BY    [SalesOrderHeader].[OrderDate]
