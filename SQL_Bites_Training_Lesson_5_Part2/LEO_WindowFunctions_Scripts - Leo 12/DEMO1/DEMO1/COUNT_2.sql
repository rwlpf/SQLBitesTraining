USE WindowFunctions;
GO

/*let's add a partition*/

SELECT 'Partition Only';

SELECT
	hl.DinerFirstName,
	hl.DinerLastName,
	hl.partyname,
	hl.ArrivalTime,
	COUNT(*) OVER(
		PARTITION BY
			hl.PartyName
	) AS _count
FROM HostessLog_SingleDay AS hl


/*
Let's eliminate a few rows, 
to make the next demo easier to follow.
We're going to look at the Overby party first.
*/

SELECT 'Partition Only';

SELECT
	hl.DinerFirstName,
	hl.DinerLastName,
	hl.partyname,
	hl.ArrivalTime,
	COUNT(*) OVER(
		PARTITION BY
			hl.PartyName
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
			hl.PartyName
	) AS _count
FROM HostessLog_SingleDay AS hl
WHERE 
	PartyName = 'Giltner'