USE WindowFunctions


--DROP INDEX [ix_storeID_txDate_txID] ON [dbo].[transaction_history]
--GO


CREATE NONCLUSTERED INDEX ix_storeID_txDate_txID
ON dbo.transaction_history
(
	store_id, --P
	transaction_date, --P
	transaction_id --O
)
INCLUDE 
(
	actual_cost --C
);
GO