USE WindowFunctions;
GO

SELECT 
	store_id,
	transaction_date,
	actual_cost,
	ROW_NUMBER() OVER
	(
		PARTITION BY 
			store_id,
			transaction_date
		ORDER BY
			transaction_id 
	) as tx_order_asc
FROM dbo.transaction_history;
