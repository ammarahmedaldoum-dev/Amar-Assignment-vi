USE retail_analytics;

-- Run after the database setup scripts. Queries using v_order_sales require database/04_create_view.sql.
-- 4. FULL OUTER JOIN equivalent for MySQL: matched rows plus unmatched rows on either side.
-- UNION (rather than UNION ALL) avoids duplicating matching branches.
SELECT b.branch_id, b.branch_name, o.order_id
FROM branches b LEFT JOIN sales_orders o ON o.branch_id = b.branch_id
UNION
SELECT b.branch_id, b.branch_name, o.order_id
FROM branches b RIGHT JOIN sales_orders o ON o.branch_id = b.branch_id;



