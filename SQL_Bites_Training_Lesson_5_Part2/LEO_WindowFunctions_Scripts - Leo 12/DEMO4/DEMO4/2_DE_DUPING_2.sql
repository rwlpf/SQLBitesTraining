SELECT
	ROW_NUMBER() OVER
	(
		PARTITION BY
			transaction_date
		ORDER BY 
			(SELECT NULL)
	) AS row_num,
	*
FROM dbo.transaction_history_small
