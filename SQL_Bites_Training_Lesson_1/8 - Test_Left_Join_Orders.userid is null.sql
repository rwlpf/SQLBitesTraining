USE SQL_AdventureWork_SB;
SELECT 
U.ID,
U.Name,
O.ID,
O.Item,
O.UserID
FROM Users AS U LEFT OUTER JOIN Orders AS O
ON U.id = O.UserID
WHERE O.userid IS NOT NULL