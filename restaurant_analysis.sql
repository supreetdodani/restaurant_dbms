-- all menu items 
SELECT * FROM menu_items;

-- number of items in each category
SELECT category, 
		COUNT(menu_item_id) AS count 
	FROM menu_items
GROUP BY category;

-- most & least expensive items on the menu 
SELECT item_name, price
		FROM menu_items
WHERE price = (SELECT MAX(price) FROM menu_items)
		OR price = (SELECT MIN(price) FROM menu_items);

-- number of italian items on the menu 
SELECT category, 
	COUNT(*) as Total_items
		FROM menu_items
WHERE category = 'Italian'
	GROUP BY category; 

-- least & most expensive italian item on the menu 
SELECT category, item_name, price
		FROM menu_items
WHERE category = 'Italian'
	ORDER BY price;

-- number of dishes in each category with the avg category price 
SELECT category, 
		COUNT(*) AS total_items, 
		AVG(price) as average_price 
	FROM menu_items 
GROUP BY category;


-- all order details 
SELECT * FROM order_details;

-- date range of orders placed
SELECT 
MIN(order_date) AS first_order, 
MAX(order_date) AS last_order
	FROM order_details;

-- orders within the date range
SELECT 
COUNT(distinct order_id) as num_orders 
	FROM order_details;

-- number of items ordered within the date range 
SELECT COUNT(*) as item_orders 
	FROM order_details;

-- item count in different orders 
SELECT DISTINCT order_id, 
		COUNT(item_id) as num_items 
	FROM order_details 
GROUP BY order_id
ORDER BY num_items DESC; 

-- orders with more than 12 items 
SELECT COUNT(*) 
FROM (SELECT order_id, 
		COUNT(item_id) AS num_items
		FROM order_details
		GROUP BY order_id
		HAVING num_items > 12) 
AS orders; 
    
SELECT * FROM menu_items a
RIGHT JOIN order_details b
ON a.menu_item_id = b.item_id;

-- least and most ordered items category wise 
WITH details AS (SELECT * FROM menu_items a
				RIGHT JOIN order_details b
				ON a.menu_item_id = b.item_id)
SELECT category, 
		item_name, 
		COUNT(item_name) as num_orders
		FROM details
GROUP BY category, item_name
ORDER BY num_orders DESC; 

-- top 5 orders that spent the most money 
WITH details AS (SELECT * FROM menu_items a
				RIGHT JOIN order_details b
				ON a.menu_item_id = b.item_id)
SELECT order_id, 
		SUM(price) as total_spend 
		FROM details 
GROUP BY order_id
ORDER BY total_spend DESC
LIMIT 5;

-- details of the highest spent order 
WITH details AS (SELECT * FROM menu_items a
				RIGHT JOIN order_details b
				ON a.menu_item_id = b.item_id)
SELECT * FROM details 
	WHERE order_id  = 440
	ORDER BY category ASC;

-- details of the highest spent order category wise 
WITH details AS (SELECT * FROM menu_items a
				RIGHT JOIN order_details b
				ON a.menu_item_id = b.item_id)
SELECT category, 
		COUNT(item_name) AS num_items 
		FROM details 
WHERE order_id  = 440
GROUP BY category
ORDER BY category ASC;

-- details of the top 5 highest spent orders 
WITH details AS (SELECT * FROM menu_items a
				RIGHT JOIN order_details b
				ON a.menu_item_id = b.item_id)
SELECT * FROM details 
	WHERE order_id IN (440, 2075, 1957, 330, 2675)
ORDER BY order_id ASC;

-- OR 
WITH orders AS (WITH details AS (SELECT * FROM menu_items a
								RIGHT JOIN order_details b
								ON a.menu_item_id = b.item_id)
				SELECT order_id, SUM(price) as total_spend 
				FROM details 
				GROUP BY order_id
				ORDER BY total_spend DESC
				LIMIT 5) 
SELECT * 
FROM orders;

-- details of the top 5 highest spent orders category wise 
WITH details AS (SELECT * FROM menu_items a
				RIGHT JOIN order_details b
				ON a.menu_item_id = b.item_id)
SELECT category, 
		order_id, 
		COUNT(item_name) AS num_items 
		FROM details 
WHERE order_id IN (440, 2075, 1957, 330, 2675)
GROUP BY category, order_id;
