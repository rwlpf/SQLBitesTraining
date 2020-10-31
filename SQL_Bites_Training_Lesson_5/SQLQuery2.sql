SELECT
    [Employee].[LoginID]
  , [Employee].[OrganizationLevel]
  , [Employee].[SickLeaveHours]
 ,SUM([Employee].[SickLeaveHours]) OVER (PARTITION BY [Employee].[OrganizationLevel]
                      ) AS [SUM_SickLeaveHours]	
/*=================================================================================*/
 ,SUM([Employee].[SickLeaveHours]) OVER (PARTITION BY [Employee].[OrganizationLevel]
									ORDER BY  [Employee].[LoginID]
                      ) AS [SUM_SickLeaveHours_With_Order]	

 ,
 (
 CAST(
 SUM([Employee].[SickLeaveHours]) OVER (PARTITION BY [Employee].[OrganizationLevel]
									ORDER BY  [Employee].[LoginID]) 
									AS DECIMAL(6,2))
/
CAST(
 SUM([Employee].[SickLeaveHours]) OVER (PARTITION BY [Employee].[OrganizationLevel]) 
 AS DECIMAL(6,2)))*  100
					  AS [PercentageOfTotalOverPartition]
FROM
    [AdventureWorks2012].[HumanResources].[Employee]
