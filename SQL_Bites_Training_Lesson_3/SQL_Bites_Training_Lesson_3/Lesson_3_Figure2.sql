USE AdventureWorks2012
GO 

SELECT * FROM Production.ProductInventory as pinv
INNER JOIN Production.Product as pp
ON pinv.ProductID=pp.ProductID
WHERE pp.DaysToManufacture <= 1