/*Stole, no sorry borrowed from here -> 
 https://sqlsunday.com/2014/01/19/sargable-expression-performance/
*/

/*================================================
Step 1 - Create temp table to use in the example
=================================================*/

CREATE TABLE #testData (
    [ID]        int IDENTITY(1, 1) NOT NULL,
    [date]        datetime NOT NULL,
    PRIMARY KEY CLUSTERED ([ID])
);

CREATE UNIQUE INDEX #IX_testData ON #testData ([date]);

DECLARE @date datetime={d '2014-01-01'};
WHILE (@date<{d '2014-01-02'}) BEGIN;
    INSERT INTO #testData ([date]) VALUES (@date);
    SET @date=DATEADD(ss, 30, @date);
END;

INSERT INTO #testData ([date]) SELECT DATEADD(dd,  1, [date]) FROM #testData;
INSERT INTO #testData ([date]) SELECT DATEADD(dd,  2, [date]) FROM #testData;
INSERT INTO #testData ([date]) SELECT DATEADD(dd,  4, [date]) FROM #testData;
INSERT INTO #testData ([date]) SELECT DATEADD(dd,  8, [date]) FROM #testData;
INSERT INTO #testData ([date]) SELECT DATEADD(dd, 16, [date]) FROM #testData;

/*================================================
Step 2 - run a SELECT query on the table
=================================================*/

SELECT ID,
       date
FROM #testData

/*========================================================
Step 3 - Cost of using Scalar calcuations in WHERE clause
=========================================================*/

SET STATISTICS IO ON
SET STATISTICS TIME ON
--- Not SARGable expression: Index scan
SELECT [date]
FROM #testData
WHERE DATEPART(yy, [date])=2014 AND
      DATEPART(mm, [date])=1 AND
      DATEPART(dd, [date])=15;

--- SARGable expression: Index seek
SELECT [date]
FROM #testData
WHERE [date] >='2014-01-15 00:00:00' AND
    [date] <'2014-01-16 00:00:00';

SET STATISTICS IO OFF
SET STATISTICS TIME OFF

/*======================================================================
Step 4 -  Cost of using Arthemtic operators calcuations in WHERE clause
========================================================================*/
SET STATISTICS IO ON
SET STATISTICS TIME ON

--- Not SARGable expression: Index scan
SELECT [ID], [date]
FROM #testData
WHERE [ID]+1000>=41321 AND [ID]+1000<44201;

--- SARGable expression: Index seek
SELECT [ID], [date]
FROM #testData
WHERE [ID]>=41321-1000 AND [ID]<44201-1000;

SET STATISTICS IO OFF
SET STATISTICS TIME OFF

/*======================================================================
Step 5 -  Wildcard comparisons
========================================================================*/

USE AdventureWorks2012;

SET STATISTICS IO ON
SET STATISTICS TIME ON

--- Not SARGable expression: Index scan
SELECT FirstName, LastName
FROM Person.Person
WHERE LastName+'' LIKE 'Hill%';

--- SARGable expression: Index seek
SELECT FirstName, LastName
FROM Person.Person
WHERE LastName LIKE 'Hill%';

SET STATISTICS IO OFF
SET STATISTICS TIME OFF

DROP TABLE  #testData