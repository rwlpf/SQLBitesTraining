WITH source_data AS
(	
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
)

SELECT 
	*
FROM source_data 
WHERE 
	row_num = 1