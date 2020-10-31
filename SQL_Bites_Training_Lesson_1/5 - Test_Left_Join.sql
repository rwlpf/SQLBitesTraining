USE Test;
SELECT * FROM users AS U
LEFT OUTER JOIN orders AS O ON U.id = O.userid