--task1  (lesson8)
-- oracle: https://leetcode.com/problems/department-top-three-salaries/

select Department, Employee, Salary
from
    (
        select d.name as Department, e.name as Employee, salary as Salary,
        dense_rank() over (partition by d.name order by salary desc) rank
        from Employee e
        join Department d
        on e.departmentId = d.id
    ) ranked_salary
where rank <= 3 ;

--task2  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/17

select member_name, status, costs
from FamilyMembers
JOIN 
(
    select sum(amount * unit_price) as costs, family_member
    from Payments
    where year(date) = 2005  
    GROUP BY family_member
) as t1
on FamilyMembers.member_id = t1.family_member ;

--task3  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/13

select name
FROM 
(
    select name, count(*) count
    from Passenger
    group by name
) a1 
where count >= 2;

--task4  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/38

select count(first_name) as count 
from Student
where first_name = 'Anna' ;

--task5  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/35

select count(classroom) as count
from Schedule
where date = '2019-09-02' ;

--task6  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/38

SELECT count(first_name) as count 
from Student
where first_name = 'Anna' ; 

--task7  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/32

SELECT FLOOR(AVG(year('2021-01-01') - year(birthday))) as age
from FamilyMembers ; 

--task8  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/27

select good_type_name, sum(amount * unit_price) as costs
from
(
    select good_type_name, good_id
    from GoodTypes
    join Goods
    on GoodTypes.good_type_id = Goods.type
) t1
join Payments
on Payments.good = t1.good_id
where YEAR(DATE) = 2005
group by good_type_name ;

--task9  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/37

SELECT MIN(TIMESTAMPDIFF(year, birthday, current_date)) as year
FROM Student ;

--task10  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/44

SELECT MAX(TIMESTAMPDIFF(year, birthday, current_date)) as max_year
FROM 
(
    SELECT student, name
    FROM Student_in_class
    JOIN Class
    ON Student_in_class.class = Class.id
) students_in_class
JOIN Student 
on Student.id = students_in_class.student 
WHERE name LIKE '10%' ;

--task11 (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/20

with types_of_goods as 
(SELECT good_type_name, good_id
FROM GoodTypes
JOIN Goods
ON GoodTypes.good_type_id = Goods.type)
SELECT status, member_name, costs
FROM 
(
    SELECT family_member, SUM(amount * unit_price) as costs, good_type_name
    FROM Payments
    JOIN types_of_goods
    ON Payments.good = types_of_goods.good_id
    GROUP BY family_member, good_type_name
) costs_of_family
JOIN FamilyMembers
ON FamilyMembers.member_id = costs_of_family.family_member
WHERE good_type_name = 'entertainment' ;

--task12  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/55

with number_of_flights as 
(SELECT company, COUNT(id) count
FROM Trip
GROUP BY Company)
DELETE FROM Company
WHERE id in 
    (SELECT company 
    FROM number_of_flights
    WHERE count = (SELECT MIN(count) FROM number_of_flights)
    ) ;

--task13  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/45

with number_of_classrooms as
(SELECT classroom, COUNT(classroom) count
FROM Schedule
GROUP BY classroom)
SELECT classroom 
FROM Schedule
WHERE classroom in 
    (SELECT classroom
    FROM number_of_classrooms
    WHERE count = (SELECT MAX(count) FROM number_of_classrooms)
    ) 
GROUP BY classroom;

--task14  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/43

SELECT last_name
FROM Teacher
JOIN 
(
    SELECT name, teacher
    FROM Subject
    JOIN Schedule
    ON Subject.id = Schedule.subject
) subjects
ON Teacher.id = subjects.teacher
WHERE name = 'Physical Culture' 
ORDER BY last_name ;

--task15  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/63

SELECT CONCAT(last_name, '.', LEFT(first_name, 1), '.', LEFT(middle_name, 1), '.')  as name
FROM Student
ORDER BY last_name, first_name, middle_name ;
