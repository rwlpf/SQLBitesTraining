USE [AdventureWorks2012];

/*===========================================
Anchor query
============================================*/
SELECT [BusinessEntityID]
     , [JobTitle]
     , [MgrEntityID] 
	 , CAST([JobTitle] AS VARCHAR(250)) AS OrgChart
FROM [HumanResources].[Employee]
WHERE [MgrEntityID] IS NULL

/*============================================*/

;
WITH OrgChart_CTE AS 
(
SELECT [BusinessEntityID]
     , [JobTitle]
     , [MgrEntityID] 
	 , CAST([JobTitle] AS VARCHAR(250)) AS OrgChart
FROM [HumanResources].[Employee]
WHERE [MgrEntityID] IS NULL
)

SELECT E.[BusinessEntityID]
     , E.[JobTitle]
     , E.[MgrEntityID] 
	 , CAST(OrgChart_CTE.OrgChart + '->' + [E].[JobTitle] AS VARCHAR(250)) AS OrgChart
FROM OrgChart_CTE 
INNER JOIN [HumanResources].[Employee] AS E 
ON [OrgChart_CTE].[BusinessEntityID] = [E].[MgrEntityID]