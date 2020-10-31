USE WindowFunctions;
GO

SELECT 
	hl.LogID,
	hl.arrivaldate,
	hl.arrivaltime,
	hl.sales_total AS current_sale,
	SUM(hl.sales_total) OVER
	(
		ORDER BY
			ArrivalDate,
			ArrivalTime
		ROWS BETWEEN 1 PRECEDING AND 1 PRECEDING -- full syntax
	) AS previous_sale
FROM HostessLog AS hl
ORDER BY
	ArrivalDate,
	hl.ArrivalTime

SELECT 
	hl.LogID,
	hl.arrivaldate,
	hl.arrivaltime,
	hl.sales_total AS current_sale,
	SUM(hl.sales_total) OVER
	(
		ORDER BY
			ArrivalDate,
			ArrivalTime
		ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING -- full syntax
	) AS monthly_sales
FROM HostessLog AS hl
ORDER BY
	ArrivalDate,
	hl.ArrivalTime

