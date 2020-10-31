/*
objective is to Calulate the Total amount for sales item from SalesDetail Table and store it in the Sales Table (for each row).
*/
/*Therefore first thing  is to create the sample Column, which goes something like this.*/ 

IF EXISTS(SELECT 1 FROM sys.columns 
          WHERE Name = N'TotalAmt'
          AND Object_ID = Object_ID(N'Sales.SalesOrderHeader'))
BEGIN 
	PRINT 'Column Exists, going to do nothing.....';
END 
ELSE
BEGIN
    PRINT 'Column does not exist, adding it.....';
	ALTER table Sales.SalesOrderHeader add TotalAmt real not null default 0
END

DECLARE @orderId INT;
DECLARE @taxAmt REAL;
DECLARE @subTotal REAL;
DECLARE @freight REAL;

DECLARE [adventure_cursor] CURSOR FOR
SELECT  [SalesOrderID], [SubTotal], [TaxAmt], [Freight] FROM    [Sales].[SalesOrderHeader];

OPEN [adventure_cursor];

FETCH NEXT FROM [adventure_cursor]
INTO
    @orderId
  , @subTotal
  , @taxAmt
  , @freight;

WHILE @@fetch_status = 0
    BEGIN

        UPDATE
            [Sales].[SalesOrderHeader] SET
            [TotalAmt] = @subTotal + @taxAmt + @freight WHERE   [SalesOrderID] = @orderId ;

        FETCH NEXT FROM [adventure_cursor]
        INTO
            @orderId
          , @subTotal
          , @taxAmt
          , @freight ;

    END ;

CLOSE [adventure_cursor];

DEALLOCATE [adventure_cursor];

SELECT SUM([TotalAmt])
FROM    [Sales].[SalesOrderHeader];
--123216786.147415
