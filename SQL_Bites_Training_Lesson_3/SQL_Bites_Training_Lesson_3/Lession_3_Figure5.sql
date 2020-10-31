/*Corrlated sub query - https://en.wikipedia.org/wiki/Correlated_subquery
 and UPDATE statment using a FROM Clause*/

UPDATE  [Sales].[SalesOrderHeader]
SET [TotalAmt] = [list].[SubTotal] + [list].[TaxAmt] + [list].[Freight]
FROM
    [Sales].[SalesOrderHeader] AS [SalesOrder]
INNER JOIN
    (
        SELECT
            [SalesOrderID]
          , [SubTotal]
          , [TaxAmt]
          , [Freight]
        FROM
            (
                SELECT
                    [SalesOrderID]
                  , [SubTotal]
                  , [TaxAmt]
                  , [Freight]
                FROM
                    [Sales].[SalesOrderHeader]
            ) AS [T]
    )                          AS [list]
        ON [list].[SalesOrderID] = [SalesOrder].[SalesOrderID]
;