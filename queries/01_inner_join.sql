USE retail_analytics;

-- Run after the database setup scripts. Queries using v_order_sales require database/04_create_view.sql.
-- 1. INNER JOIN: paid order lines with product names.
SELECT o.order_id, o.order_date, p.product_name, oi.quantity,
       oi.quantity * oi.unit_price AS line_sales
FROM sales_orders o
INNER JOIN order_items oi ON oi.order_id = o.order_id
INNER JOIN products p ON p.product_id = oi.product_id
ORDER BY o.order_id, p.product_name;



