USE [AdventureWorks2012];
;
WITH WasherProducts
(
[ProdID],
[Name_],
[ProdNumber],
[ProdSubcategoryID],
[ProdModelID]
)
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
  SELECT [WasherProducts].[ProdID]
       , [WasherProducts].[Name_]
       , [WasherProducts].[ProdNumber]
       , [WasherProducts].[ProdSubcategoryID]
       , [WasherProducts].[ProdModelID] 
  FROM [WasherProducts]
