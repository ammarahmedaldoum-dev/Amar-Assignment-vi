USE retail_analytics;

-- Common sales view used by the analyses below.
CREATE OR REPLACE VIEW v_order_sales AS
SELECT o.order_id, o.order_date, o.customer_id, c.customer_name, c.region AS customer_region,
       o.branch_id, b.branch_name, b.region AS branch_region, o.employee_id,
       SUM(oi.quantity * oi.unit_price) AS sales_amount
FROM sales_orders o
JOIN customers c ON c.customer_id = o.customer_id
JOIN branches b ON b.branch_id = o.branch_id
JOIN order_items oi ON oi.order_id = o.order_id
WHERE o.status = 'PAID'
GROUP BY o.order_id, o.order_date, o.customer_id, c.customer_name, c.region,
         o.branch_id, b.branch_name, b.region, o.employee_id;


