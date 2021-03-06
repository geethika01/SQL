/*----------------------------------------------------- 
SQL - Window Functions
-------------------------------------------------------- */

--1. Running Total by Name
select 
name, 
sum(weight) over (order by name)
 from cats 
order by name

--2. Running Total by Name within breed
select 
 name,
breed,
sum(weight) over (partition by breed order by name) 
from cats 
order by breed, name

--3. Average weight within above and below rows
select 
name,
weight,
avg(weight) over (order by weight rows between 1 preceding  and 
 1 following)
from cats
order by weight

--4. Row_number() over color and name
select 
row_number() over (order by color, name),
name,
color
 from cats 
order by color, name

--5. Rank cats by weight in desc order - with rank() the next rank is skipped at ties
select 
rank() over (order by weight desc) as ranking,
weight,
name
from cats 
Order by ranking, name

--6. Rank Cats by age - Dont skip the next rank at ties
select 
dense_rank() over (order by age desc) as r,
name,
age
from cats 
order by age desc, name

--7. Calc the percent ranking by weight
select 
name,
weight,
percent_rank() over (order by weight) * 100 as percent
from cats 
order by weight

/*8. A median is defined as a number separating the higher half of a data set from the lower half. 
   Query the median of the Northern Latitudes (LAT_N) from STATION and round your answer to  decimal places. */

SELECT DISTINCT(CONVERT(DECIMAL(9,4)
		, PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY LAT_N) OVER ())) 
FROM STATION

/*9. Harry Potter and his friends are at Ollivander's with Ron, finally replacing Charlie's old broken wand.
   Hermione decides the best way to choose is by determining the minimum number of gold galleons needed to buy each non-evil wand of high power and age.
   Write a query to print the id, age, coins_needed, and power of the wands that Ron's interested in, sorted in order of descending power. */
   If more than one wand has same power, sort the result in order of descending age.

SELECT id
    ,  age
    ,  coins_needed
    ,  power    
FROM( 
    SELECT w.id
        , wp.age
        , w.coins_needed
        , w.power
        , RANK() OVER (PARTITION BY w.power, wp.age ORDER BY w.coins_needed) AS 'Wand_Rank'
    FROM Wands w
    JOIN Wands_Property wp ON w.code = wp.code
    WHERE wp.is_evil = 0 ) x
WHERE Wand_rank = 1      
ORDER BY power DESC, age DESC 

