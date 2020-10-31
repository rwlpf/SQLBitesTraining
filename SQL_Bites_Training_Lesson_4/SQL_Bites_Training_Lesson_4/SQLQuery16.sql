Declare @RowNo int =1;
DECLARE @MaxRowNo INT = 5
;with ROWCTE as  
   (  
      SELECT @RowNo as ROWNO    
		UNION ALL  
      SELECT  ROWNO+1  
  FROM  ROWCTE  
  WHERE RowNo < @MaxRowNo
    )  
 
SELECT * FROM ROWCTE 