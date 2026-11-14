USE retail_analytics;

-- Run after the database setup scripts. Queries using v_order_sales require database/04_create_view.sql.
-- Consecutive customer purchases and gaps between each customer's orders.
WITH customer_order_sequence AS (
  SELECT customer_id, customer_name, order_id, order_date, sales_amount,
         LAG(order_date) OVER (PARTITION BY customer_id ORDER BY order_date, order_id) AS previous_order_date,
         LEAD(order_date) OVER (PARTITION BY customer_id ORDER BY order_date, order_id) AS next_order_date,
         LAG(sales_amount) OVER (PARTITION BY customer_id ORDER BY order_date, order_id) AS previous_order_sales
  FROM v_order_sales
)
SELECT *, DATEDIFF(order_date, previous_order_date) AS days_since_previous_order,
       sales_amount - previous_order_sales AS change_from_previous_order
FROM customer_order_sequence ORDER BY customer_id, order_date;



