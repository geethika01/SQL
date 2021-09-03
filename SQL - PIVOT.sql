/*----------------------
SQL PIVOT
------------------------
Pivot the Occupation column in OCCUPATIONS so that each Name is sorted alphabetically and displayed underneath its corresponding Occupation. The output column headers should be Doctor, Professor, Singer, and Actor, respectively.
Note: Print NULL when there are no more names corresponding to an occupation. */

SELECT [Doctor], [Professor], [Singer], [Actor] 
FROM (
SELECT ROW_NUMBER() OVER (PARTITION BY occupation ORDER BY name) AS row_num, * FROM occupations) t
PIVOT(MAX(name) FOR occupation IN ([Doctor], [Professor], [Singer], [Actor]))
    AS pvt;
	
-------------------------------
SELECT * FROM (
SELECT hacker_id
    ,   submission_date
    ,   COUNT(submission_date) AS 'sub_cnt'
FROM Submissions
GROUP BY hacker_id, submission_date) p
PIVOT (MAX(sub_cnt) 
       FOR submission_date IN ([2016-03-01],[2016-03-02],[2016-03-03],[2016-03-04],
                             [2016-03-05],[2016-03-06],[2016-03-07],[2016-03-08],
                             [2016-03-09],[2016-03-10],[2016-03-11],[2016-03-12],
                             [2016-03-13],[2016-03-14],[2016-03-15])) AS pvt