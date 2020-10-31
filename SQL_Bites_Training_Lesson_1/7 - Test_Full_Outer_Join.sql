USE SQL_AdventureWork_SB;
SELECT 
U.ID,
U.Name,
O.ID,
O.Item,
O.UserID
FROM Users AS U FULL OUTER JOIN Orders AS O
ON U.id = O.UserID