--����� ��: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing
--colab/jupyter: https://colab.research.google.com/drive/1j4XdGIU__NYPVpv74vQa9HUOAkxsgUez?usp=sharing

-- ������� 1: ������� name, class �� ��������, ���������� ����� 1920
--
select name, class 
from ships 
where launched > 1920;

-- ������� 2: ������� name, class �� ��������, ���������� ����� 1920, �� �� ������� 1942
--
select name, class 
from ships 
where launched > 1920 and launched < 1942;

-- ������� 3: ����� ���������� �������� � ������ ������. ������� ���������� � class
--
select count(*), class 
from ships 
group by class;


-- ������� 4: ��� ������� ��������, ������ ������ ������� �� ����� 16, ������� ����� � ������. (������� classes)
--
select class, country 
from classes 
where bore >= 16;

-- ������� 5: ������� �������, ����������� � ��������� � �������� ��������� (������� Outcomes, North Atlantic). �����: ship.
--
select ship
from outcomes 
where battle = 'North Atlantic' and result = 'sunk';

-- ������� 6: ������� �������� (ship) ���������� ������������ �������
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

-- ������� 7: ������� �������� ������� (ship) � ����� (class) ���������� ������������ �������
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

-- ������� 8: ������� ��� ����������� �������, � ������� ������ ������ �� ����� 16, � ������� ���������. �����: ship, class
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

-- ������� 9: ������� ��� ������ ��������, ���������� ��� (������� classes, country = 'USA'). �����: class
--
select class 
from classes
where country = 'USA';

-- ������� 10: ������� ��� �������, ���������� ��� (������� classes & ships, country = 'USA'). �����: name, class
--
select name, ships.class
from classes 
join ships 
on classes.class = ships.class
where country = 'USA';


-- ������� 18: ������� ��� �������� ������������� = 'A' �� ���������� ���� ������� �� ��������� ������������� = 'D'. ������� model
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

-- ������� 19: ������� ��������������, ������� ����������� �� ��� PC �� ��������� (speed) �� ����� 750, ��� � laptop �� ��������� (speed) �� ����� 750. ������� maker
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
	
-- ������� 20: ������� ������� ������ hd PC ������� �� ��� ��������������, ������� ��������� � ��������. �������: maker, ������� ������ HD.
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

