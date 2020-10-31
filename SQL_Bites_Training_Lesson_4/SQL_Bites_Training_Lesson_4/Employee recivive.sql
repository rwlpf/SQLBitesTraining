--SELECT HRE.[BusinessEntityID]
--     , HRE.[MgrEntityID]

--FROM [HumanResources].[Employee] AS HRE
--WHERE hre.[BusinessEntityID] = 27

;
WITH OrgChart_CTE AS 
(
SELECT [BusinessEntityID]
     , [NationalIDNumber]
     , [LoginID]
     , [OrganizationNode]
     , [OrganizationLevel]
     , [JobTitle]
     , [MgrEntityID] 
	 , CAST([JobTitle] AS VARCHAR(250)) AS OrgChart
FROM [HumanResources].[Employee]
WHERE [MgrEntityID] IS NULL
UNION ALL
SELECT E.[BusinessEntityID]
     , E.[NationalIDNumber]
     , E.[LoginID]
     , E.[OrganizationNode]
     , E.[OrganizationLevel]
     , E.[JobTitle]
     , E.[MgrEntityID] 
	 , CAST(OrgChart_CTE.OrgChart + '->' + [E].[JobTitle] AS VARCHAR(250)) AS OrgChart
FROM OrgChart_CTE 
INNER JOIN [HumanResources].[Employee] AS E ON [OrgChart_CTE].[BusinessEntityID] = [E].[MgrEntityID]

)
SELECT *
FROM OrgChart_CTE
ORDER BY [OrgChart_CTE].[BusinessEntityID]