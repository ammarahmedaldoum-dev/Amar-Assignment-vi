USE retail_analytics;

-- Run after the database setup scripts. Queries using v_order_sales require database/04_create_view.sql.
-- 2. LEFT JOIN: every customer, including customers with no orders.
SELECT c.customer_id, c.customer_name, COUNT(DISTINCT o.order_id) AS order_count
FROM customers c LEFT JOIN sales_orders o ON o.customer_id = c.customer_id
GROUP BY c.customer_id, c.customer_name
ORDER BY c.customer_id;



