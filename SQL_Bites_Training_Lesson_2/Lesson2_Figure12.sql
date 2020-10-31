USE CCGTMongooseTCC;

/*get first 1000 grants for the purposes of demonstration */
SELECT TOP 100
       ID
INTO #Grants
FROM dbo.Grants;
/*=====================================================*/

SELECT BIV.[GrantID],
       BIV.[AnnualBudgetType],
       BIV.[Year],
       SUM(BIV.[Amount]) AS TotalAmount
FROM [dbo].[BudgetItemsView] AS BIV
/*===============================================
join to the temp table to only return 1000 grants
================================================*/
    INNER JOIN #Grants AS G
        ON G.ID = BIV.GrantID
/*================================================*/
GROUP BY BIV.[GrantID],
         BIV.[AnnualBudgetType],
         BIV.[Year] 
WITH ROLLUP
HAVING BIV.AnnualBudgetType = 'Validated'
ORDER BY BIV.GrantID,
         BIV.[Year];

DROP TABLE #Grants