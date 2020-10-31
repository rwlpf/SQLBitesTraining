USE [AdventureWorks2012];
DECLARE @TopNo AS INT = 30;

SELECT TOP (@TopNo) WITH TIES
       [StateProvinceID],
       COUNT([StateProvinceID]) AS CountOfStateIDs
FROM.[Person].[Address]
GROUP BY [StateProvinceID]
ORDER BY COUNT([StateProvinceID]) DESC;