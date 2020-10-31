SELECT DISTINCT	
	group_key AS new_key,
	transaction_date
FROM
(
	SELECT
		DENSE_RANK() OVER
		(
			ORDER BY transaction_date
		) AS group_key,
		*
	FROM dbo.transaction_history_small
) AS source_data;