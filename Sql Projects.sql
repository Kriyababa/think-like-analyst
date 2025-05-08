USE restaurant_db;

-- Objective 1-- Explore the items table - Your first objective is to better understand the items table by finding the number of rows in the table, the least and most expensive items, and the item prices within each category.

-- View the menu_items table and write a query to find the number of items on the menu
select * from menu_items;
select count(*) from menu_items;
-- What are the least and most expensive items on the menu?
select min(price) from menu_items;
-- or
select * from menu_items
order by price desc
LIMIT 1;

select max(price) from menu_items;
-- or
select * from menu_items
order by price
Limit 1;

select item_name, price
from menu_items
where price = (select min(price) from menu_items);
select item_name, price
from menu_items
where price = (select max(price) from menu_items);

-- How many Italian dishes are on the menu? What are the least and most expensive Italian dishes on the menu?
select count(*) from menu_items
where category = 'Italian';

select category, min(price)
from menu_items
where category = 'Italian';

select category, max(price)
from menu_items
where category = 'Italian';
SELECT item_name, category, price 
FROM menu_items 
WHERE category = 'Italian' 
AND price = (SELECT MIN(price) FROM menu_items WHERE category = 'Italian');
select item_name, category, price
from menu_items
where category = 'Italian'
and price = (select max(price) from menu_items where category = 'Italian');
-- How many dishes are in each category? What is the average dish price within each category?
select category, count(menu_item_id) as dish_id
from menu_items
group by category;

select category, avg(price)
from menu_items
group by category;

-- Objective 2
-- Explore the orders table-- Your second objective is to better understand the orders table by finding the date range, the number of items within each order, and the orders with the highest number of items.
-- View the order_details table. What is the date range of the table?
select * from order_details;
select min(order_date), max(order_date) from order_details;
-- How many orders were made within this date range? How many items were ordered within this date range?
select count(distinct order_id) from order_details;
select count(item_id) from order_details;

-- Which orders had the most number of items?
select order_id, count(item_id) as num_item
from order_details
group by order_id
order by num_item desc;

-- How many orders had more than 12 items?
select count(*) from 
(select order_id, count(item_id) as num_items
from order_details
group by order_id
having num_items > 12) as num_orders;

-- Objective 3 : Analyze customer behavior- Your final objective is to combine the items and orders tables, find the least and most ordered categories, and dive into the details of the highest spend orders.

-- Combine the menu_items and order_details tables into a single table
select * from
order_details od
left join
menu_items mi
on od.item_id = mi.menu_item_id;

-- What were the least and most ordered items? What categories were they in?
select item_name, category, count(order_details_id) as num_like
from order_details od left join menu_items mi
on od.item_id = mi.menu_item_id
group by item_name, category
order by num_like desc
LIMIT 1;

select item_name, category, count(order_details_id) as num_like
from order_details od left join menu_items mi
on od.item_id = mi.menu_item_id
group by item_name, category
order by num_like
LIMIT 1;

-- What were the top 5 orders that spent the most money?
select order_id, SUM(PRICE) AS total_spend
from
order_details od
left join
menu_items mi
on od.item_id = mi.menu_item_id
group by order_id
order by total_spend desc
limit 5;

-- View the details of the highest spend order. Which specific items were purchased?
select category, count(item_name) as num_item from
order_details od
left join
menu_items mi
on od.item_id = mi.menu_item_id
where order_id = 440
group by category;


--  View the details of the top 5 highest spend orders

select order_id, category, count(item_id) as name_i, sum(price) as total_spend
from order_details od left join
menu_items mi on 
od.item_id = mi.menu_item_id
where order_id in (440, 2075,1957, 330, 2675)
group by order_id, category
order by total_spend, name_i desc;

