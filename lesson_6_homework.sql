--схема БД: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing
--colab/jupyter: https://colab.research.google.com/drive/1j4XdGIU__NYPVpv74vQa9HUOAkxsgUez?usp=sharing

--task5  (lesson6)
-- Компьютерная фирма: Создать таблицу all_products_with_index_task5 как объединение всех данных по ключу code (union all) и сделать флаг (flag) по цене > максимальной по принтеру. Также добавить нумерацию (через оконные функции) по каждой категории продукта в порядке возрастания цены (price_index). По этому price_index сделать индекс

create table all_products_with_index_task5 as
select *,
case 
	when price > (select max(price) from printer)
	then 1
	else 0
end flag, 
row_number() over (partition by type order by price asc) price_index
from (
	select maker, product.model, product.type, price
	from pc
	join product 
	on pc.model = product.model
	
	union all
	
	select maker, product.model, product.type, price
	from laptop 
	join product 
	on laptop.model = product.model
	
	union all
	
	select maker, product.model, product.type, price
	from printer
	join product 
	on printer.model = product.model
	) all_products ;

create index price_idx on all_products_with_index_task5 (price_index) ;

--task1  (lesson6, дополнительно)
-- SQL: Создайте таблицу с синтетическими данными (10000 строк, 3 колонки, все типы int) и заполните ее случайными данными от 0 до 1 000 000. Проведите EXPLAIN операции и сравните базовые операции.

create table if not exists my_table (	
	col_1 int not null,
	col_2 int not null, 
	col_3 int not null
);
create or replace function
random_in_range(integer, integer) returns integer as $$
    select floor(($1 + ($2 - $1 + 1) * random()))::integer;
$$ language sql;

insert into my_table(col_1, col_2, col_3)
	select random_in_range(0, 1000000), random_in_range(0, 1000000), random_in_range(0, 1000000)
	from generate_series(1,10000);

select * from my_table ;

explain 
insert into my_table(col_1, col_2, col_3)
	select random_in_range(0, 1000000), random_in_range(0, 1000000), random_in_range(0, 1000000)
	from generate_series(1,10000);

explain select * from my_table ;

explain
select count(*)
from my_table 
where col_1 < 60000 and col_3 > 500000;

explain analyze
select sum(col_3)
from my_table 
where col_1 < 7000 and col_2 > 60000;

--task2 (lesson6, дополнительно)
-- GCP (Google Cloud Platform): Через GCP загрузите данные csv в базу PSQL по личным реквизитам (используя только bash и интерфейс bash) 

psql -h 52.157.159.24 -Ustudent21 sql_ex_for_student21

 create table avocado (num int, Date date, 
AveragePrice real, "Total_Volume" real, "4046" real, "4225" real, "4770" real, 
"Total Bags" real, "Small Bags" real, "Large Bags" real, "XLarge Bags" real,0
type varchar(255), year int, region varchar(255));

\copy avocado from '/home/anny_tr12/220228/avocado.csv' delimiter ',' csv header ;

select * from avocado ;