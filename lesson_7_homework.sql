--colab/jupyter: https://colab.research.google.com/drive/1j4XdGIU__NYPVpv74vQa9HUOAkxsgUez?usp=sharing

--task1  (lesson7)
-- sqlite3: Сделать тестовый проект с БД (sqlite3, project name: task1_7). В таблицу table1 записать 1000 строк с случайными значениями (3 колонки, тип int) от 0 до 1000.
-- Далее построить гистаграмму распределения этих трех колонок

# Импортируем библиотеку
import sqlite3
import pandas as pd

# Создаем соединение с БД
conn = sqlite3.connect('task1_7.db')

# Создаем таблицу с синтетическими данными, используя рекурсивный запрос
df = pd.read_sql('''
with recursive generate_series(col_1, col_2, col_3) as (
    select abs(random() % 1000) as col_1, abs(random() % 1000) as col_2, abs(random() % 1000) as col_3
    union all select abs(random() % 1000) as col_1, abs(random() % 1000) as col_2, abs(random() % 1000) as col_3
    from generate_series
    limit 1000)
select * from generate_series; 
''', conn)


df.to_sql(name='table1', con=conn)

# Строим гистограмму
from IPython.display import HTML
import plotly.express as px
import plotly.graph_objects as go

fig = go.Figure()
fig.add_trace(go.Histogram(x=df['col_1'], name='col_1'))
fig.add_trace(go.Histogram(x=df['col_2'], name='col_2')) 
fig.add_trace(go.Histogram(x=df['col_3'], name='col_3')) 
fig.update_layout(
    title="Гистограмма распределения данных в таблице 'table1'",
    title_x = 0.5,
    legend=dict(x=.5, xanchor="center", orientation="h"))
fig.show()

--task2  (lesson7)
-- oracle: https://leetcode.com/problems/duplicate-emails/

select email
from 
    (
        select email, count(*) as count
        from person
        group by email
    )
where count >= 2 ;

--task3  (lesson7)
-- oracle: https://leetcode.com/problems/employees-earning-more-than-their-managers/

select t1.name as employee
from employee t1
join employee t2 
on t1.managerId = t2.id
where t1.salary > t2.salary ;

--task4  (lesson7)
-- oracle: https://leetcode.com/problems/rank-scores/

select score, 
    dense_rank() over (order by score desc) rank
from scores ;

--task5  (lesson7)
-- oracle: https://leetcode.com/problems/combine-two-tables/

select firstName, lastName, city, state
from Person
left join Address
on Person.personId = Address.personId ;
