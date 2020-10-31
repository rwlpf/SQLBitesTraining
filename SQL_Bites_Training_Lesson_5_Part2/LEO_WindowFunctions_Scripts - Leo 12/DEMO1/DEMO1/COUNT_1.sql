USE WindowFunctions;
GO

/*no partitioning, ordering, or framing*/



SELECT
	hl.DinerFirstName,
	hl.DinerLastName,
	hl.partyname,
	hl.ArrivalTime,
	COUNT(*) OVER() AS _count
FROM HostessLog_SingleDay AS hl;

