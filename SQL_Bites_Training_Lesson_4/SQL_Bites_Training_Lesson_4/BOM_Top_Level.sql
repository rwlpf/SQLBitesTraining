USE [AdventureWorks2012]
;

SELECT  [BOM].[BillOfMaterialsID]
      , [BOM].[ProductAssemblyID]
      , [BOM].[ComponentID]
      , [BOM].[ProductAssemblyID]
      , [BOM].[ComponentID]
      , [BOM].[BOMLevel]
      , [BOM].[PerAssemblyQty]
      , [P].[ProductID]
      , [P].[Name]
FROM
    [Production].[BillOfMaterials] AS [BOM]
INNER JOIN
    [Production].[Product]         AS [P]
        ON [BOM].[ComponentID] = [P].[ProductID]
WHERE
    (
        [BOM].[ComponentID] = 749
        OR  [BOM].[ProductAssemblyID] = 749
    )
    AND
        (
            [BOM].[EndDate] IS NULL
            OR  [BOM].[EndDate] > GETDATE()
        )
;
