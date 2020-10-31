  SELECT  
    [BOM].[ProductAssemblyID]
  , [BOM].[ComponentID]
  , [BOM].[BOMLevel]
  , [P].[ProductID]
  , [P].[Name]
  , [P].[ProductNumber]
  , [BOM].[PerAssemblyQty]

  FROM [AdventureWorks2012].[Production].[BillOfMaterials] AS BOM
  INNER JOIN [Production].[Product] AS P  ON [BOM].[ComponentID] = [P].[ProductID]
  WHERE 
  [BOM].[ProductAssemblyID] = 3

