USE WindowFunctions;
GO

-- We talked about the default boundaries 
-- for RANGE on ROW frames.
-- Let's now take a look at some 
-- of the things we can do with custom 
-- frame bounaries.

SELECT 
	* 
FROM HostessLog AS hl


-- What columns would I need to partition 
-- on to use find the check total for each
-- individual party?


SELECT 
	*,
	SUM(hl.sales_total) OVER
	(
		PARTITION BY
			ArrivalDate,
			PartyName
	) AS party_total 
FROM HostessLog AS hl

-- That looks just like what we can do with
-- GROUP BY. But if we want to get a running total
-- as the evening progressing, then I need
-- to add some framing to do my calculations based
-- on ArrivalTime Order

-- Knowing what we know about our uniqueness issues
-- with arrival time, what columns do I want
-- to order on to guarantee unique rows
-- and total up our values as the night progresses?

-- Hint: LogID is an identity column

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
			hl.ArrivalTime,
			hl.LogID
	) AS party_total 
FROM HostessLog AS hl
ORDER BY
	ArrivalDate,
	hl.PartyName,
	hl.ArrivalTime


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
			hl.ArrivalTime
		ROWS UNBOUNDED PRECEDING --short cut syntax
	) AS party_total 
FROM HostessLog AS hl
ORDER BY
	ArrivalDate,
	hl.PartyName,
	hl.ArrivalTime
