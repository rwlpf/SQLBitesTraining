declare @SelectedStatusID uniqueidentifier = (select id from grantstatuses where status = 'Active')
declare @startDate datetime = '16 February 2017'
declare @EndDate datetime = '16 February 2018'


DECLARE @ID int
, @GrantID uniqueidentifier
, @Reference varchar(200)
, @CloseDate datetime
, @CurrentGrantID uniqueidentifier
, @OldStatusID uniqueidentifier
, @NewStatusID uniqueidentifier
, @PeriodStartDate datetime
, @PeriodEndDate datetime
-- these 3 used to iterate through
, @CurrentReference varchar(200)
, @CurrentStatusID uniqueidentifier
, @StatusID uniqueidentifier

CREATE TABLE #TempActiveHistory (
 ID int, GrantID uniqueidentifier, Reference varchar(200), OldStatusID uniqueidentifier, NewStatusID uniqueidentifier, PeriodStartDate datetime, PeriodEndDate datetime)

SET NOCOUNT ON

PRINT '1'

SELECT G.Reference, G.EndDate AS CloseDate, AFV.ID, AFV.EntityID, AFV.Value, AFV.AddedAt
INTO #TempHistory
 FROM AuditFieldsView AFV
-- LEFT OUTER JOIN GrantsView G ON CAST(G.ID AS NVARCHAR(36)) = AFV.EntityID
 LEFT OUTER JOIN Grants G ON CAST(G.ID AS NVARCHAR(36)) = AFV.EntityID
 WHERE AFV.EntityTable = 'Grants' AND AFV.ColumnName = 'StatusID'
 ORDER BY G.Reference, AFV.AddedAt DESC

PRINT '2'

WHILE EXISTS(SELECT * FROM #TempHistory)
BEGIN
    SELECT @ID = #TempHistory.ID FROM #TempHistory
    SELECT @GrantID = #TempHistory.EntityID FROM #TempHistory
    SELECT @Reference = #TempHistory.Reference FROM #TempHistory
    SELECT @CloseDate = #TempHistory.CloseDate FROM #TempHistory

    IF (@CurrentGrantID IS NULL OR @GrantID <> @CurrentGrantID)
    BEGIN
        SELECT @CurrentGrantID = @GrantID
        SELECT @OldStatusID = NULL
    END
    ELSE
    BEGIN
        SELECT @OldStatusID = @NewStatusID
    END

    SELECT @NewStatusID = #TempHistory.Value FROM #TempHistory
    SELECT @PeriodStartDate = #TempHistory.AddedAt FROM #TempHistory
    SELECT @CloseDate = #TempHistory.CloseDate FROM #TempHistory

    IF @CloseDate < @PeriodStartDate
    BEGIN
        SET @PeriodStartDate = @CloseDate
    END

    INSERT INTO #TempActiveHistory (ID, GrantID, Reference, OldStatusID, NewStatusID, PeriodStartDate, PeriodEndDate)
    VALUES (@ID, @GrantID, @Reference, @OldStatusID, @NewStatusID, @PeriodStartDate, @PeriodEndDate)

    DELETE FROM #TempHistory WHERE ID = @ID
END

PRINT '3'

SELECT * INTO #tempSetEndDates FROM #TempActiveHistory

PRINT '4'

IF EXISTS(SELECT * FROM #tempSetEndDates)
BEGIN
    SELECT @GrantID = GrantID FROM #tempSetEndDates
    SELECT @CurrentReference = Reference FROM #tempSetEndDates -- 1st iteration so match
    SELECT @Reference = Reference FROM #tempSetEndDates
    SELECT @CurrentStatusID = StatusID FROM Grants WHERE ID = @GrantID
    
    SELECT @ID = ID FROM #tempSetEndDates
    
    SELECT @StatusID = NewStatusID FROM #tempSetEndDates
    IF @StatusID = @CurrentStatusID
    BEGIN
        UPDATE #TempActiveHistory SET PeriodEndDate = DATEADD(second, -1, DATEADD(day, 1, CAST(CAST(GETDATE() AS date) AS datetime))) WHERE ID = @ID
    END
    ELSE
    BEGIN
        UPDATE #TempActiveHistory SET PeriodEndDate = @PeriodEndDate WHERE ID = @ID
    END

    SELECT @PeriodEndDate = PeriodStartDate FROM #tempSetEndDates
    IF @PeriodEndDate > @CloseDate
    BEGIN
        SET @PeriodEndDate = @CloseDate
    END
    DELETE FROM #tempSetEndDates WHERE ID = @ID
END

PRINT '5'
    
WHILE EXISTS(SELECT * FROM #tempSetEndDates)
BEGIN
    SELECT @ID = ID FROM #tempSetEndDates
    SELECT @Reference = Reference FROM #tempSetEndDates
    
    IF @Reference = @CurrentReference
    BEGIN
        UPDATE #TempActiveHistory SET PeriodEndDate = @PeriodEndDate WHERE ID = @ID
    END
    ELSE
    BEGIN
        UPDATE #TempActiveHistory SET PeriodEndDate = DATEADD(second, -1, DATEADD(day, 1, CAST(CAST(GETDATE() AS date) AS datetime))) WHERE ID = @ID
        SELECT @CurrentReference = @Reference
    END
    
    SELECT @PeriodEndDate = PeriodStartDate FROM #tempSetEndDates
    IF @PeriodEndDate > @CloseDate
    BEGIN
        SET @PeriodEndDate = @CloseDate
    END
    DELETE FROM #tempSetEndDates WHERE ID = @ID
END

PRINT '6'

DECLARE @tmpRecs integer
SELECT @tmpRecs = COUNT(*) FROM #TempActiveHistory
WHERE NewStatusID = @SelectedStatusID
AND (
    (PeriodStartDate BETWEEN @StartDate AND DATEADD(second, -1, DATEADD(day, 1, @EndDate))) -- Selected date range crosses Period Start Date
    OR (PeriodEndDate BETWEEN @StartDate AND DATEADD(second, -1, DATEADD(day, 1, @EndDate))) -- Selected date range crosses Period End Date
    OR (PeriodStartDate <= @StartDate AND PeriodEndDate >= DATEADD(second, -1, DATEADD(day, 1, @EndDate))) -- Selected date range falls fully inside Period
    )

IF @tmpRecs > 0
BEGIN
    SELECT * FROM #TempActiveHistory
    WHERE NewStatusID = @SelectedStatusID
    AND (
    (PeriodStartDate BETWEEN @StartDate AND DATEADD(second, -1, DATEADD(day, 1, @EndDate))) -- Selected date range crosses Period Start Date
    OR (PeriodEndDate BETWEEN @StartDate AND DATEADD(second, -1, DATEADD(day, 1, @EndDate))) -- Selected date range crosses Period End Date
    OR (PeriodStartDate <= @StartDate AND PeriodEndDate >= DATEADD(second, -1, DATEADD(day, 1, @EndDate))) -- Selected date range falls fully inside Period
    )
    ORDER BY Reference, PeriodStartDate
END
ELSE
BEGIN
    -- We need a blank row to return to avoid a report viewer error in case no valid records are returned
    INSERT INTO #TempActiveHistory (ID, GrantID, Reference, OldStatusID, NewStatusID, PeriodStartDate, PeriodEndDate)
    VALUES (NULL, NULL, '', NULL, NULL, NULL, NULL)

    SELECT * FROM #TempActiveHistory
    WHERE ID IS NULL
END

DROP TABLE #tempSetEndDates
DROP TABLE #TempHistory
DROP TABLE #TempActiveHistory