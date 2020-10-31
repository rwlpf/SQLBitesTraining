USE [AdventureWorks2012];

WITH OrgChart_CTE AS 
(
SELECT [BusinessEntityID]
     , [JobTitle]
     , [MgrEntityID] 
	 , CAST([JobTitle] AS VARCHAR(250)) AS OrgChart
FROM [HumanResources].[Employee]
WHERE [MgrEntityID] IS NULL
UNION ALL
SELECT E.[BusinessEntityID]
     , E.[JobTitle]
     , E.[MgrEntityID] 
	 , CAST(OrgChart_CTE.OrgChart + '->' + [E].[JobTitle] AS VARCHAR(250)) AS OrgChart
FROM OrgChart_CTE 
INNER JOIN [HumanResources].[Employee] AS E 
ON [OrgChart_CTE].[BusinessEntityID] = [E].[MgrEntityID]

)
SELECT	[OrgChart_CTE].[BusinessEntityID]
      , [OrgChart_CTE].[MgrEntityID]
      , [OrgChart_CTE].[OrgChart]
FROM OrgChart_CTE
ORDER BY [OrgChart_CTE].[BusinessEntityID]