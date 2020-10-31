USE [AdventureWorks2012];

SELECT
    [Employee].[LoginID]
  , [Employee].[OrganizationLevel]
  , [Employee].[SickLeaveHours]
  , ROW_NUMBER() OVER (PARTITION BY [Employee].[OrganizationLevel]
                 ORDER BY     [Employee].[SickLeaveHours]
                ) AS [RowNumber]
  , RANK() OVER (PARTITION BY [Employee].[OrganizationLevel]
                 ORDER BY     [Employee].[SickLeaveHours]
                ) AS [Rank]
  , DENSE_RANK() OVER (PARTITION BY [Employee].[OrganizationLevel]
                 ORDER BY     [Employee].[SickLeaveHours]
                ) AS [Dense_Rank]
  , NTILE(4) OVER (PARTITION BY [Employee].[OrganizationLevel]
                 ORDER BY     [Employee].[SickLeaveHours]
                ) AS [NTILE(4)]
FROM [HumanResources].[Employee]