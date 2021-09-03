-------------------------------
-- SQL - USE Variables and Loops
----------------------------------- 

DECLARE @sub_date AS DATE = '2016-03-02';
/* OR
DECLARE @sub_date AS DATE
SET @sub_date = '2016-03-02'; */

WITH CTE_1 AS (
SELECT DISTINCT hacker_id
    ,   submission_date
FROM Submissions
WHERE submission_date = @sub_date),
CTE_2 AS (
SELECT DISTINCT hacker_id
    ,   submission_date
FROM Submissions
WHERE submission_date = (SELECT DATEADD(DAY, -1, @sub_date))
    )

SELECT COUNT(DISTINCT ct2.hacker_id)
FROM CTE_1 ct1
INNER JOIN CTE_2 ct2  ON ct1.hacker_id = ct2.hacker_id

-----------------------------------
/* Write a query to print the pattern P(20) as below where the pattern has 20 rows and 20 * in the first row
* * * * * * 
* * * * 
* * * 
* * 
*
*/
DECLARE @n AS INT = 20;

WHILE @n > 0
BEGIN
    PRINT REPLICATE("* " , @n)
    SET @n = @n - 1
END

