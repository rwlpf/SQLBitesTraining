USE WindowFunctions;
GO

/*How do fix our counts*/

SELECT 'Force a unique ordering key';

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
	) AS _count
FROM HostessLog_SingleDay AS hl
WHERE 
	PartyName = 'Giltner'