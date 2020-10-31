USE [AdventureWorks2012];

SELECT
    [Employee].[LoginID]
  , [Employee].[OrganizationLevel]
  , [Employee].[SickLeaveHours]
  , ROW_NUMBER() 
  OVER (
		PARTITION BY [Employee].[OrganizationLevel] 
        ORDER BY     [Employee].[SickLeaveHours]
       ) AS [RowNumber]
FROM
    [HumanResources].[Employee];
