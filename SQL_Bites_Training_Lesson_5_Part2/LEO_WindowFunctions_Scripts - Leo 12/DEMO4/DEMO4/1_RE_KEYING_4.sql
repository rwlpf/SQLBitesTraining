SELECT
	DENSE_RANK() OVER
	(
		ORDER BY transaction_date
	) AS group_key,
	*
FROM dbo.transaction_history_small;