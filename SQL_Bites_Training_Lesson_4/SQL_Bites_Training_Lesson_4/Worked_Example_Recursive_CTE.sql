 CREATE TABLE #CTE_ComponentList
 (
 ParentComponent INTEGER,
 [BillOfMaterialsID] INTEGER,
 [ProductAssemblyID] INTEGER,
 [ComponentID] INTEGER,
 [BOMLevel] INTEGER,
 [PerAssemblyQty] DECIMAL(8,2),
 [EndDate] DATETIME,
 [ProductID]  INTEGER,
 [Name] NVARCHAR(200),
 [ProductLevel] INTEGER,
 AssemblyChain VARCHAR(200) COLLATE SQL_Latin1_General_CP1_CI_AS,
 Sort VARCHAR(100) COLLATE SQL_Latin1_General_CP1_CI_AS
 ) 

  CREATE TABLE #CTE_ComponentList_Step2
 (
 ParentComponent INTEGER,
 [BillOfMaterialsID] INTEGER,
 [ProductAssemblyID] INTEGER,
 [ComponentID] INTEGER,
 [BOMLevel] INTEGER,
 [PerAssemblyQty] DECIMAL(8,2),
 [EndDate] DATETIME,
 [ProductID]  INTEGER,
 [Name] NVARCHAR(200),
 [ProductLevel] INTEGER,
 AssemblyChain VARCHAR(200) COLLATE SQL_Latin1_General_CP1_CI_AS,
 Sort VARCHAR(100) COLLATE SQL_Latin1_General_CP1_CI_AS
 ) 


--INSERT INTO #CTE_ComponentList
--SELECT 0 AS ParentComponent,
--       [BOM].[BillOfMaterialsID],
--       [BOM].[ProductAssemblyID],
--       [BOM].[ComponentID],
--       [BOM].[BOMLevel],
--       [BOM].[PerAssemblyQty],
--       [BOM].[EndDate],
--       [P].[ProductID],
--       [P].[Name],
--       /*set the product level at 1 to be the same as the [BOM].[BOMLevel]
--	  ProductLevel Set to Zero*/
--       0 AS [ProductLevel],
--       CAST([P].[ProductID] AS VARCHAR(200)) AS AssemblyChain,
--       CAST(P.Name AS VARCHAR(100)) AS Sort
--FROM [Production].[BillOfMaterials] AS [BOM]
--    INNER JOIN [Production].[Product] AS [P]
--        ON [BOM].[ComponentID] = [P].[ProductID]
--WHERE ([BOM].[ComponentID] = 749)
--      AND
--      (
--          ([BOM].[EndDate] IS NULL)
--          OR ([BOM].[EndDate] > GETDATE())
--      )
 
	 SELECT		ParentComponent,
                BillOfMaterialsID,
                ProductAssemblyID,
                ComponentID,
                BOMLevel,
                PerAssemblyQty,
                EndDate,
                ProductID,
                Name,
                ProductLevel,
                AssemblyChain,
                Sort 
	FROM #CTE_ComponentList

	INSERT INTO [#CTE_ComponentList_Step2]
    SELECT 
		   [#CTE_ComponentList].[ProductID] AS ParentComponent,
           [P_BOM].[BillOfMaterialsID] AS [BillOfMaterialsID],
           [P_BOM].[ProductAssemblyID],
           [P_BOM].[ComponentID],
           [P_BOM].[BOMLevel],
           [P_BOM].[PerAssemblyQty],
           [P_BOM].[EndDate] AS [EndDate],
           [P].[ProductID],
           [P].[Name],
           [#CTE_ComponentList].[ProductLevel] + 1 AS [ProductLevel],
           CAST([#CTE_ComponentList].[AssemblyChain] + '->' + CAST([P].[ProductID] AS VARCHAR(20)) AS VARCHAR(200)) AS AssemblyChain,
           CAST([#CTE_ComponentList].Sort + '\' + P.Name AS VARCHAR(100)) AS Sort
    FROM [#CTE_ComponentList]
        INNER JOIN [Production].[BillOfMaterials] AS [P_BOM]
            ON [#CTE_ComponentList].[ProductID] = [P_BOM].[ProductAssemblyID]
        INNER JOIN [Production].[Product] AS P
            ON [P_BOM].[ComponentID] = [P].[ProductID]
    WHERE (
			  [P_BOM].[EndDate] IS NULL
			   OR [P_BOM].[EndDate] > GETDATE()
          )
	UNION ALL
	SELECT		ParentComponent,
                BillOfMaterialsID,
                ProductAssemblyID,
                ComponentID,
                BOMLevel,
                PerAssemblyQty,
                EndDate,
                ProductID,
                Name,
                ProductLevel,
                AssemblyChain,
                Sort 
	FROM #CTE_ComponentList

	SELECT * FROM #CTE_ComponentList_Step2
	ORDER BY ParentComponent

	DROP TABLE #CTE_ComponentList
	DROP TABLE #CTE_ComponentList_Step2