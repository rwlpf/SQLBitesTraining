--Wow! From 2 and a half minutes to less than 1 second!

declare @SelectedStatusID uniqueidentifier = (select id from grantstatuses where status = 'Active')
declare @startDate datetime = '16 February 2017'
declare @EndDate datetime = '16 February 2018'

set statistics io on
set statistics time on

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

--CREATE TABLE #TempActiveHistory (
-- ID int, GrantID uniqueidentifier, Reference varchar(200), OldStatusID uniqueidentifier, NewStatusID uniqueidentifier, PeriodStartDate datetime, PeriodEndDate datetime)

SET NOCOUNT ON

--select * from auditfieldsview where entityid = '36a0a1b6-e61f-41ef-b351-a2e0011c82fe' and EntityTable = 'Grants' and ColumnName = 'StatusID' order by addedat

SELECT AFV.ID, AFV.EntityID AS GrantID, G.Reference, --G.EndDate AS CloseDate, 
     --LAG(AFV.Value) OVER (PARTITION BY AFV.EntityID ORDER BY AFV.ID) AS OldStatusID,
     --AFV.Value AS NewStatusID,
     AFV.Value AS OldStatusID,
     ISNULL(LEAD(AFV.Value) OVER (PARTITION BY AFV.EntityID ORDER BY AFV.AddedAt),AFV.Value) AS NewStatusID,
     --LAG(AFV.AddedAt) OVER (PARTITION BY AFV.EntityID ORDER BY AFV.ID) AS PeriodStartDate,
     --AFV.AddedAt AS PeriodEndDate
     AFV.AddedAt AS PeriodStartDate,
     ISNULL(LEAD(AFV.AddedAt) OVER (PARTITION BY AFV.EntityID ORDER BY AFV.AddedAt), G.EndDate) AS PeriodEndDate
--INTO #TempHistory
INTO #TempActiveHistory
 FROM AuditFieldsView AFV
-- LEFT OUTER JOIN GrantsView G ON CAST(G.ID AS NVARCHAR(36)) = AFV.EntityID
 LEFT OUTER JOIN Grants G ON CAST(G.ID AS NVARCHAR(36)) = AFV.EntityID
 WHERE AFV.EntityTable = 'Grants' AND AFV.ColumnName = 'StatusID'-- AND AFV.Value = CAST(@SelectedStatusID AS NVARCHAR(36))
 ORDER BY G.Reference, AFV.AddedAt DESC

 --select * from #TempActiveHistory  WHERE grantid = '36a0a1b6-e61f-41ef-b351-a2e0011c82fe' order by PeriodStartDate

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

set statistics io off
set statistics time off