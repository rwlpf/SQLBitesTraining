USE SQL_AdventureWork_SB;
/*======================================
Simple SELECT statment returns 8 records
======================================*/

SELECT [ID]
      ,[Item]
      ,[UserID]
  FROM [dbo].[Orders]

/*======================================
UNION Keyword
======================================*/
SELECT [ID]
      ,[Item]
      ,[UserID]
  FROM [dbo].[Orders]
  UNION 
  SELECT [ID]
      ,[Item]
      ,[UserID]
  FROM [dbo].[Orders]

/*======================================
UNION ALL Keyword
======================================*/
SELECT [ID]
      ,[Item]
      ,[UserID]
  FROM [dbo].[Orders]
  UNION ALL
  SELECT [ID]
      ,[Item]
      ,[UserID]
  FROM [dbo].[Orders]	  
/*====================================================
TEXT, NTEXT can be compared using UNION OR UNION ALL
=====================================================*/	  