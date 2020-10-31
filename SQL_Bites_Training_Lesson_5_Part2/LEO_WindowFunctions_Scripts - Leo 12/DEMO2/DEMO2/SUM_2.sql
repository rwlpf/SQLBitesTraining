USE WindowFunctions;
GO

-- Since we've only looked at the short-cut syntax
-- for our boundary definitons, it might not be
-- apparent why we might want to explicitly define
-- our frames. Let's look at what we can do with the
-- full syntax.

SELECT 
	hl.PartyName,
	hl.arrivaldate,
	hl.arrivaltime,
	hl.sales_total,
	SUM(hl.sales_total) OVER
	(
		PARTITION BY
			ArrivalDate
		ORDER BY
			hl.PartyName,
			ArrivalTime
		ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW -- full syntax
	) AS party_total 
FROM HostessLog AS hl
ORDER BY
	ArrivalDate,
	hl.PartyName,
	hl.ArrivalTime