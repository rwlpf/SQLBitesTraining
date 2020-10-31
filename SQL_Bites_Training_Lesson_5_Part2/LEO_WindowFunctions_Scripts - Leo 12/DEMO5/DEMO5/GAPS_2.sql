USE WindowFunctions;
GO


SELECT 
	current_tx = transaction_date,
	next_tx = LEAD(transaction_date) OVER
	(
		ORDER BY
			transaction_date
	)
FROM dbo.transaction_history_clean
