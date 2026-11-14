USE retail_analytics;

-- Run after the database setup scripts. Queries using v_order_sales require database/04_create_view.sql.
-- PART B-B and C: aggregate and navigation functions over monthly sales.
-- Monthly order counts and sales, including months without transactions.
WITH RECURSIVE months AS (
  SELECT DATE('2025-01-01') AS month_start
  UNION ALL SELECT month_start + INTERVAL 1 MONTH FROM months WHERE month_start < '2025-12-01'
), monthly AS (
  SELECT m.month_start, YEAR(m.month_start) * 12 + MONTH(m.month_start) AS month_key,
         COALESCE(SUM(v.sales_amount),0) AS monthly_sales,
         COUNT(v.order_id) AS order_count
  FROM months m LEFT JOIN v_order_sales v
    ON v.order_date >= m.month_start AND v.order_date < m.month_start + INTERVAL 1 MONTH
  GROUP BY m.month_start
)
SELECT month_start, monthly_sales, order_count,
       SUM(monthly_sales) OVER (ORDER BY month_start ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_sales,
       AVG(monthly_sales) OVER (ORDER BY month_start ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS moving_avg_3_months,
       MIN(monthly_sales) OVER (PARTITION BY YEAR(month_start)) AS min_month_sales_in_year,
       MAX(monthly_sales) OVER (PARTITION BY YEAR(month_start)) AS max_month_sales_in_year,
       COUNT(*) OVER (PARTITION BY YEAR(month_start)) AS months_in_year,
       LAG(monthly_sales) OVER (ORDER BY month_start) AS previous_month_sales,
       LEAD(monthly_sales) OVER (ORDER BY month_start) AS next_month_sales,
       monthly_sales - LAG(monthly_sales) OVER (ORDER BY month_start) AS change_from_previous,
       AVG(monthly_sales) OVER (
         ORDER BY month_key RANGE BETWEEN 2 PRECEDING AND CURRENT ROW
       ) AS range_3_month_avg
FROM monthly ORDER BY month_start;

-- Average sale per branch and compare each order with its branch average.
SELECT branch_name, order_id, order_date, sales_amount,
       AVG(sales_amount) OVER (PARTITION BY branch_id) AS branch_average,
       sales_amount - AVG(sales_amount) OVER (PARTITION BY branch_id) AS difference_from_branch_avg
FROM v_order_sales ORDER BY branch_name, order_date;



