--3. Необходимо составить отчет для менеджеров (отправить ссылку на гитхаб с запросами):
--3.1. Посчитать количество заказов за все время. Смотри таблицу orders. Вывод: количество заказов.
select count(*) as "Количество заказов"
from orders

--3.2. Посчитать сумму денег по всем заказам за все время (учитывая скидки).  Смотри таблицу order_details. Вывод: id заказа, итоговый чек (сумма стоимостей всех  продуктов со скидкой)
select o.order_id, sum(o.unit_price * o.quantity * (1 - o.discount))::Decimal(10,2) as "Итоговый чек"
from order_details o
group by order_id
order by order_id

-- Решил использовать эту выборку для п.3.4 и сохранил как view
create view final_check as (
select o.order_id, sum(o.unit_price * o.quantity * (1 - o.discount))::Decimal(10,2) as "Итоговый чек"
from order_details o
group by order_id
order by o.order_id
)

--3.3. Показать сколько сотрудников работает в каждом городе. Смотри таблицу employee. Вывод: наименование города и количество сотрудников
select city, count(employee_id) as "Количество сотрудников"
from employees
group by city

--3.4. Показать фио сотрудника (одна колонка) и сумму всех его заказов 
select t1.last_name, sum("Итоговый чек")
from
(select e.last_name, o.order_id, sum(o_d.unit_price * o_d.quantity * (1 - o_d.discount))::Decimal(10,2)as "Итоговый чек"
from employees e 
	join orders o on  e.employee_id = o.employee_id
 	join order_details o_d on o.order_id =o_d.order_id
group by e.last_name, o.order_id
order by e.last_name
) as t1 
group by t1.last_name


--Вариант 2 с использованием view final_check из п.3.2
select e.last_name, sum("Итоговый чек")
from employees e 
	join orders o on  e.employee_id = o.employee_id
 	join final_check f on o.order_id =f.order_id
group by e.last_name 
order by e.last_name

--3.5. Показать перечень товаров от самых продаваемых до самых непродаваемых (в штуках). - Вывести наименование продукта и количество проданных штук.
select product_name, sum(quantity) as "Количество проданных штук"
from orders o join order_details o_d on o.order_id =o_d.order_id
join products p on p.product_id = o_d.product_id
group by product_name
order by "Количество проданных штук" desc

--Используемые таблицы:
--orders - заказы
--order_details - детали заказа 
--products - продукты
--employees - сотрудники
