SELECT * FROM [Production].[Product] WHERE  [Product].[ProductID] = 717

SELECT * FROM [Production].[BillOfMaterials] AS BOM
INNER JOIN [Production].[Product] AS P ON [BOM].[ComponentID] = [P].[ProductID]
WHERE [BOM].[BillOfMaterialsID] = 3108

