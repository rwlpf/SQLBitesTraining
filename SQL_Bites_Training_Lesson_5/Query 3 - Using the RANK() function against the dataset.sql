USE [AdventureWorks2012];

SELECT
    [Employee].[LoginID]
  , [Employee].[OrganizationLevel]
  , [Employee].[SickLeaveHours]
  , DENSE_RANK() OVER (PARTITION BY [Employee].[OrganizationLevel]
                 ORDER BY     [Employee].[SickLeaveHours]
                ) AS [Rank]
FROM [HumanResources].[Employee];
;