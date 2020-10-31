USE WindowFunctions;
GO

SELECT
	ranged_values.StartDate,
	DATEADD(DAY,-1,ranged_values.EndDate) AS EndDate
FROM
(
	SELECT 
		StartDate = transaction_date,
		EndDate = LEAD(transaction_date) OVER
		(
			ORDER BY
				transaction_date
		)
	FROM dbo.transaction_history_clean
) AS ranged_values