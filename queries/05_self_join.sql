USE retail_analytics;

-- Run after the database setup scripts. Queries using v_order_sales require database/04_create_view.sql.
-- 5. SELF JOIN: employees and their managers.
SELECT e.employee_id, CONCAT(e.first_name,' ',e.last_name) AS employee_name,
       CONCAT(m.first_name,' ',m.last_name) AS manager_name
FROM employees e LEFT JOIN employees m ON m.employee_id = e.manager_id
ORDER BY e.employee_id;



