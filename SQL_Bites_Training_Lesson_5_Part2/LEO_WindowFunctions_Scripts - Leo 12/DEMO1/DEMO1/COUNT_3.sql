USE WindowFunctions;
GO

/*What happens if we add an order by statement*/

SELECT 'PARTITION + ORDER BY';

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
	PartyName = 'Overby'


/*
Everything looks the same as using partition only,
but is that really the case? Let's look at two others.
*/ 


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