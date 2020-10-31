USE WindowFunctions;
GO


SELECT 
	StartDate = transaction_date,
	EndDate = LEAD(transaction_date) OVER
	(
		ORDER BY
			transaction_date
	)
FROM dbo.transaction_history_clean
