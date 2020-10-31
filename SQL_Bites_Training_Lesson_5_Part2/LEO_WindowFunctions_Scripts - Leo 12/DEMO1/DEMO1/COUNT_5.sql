USE WindowFunctions;
GO

/*How do fix our counts*/

SELECT 'Explicitly declare a ROWS frame';

SELECT
	hl.DinerFirstName,
	hl.DinerLastName,
	hl.partyname,
	hl.ArrivalTime,
	COUNT(*) OVER(
		PARTITION BY
			hl.PartyName
		ORDER BY
			ArrivalTime ASC,
			hl.partyname ASC,
			hl.DinerLastName ASC,
			hl.DinerFirstName
		ROWS UNBOUNDED PRECEDING
	) AS _count
FROM HostessLog_SingleDay AS hl
WHERE 
	PartyName = 'Overby'

SELECT
	hl.DinerFirstName,
	hl.DinerLastName,
	hl.partyname,
	hl.ArrivalTime,
	COUNT(*) OVER(
		PARTITION BY
			hl.PartyName
		ORDER BY
			hl.ArrivalTime ASC,
			hl.DinerLastName ASC
		ROWS UNBOUNDED PRECEDING
	) AS _count
FROM HostessLog_SingleDay AS hl
WHERE 
	PartyName = 'Price'



SELECT
	hl.DinerFirstName,
	hl.DinerLastName,
	hl.partyname,
	hl.ArrivalTime,
	COUNT(*) OVER(
		PARTITION BY
			PartyName
		ORDER BY
			ArrivalTime ASC
		ROWS UNBOUNDED PRECEDING
	) AS _count
FROM HostessLog_SingleDay AS hl
WHERE 
	PartyName = 'Giltner'