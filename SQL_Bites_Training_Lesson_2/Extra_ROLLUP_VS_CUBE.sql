/* Hey bright spark have you remember to use 192.168.2.44 ?????????? */

USE CCGTMongooseTCC;

SELECT TOP 100
       ID
INTO #Grants
FROM dbo.Grants;

SELECT     BIV.[GrantID],
           BIV.[AnnualBudgetType],
           BIV.[Year],
           SUM(BIV.[Amount]) AS TotalAmount
    FROM [dbo].[BudgetItemsView] AS BIV
        INNER JOIN #Grants AS G
            ON G.ID = BIV.GrantID
    GROUP BY BIV.[GrantID],
             BIV.[AnnualBudgetType],
             BIV.[Year]
   WITH ROLLUP
   --WITH CUBE
    HAVING BIV.AnnualBudgetType = 'Validated'
    ORDER BY BIV.GrantID,
             BIV.[Year]
;

WITH Step1
AS (SELECT TOP 100 PERCENT
           BIV.[GrantID],
           BIV.[AnnualBudgetType],
           BIV.[Year],
           SUM(BIV.[Amount]) AS TotalAmount,
           COUNT(*) OVER (PARTITION BY BIV.[GrantID] ORDER BY BIV.GrantID) AS [RecordCount]
    FROM [dbo].[BudgetItemsView] AS BIV
        INNER JOIN #Grants AS G
            ON G.ID = BIV.GrantID
    GROUP BY BIV.[GrantID],
             BIV.[AnnualBudgetType],
             BIV.[Year]
   --WITH ROLLUP
   WITH CUBE
    HAVING BIV.AnnualBudgetType = 'Validated'
    ORDER BY BIV.GrantID,
             BIV.[Year])
SELECT Step1.GrantID,
       Step1.AnnualBudgetType,
       COALESCE(CAST(Step1.[Year] AS NVARCHAR(5)), 'Total') AS [Year],
       Step1.TotalAmount
FROM Step1
ORDER BY Step1.GrantID,
         COALESCE(Step1.[Year], Step1.RecordCount);

DROP TABLE #Grants;