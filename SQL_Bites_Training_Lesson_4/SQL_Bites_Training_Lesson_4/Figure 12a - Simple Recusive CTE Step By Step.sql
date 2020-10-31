DECLARE @RowNo INT = 1;
DECLARE @MaxRowNo INT = 5;

/*===========================================
Anchor query
============================================*/

SELECT @RowNo AS ROWNO

/*============================================*/
;
WITH
ROWCTE
AS (
	SELECT @RowNo AS ROWNO
	)

SELECT ROWNO + 1 AS ROWNO
FROM ROWCTE
WHERE ROWNO < @MaxRowNo