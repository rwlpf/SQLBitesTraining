Use AdventureWorks2012;

SELECT
    [Employee].[LoginID]
  , [Employee].[OrganizationLevel]
 , [Employee].[SickLeaveHours]
 ,SUM([Employee].[SickLeaveHours]) OVER (PARTITION BY [Employee].[OrganizationLevel]
                      ) AS [SUM_SickLeaveHours]	
 ,SUM([Employee].[SickLeaveHours]) OVER (PARTITION BY [Employee].[OrganizationLevel]
						  ORDER BY  [Employee].[LoginID]
                      ) AS [SUM_SickLeaveHours_With_Order]	
FROM
    [HumanResources].[Employee];

;
