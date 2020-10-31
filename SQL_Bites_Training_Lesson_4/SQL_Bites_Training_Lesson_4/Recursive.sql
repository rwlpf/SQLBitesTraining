USE [AdventureWorks2012];

WITH CTE_ComponentList
AS (SELECT 0 AS ParentComponent,
           [BOM].[BillOfMaterialsID],
           [BOM].[ProductAssemblyID],
           [BOM].[ComponentID],
           [BOM].[BOMLevel],
           [BOM].[PerAssemblyQty],
           [BOM].[EndDate],
           [P].[ProductID],
           [P].[Name],
           /*set the product level at 1 to be the same as the [BOM].[BOMLevel]
	  ProductLevel Set to Zero*/
           0 AS [ProductLevel],
           CAST([P].[ProductID] AS VARCHAR(200)) AS AssemblyChain,
           CAST(P.Name AS VARCHAR(100)) AS Sort
    FROM [Production].[BillOfMaterials] AS [BOM]
        INNER JOIN [Production].[Product] AS [P]
            ON [BOM].[ComponentID] = [P].[ProductID]
    WHERE 
          (
              ([BOM].[EndDate] IS NULL)
              OR ([BOM].[EndDate] > GETDATE())
          )
          AND [BOM].[ProductAssemblyID] IS NULL
    UNION ALL
    SELECT [CTE_ComponentList].[ProductID] AS ParentComponent,
           [P_BOM].[BillOfMaterialsID] AS [BillOfMaterialsID],
           [P_BOM].[ProductAssemblyID],
           [P_BOM].[ComponentID],
           [P_BOM].[BOMLevel],
           [P_BOM].[PerAssemblyQty],
           [P_BOM].[EndDate] AS [EndDate],
           [P].[ProductID],
           [P].[Name],
           [CTE_ComponentList].[ProductLevel] + 1 AS [ProductLevel],
           CAST([CTE_ComponentList].[AssemblyChain] + '->' + CAST([P].[ProductID] AS VARCHAR(20)) AS VARCHAR(200)) AS AssemblyChain,
           CAST([CTE_ComponentList].Sort + '\' + P.Name AS VARCHAR(100)) AS Sort
    FROM [CTE_ComponentList]
        INNER JOIN [Production].[BillOfMaterials] AS [P_BOM]
            ON [CTE_ComponentList].[ProductID] = [P_BOM].[ProductAssemblyID]
        INNER JOIN [Production].[Product] AS P
            ON [P_BOM].[ComponentID] = [P].[ProductID]
    WHERE (
			  [P_BOM].[EndDate] IS NULL
			   OR [P_BOM].[EndDate] > GETDATE()
          ))
SELECT [CTE_ComponentList].[ProductAssemblyID],
       [CTE_ComponentList].[ProductID],
       [CTE_ComponentList].[AssemblyChain],
       [CTE_ComponentList].[Name],
       [CTE_ComponentList].[Sort],
       [CTE_ComponentList].[ProductLevel],
       [CTE_ComponentList].[PerAssemblyQty]
FROM [CTE_ComponentList]
ORDER BY [CTE_ComponentList].[ProductLevel];



