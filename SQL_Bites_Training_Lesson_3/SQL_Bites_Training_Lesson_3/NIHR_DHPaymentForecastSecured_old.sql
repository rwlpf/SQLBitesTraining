USE [CCGTMongooseCCF];
GO

SET STATISTICS IO ON ;
SET STATISTICS TIME ON;
/****** Object:  StoredProcedure [dbo].[NIHR_DHPaymentForecastSecured]    Script Date: 23/05/2016 08:59:16 ******/
--SET ANSI_NULLS ON;
--GO

--SET QUOTED_IDENTIFIER ON;
--GO

--ALTER PROCEDURE [dbo].[NIHR_DHPaymentForecastSecured]
--    (
DECLARE @StartFrom DATETIME = '2014-04-01 00:00:00.000'

DECLARE @Teams VARCHAR(200) = 'I4I,RISC,PG,IRS,HICF,PRP,RDS,PDG,RfPB'
--DECLARE @Teams VARCHAR(200) = 'RISC'

DECLARE @Mode INT = 2
DECLARE @UserID UNIQUEIDENTIFIER = 'FFE5E71F-A68E-4B33-BC78-A53900BE720A'
    --)
--AS
--    BEGIN

/*=========  Generate data for report  ================*/

        CREATE TABLE #grants
            (
             GrantID UNIQUEIDENTIFIER
            ,Reference VARCHAR(200)
            ,PRPNumber VARCHAR(100)
            ,LiaisonOfficer VARCHAR(252)
            ,GrantManager VARCHAR(252)
            ,GrantType VARCHAR(100)
            ,Round VARCHAR(100)
            ,Region VARCHAR(100)
            ,Team VARCHAR(100)
            ,GrantStatus VARCHAR(100)
            ,StartDate DATETIME
            ,EndDate DATETIME
            ,TotalAward MONEY
            ,Institution VARCHAR(200)
            );

        CREATE TABLE #grant_quarters
            (
             QuarterName VARCHAR(50)
            ,YearName VARCHAR(50)
            ,StartDate DATETIME
            ,EndDate DATETIME
            );

        CREATE TABLE #results
            (
             GrantID UNIQUEIDENTIFIER
            ,Reference VARCHAR(100)
            ,PRPNumber VARCHAR(100)
            ,LiaisonOfficer VARCHAR(100)
            ,GrantManager VARCHAR(100)
            ,GrantType VARCHAR(100)
            ,Round VARCHAR(100)
            ,Region VARCHAR(100)
            ,Team VARCHAR(100)
            ,GrantStatus VARCHAR(100)
            ,StartDate DATETIME
            ,EndDate DATETIME
            ,TotalAward MONEY
            ,Institution VARCHAR(100)
            ,FinancialYear VARCHAR(50)
            ,FinancialQuarter VARCHAR(50)
            ,AmountType VARCHAR(50)
            ,QuarterAmount MONEY
            ,CountIndex INT
            );

        INSERT  INTO #grants
                SELECT  gv.ID
                       ,gv.Reference
                       ,DFV.Varchar80Value AS PRPNum
                       ,LO.FullName AS LiaisonOfficer
                       ,gv.GMFullName AS GrantManager
                       ,gv.Type
                       ,gv.Round
                       ,gv.Region
                       ,gv.Team
                       ,gv.Status
                       ,gv.StartDate
                       ,gv.EndDate
                       ,gv.TotalAward
                       ,gv.Institution
                FROM    GrantsView gv
                        LEFT OUTER JOIN DynamicFieldValues DFV ON DFV.EntityID = gv.ID
                                                              AND DFV.DynamicFieldID = 1
                                                              AND DynamicFieldEntityTypeID = 1
                        LEFT OUTER JOIN GrantContacts LO_GC ON LO_GC.GrantID = gv.ID
                                                              AND LO_GC.TypeID = 'BCE8014A-DF65-45AB-BE46-B6D52BA7D0D9'
                        LEFT OUTER JOIN Contacts LO ON LO.ID = LO_GC.ContactID
                WHERE  
				 ( gv.Status IN ( 'Approved' )
                          OR gv.Outcome IN ( 'Funded', 'Partially Funded',
                                             'Phased funded',
                                             'Conditionally funded' )
                        )
                        AND
						Team IN (@Teams)
                        AND gv.ID IN (
                        SELECT  ID
                        FROM    Grants
                        WHERE   RoundID IN (
                                SELECT  RoundID
                                FROM    RoundSecurityGroups
                                WHERE   SecurityGroupID IN (
                                        SELECT  SecurityGroupID
                                        FROM    SecurityGroupUsers
                                        WHERE   UserID = @UserID ) )
                                OR RoundID NOT IN (
                                SELECT  RoundID
                                FROM    RoundSecurityGroups ) )
                ORDER BY Reference;

		SELECT DISTINCT team FROM [#grants]

        WHILE EXISTS ( SELECT   *
                       FROM     #grants )
            BEGIN
	
                DECLARE @GrantID UNIQUEIDENTIFIER
                   ,@Reference VARCHAR(100)
                   ,@PRPNumber VARCHAR(100)
                   ,@LiaisonOfficer VARCHAR(100)
                   ,@GrantManager VARCHAR(100)
                   ,@GrantType VARCHAR(100)
                   ,@Round VARCHAR(100)
                   ,@Region VARCHAR(100)
                   ,@Team VARCHAR(100)
                   ,@GrantStatus VARCHAR(100)
                   ,@GrantStartDate DATETIME
                   ,@GrantEndDate DATETIME
                   ,@TotalAward MONEY
                   ,@Institution VARCHAR(100)
                   ,@CountIndex INT;
	
                SET @CountIndex = 0;
	
                SELECT  @GrantID = GrantID
                FROM    #grants;
                SELECT  @Reference = Reference
                FROM    #grants;
                SELECT  @PRPNumber = PRPNumber
                FROM    #grants;
                SELECT  @LiaisonOfficer = LiaisonOfficer
                FROM    #grants;
                SELECT  @GrantManager = GrantManager
                FROM    #grants;
                SELECT  @GrantType = GrantType
                FROM    #grants;
                SELECT  @Round = Round
                FROM    #grants;
                SELECT  @Region = Region
                FROM    #grants;
                SELECT  @Team = Team
                FROM    #grants;
                SELECT  @GrantStatus = GrantStatus
                FROM    #grants;
                SELECT  @GrantStartDate = StartDate
                FROM    #grants;
                SELECT  @GrantEndDate = EndDate
                FROM    #grants;
                SELECT  @TotalAward = TotalAward
                FROM    #grants;
                SELECT  @Institution = Institution
                FROM    #grants;
	
	-- get the FY quarters grant that contain non-approved payments for grant
                INSERT  INTO #grant_quarters
                        SELECT  FQ.Name
                               ,FY.Name
                               ,FQ.StartDate
                               ,FQ.EndDate
                        FROM    Years FQ
                                INNER JOIN Years FY ON FY.ID = FQ.ParentID
                        WHERE   FY.StartDate >= @StartFrom
                                AND EXISTS ( SELECT ID
                                             FROM   ScheduledPayments SP
                                             WHERE  GrantID = @GrantID
                                                    AND SP.DueDate >= FQ.StartDate
                                                    AND SP.DueDate <= FQ.EndDate
                                                    AND SnapshotID IS NULL )
                        ORDER BY StartDate;

                DECLARE @YearName VARCHAR(50)
                   ,@QuarterName VARCHAR(50)
                   ,@QuarterStartDate DATETIME
                   ,@QuarterEndDate DATETIME
                   ,@ScheduledAmount MONEY
                   ,@PaidAmount MONEY
                   ,@AccruedAmount MONEY;	

                WHILE EXISTS ( SELECT   *
                               FROM     #grant_quarters )
                    BEGIN
		-- select quarter variables
                        SELECT  @YearName = YearName
                        FROM    #grant_quarters;
                        SELECT  @QuarterName = QuarterName
                        FROM    #grant_quarters;
                        SELECT  @QuarterStartDate = StartDate
                        FROM    #grant_quarters;
                        SELECT  @QuarterEndDate = EndDate
                        FROM    #grant_quarters;			
		
		-- set ForecastAmount to the total of non-approved scheduled payments
                        SET @ScheduledAmount = ( SELECT ISNULL(SUM(Amount), 0)
                                                 FROM   ScheduledPayments
                                                 WHERE  GrantID = @GrantID
                                                        AND DueDate >= @QuarterStartDate
                                                        AND DueDate <= @QuarterEndDate
                                                        AND SnapshotID IS NULL
                                               );
		
		-- default paid amount to zero
                        SET @PaidAmount = 0;
		
		/* if running in 'cash' or 'accruals' mode set paid amount to the sum of payment transactions that are not for 
		accrued SPs */
                        IF ( @Mode = 1
                             OR @Mode = 2
                           )
                            BEGIN	
                                SET @PaidAmount = ( SELECT  ISNULL(SUM(CASE
                                                              WHEN t.TypeID = 'FB0DFD28-8750-4FFE-A396-4CD2803D288E'
                                                              THEN -te.Amount
                                                              ELSE te.Amount
                                                              END), 0)
                                                    FROM    Transactions t
                                                           ,TransactionElements te
                                                           ,TransactionGroups tg
                                                    WHERE   te.TransactionID = t.ID
                                                            AND t.GroupID = tg.ID
                                                            AND tg.ScheduledPaymentID IN (
                                                            SELECT
                                                              ID
                                                            FROM
                                                              ScheduledPayments
                                                            WHERE
                                                              GrantID = @GrantID
                                                              AND DueDate >= @QuarterStartDate
                                                              AND DueDate <= @QuarterEndDate
                                                              AND AccrualDate IS NULL )
                                                  );
                            END;
		
		-- if running in 'cash' mode add on actual payments from accrued SPs to Paid amount
                        IF ( @Mode = 1 )
                            BEGIN
                                SET @PaidAmount = ( @PaidAmount
                                                    + ( SELECT
                                                              ISNULL(SUM(te.Amount),
                                                              0)
                                                        FROM  Transactions t
                                                             ,TransactionElements te
                                                             ,TransactionGroups tg
                                                        WHERE te.TransactionID = t.ID
                                                              AND t.GroupID = tg.ID
                                                              AND tg.ScheduledPaymentID IN (
                                                              SELECT
                                                              ID
                                                              FROM
                                                              ScheduledPayments
                                                              WHERE
                                                              GrantID = @GrantID
                                                              AND DueDate >= @QuarterStartDate
                                                              AND DueDate <= @QuarterEndDate
                                                              AND AccrualDate IS NOT NULL )
                                                      ) );
                            END;
		
		-- default accrued amount to zero
                        SET @AccruedAmount = 0;
		
		/* if running in 'accruals' mode set accrued amount to the sum of accrued scheduled payment 
		amounts*/
                        IF ( @Mode = 2 )
                            BEGIN	
                                SET @AccruedAmount = ( SELECT ISNULL(SUM(Amount),
                                                              0)
                                                       FROM   ScheduledPayments
                                                       WHERE  GrantID = @GrantID
                                                              AND AccrualDate >= @QuarterStartDate
                                                              AND AccrualDate <= @QuarterEndDate
                                                              AND SnapshotID IS NULL
                                                     );
                            END;
		
                        SET @CountIndex = @CountIndex + 1;

		-- add scheduled row to results for the current quarter
                        INSERT  INTO #results
                                ( GrantID
                                ,Reference
                                ,PRPNumber
                                ,LiaisonOfficer
                                ,GrantManager
                                ,GrantType
                                ,Round
                                ,Region
                                ,Team
                                ,GrantStatus
                                ,StartDate
                                ,EndDate
                                ,TotalAward
                                ,Institution
                                ,FinancialYear
                                ,FinancialQuarter
                                ,AmountType
                                ,QuarterAmount
                                ,CountIndex
                                )
                        VALUES  ( @GrantID
                                ,@Reference
                                ,@PRPNumber
                                ,@LiaisonOfficer
                                ,@GrantManager
                                ,@GrantType
                                ,@Round
                                ,@Region
                                ,@Team
                                ,@GrantStatus
                                ,@GrantStartDate
                                ,@GrantEndDate
                                ,@TotalAward
                                ,@Institution
                                ,@YearName
                                ,@QuarterName
                                ,'Scheduled'
                                ,@ScheduledAmount
                                ,@CountIndex
                                );

                        SET @CountIndex = @CountIndex + 1;

		-- add paid row to results for the current quarter
                        INSERT  INTO #results
                                ( GrantID
                                ,Reference
                                ,PRPNumber
                                ,LiaisonOfficer
                                ,GrantManager
                                ,GrantType
                                ,Round
                                ,Region
                                ,Team
                                ,GrantStatus
                                ,StartDate
                                ,EndDate
                                ,TotalAward
                                ,Institution
                                ,FinancialYear
                                ,FinancialQuarter
                                ,AmountType
                                ,QuarterAmount
                                ,CountIndex
                                )
                        VALUES  ( @GrantID
                                ,@Reference
                                ,@PRPNumber
                                ,@LiaisonOfficer
                                ,@GrantManager
                                ,@GrantType
                                ,@Round
                                ,@Region
                                ,@Team
                                ,@GrantStatus
                                ,@GrantStartDate
                                ,@GrantEndDate
                                ,@TotalAward
                                ,@Institution
                                ,@YearName
                                ,@QuarterName
                                ,'Paid'
                                ,@PaidAmount
                                ,@CountIndex
                                );

                        SET @CountIndex = @CountIndex + 1;

		-- add accrued row to results for the current quarter
                        INSERT  INTO #results
                                ( GrantID
                                ,Reference
                                ,PRPNumber
                                ,LiaisonOfficer
                                ,GrantManager
                                ,GrantType
                                ,Round
                                ,Region
                                ,Team
                                ,GrantStatus
                                ,StartDate
                                ,EndDate
                                ,TotalAward
                                ,Institution
                                ,FinancialYear
                                ,FinancialQuarter
                                ,AmountType
                                ,QuarterAmount
                                ,CountIndex
                                )
                        VALUES  ( @GrantID
                                ,@Reference
                                ,@PRPNumber
                                ,@LiaisonOfficer
                                ,@GrantManager
                                ,@GrantType
                                ,@Round
                                ,@Region
                                ,@Team
                                ,@GrantStatus
                                ,@GrantStartDate
                                ,@GrantEndDate
                                ,@TotalAward
                                ,@Institution
                                ,@YearName
                                ,@QuarterName
                                ,'Accrued'
                                ,@AccruedAmount
                                ,@CountIndex
                                );
		
                        DELETE  FROM #grant_quarters
                        WHERE   StartDate = @QuarterStartDate;
                    END;

                DELETE  FROM #grants
                WHERE   GrantID = @GrantID;

            END;

        DROP TABLE #grants;
        DROP TABLE #grant_quarters;

        SELECT  *
        FROM    #results
        ORDER BY FinancialQuarter;

        DROP TABLE #results;

    --END

	SET STATISTICS IO OFF ;
SET STATISTICS TIME OFF;