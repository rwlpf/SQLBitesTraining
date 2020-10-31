Use AdventureWorks2012;

SELECT [Employee].[LoginID]
     , [Employee].[OrganizationLevel]
     , [Employee].[SickLeaveHours]
     , CAST([Employee].[SickLeaveHours] AS DECIMAL(6, 2))
       / CAST(SUM([Employee].[SickLeaveHours]) 
	   OVER (PARTITION BY [Employee].[OrganizationLevel]) AS DECIMAL(6, 2))
       * 100 AS [PercentageOfTotalOverPartition]
FROM [HumanResources].[Employee];