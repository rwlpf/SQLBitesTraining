USE WindowFunctions;
GO

WITH gaps AS
(
	SELECT 
		current_tx = transaction_date,
		next_tx = LEAD(transaction_date) OVER
		(
			ORDER BY
				transaction_date
		)
	FROM dbo.transaction_history_clean
)

SELECT
	RangeStart = DATEADD(DAY, 1,current_tx),
	RangeEnd = DATEADD(DAY, -1, current_tx)
FROM gaps
WHERE 
	DATEDIFF(DAY,current_tx,next_tx) > 1 --DaysApart