USE AdventureWorks2012;

DECLARE @id int
 
DECLARE cursorT CURSOR
--LOCAL STATIC
--LOCAL FAST_FORWARD
--LOCAL READ_ONLY FORWARD_ONLY
FOR
SELECT ProductId
FROM AdventureWorks2012.Production.Product
WHERE DaysToManufacture <= 1
 
OPEN cursorT 
FETCH NEXT FROM cursorT INTO @id
WHILE @@FETCH_STATUS = 0
BEGIN
          SELECT * FROM Production.ProductInventory
          WHERE ProductID=@id
          FETCH NEXT FROM cursorT INTO @id
END
CLOSE cursorT 
DEALLOCATE cursorT 