USE SQL_AdventureWork_SB;
GO
/****** Script for SelectTopNRows command from SSMS  ******/
SET STATISTICS IO ON 
SET STATISTICS TIME ON 

SELECT [AddressID]
      ,[AddressLine1]
      ,[AddressLine2]
      ,[City]
  FROM [Person].[Address]
GO

SELECT *
  FROM [Person].[Address]
GO
SET STATISTICS IO OFF
SET STATISTICS TIME OFF

