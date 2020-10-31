/*
objective is to Calulate the Total amount for sales item from SalesDetail Table and store it in the Sales Table (for each row).
*/
/*Therefore first thing  is to create the sample Column, which goes something like this.*/ 


IF EXISTS
(
    SELECT 1
    FROM sys.columns
    WHERE name = N'TotalAmt'
          AND object_id = OBJECT_ID(N'Sales.SalesOrderHeader')
)
BEGIN
    PRINT 'Column Exists, going to do nothing.....';
END;
ELSE
BEGIN
    PRINT 'Column does not exist, adding it.....';
    ALTER TABLE Sales.SalesOrderHeader ADD TotalAmt REAL NOT NULL DEFAULT 0;
END;

/*do the update*/
UPDATE [Sales].[SalesOrderHeader]
SET TotalAmt = [SubTotal] + [TaxAmt] + [Freight];
/*finish the update*/


SELECT SUM([TotalAmt])
FROM [Sales].[SalesOrderHeader];
--123216786.147415