WITH
Nodelevelstring
AS (SELECT [BusinessEntityID]
         --, [OrganizationNode].ToString() AS NodelevelString
         --, LEN([OrganizationNode].ToString()) LengthNodelevelString
         /*remove last character from [OrganizationNode].ToString() */
         , LEFT([OrganizationNode].ToString(), LEN([OrganizationNode].ToString()) - 1) AS NodelevelString
    --, LEN([OrganizationNode].ToString()) - CHARINDEX('/',REVERSE([OrganizationNode].ToString()))  AS LinePostion
    FROM [AdventureWorks2012].[HumanResources].[Employee])
,
Step1
AS (SELECT [Nodelevelstring].[BusinessEntityID]
         , [Nodelevelstring].[NodelevelString]
         , LEN([Nodelevelstring].[NodelevelString]) - CHARINDEX('/', REVERSE([Nodelevelstring].[NodelevelString])) AS BackSlashLocation
    FROM [Nodelevelstring])
, [RecordsToInsert] AS 
(
SELECT [Step1].[BusinessEntityID]
     , [Step1].[NodelevelString]
     , LEFT([Step1].[NodelevelString], [Step1].[BackSlashLocation]+1) AS MgrLevel
     , [Step1].[BackSlashLocation]
	 , [Mgr].[BusinessEntityID] MgrEntityID
FROM [Step1]
        CROSS APPLY
    (
        SELECT [BusinessEntityID]
        FROM [AdventureWorks2012].[HumanResources].[Employee]
        WHERE [OrganizationNode].ToString() = LEFT([Step1].[NodelevelString], [Step1].[BackSlashLocation]+1)
    ) AS Mgr 
)
--SELECT * FROM [Step2]

UPDATE [HumanResources].[Employee]
SET [MgrEntityID] = [RecordsToInsert].[MgrEntityID]
FROM [HumanResources].[Employee]
    INNER JOIN [RecordsToInsert]
        ON [Employee].[BusinessEntityID] = [RecordsToInsert].[BusinessEntityID];



/*

--ALTER TABLE [HumanResources].[Employee] ADD MgrEntityID INT;
BEGIN TRAN
;
WITH
EmployeesLevel
AS (SELECT [BusinessEntityID]
         , [OrganizationNode].ToString() AS NodelevelString
    FROM [AdventureWorks2012].[HumanResources].[Employee])
,
ManagerLevels
AS (SELECT [EmployeesLevel].[BusinessEntityID]
         , [EmployeesLevel].[NodelevelString]
         , CASE
               WHEN LEN([EmployeesLevel].[NodelevelString]) > 2 THEN
                   LEFT([EmployeesLevel].[NodelevelString], LEN([EmployeesLevel].[NodelevelString]) - 2)
           END AS ManagerNodelevelString
    FROM [EmployeesLevel])
,
RecordsToInsert
AS (SELECT [ManagerLevels].[BusinessEntityID]
         , [ManagerLevels].[NodelevelString]
         , [ManagerLevels].[ManagerNodelevelString]
         , Mgr.[BusinessEntityID] AS MgrEntityID
    FROM [ManagerLevels]
        CROSS APPLY
    (
        SELECT [BusinessEntityID]
        FROM [AdventureWorks2012].[HumanResources].[Employee]
        WHERE [OrganizationNode].ToString() = [ManagerLevels].[ManagerNodelevelString]
    ) AS Mgr )

--SELECT [RecordsToInsert].[BusinessEntityID]
--     , [RecordsToInsert].[NodelevelString]
--     , [RecordsToInsert].[ManagerNodelevelString]
--     , [RecordsToInsert].[MgrEntityID]
--FROM [RecordsToInsert];

UPDATE [HumanResources].[Employee]
SET [MgrEntityID] = [RecordsToInsert].[MgrEntityID]
FROM [HumanResources].[Employee]
    INNER JOIN [RecordsToInsert]
        ON [Employee].[BusinessEntityID] = [RecordsToInsert].[BusinessEntityID];


SELECT [BusinessEntityID]
     , [NationalIDNumber]
     , [LoginID]
     , [OrganizationNode]
     , [OrganizationLevel]
     , [JobTitle]
     --, [BirthDate]
     --, [MaritalStatus]
     --, [Gender]
     --, [HireDate]
     --, [SalariedFlag]
     --, [VacationHours]
     --, [SickLeaveHours]
     --, [CurrentFlag]
     --, [rowguid]
     --, [ModifiedDate]
     , [MgrEntityID] 
FROM [HumanResources].[Employee]

ROLLBACK TRAN

*/