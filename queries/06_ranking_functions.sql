USE retail_analytics;

-- Run after the database setup scripts.
-- PART B-A: ranking functions
-- Product ranking by revenue; ties are retained for RANK and DENSE_RANK.
WITH product_sales AS (
  SELECT p.product_id, p.product_name, p.category,
         COALESCE(SUM(oi.quantity * oi.unit_price),0) AS revenue
  FROM products p LEFT JOIN order_items oi ON oi.product_id = p.product_id
  GROUP BY p.product_id, p.product_name, p.category
)
SELECT product_name, category, revenue,
       ROW_NUMBER() OVER (ORDER BY revenue DESC, product_id) AS row_num,
       RANK() OVER (ORDER BY revenue DESC) AS revenue_rank,
       DENSE_RANK() OVER (ORDER BY revenue DESC) AS dense_revenue_rank,
       PERCENT_RANK() OVER (ORDER BY revenue DESC) AS percentile_rank
FROM product_sales ORDER BY revenue DESC, product_id;

-- Required success criterion: top five products in every branch region using RANK().
WITH regional_product_sales AS (
  SELECT b.region, p.product_id, p.product_name,
         SUM(oi.quantity * oi.unit_price) AS revenue
  FROM sales_orders o
  JOIN branches b ON b.branch_id = o.branch_id
  JOIN order_items oi ON oi.order_id = o.order_id
  JOIN products p ON p.product_id = oi.product_id
  WHERE o.status = 'PAID'
  GROUP BY b.region, p.product_id, p.product_name
), ranked AS (
  SELECT *, RANK() OVER (PARTITION BY region ORDER BY revenue DESC) AS region_rank
  FROM regional_product_sales
)
SELECT region, product_name, revenue, region_rank
FROM ranked WHERE region_rank <= 5
ORDER BY region, region_rank, product_name;

-- Top three customers within each customer region.
WITH customer_sales AS (
  SELECT c.customer_id, c.customer_name, c.region,
         COALESCE(SUM(v.sales_amount),0) AS revenue
  FROM customers c LEFT JOIN v_order_sales v ON v.customer_id = c.customer_id
  GROUP BY c.customer_id, c.customer_name, c.region
), ranked AS (
  SELECT *, ROW_NUMBER() OVER (PARTITION BY region ORDER BY revenue DESC, customer_id) AS rn
  FROM customer_sales
)
SELECT region, customer_name, revenue, rn FROM ranked WHERE rn <= 3 ORDER BY region, rn;

-- Employee performance ranking within branch.
WITH employee_sales AS (
  SELECT e.employee_id, CONCAT(e.first_name,' ',e.last_name) AS employee_name,
         b.branch_name, COALESCE(SUM(v.sales_amount),0) AS revenue
  FROM employees e JOIN branches b ON b.branch_id = e.branch_id
  LEFT JOIN v_order_sales v ON v.employee_id = e.employee_id
  GROUP BY e.employee_id, employee_name, b.branch_name
)
SELECT *, DENSE_RANK() OVER (PARTITION BY branch_name ORDER BY revenue DESC) AS branch_rank
FROM employee_sales ORDER BY branch_name, branch_rank, employee_name;

-- Highest performing branch(es); ties share rank 1.
WITH branch_sales AS (
  SELECT b.branch_id, b.branch_name, COALESCE(SUM(v.sales_amount),0) AS revenue
  FROM branches b LEFT JOIN v_order_sales v ON v.branch_id = b.branch_id
  GROUP BY b.branch_id, b.branch_name
), ranked AS (
  SELECT *, RANK() OVER (ORDER BY revenue DESC) AS rnk FROM branch_sales
)
SELECT branch_name, revenue FROM ranked WHERE rnk = 1;

-- ROW_NUMBER numbers each row uniquely, RANK leaves gaps after ties,
-- and DENSE_RANK leaves no gaps after ties.



