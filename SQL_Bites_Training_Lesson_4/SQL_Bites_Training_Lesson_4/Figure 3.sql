USE [AdventureWorks2012];
;
WITH WasherProducts
 AS 
(
SELECT [ProductID]
      ,[Name]
      ,[ProductNumber]
      ,[ProductSubcategoryID]
      ,[ProductModelID]
  FROM [AdventureWorks2012].[Production].[Product]
  WHERE [Name] LIKE '%Was%'
  )
  SELECT [WasherProducts].[ProductID]
       , [WasherProducts].[Name]
       , [WasherProducts].[ProductNumber]
       , [WasherProducts].[ProductSubcategoryID]
       , [WasherProducts].[ProductID] 
  FROM [WasherProducts]

  SELECT [WasherProducts].[ProductID]
       , [WasherProducts].[Name]
       , [WasherProducts].[ProductNumber]
       , [WasherProducts].[ProductSubcategoryID]
       , [WasherProducts].[ProductID] 
  FROM [WasherProducts]