USE [AdventureWorks2012];
;
WITH WasherProducts
 AS 
(
SELECT [ProductID]
      ,[Name] AS product_
      ,[ProductNumber]
      ,[ProductSubcategoryID]
      ,[ProductModelID]
  FROM [AdventureWorks2012].[Production].[Product]
  WHERE [Name] LIKE '%Was%'
  )
  SELECT [WasherProducts].[ProductID]
       , [WasherProducts].[product_]
       , [WasherProducts].[ProductNumber]
       , [WasherProducts].[ProductSubcategoryID]
       , [WasherProducts].[ProductModelID] 
  FROM [WasherProducts]
