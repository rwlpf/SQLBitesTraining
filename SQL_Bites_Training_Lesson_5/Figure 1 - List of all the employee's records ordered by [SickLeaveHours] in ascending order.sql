Use AdventureWorks2012;
SELECT
    [LoginID]
  , [OrganizationLevel]
  , [SickLeaveHours]
FROM
    [AdventureWorks2012].[HumanResources].[Employee]
	ORDER BY [Employee].[SickLeaveHours] ASC;

