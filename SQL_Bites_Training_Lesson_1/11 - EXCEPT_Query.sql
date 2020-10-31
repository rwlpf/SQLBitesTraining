USE SQL_AdventureWork_SB;
GO

/*====================================
SELECT statement returns 8 records
=====================================*/

SELECT [ID],
       [Item],
       [UserID]
FROM [dbo].[Orders]

/*====================================
EXCEPT statement returns ? records
=====================================*/

SELECT [ID],
       [Item],
       [UserID]
FROM [dbo].[Orders]
EXCEPT
SELECT [ID],
       [Item],
       [UserID]
FROM [dbo].[Orders];
GO