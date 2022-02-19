--схема БД: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing
--colab/jupyter: https://colab.research.google.com/drive/1j4XdGIU__NYPVpv74vQa9HUOAkxsgUez?usp=sharing

-- Задание 1: Вывести name, class по кораблям, выпущенным после 1920
--
select name, class 
from ships 
where launched > 1920;

-- Задание 2: Вывести name, class по кораблям, выпущенным после 1920, но не позднее 1942
--
select name, class 
from ships 
where launched > 1920 and launched < 1942;

-- Задание 3: Какое количество кораблей в каждом классе. Вывести количество и class
--
select count(*), class 
from ships 
group by class;

-- Задание 4: Для классов кораблей, калибр орудий которых не менее 16, укажите класс и страну. (таблица classes)
--
select class, country 
from classes 
where bore >= 16;

-- Задание 5: Укажите корабли, потопленные в сражениях в Северной Атлантике (таблица Outcomes, North Atlantic). Вывод: ship.
--
select ship
from outcomes 
where battle = 'North Atlantic' and result = 'sunk';

-- Задание 6: Вывести название (ship) последнего потопленного корабля
--
select ship 
from outcomes 
join battles 
on outcomes.battle = battles.name
where result = 'sunk' and date =  
	(select max(date)
	from outcomes 
	join battles 
	on outcomes.battle = battles.name);

-- Задание 7: Вывести название корабля (ship) и класс (class) последнего потопленного корабля
--
SELECT ship, ships.class 
from ships 
join (select ship 
	from outcomes 
	join battles 
	on outcomes.battle = battles.name
	where result = 'sunk' and date = (select max(date)
		from outcomes 
		join battles 
		on outcomes.battle = battles.name)) as last_sunk_ship
on ships.name = last_sunk_ship.ship

-- Задание 8: Вывести все потопленные корабли, у которых калибр орудий не менее 16, и которые потоплены. Вывод: ship, class
--
select name as ship, ships.class 
from classes 
join ships
on classes.class = ships.class
where bore >= 16 and name = (select ship 
	from ships 
	join outcomes 
	on ships.name = outcomes.ship
	where result = 'sunk') ;

-- Задание 9: Вывести все классы кораблей, выпущенные США (таблица classes, country = 'USA'). Вывод: class
--
select class 
from classes
where country = 'USA';

-- Задание 10: Вывести все корабли, выпущенные США (таблица classes & ships, country = 'USA'). Вывод: name, class
--
select name, ships.class
from classes 
join ships 
on classes.class = ships.class
where country = 'USA';

-- Задание 18: Вывести все принтеры производителя = 'A' со стоимостью выше средней по принтерам производителя = 'D'. Вывести model
--
select printer.model  
from product
join printer
on product.model = printer.model
where maker = 'A' and price > (select avg(price)
	from printer
	join product
	on printer.model = product.model
	where maker = 'D');

-- Задание 19: Найдите производителей, которые производили бы как PC со скоростью (speed) не менее 750, так и laptop со скоростью (speed) не менее 750. Вывести maker
--
select distinct maker
from product
join pc
on product.model = pc.model 
where speed >= 750 and maker in 
	(select distinct maker 
	from product
	join laptop
	on product.model = laptop.model 
	where speed >= 750 )

-- Задание 20: Найдите средний размер hd PC каждого из тех производителей, которые выпускают и принтеры. Вывести: maker, средний размер HD.
--
select maker, avg(hd)
from pc
join product
on pc.model = product.model 
where maker in (select distinct maker 
	from printer 
	join product 
	on printer.model = product.model)
group by maker;