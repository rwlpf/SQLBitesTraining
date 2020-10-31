 /*return 
 Average number of orders placed
 Max Number of orders placed
 Min Number of orders placed
 
 non-CTE query */
 USE [AdventureWorks2012];

  SELECT
  	(SELECT AVG(OrdersPlaced)
  	FROM (SELECT v.BusinessEntityID, v.[Name] AS VendorName, COUNT(*) AS OrdersPlaced
  			FROM Purchasing.PurchaseOrderHeader AS poh
  			INNER JOIN Purchasing.Vendor AS v ON poh.VendorID = v.BusinessEntityID
  			GROUP BY v.BusinessEntityID, v.[Name]) AS x
			) AS AvgOrdersPlaced,
  	(SELECT MAX(OrdersPlaced)
  	FROM (SELECT v.BusinessEntityID, v.[Name] AS VendorName, COUNT(*) AS OrdersPlaced
  			FROM Purchasing.PurchaseOrderHeader AS poh
  			INNER JOIN Purchasing.Vendor AS v ON poh.VendorID = v.BusinessEntityID
  			GROUP BY v.BusinessEntityID, v.[Name]) AS x) AS MaxOrdersPlaced,
  	(SELECT MIN(OrdersPlaced)
  	FROM (SELECT v.BusinessEntityID, v.[Name] AS VendorName, COUNT(*) AS OrdersPlaced
  			FROM Purchasing.PurchaseOrderHeader AS poh
  			INNER JOIN Purchasing.Vendor AS v ON poh.VendorID = v.BusinessEntityID
  			GROUP BY v.BusinessEntityID, v.[Name]) AS x) AS MinOrdersPlaced


			--SELECT v.BusinessEntityID, v.[Name] AS VendorName, COUNT(*) AS OrdersPlaced
  	--		FROM Purchasing.PurchaseOrderHeader AS poh
  	--		INNER JOIN Purchasing.Vendor AS v ON poh.VendorID = v.BusinessEntityID
  	--		GROUP BY v.BusinessEntityID, v.[Name]