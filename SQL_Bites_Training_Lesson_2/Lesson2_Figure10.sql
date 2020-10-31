USE [AdventureWorks2012];
DECLARE @TopNo AS INTEGER = 10;
SELECT TOP (@TopNo)
       [AddressID],
       [AddressLine1],
       [AddressLine2],
       [City],
       [StateProvinceID],
       [PostalCode],
       [ModifiedDate]
FROM [Person].[Address];

