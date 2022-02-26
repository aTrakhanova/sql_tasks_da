--схема БД: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing
--colab/jupyter: https://colab.research.google.com/drive/1j4XdGIU__NYPVpv74vQa9HUOAkxsgUez?usp=sharing

--task13 (lesson3)
--Компьютерная фирма: Вывести список всех продуктов и производителя с указанием типа продукта (pc, printer, laptop). Вывести: model, maker, type

select *
from product;

--task14 (lesson3)
--Компьютерная фирма: При выводе всех значений из таблицы printer дополнительно вывести для тех, у кого цена вышей средней PC - "1", у остальных - "0"

select *,
case
	when price > (select avg(price) from pc)
	then '1'
	else '0'
end flag 
from printer;

--task15 (lesson3)
--Корабли: Вывести список кораблей, у которых class отсутствует (IS NULL)

select name 
from ships
where class is null;

ИЛИ

select name, ship 
from ships
full join outcomes
on ships.name = outcomes.ship
where class is null;

--task16 (lesson3)
--Корабли: Укажите сражения, которые произошли в годы, не совпадающие ни с одним из годов спуска кораблей на воду.

with years_of_launches as 
  (select launched
  from ships
  where launched is not null)
select name 
from battles
where date_part('year', date) not in (select launched from years_of_launches)

--task17 (lesson3)
--Корабли: Найдите сражения, в которых участвовали корабли класса Kongo из таблицы Ships.

select distinct battle 
from outcomes
where ship in 
    (select name 
    from ships
    where class = 'Kongo')

ИЛИ

select battle
from outcomes 
join ships 
on outcomes.ship = ships.name
where class = 'Kongo'

--task1  (lesson4)
-- Компьютерная фирма: Сделать view (название all_products_flag_300) для всех товаров (pc, printer, laptop) с флагом, если стоимость больше > 300. Во view три колонки: model, price, flag

create view all_products_flag_300 as
select model, price,
case 
	when price > 300
	then 1
	else 0
end flag
from
	(
		select model, price 
		from pc 
		
		union all
		
		select model, price 
		from laptop
		
		union all 
		
		select model, price 
		from printer
	) as all_products ;

select *
from all_products_flag_300 ;

--task2  (lesson4)
-- Компьютерная фирма: Сделать view (название all_products_flag_avg_price) для всех товаров (pc, printer, laptop) с флагом, если стоимость больше cредней . Во view три колонки: model, price, flag

create view all_products_flag_avg_price as
with all_products as 
	(select model, price
	from pc 
	
	union all
	
	select model, price 
	from printer
	
	union all
	
	select model, price 
	from laptop
	)
select model, price,
case 
	when price > (select avg(price) from all_products)
	then 1
	else 0
end flag
from all_products ;

select *
from all_products_flag_avg_price ;

--task3  (lesson4)
-- Компьютерная фирма: Вывести все принтеры производителя = 'A' со стоимостью выше средней по принтерам производителя = 'D' и 'C'. Вывести model

with printer_with_makers as 
	(
		select maker, printer.model, price
		from printer 
		join product 
		on printer.model = product.model
	) 
select model 
from printer_with_makers
where maker = 'A' and price > (select avg (price) 
                        	from printer_with_makers 
							where maker = 'D' or maker = 'C') ;

--task4 (lesson4)
-- Компьютерная фирма: Вывести все товары производителя = 'A' со стоимостью выше средней по принтерам производителя = 'D' и 'C'. Вывести model

with printer_with_makers as 
	(
		select maker, printer.model, price
		from printer 
		join product 
		on printer.model = product.model
	) 
select products_with_makers.model
from 
	(
		select model, price
		from pc 
		
		union all
		
		select model, price 
		from printer 
		
		union all 
		
		select model, price 
		from laptop 
	) as all_products
left join 
	(
		select model, maker 
		from product 
	) as products_with_makers 
on all_products.model = products_with_makers.model
where maker = 'A' and price > (select avg(price) from printer_with_makers where maker = 'D' or maker = 'C') ;

--task5 (lesson4)
-- Компьютерная фирма: Какая средняя цена среди продуктов производителя = 'A' (printer & laptop & pc)

select avg(price)
from 
	(
		select model, price 
		from pc 
		
		union all
		
		select model, price
		from printer 
		
		union all
		
		select model, price 
		from laptop
	) as all_products
left join 
	(
		select model, maker
		from product
	) as products_with_makers
on all_products.model = products_with_makers.model
where maker = 'A'
group by maker ;

--task6 (lesson4)
-- Компьютерная фирма: Сделать view с количеством товаров (название count_products_by_makers) по каждому производителю. Во view: maker, count

create view count_products_by_makers as 
select maker, count(model) count
from product
group by maker
order by maker asc ;

select *
from count_products_by_makers ;

--task7 (lesson4)
-- По предыдущему view (count_products_by_makers) сделать график в colab (X: maker, y: count)

request = """
select maker, count
from count_products_by_makers
"""
df = pd.read_sql_query(request, conn)
fig = px.bar(x=df.maker, y=df['count'], labels={'x':'maker', 'y':'count'})
fig.show()

--task8 (lesson4)
-- Компьютерная фирма: Сделать копию таблицы printer (название printer_updated) и удалить из нее все принтеры производителя 'D'

create table printer_updated as table printer;

delete from printer_updated
where model in 
	(select printer_updated.model
	from printer_updated
	join product 
	on printer_updated.model = product.model
	where maker = 'D') ;

select *
from printer_updated;

--task9 (lesson4)
-- Компьютерная фирма: Сделать на базе таблицы (printer_updated) view с дополнительной колонкой производителя (название printer_updated_with_makers)

create view printer_updated_with_makers as 
select code, printer_updated.model, color, printer_updated.type, price, maker
from printer_updated
join product
on printer_updated.model = product.model ;

select *
from printer_updated_with_makers ;

--task10 (lesson4)
-- Корабли: Сделать view c количеством потопленных кораблей и классом корабля (название sunk_ships_by_classes). Во view: count, class (если значения класса нет/IS NULL, то заменить на 0)

create view sunk_ships_by_classes as 
select count(ship) count,
case 
	when class is not null
	then class
	else '0'
end ship_class
from
	(
		select ship, class, result
		from outcomes
		left join ships
		on ships.name = outcomes.ship	
	) as sunked_ships
where result = 'sunk'
group by class ;

select *
from sunk_ships_by_classes ;

--task11 (lesson4)
-- Корабли: По предыдущему view (sunk_ships_by_classes) сделать график в colab (X: class, Y: count)

request = """
select count, ship_class
from sunk_ships_by_classes
"""
df = pd.read_sql_query(request, conn)
fig = px.bar(x=df.ship_class, y=df['count'], labels={'x':'ship_class', 'y':'count'})
fig.show()

--task12 (lesson4)
-- Корабли: Сделать копию таблицы classes (название classes_with_flag) и добавить в нее flag: если количество орудий больше или равно 9 - то 1, иначе 0

create table classes_with_flag as table classes ;

select *,
case when numguns >= 9
then 1
else 0
end flag
from classes_with_flag ;

--task13 (lesson4)
-- Корабли: Сделать график в colab по таблице classes с количеством классов по странам (X: country, Y: count)

request = """
select count(class) as count, country 
from classes
group by country 
order by country asc
"""
df = pd.read_sql_query(request, conn)
fig = px.bar(x=df.country, y=df['count'], labels={'x':'country', 'y':'count'})
fig.show()

--task14 (lesson4)
-- Корабли: Вернуть количество кораблей, у которых название начинается с буквы "O" или "M".

select count(name) count_of_ships
from ships 
where name like 'O%' or name like 'M%' ;

--task15 (lesson4)
-- Корабли: Вернуть количество кораблей, у которых название состоит из двух слов.

select count(name) count_of_ships
from ships 
where name like '% %' ;

--task16 (lesson4)
-- Корабли: Построить график с количеством запущенных на воду кораблей и годом запуска (X: year, Y: count)

request = """
select launched as year, count(name) as count 
from ships 
group by year
order by year asc
"""
df = pd.read_sql_query(request, conn)
fig = px.bar(x=df.year, y=df['count'], labels={'x':'year', 'y':'count'})
fig.show()