USE WindowFunctions;

-- What if I don't want to re-key anything, the NULLS are okay for
-- now. I just want to get rid of the duplicates.

SELECT
	ROW_NUMBER() OVER
	(
		ORDER BY 
			(SELECT NULL)
	) AS row_num,
	*
FROM dbo.transaction_history_small
