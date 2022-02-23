--схема БД: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing

--task1
--Корабли: Для каждого класса определите число кораблей этого класса, потопленных в сражениях. Вывести: класс и число потопленных кораблей.

select classes.class, count(sunked_ships.ship)
from classes
left join
	(
		select ship, class
		from outcomes
		left join ships
		on outcomes.ship = ships.name  
		where result = 'sunk'
	) as sunked_ships
on classes.class = sunked_ships.class or sunked_ships.ship = classes.class
group by classes.class;

--task2
--Корабли: Для каждого класса определите год, когда был спущен на воду первый корабль этого класса. Если год спуска на воду головного корабля неизвестен, определите минимальный год спуска на воду кораблей этого класса. Вывести: класс, год.

select classes.class, first_ship.year
from classes
left join 
	(
		select class, min(launched) as year
		from ships
		group by class
	) as first_ship
on classes.class = first_ship.class;

--task3
--Корабли: Для классов, имеющих потери в виде потопленных кораблей и не менее 3 кораблей в базе данных, вывести имя класса и число потопленных кораблей.

select classes.class, count(ship)
from classes
join 
	(
		select class, ship
		from outcomes  
		join ships
		on outcomes.ship = ships.name
		where result = 'sunk'
	) as sunked_ships
on classes.class = sunked_ships.class
join 
	(
		select count(name) as n_of_ships, class
		from ships 
		group by class
	) as number_of_ships 
on classes.class = number_of_ships.class
where number_of_ships.n_of_ships >= 3
group by classes.class;

--task4
--Корабли: Найдите названия кораблей, имеющих наибольшее число орудий среди всех кораблей такого же водоизмещения (учесть корабли из таблицы Outcomes).

select name 
from (
	select name, numguns, displacement 
	from ships
	join classes
	on ships.class = classes.class
	
	union
	
	select ship as name, numguns, displacement 
	from outcomes
	join classes 
	on outcomes.ship = classes.class and ship not in (select name from ships)
	) ships_incl_outcomes
join 
	(
	select max(numguns) as maxNumguns, displacement 
	from ships
	join classes
	on ships.class = classes.class
	group by displacement 
	
	union 
	
	select max(numguns) as maxNumguns, displacement
	from outcomes
	join classes
	on outcomes.ship = classes.class and ship not in (select name from ships)
	group by displacement
	) as maxNumguns_data
on ships_incl_outcomes.numguns = maxNumguns_data.maxNumguns and ships_incl_outcomes.displacement = maxNumguns_data.displacement;

