--task1  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/the-report/problem

select
    case
        when grade >= 8 then name
        when grade < 8 then null
    end name,
grade, marks
from Students
join Grades
on Students.Marks between Min_Mark and Max_Mark
order by grade desc, name asc, marks asc ;

--task2  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/occupations/problem

select Doctor, Professor, Singer, Actor
from 
(
    select Name, Occupation,
    row_number() over(partition by Occupation order by name) rn
    from Occupations
) rn_names
pivot
(max(name) for Occupation in ('Doctor' as Doctor, 'Professor' as Professor, 'Singer' as Singer, 'Actor' as Actor)
) pvt_table 
order by rn asc;

--task3  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/weather-observation-station-9/problem

select distinct city
from station
where not (city like 'A%' or city like 'E%' or city like 'O%' or city like 'U%' or city like 'I%') ;

--task4  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/weather-observation-station-10/problem

select distinct city
from station
where not (city like '%a' or city like '%e' or city like '%o' or city like '%i' or city like '%u') ;

--task5  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/weather-observation-station-11/problem

select distinct city
from station
where 
(
    not(city like 'A%' or city like 'E%' or city like 'U%' or city like 'I%' or city like 'O%') or 
    not(city like '%a' or city like '%e' or city like '%u' or city like '%i' or city like '%o')
) ;

--task6  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/weather-observation-station-12/problem

select distinct city
from station
where 
(
    not(city like 'A%' or city like 'E%' or city like 'U%' or city like 'I%' or city like 'O%') and 
    not(city like '%a' or city like '%e' or city like '%u' or city like '%i' or city like '%o')
) ;

ИЛИ

select distinct city
from station
where not
(
    (city like 'A%' or city like 'E%' or city like 'U%' or city like 'I%' or city like 'O%') or 
    (city like '%a' or city like '%e' or city like '%u' or city like '%i' or city like '%o')
) ;

--task7  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/salary-of-employees/problem

select name
from employee
where salary > 2000 and months < 10
order by employee_id asc ;

--task8  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/the-report/problem

select
    case
        when grade >= 8 then name
        when grade < 8 then null
    end name,
grade, marks
from Students
join Grades
on Students.Marks between Min_Mark and Max_Mark
order by grade desc, name asc, marks asc ;