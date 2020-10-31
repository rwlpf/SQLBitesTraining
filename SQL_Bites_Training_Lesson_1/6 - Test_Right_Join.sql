USE Test;
SELECT * FROM users AS U
RIGHT OUTER JOIN orders AS O ON U.id = O.userid