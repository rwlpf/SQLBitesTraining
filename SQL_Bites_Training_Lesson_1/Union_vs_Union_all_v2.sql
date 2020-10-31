/* Declare First Table */
USE Test;

CREATE TABLE #Table1 (ColDetail VARCHAR(10))

INSERT INTO #Table1
SELECT 'First'
UNION ALL
SELECT 'Second'
UNION ALL
SELECT 'Third'
UNION ALL
SELECT 'Fourth'
UNION ALL
SELECT 'Fifth'

/* Declare Second Table */
CREATE TABLE #Table2 (ColDetail VARCHAR(10))
INSERT INTO #Table2
SELECT 'First'
UNION ALL
SELECT 'Third'
UNION ALL
SELECT 'Fifth'


/* Check the data using SELECT */
SELECT *
FROM #Table1
SELECT *
FROM #Table2

/* UNION ALL */
SELECT *
FROM #Table1
UNION ALL
SELECT *
FROM #Table2

/* UNION */
SELECT *
FROM #Table1
UNION
SELECT *
FROM #Table2
GO

DROP TABLE #Table1
DROP TABLE #Table2