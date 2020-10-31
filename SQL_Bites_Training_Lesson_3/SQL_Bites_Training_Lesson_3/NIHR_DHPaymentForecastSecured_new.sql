/*    ==Scripting Parameters==

    Source Server Version : SQL Server 2012 (11.0.5388)
    Source Database Engine Edition : Microsoft SQL Server Standard Edition
    Source Database Engine Type : Standalone SQL Server

    Target Server Version : SQL Server 2012
    Target Database Engine Edition : Microsoft SQL Server Standard Edition
    Target Database Engine Type : Standalone SQL Server
*/

USE [CCGTMongooseCCF]
GO

SET STATISTICS IO ON ;
SET STATISTICS TIME ON;

DECLARE @StartFrom DATETIME = '2013-04-01 00:00:00.000'

DECLARE @Teams VARCHAR(200) = 'I4I,RISC,PG,IRS,HICF,PRP,RDS,PDG,RfPB'
--DECLARE @Teams VARCHAR(200) = 'RISC'

DECLARE @Mode INT = 1
DECLARE @UserID UNIQUEIDENTIFIER = '57701624-D5BE-40B8-A68F-A29EC10BE75F'

/****** Object:  StoredProcedure [dbo].[NIHR_DHPaymentForecastSecured]    Script Date: 06/10/2017 09:20:38 ******/
--SET ANSI_NULLS ON
--GO

--SET QUOTED_IDENTIFIER ON
--GO

--ALTER PROCEDURE [dbo].[NIHR_DHPaymentForecastSecured] (@StartFrom DATETIME, @Teams VARCHAR(200), @Mode INT, @UserID UNIQUEIDENTIFIER)

--AS
--BEGIN

/*=========  Generate data for report  ================*/
/*Populate a temp table with a list of grants that match
the criteria passed into the stored proceedure*/
CREATE TABLE #Grants
(
    GrantID uniqueidentifier
)

INSERT INTO #Grants
SELECT
    [gv].[ID] 
FROM
    [GrantsView] [gv]
LEFT OUTER JOIN
    [DynamicFieldValues] [DFV]
        ON [DFV].[EntityID] = [gv].[ID]
           AND  [DFV].[DynamicFieldID] = 1
           AND  [DynamicFieldEntityTypeID] = 1
LEFT OUTER JOIN
    [GrantContacts] [LO_GC]
        ON [LO_GC].[GrantID] = [gv].[ID]
           AND  [LO_GC].[TypeID] = 'BCE8014A-DF65-45AB-BE46-B6D52BA7D0D9'
LEFT OUTER JOIN
    [Contacts] [LO]
        ON [LO].[ID] = [LO_GC].[ContactID]
WHERE
    (
        [gv].[Status] IN ( 'Approved' )
        OR  [gv].[Outcome] IN ( 'Funded', 'Partially Funded', 'Phased funded', 'Conditionally funded' )
    )
AND [Team] IN
    (
        SELECT  * FROM  [SplitParameterValues](@Teams)
    )
AND
gv.ID IN (SELECT ID FROM Grants 
WHERE RoundID IN (
SELECT RoundID FROM RoundSecurityGroups WHERE SecurityGroupID IN (
SELECT SecurityGroupID FROM SecurityGroupUsers WHERE UserID = @UserID)
) OR RoundID NOT IN (SELECT RoundID FROM RoundSecurityGroups)
)
ORDER BY Reference
/*============================================================*/
/*for each Grant record in #Grants get the Quarters which a 
schedule payment falls between start and end date of any quarter
where start date is greater than or equal to @StartDate 
Note that only Quarters are required to be returned from 
Years table*/

CREATE TABLE #grant_quarters(
    [GrantID] UNIQUEIDENTIFIER,
	[FY_Name] varchar (50),
    [FQ_Name] varchar (50),
    [StartDate] DATETIME,
    [EndDate] DateTime 
)
;
WITH DistinctGrantScheduledPayments AS 
(
SELECT DISTINCT
    [GrantID] ,
    [DueDate]
FROM
    [dbo].[ScheduledPayments] AS [SP]

WHERE [SP].[GrantID] IN (SELECT [GrantID] FROM #Grants)
    AND [SP].[SnapshotID] IS NULL
),
[Qtrs] AS 
(
	SELECT
    [FQ].[Name] AS [FQ_Name] ,
    [FY].[Name] [FY_Name] ,
    [FQ].[StartDate] ,
    [FQ].[EndDate]
FROM [Years] [FQ]

INNER JOIN [Years] [FY]
        ON [FY].[ID] = [FQ].[ParentID]
WHERE  [FY].[StartDate] >= @StartFrom
AND FQ.[YearTypeID] = 3 -- FY Quarter
 ) 

 INSERT INTO #grant_quarters
 SELECT  DISTINCT 
        [SP].[GrantID] ,
		[Qtrs].[FY_Name] ,
        [Qtrs].[FQ_Name] ,
        [Qtrs].[StartDate] ,
        [Qtrs].[EndDate] 
FROM [DistinctGrantScheduledPayments] AS [SP]
 INNER JOIN [Qtrs] 
 ON [SP].[DueDate] >= [Qtrs].[StartDate]
 AND  [SP].[DueDate] <= [Qtrs].[EndDate]
 ORDER BY qtrs.[StartDate]


/*========================================================================================================
start of results CTE 
=========================================================================================================*/
/*
The inner part of the CTE has three seperate SELECT statements to complete calcuations for
'Scheduled' - calculation ,
'Paid' - calculation and 
'Accrued' - calculation
These three seperate 'calculations' are combined togther using UNION ALL to provide
one complete dataset from the CTE 
*/
;
WITH results AS 
(
SELECT
       [GQ].[GrantID] ,
	   [GQ].[FY_Name] ,
       [GQ].[FQ_Name] ,
       [GQ].[StartDate] ,
       [GQ].[EndDate] ,
	   'Scheduled' AS AmountType ,
	   CAST(Scheduled.[Amount] AS MONEY) AS Amount
	    FROM [#grant_quarters] AS GQ
		-- set ForecastAmount to the total of non-approved scheduled payments
		CROSS APPLY (
			SELECT ISNULL(SUM(Amount), CAST(0 AS MONEY)) AS Amount
			FROM ScheduledPayments
			WHERE GrantID = GQ.GrantID					
			AND DueDate >= GQ.StartDate AND DueDate <= GQ.EndDate
			AND SnapshotID IS NULL
		) AS Scheduled

UNION ALL
/*========================================================================================================*/
SELECT 
       [GQ].[GrantID] ,
	   [GQ].[FY_Name] ,
       [GQ].[FQ_Name] ,
       [GQ].[StartDate] ,
       [GQ].[EndDate] ,
	   'Paid' AS AmountType ,
	   CASE
       WHEN @Mode = 1 THEN CAST([PaidMode_1_Or_2].[Amount] + [PaidMode_1].[Amount] AS MONEY)
	   WHEN @Mode = 2 THEN CAST([PaidMode_1_Or_2].[Amount] AS MONEY)
	   END AS Amount
	   FROM [#grant_quarters] AS GQ
		/* if running in 'cash' or 'accruals' mode set paid amount to the sum of payment transactions that are not for 
		accrued SPs */
		CROSS APPLY 
		(
		SELECT	ISNULL(SUM(CASE WHEN t.TypeID = 'FB0DFD28-8750-4FFE-A396-4CD2803D288E' 
								THEN -te.Amount ELSE te.Amount END), 
								CAST(0 AS MONEY)) AS [Amount]
		FROM Transactions t,TransactionElements te, TransactionGroups tg
		WHERE te.transactionid = t.id
		AND t.groupid = tg.id
		AND tg.ScheduledPaymentID IN (
			SELECT ID
			FROM ScheduledPayments
			WHERE GrantID = GQ.GrantID					
			AND DueDate >= GQ.StartDate AND DueDate <= GQ.EndDate
			AND AccrualDate IS NULL
		) 
		) AS [PaidMode_1_Or_2]
		
		CROSS APPLY
		(
		SELECT ISNULL(SUM(te.Amount), CAST(0 AS MONEY))  AS Amount
					FROM Transactions t,TransactionElements te, TransactionGroups tg
					WHERE te.transactionid = t.id
					AND t.groupid = tg.id
					AND tg.ScheduledPaymentID IN (
						SELECT ID
						FROM ScheduledPayments
						WHERE GrantID = GQ.GrantID					
						AND DueDate >= GQ.StartDate AND DueDate <= GQ.EndDate
						AND AccrualDate IS NOT NULL
					)
		) AS [PaidMode_1]

UNION ALL 
/*========================================================================================================*/
SELECT 
       [GQ].[GrantID] ,
	   [GQ].[FY_Name] ,
       [GQ].[FQ_Name] ,
       [GQ].[StartDate] ,
       [GQ].[EndDate] ,
	   'Accrued' AS AmountType ,
	   CASE
       WHEN @Mode = 1 THEN CAST(0 AS MONEY)
	   WHEN @Mode = 2 THEN CAST(Accrued.[Amount] AS MONEY)
	   END AS Amount
	    FROM [#grant_quarters] AS GQ

CROSS APPLY
(
		-- set ForecastAmount to the total of non-approved scheduled payments
			SELECT  ISNULL(SUM(Amount), CAST(0 AS MONEY)) AS Amount 
			FROM ScheduledPayments
			WHERE GrantID = GQ.[GrantID]					
			AND AccrualDate >= GQ.[StartDate] AND AccrualDate <= GQ.[EndDate]
			AND SnapshotID IS NULL
		) AS Accrued

)
/*========================================================================================================
End of results CTE
========================================================================================================*/

SELECT 
		[results].[GrantID] ,
		[gv].[Reference] ,
		[DFV].[Varchar80Value] AS [PRPNumber] ,
		[LO].[FullName]        AS [LiaisonOfficer] ,
		[gv].[GMFullName]      AS [GrantManager] ,
		[gv].[Type]			   AS [GrantType],
		[gv].[Round] ,
		[gv].[Region] ,
		[gv].[Team] ,
		[gv].[Status] AS GrantStatus,
		[gv].[StartDate],
		[gv].[EndDate],
		[gv].[TotalAward] ,
		[gv].[Institution] ,
		[results].[FY_Name] AS FinancialYear,
		[results].[FQ_Name] AS FinancialQuarter,
		--[results].[StartDate] AS FP_StartDate,
		--[results].[EndDate] AS FP_EndDate,
		CAST([results].[AmountType] AS VARCHAR(50)) AS AmountType ,
		[results].[Amount] AS QuarterAmount
		/*the report used by this stored proc requires to have CountIndex which is an index based on results listed 
		by GrantID, the start of the Financal Quarter order of the payment types must by 
		1st = Scheduled
		2nd = Paid
		3rd = Accrued
		This order is to replicate the results set from the orginal stored proceedure
		*/
		,RANK() OVER (PARTITION BY [results].[GrantID] ORDER BY [results].[StartDate] DESC , [results].[AmountType] DESC) AS [CountIndex]
 FROM [results]
 /*join to other tables to return the additional details eg Grant Reference etc*/
		INNER JOIN  
		[GrantsView] AS GV ON [GV].[ID] = [results].[GrantID]
		LEFT OUTER JOIN
			[DynamicFieldValues] [DFV]
				ON [DFV].[EntityID] = [results].[GrantID] 
				   AND  [DFV].[DynamicFieldID] = 1
				   AND  [DynamicFieldEntityTypeID] = 1
		LEFT OUTER JOIN
			[GrantContacts] [LO_GC]
				ON [LO_GC].[GrantID] = [results].[GrantID]
				   AND  [LO_GC].[TypeID] = 'BCE8014A-DF65-45AB-BE46-B6D52BA7D0D9'
		LEFT OUTER JOIN
			[Contacts] [LO]
				ON [LO].[ID] = [LO_GC].[ContactID]

DROP TABLE [#Grants];
DROP TABLE [#grant_quarters];

--END


SET STATISTICS IO OFF ;
SET STATISTICS TIME OFF;


