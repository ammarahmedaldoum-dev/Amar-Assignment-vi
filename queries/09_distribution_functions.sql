USE retail_analytics;

-- Run after the database setup scripts. This query uses v_order_sales.
-- Required success criterion: divide customers into four groups by total spending.
WITH customer_totals AS (
  SELECT c.customer_id, c.customer_name, c.region,
         COALESCE(SUM(v.sales_amount),0) AS total_spending
  FROM customers c LEFT JOIN v_order_sales v ON v.customer_id = c.customer_id
  GROUP BY c.customer_id, c.customer_name, c.region
)
SELECT customer_id, customer_name, region, total_spending,
       NTILE(4) OVER (ORDER BY total_spending DESC, customer_id) AS spending_quartile,
       CUME_DIST() OVER (ORDER BY total_spending) AS cumulative_distribution
FROM customer_totals ORDER BY spending_quartile, customer_id;

-- Each category's share of total product revenue distribution.
WITH product_revenue AS (
  SELECT p.product_id, p.product_name, p.category,
         COALESCE(SUM(oi.quantity * oi.unit_price),0) AS revenue
  FROM products p LEFT JOIN order_items oi ON oi.product_id = p.product_id
  GROUP BY p.product_id, p.product_name, p.category
)
SELECT product_name, category, revenue,
       CUME_DIST() OVER (PARTITION BY category ORDER BY revenue) AS category_cume_dist
FROM product_revenue ORDER BY category, revenue;

