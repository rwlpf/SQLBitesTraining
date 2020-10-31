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
INTERSECT statement returns ? records
=====================================*/

SELECT [ID],
       [Item],
       [UserID]
FROM [dbo].[Orders]
INTERSECT
SELECT [ID],
       [Item],
       [UserID]
FROM [dbo].[Orders];
GO