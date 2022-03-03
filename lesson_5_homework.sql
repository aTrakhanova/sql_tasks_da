--схема БД: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing
--colab/jupyter: https://colab.research.google.com/drive/1j4XdGIU__NYPVpv74vQa9HUOAkxsgUez?usp=sharing

--task1 (lesson5)
-- Компьютерная фирма: Сделать view (pages_all_products), в которой будет постраничная разбивка всех продуктов (не более двух продуктов на одной странице). Вывод: все данные из laptop, номер страницы, список всех страниц

create view pages_all_products as
select *,
	case when num % 2 = 0
	then 2
	else 1
end num_in_page,
	case when num % 2 = 0
	then num / 2
	else num / 2 + 1
end page_number
from (
	select *,
	row_number() over (order by price desc) num
	from laptop
) laptop_with_pages ;

select *
from pages_all_products ;

--task2 (lesson5)
-- Компьютерная фирма: Сделать view (distribution_by_type), в рамках которого будет процентное соотношение всех товаров по типу устройства. Вывод: производитель, тип, процент (%)

create view distribution_by_type as 
select maker, type, 
	count(*)*100./(select count(*) from product) as percentage
from product
group by maker, type
order by maker ;

select *
from distribution_by_type ;

--task3 (lesson5)
-- Компьютерная фирма: Сделать на базе предыдущенр view график - круговую диаграмму. Пример https://plotly.com/python/histograms/

request = """
select maker, type, percentage 
from distribution_by_type
"""
df = pd.read_sql_query(request, conn)
fig = go.Figure()
fig.add_trace(go.Pie(values=df['percentage'], labels=df['maker'], sort = False))
fig.show()

--task4 (lesson5)
-- Корабли: Сделать копию таблицы ships (ships_two_words), но название корабля должно состоять из двух слов

create table ships_two_words as 
select *
from ships
where name like '% %' ;

select *
from ships_two_words ;

--task5 (lesson5)
-- Корабли: Вывести список кораблей, у которых class отсутствует (IS NULL) и название начинается с буквы "S"

select ship
from
	(
		select ship, class 
		from outcomes
		left join ships 
		on outcomes.ship = ships.name
	) as ships_with_class
where class is null and ship like 'S_%' ;

--task6 (lesson5)
-- Компьютерная фирма: Вывести все принтеры производителя = 'A' со стоимостью выше средней по принтерам производителя = 'C' и три самых дорогих (через оконные функции). Вывести model

with printers_with_makers as 
	(select maker, printer.model, price
	from printer
	join product
	on printer.model = product.model)
select model
from (
	select *,
	row_number(*) over (partition by maker order by price desc) rn
	from printers_with_makers
) ranked_printers 
where maker = 'A' and 
price > (select avg(price) from printers_with_makers where maker = 'C') and
rn <= 3 ;
