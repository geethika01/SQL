/*------------------------------------------------------------------
SQL - Sub queries and CTEs
---------------------------------------------------------------------
1. Julia asked her students to create some coding challenges. Write a query to print the hacker_id, name, and the total number of challenges created by each student. Sort your results by the total number of challenges in descending order. If more than one student created the same number of challenges, then sort the result by hacker_id. If more than one student created the same number of challenges and the count is less than the maximum number of challenges created, then exclude those students from the result. */

WITH Challenge_cnt_dat AS
    (SELECT hacker_id
         , COUNT(challenge_id) AS 'cnt'
    FROM Challenges
    GROUP BY hacker_id),
    
MAX_cnt_dat AS
    (SELECT MAX(cnt) AS MAX_cnt
        FROM Challenge_cnt_dat ),
        
Hacker_cnt AS 
    (SELECT cnt
        , COUNT(hacker_id) AS 'hacker_cnt'
    FROM Challenge_cnt_dat
    GROUP BY cnt )

SELECT cc.hacker_id
    , h.name
    , cc.cnt
   /* , hc.hacker_cnt   */
FROM Hacker_cnt hc
INNER JOIN Challenge_cnt_dat cc ON hc.cnt = cc.cnt 
INNER JOIN Hackers h on cc.hacker_id = h.hacker_id
WHERE cc.cnt = (SELECT MAX_cnt FROM MAX_cnt_dat)
OR hc.hacker_cnt = 1
ORDER BY cc.cnt desc, cc.hacker_id

------------

/*2. We define an employee's total earnings to be their monthly  worked, and the maximum total earnings to be the maximum total earnings for any employee in the Employee table. Write a query to find the maximum total earnings for all employees as well as the total number of employees who have maximum total earnings. Then print these values as  space-separated integers. */

SELECT TOP(1) x.ernings, COUNT(employee_id)
FROM (SELECT employee_id, salary * months as ernings FROM EMPLOYEE) x
GROUP BY x.ernings
ORDER BY x.ernings DESC

/*3. You are given a table, Projects, containing three columns: Task_ID, Start_Date and End_Date. It is guaranteed that the difference between the End_Date and the Start_Date is equal to 1 day for each row in the table. If the End_Date of the tasks are consecutive, then they are part of the same project. Samantha is interested in finding the total number of different projects completed. 
Write a query to output the start and end dates of projects listed by the number of days it took to complete the project in ascending order. If there is more than one project that have the same number of completion days, then order by the start date of the project. */

WITH Project_Start_Dates AS 
   (SELECT Start_Date
           , LEAD (Start_Date) OVER (ORDER BY Start_Date) AS 'Next_Start_Date'
    FROM Projects
    WHERE Start_Date NOT IN (
        SELECT DISTINCT End_Date
        FROM Projects)
     ),
    
    Project_End_Dates AS
    (SELECT End_Date
           , LEAD (End_Date) OVER (ORDER BY End_Date) AS 'Next_End_Date'
    FROM Projects
    WHERE End_Date NOT IN (
        SELECT DISTINCT Start_Date
        FROM Projects)
    )
    
 SELECT ps.Start_Date
       /* , ps.Next_Start_Date */
        , pe.End_Date
      /*  , pe.Next_End_Date 
      , DATEDIFF(DAY,  ps.Start_Date, pe.End_Date)*/
FROM Project_Start_Dates ps, Project_End_Dates pe
WHERE (pe.End_Date < ps.Next_Start_Date
       OR ps.Next_Start_Date IS NULL)
    AND pe.End_Date > ps.Start_Date
ORDER BY DATEDIFF(DAY,  ps.Start_Date, pe.End_Date), ps.Start_Date

----------------

