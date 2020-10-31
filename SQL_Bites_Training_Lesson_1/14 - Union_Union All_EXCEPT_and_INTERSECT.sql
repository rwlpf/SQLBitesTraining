/*first step is to look at the datasets that will be used */

/*this will return 109 records*/
USE AdventureWorks2012
SELECT COUNT(CurrencyCode)
FROM [Sales].[CountryRegionCurrency]

/*this will return 105 records*/
USE AdventureWorks2012
SELECT COUNT(CurrencyCode)
FROM [Sales].[Currency]
--ORDER BY CurrencyCode

/*=====================================================================================
UNION ALL will return ALL the values from ALL recordsets, returing on unified dataset
consisting of all the records from all the recordset
First recordset = 109 records
Second recordset = 105 records

Combined total number of records  109 + 105 = 214 records
=====================================================================================*/

USE AdventureWorks2012
SELECT CurrencyCode
FROM [Sales].[CountryRegionCurrency]
UNION ALL
SELECT CurrencyCode
FROM [Sales].[Currency]
ORDER BY CurrencyCode


/*=====================================================================================
UNION  
https://docs.microsoft.com/en-us/sql/t-sql/language-elements/set-operators-union-transact-sql?view=sql-server-2017
"Combines the results of two or more queries into a single result set that includes 
all the rows that belong to all queries in the union"

The query below will return 105 records the reason for this is

[Sales].[Currency] - contains 97 unique records for this query use the following query
SELECT DISTINCT(CurrencyCode)
FROM [Sales].[CountryRegionCurrency]

There are 8 currencies present in [Sales].[Currency].[CurrencyCode] 
which are not in [Sales].[CountryRegionCurrency].[CurrencyCode]
See query below
-----------------------------------------------------------------------------------------*/

USE AdventureWorks2012
;
SELECT DISTINCT(CurrencyCode) AS CurrencyCode
INTO #SalesCurrency
FROM [Sales].[Currency]

SELECT DISTINCT(CurrencyCode) AS CurrencyCode
INTO #CountryRegionCurrency
FROM [Sales].[CountryRegionCurrency]

SELECT #SalesCurrency.CurrencyCode AS [SalesCurrency.CurrencyCode],
       #CountryRegionCurrency.CurrencyCode AS [CountryRegionCurrency.CurrencyCode]
FROM #SalesCurrency 
LEFT JOIN #CountryRegionCurrency
ON  #CountryRegionCurrency.CurrencyCode = #SalesCurrency.CurrencyCode
WHERE #CountryRegionCurrency.CurrencyCode IS NULL

DROP TABLE #SalesCurrency
DROP TABLE #CountryRegionCurrency

/*-----------------------------------------------------------------------------------------
So the query below will return 105 records
97 Distinct records from [Sales].[CountryRegionCurrency].[CurrencyCode]
and 
8 records from [Sales].[Currency].[CurrencyCode] which are not in the above recordset
97 + 8 = 105 unique records
-----------------------------------------------------------------------------------------*/

USE AdventureWorks2012
SELECT CurrencyCode
FROM [Sales].[CountryRegionCurrency]
UNION
SELECT CurrencyCode
FROM [Sales].[Currency]
ORDER BY CurrencyCode
/*=====================================================================================*/

/*=====================================================================================
Next is the EXCEPT keyword
https://docs.microsoft.com/en-us/sql/t-sql/language-elements/set-operators-except-and-intersect-transact-sql?view=sql-server-2017

"Returns distinct rows by comparing the results of two queries.

EXCEPT returns distinct rows from the left input query that aren’t output by the right input query."
=====================================================================================*/

/*note with first query all the records in the left recordset [Sales].[CountryRegionCurrency]
are present in the right recordset [Sales].[Currency]*/

USE AdventureWorks2012
SELECT CurrencyCode
FROM [Sales].[CountryRegionCurrency]
EXCEPT
SELECT CurrencyCode
FROM [Sales].[Currency]

/*note with second query all the records in the left recordset [Sales].[Currency]
there are 8 records which are not present in the right recordset [Sales].[CountryRegionCurrency]*/

SELECT CurrencyCode
FROM [Sales].[Currency]
EXCEPT
SELECT CurrencyCode
FROM [Sales].[CountryRegionCurrency]

/*============================================================================================================================
https://docs.microsoft.com/en-us/sql/t-sql/language-elements/set-operators-except-and-intersect-transact-sql?view=sql-server-2017
Last but not least is the EXCEPT keyword
"INTERSECT returns distinct rows that are output by both the left and right input queries operator."
There are 97 records which are present in BOTH recordsets
*/

USE AdventureWorks2012
SELECT CurrencyCode
FROM [Sales].[CountryRegionCurrency]
INTERSECT
SELECT CurrencyCode
FROM [Sales].[Currency]
ORDER BY CurrencyCode