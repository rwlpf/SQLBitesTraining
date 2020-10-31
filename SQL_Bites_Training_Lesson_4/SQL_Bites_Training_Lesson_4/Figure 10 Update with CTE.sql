/****** Script for SelectTopNRows command from SSMS  ******/
USE [AdventureWorks2012];

BEGIN TRAN

DECLARE @SalesPersonID AS INTEGER 
SET @SalesPersonID = 20

;
WITH CustomersToUpdate (CustomerID)
AS 
(
/* 85 records returned */
SELECT [CustomerID] 
  FROM [Sales].[Customer]
  WHERE [PersonID] IS NULL
  AND [TerritoryID] = 5
)

UPDATE [Sales].[Customer]
SET [PersonID] = @SalesPersonID
FROM [Sales].[Customer] AS C
INNER JOIN [CustomersToUpdate] AS CU
ON [CU].[CustomerID] = [C].[CustomerID];

SELECT COUNT(*)
  FROM [Sales].[Customer]
  WHERE [PersonID] = @SalesPersonID
  AND [TerritoryID] = 5
ROLLBACK TRAN