SET STATISTICS IO ON ;
SET STATISTICS TIME ON ;


SELECT  *
FROM    [20090716_cross].table1 t1
CROSS APPLY
        (
        SELECT  TOP (t1.row_count) *
        FROM    [20090716_cross].table2
        ORDER BY
                id
        ) t2
ORDER BY
        t1.id, t2.id

SET STATISTICS IO ON ;
SET STATISTICS TIME ON ;

/*
SQL Server parse and compile time: 
   CPU time = 0 ms, elapsed time = 0 ms.

 SQL Server Execution Times:
   CPU time = 0 ms,  elapsed time = 0 ms.
SQL Server parse and compile time: 
   CPU time = 0 ms, elapsed time = 0 ms.

 SQL Server Execution Times:
   CPU time = 0 ms,  elapsed time = 0 ms.

 SQL Server Execution Times:
   CPU time = 0 ms,  elapsed time = 0 ms.

(8 rows affected)
Table 'table2'. Scan count 1, logical reads 10, physical reads 0, read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.
Table 'table1'. Scan count 1, logical reads 2, physical reads 0, read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.

(1 row affected)

 SQL Server Execution Times:
   CPU time = 0 ms,  elapsed time = 73 ms.
   */