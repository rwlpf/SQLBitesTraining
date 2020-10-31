USE Test;
SELECT *
FROM users AS U
INNER JOIN orders AS O
ON U.id = O.UserID