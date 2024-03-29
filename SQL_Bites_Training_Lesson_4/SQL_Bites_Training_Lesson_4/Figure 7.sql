 /*return 
 Average number of orders placed
 Max Number of orders placed
 Min Number of orders placed
 
CTE query */
 USE [AdventureWorks2012];

 DECLARE @PreferredVendorStatus AS INT
 SET @PreferredVendorStatus = 0;

  WITH cte (VendorId, VendorName, OrdersPlaced)
  AS (
  	SELECT
  		v.BusinessEntityID,
  		v.[Name] AS VendorName,
  		COUNT(*) AS OrdersPlaced
  	FROM Purchasing.PurchaseOrderHeader AS poh
  	INNER JOIN Purchasing.Vendor AS v ON poh.VendorID = v.BusinessEntityID
  	GROUP BY v.BusinessEntityID, v.[Name], v.[PreferredVendorStatus]
	HAVING V.[PreferredVendorStatus] = @PreferredVendorStatus
  )
  SELECT
  	AVG(OrdersPlaced) AS AvgOrdersPlaced,
  	MAX(OrdersPlaced) AS MaxOrdersPlaced,
  	MIN(OrdersPlaced) AS MinOrdersPlaced
  FROM cte;