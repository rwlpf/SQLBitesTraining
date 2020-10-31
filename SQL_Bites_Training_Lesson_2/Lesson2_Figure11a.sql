USE [AdventureWorks2012];
DECLARE @TopNo AS INT = 30;

SELECT TOP (@TopNo)
       [StateProvinceID],
       COUNT([StateProvinceID]) AS CountOfStateIDs
FROM [AdventureWorks2012].[Person].[Address]
GROUP BY [StateProvinceID]
ORDER BY COUNT([StateProvinceID]) DESC;
