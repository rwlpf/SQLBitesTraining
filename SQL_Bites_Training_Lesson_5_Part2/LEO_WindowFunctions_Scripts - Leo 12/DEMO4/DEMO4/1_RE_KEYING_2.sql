SELECT
	ROW_NUMBER() OVER
	(
		ORDER BY (SELECT NULL)
	) AS new_key,
	*
FROM dbo.transaction_history_small;