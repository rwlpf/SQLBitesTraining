SET STATISTICS IO ON ;
SET STATISTICS TIME ON ;

SELECT  *
FROM    [20090716_cross].table1 t1
JOIN    (
        SELECT  t2o.*,
                (
                SELECT  COUNT(*)
                FROM    [20090716_cross].table2 t2i
                WHERE   t2i.id <= t2o.id
                ) AS rn
        FROM    [20090716_cross].table2 t2o
        ) t2
ON      t2.rn <= t1.row_count
ORDER BY
        t1.id, t2.id

SET STATISTICS IO ON ;
SET STATISTICS TIME ON ;

/*
(8 rows affected)
Table 'Worktable'. Scan count 100003, logical reads 8591703, physical reads 11, read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.
Table 'Worktable'. Scan count 0, logical reads 0, physical reads 0, read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.
Table 'table1'. Scan count 1, logical reads 2, physical reads 1, read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.
Table 'table2'. Scan count 2, logical reads 694, physical reads 16, read-ahead reads 338, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.

 SQL Server Execution Times:
   CPU time = 508314 ms,  elapsed time = 509339 ms. =  8.5 mins

 SQL Server Execution Times:
   CPU time = 0 ms,  elapsed time = 0 ms.

 SQL Server Execution Times:
   CPU time = 0 ms,  elapsed time = 0 ms.
   */
