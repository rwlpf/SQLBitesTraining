SELECT [BOM].[BillOfMaterialsID]
     , [BOM].[ComponentID]
     , [BOM].[BOMLevel]
     , [P].[Name]
  FROM 
    [Production].[BillOfMaterials] AS [BOM]
	INNER JOIN  [Production].[Product] AS [P] ON [BOM].[ComponentID] = [P].[ProductID]
	WHERE [BOM].[BOMLevel] = 0 -- Top level component
	AND [P].[ProductSubcategoryID]	= 2 -- Road Bikes