SELECT
	ROW_NUMBER() OVER
	(
		ORDER BY transaction_date
	) AS new_key,
	*
FROM dbo.transaction_history_small;