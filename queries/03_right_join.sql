USE retail_analytics;

-- Run after the database setup scripts. Queries using v_order_sales require database/04_create_view.sql.
-- 3. RIGHT JOIN: every branch, including branches without orders.
SELECT b.branch_id, b.branch_name, COUNT(DISTINCT o.order_id) AS order_count
FROM sales_orders o RIGHT JOIN branches b ON b.branch_id = o.branch_id
GROUP BY b.branch_id, b.branch_name
ORDER BY b.branch_id;



