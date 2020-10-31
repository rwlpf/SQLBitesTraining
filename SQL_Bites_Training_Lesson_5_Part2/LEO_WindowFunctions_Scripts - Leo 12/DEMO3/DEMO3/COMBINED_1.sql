USE WindowFunctions;
GO

SELECT 
	hl.LogID,
	hl.arrivaldate,
	hl.arrivaltime,
	hl.sales_total,
	SUM(hl.sales_total) OVER
	(
		PARTITION BY
			ArrivalDate
		ORDER BY
			ArrivalDate,
			ArrivalTime
		ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING -- full syntax
	) AS daily_total,
	SUM(hl.sales_total) OVER
	(
		ORDER BY
			ArrivalDate,
			ArrivalTime
		ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING -- full syntax
	) AS monthly_total
FROM HostessLog AS hl
ORDER BY
	ArrivalDate,
	hl.ArrivalTime


-- To do this using group by, I'd have to use two subqueries.
-- daily_total and monthly_total would get calculated
-- completely from scratch having to go all the way back to 
-- the base tables to get their aggregations


SELECT 
	hl.LogID,
	hl.arrivaldate,
	hl.arrivaltime,
	hl.sales_total,
	( 
		SELECT
			SUM(hl_1.sales_total)
		FROM HostessLog AS hl_1
		WHERE
			hl_1.ArrivalDate = hl.arrivalDate
	) as daily_total, 
	( 
		SELECT
			SUM(hl_2.sales_total)
		FROM HostessLog AS hl_2
	) as monthly_total
FROM HostessLog AS hl
ORDER BY
	ArrivalDate,
	hl.ArrivalTime