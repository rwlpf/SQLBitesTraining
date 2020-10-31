SET STATISTICS IO ON;
SET STATISTICS TIME ON ;

/****** Script for SelectTopNRows command from SSMS  ******/
SELECT  [ProductID]
      ,[LocationID]
      ,[Shelf]
      ,[Bin]
      ,[Quantity]
      ,[rowguid]
      ,[ModifiedDate]
	  , dbo.[ufnGetStock]([ProductID]) AS Stock 
  FROM [AdventureWorks2012].[Production].[ProductInventory]

  --SELECT 
	 --  [ProductID]
  --    ,[LocationID]
  --    ,[Shelf]
  --    ,[Bin]
  --    ,[Quantity]
  --    ,[rowguid]
  --    ,[ModifiedDate]
	 -- ,Stock.[Level]
  --FROM [Production].[ProductInventory] AS ProdInv
  --CROSS APPLY
  --(SELECT [dbo].[ufnGetStock](ProdInv.ProductID)AS [Level] ) AS [Stock]

SET STATISTICS IO OFF;
SET STATISTICS TIME OFF ;