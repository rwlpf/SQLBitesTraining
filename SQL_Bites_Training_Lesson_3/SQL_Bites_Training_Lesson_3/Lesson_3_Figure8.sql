--Script to allocate select (read only) permission to user 
--for any view beginning with RV_

/*===============================================================================*/
/*declare the variables*/
DECLARE @ViewName AS NVARCHAR(128);
DECLARE @Processed CHAR(1);
DECLARE @SQL AS NVARCHAR(4000);
DECLARE @UserName AS NVARCHAR(128);

/*replace user name*/
SET @UserName = 'user_name_foo';
/*===============================================================================*/
--create table containing list of view names
DECLARE @ViewNames AS TABLE
    (
      ViewName NVARCHAR(128) ,
      Processed CHAR(1)
    );

INSERT  INTO @ViewNames
        SELECT  TABLE_NAME ,
                'N'
        FROM    [INFORMATION_SCHEMA].[VIEWS]
        WHERE   TABLE_NAME LIKE 'RV_%';

/*===============================================================================*/

WHILE ( SELECT  COUNT(*)
        FROM    @ViewNames
        WHERE   Processed = 'N'
      ) > 0
    BEGIN 
    /*get record to process*/
        SELECT TOP 1
                @ViewName = ViewName
        FROM    @ViewNames
        WHERE   Processed = 'N';

	   /*Grant permission to 'user_name_foo' */

        SET @SQL = 'GRANT SELECT ON ' + @ViewName + ' TO ' + @UserName;
	   
        --SELECT  @SQL;
        EXEC sp_executesql @SQL;

	   --mark view as processed
        UPDATE  @ViewNames
        SET     Processed = 'Y'
        WHERE   ViewName = @ViewName; 

    END;

