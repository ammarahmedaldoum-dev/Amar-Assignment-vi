-- Retail Sales Analytics: MySQL 8.0 teaching solution
-- Student: Amar Ahmed Alduom | Department: Data Sciences | Roll No.: 202512897
-- Prepared as an individual study draft; review and acknowledge assistance per course policy.
-- Run this whole script in a disposable MySQL schema. It recreates the project tables.
-- Review, understand, and adapt the model and queries before using any part in coursework.

CREATE DATABASE IF NOT EXISTS retail_analytics;
USE retail_analytics;

SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS payments;
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS sales_orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS branches;
SET FOREIGN_KEY_CHECKS = 1;

CREATE TABLE branches (
    branch_id INT PRIMARY KEY,
    branch_name VARCHAR(80) NOT NULL,
    region VARCHAR(50) NOT NULL,
    city VARCHAR(80) NOT NULL
);

CREATE TABLE employees (
    employee_id INT PRIMARY KEY,
    branch_id INT NOT NULL,
    manager_id INT NULL,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    hire_date DATE NOT NULL,
    FOREIGN KEY (branch_id) REFERENCES branches(branch_id),
    FOREIGN KEY (manager_id) REFERENCES employees(employee_id)
);

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    region VARCHAR(50) NOT NULL,
    joined_on DATE NOT NULL
);

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL CHECK (unit_price >= 0)
);

CREATE TABLE sales_orders (
    order_id INT PRIMARY KEY,
    customer_id INT NOT NULL,
    branch_id INT NOT NULL,
    employee_id INT NOT NULL,
    order_date DATE NOT NULL,
    status VARCHAR(20) NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (branch_id) REFERENCES branches(branch_id),
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id)
);

CREATE TABLE order_items (
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    unit_price DECIMAL(10,2) NOT NULL CHECK (unit_price >= 0),
    PRIMARY KEY (order_id, product_id),
    FOREIGN KEY (order_id) REFERENCES sales_orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

CREATE TABLE payments (
    payment_id INT PRIMARY KEY,
    order_id INT NOT NULL,
    paid_on DATE NOT NULL,
    amount DECIMAL(10,2) NOT NULL CHECK (amount >= 0),
    method VARCHAR(30) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES sales_orders(order_id)
);

INSERT INTO branches VALUES
(1,'Kigali Central','Kigali','Kigali'),(2,'Musanze Market','Northern','Musanze'),
(3,'Huye Plaza','Southern','Huye'),(4,'Rubavu Point','Western','Rubavu');

INSERT INTO employees VALUES
(1,1,NULL,'Aline','Uwimana','2021-02-10'),(2,1,1,'Eric','Niyonzima','2022-03-15'),
(3,2,NULL,'Diane','Mutesi','2020-07-01'),(4,2,3,'Jean','Habimana','2023-01-12'),
(5,3,NULL,'Grace','Mukamana','2019-05-20'),(6,3,5,'Paul','Iradukunda','2022-09-03'),
(7,4,NULL,'Chantal','Ingabire','2022-04-18');

INSERT INTO customers VALUES
(1,'Agnes M.','Kigali','2023-01-05'),(2,'Claude N.','Kigali','2023-02-10'),
(3,'Beata K.','Kigali','2023-03-11'),(4,'David U.','Northern','2023-04-01'),
(5,'Esther A.','Northern','2023-05-08'),(6,'Fabrice R.','Southern','2023-06-18'),
(7,'Imani T.','Southern','2023-07-22'),(8,'Patrick S.','Western','2023-08-02'),
(9,'Noel B.','Eastern','2023-09-09');

INSERT INTO products VALUES
(1,'Arabica Coffee','Grocery',8.50),(2,'Black Tea','Grocery',4.00),
(3,'Rice 5kg','Grocery',12.00),(4,'Cooking Oil 2L','Grocery',9.50),
(5,'Notebook','Stationery',2.50),(6,'Pen Pack','Stationery',3.00),
(7,'USB Drive','Electronics',15.00),(8,'Desk Lamp','Electronics',22.00);

INSERT INTO sales_orders VALUES
(1001,1,1,2,'2025-01-12','PAID'),(1002,2,1,2,'2025-01-25','PAID'),
(1003,4,2,4,'2025-02-10','PAID'),(1004,1,1,2,'2025-02-18','PAID'),
(1005,3,1,1,'2025-03-06','PAID'),(1006,5,2,4,'2025-03-20','PAID'),
(1007,6,3,6,'2025-04-03','PAID'),(1008,7,3,6,'2025-04-22','PAID'),
(1009,2,1,2,'2025-05-11','PAID'),(1010,4,2,3,'2025-05-27','PAID'),
(1011,8,4,7,'2025-06-08','PAID'),(1012,1,1,2,'2025-06-19','PAID'),
(1013,5,2,4,'2025-07-07','PAID'),(1014,3,1,2,'2025-07-23','PAID'),
(1015,6,3,6,'2025-08-05','PAID'),(1016,7,3,5,'2025-08-26','PAID'),
(1017,2,1,2,'2025-09-13','PAID'),(1018,8,4,7,'2025-10-02','PAID'),
(1019,4,2,4,'2025-11-15','PAID'),(1020,1,1,2,'2025-12-09','PAID');

INSERT INTO order_items VALUES
(1001,1,3,8.50),(1001,5,4,2.50),(1002,3,2,12.00),(1002,6,2,3.00),
(1003,2,5,4.00),(1003,4,2,9.50),(1004,7,1,15.00),(1004,1,2,8.50),
(1005,3,3,12.00),(1005,5,5,2.50),(1006,4,3,9.50),(1006,2,2,4.00),
(1007,8,1,22.00),(1007,6,3,3.00),(1008,1,4,8.50),(1008,3,1,12.00),
(1009,7,2,15.00),(1009,5,6,2.50),(1010,2,4,4.00),(1010,4,2,9.50),
(1011,8,2,22.00),(1011,1,2,8.50),(1012,3,2,12.00),(1012,6,4,3.00),
(1013,4,4,9.50),(1013,2,3,4.00),(1014,1,5,8.50),(1014,5,2,2.50),
(1015,7,1,15.00),(1015,3,2,12.00),(1016,8,1,22.00),(1016,6,5,3.00),
(1017,2,6,4.00),(1017,4,3,9.50),(1018,1,3,8.50),(1018,7,1,15.00),
(1019,3,4,12.00),(1019,5,8,2.50),(1020,4,3,9.50),(1020,1,2,8.50);

-- Add product variety so each branch region has enough products to rank its top five.
INSERT INTO order_items VALUES
(1003,1,1,8.50),(1003,3,1,12.00),(1003,5,1,2.50),(1003,6,1,3.00),
(1003,7,1,15.00),(1003,8,1,22.00),
(1011,2,1,4.00),(1011,3,1,12.00),(1011,4,1,9.50),(1011,5,1,2.50),(1011,6,1,3.00);

INSERT INTO payments VALUES
(1,1001,'2025-01-12',35.50,'CARD'),(2,1002,'2025-01-25',30.00,'CASH'),
(3,1003,'2025-02-10',39.00,'MOBILE'),(4,1004,'2025-02-18',32.00,'CARD'),
(5,1005,'2025-03-06',48.50,'CASH'),(6,1006,'2025-03-20',36.50,'MOBILE'),
(7,1007,'2025-04-03',31.00,'CARD'),(8,1008,'2025-04-22',46.00,'CASH'),
(9,1009,'2025-05-11',45.00,'MOBILE'),(10,1010,'2025-05-27',35.00,'CARD'),
(11,1011,'2025-06-08',61.00,'CASH'),(12,1012,'2025-06-19',36.00,'MOBILE'),
(13,1013,'2025-07-07',50.00,'CARD'),(14,1014,'2025-07-23',47.50,'CASH'),
(15,1015,'2025-08-05',39.00,'MOBILE'),(16,1016,'2025-08-26',37.00,'CARD'),
(17,1017,'2025-09-13',52.50,'CASH'),(18,1018,'2025-10-02',40.50,'MOBILE'),
(19,1019,'2025-11-15',68.00,'CARD'),(20,1020,'2025-12-09',45.50,'CASH');

-- Update payments for the extra sample items added above.
UPDATE payments SET amount = 87.50 WHERE order_id = 1003;
UPDATE payments SET amount = 92.00 WHERE order_id = 1011;

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

-- PART A: five JOIN types
-- 1. INNER JOIN: paid order lines with product names.
SELECT o.order_id, o.order_date, p.product_name, oi.quantity,
       oi.quantity * oi.unit_price AS line_sales
FROM sales_orders o
INNER JOIN order_items oi ON oi.order_id = o.order_id
INNER JOIN products p ON p.product_id = oi.product_id
ORDER BY o.order_id, p.product_name;

-- 2. LEFT JOIN: every customer, including customers with no orders.
SELECT c.customer_id, c.customer_name, COUNT(DISTINCT o.order_id) AS order_count
FROM customers c LEFT JOIN sales_orders o ON o.customer_id = c.customer_id
GROUP BY c.customer_id, c.customer_name
ORDER BY c.customer_id;

-- 3. RIGHT JOIN: every branch, including branches without orders.
SELECT b.branch_id, b.branch_name, COUNT(DISTINCT o.order_id) AS order_count
FROM sales_orders o RIGHT JOIN branches b ON b.branch_id = o.branch_id
GROUP BY b.branch_id, b.branch_name
ORDER BY b.branch_id;

-- 4. FULL OUTER JOIN equivalent for MySQL: matched rows plus unmatched rows on either side.
-- UNION (rather than UNION ALL) avoids duplicating matching branches.
SELECT b.branch_id, b.branch_name, o.order_id
FROM branches b LEFT JOIN sales_orders o ON o.branch_id = b.branch_id
UNION
SELECT b.branch_id, b.branch_name, o.order_id
FROM branches b RIGHT JOIN sales_orders o ON o.branch_id = b.branch_id;

-- 5. SELF JOIN: employees and their managers.
SELECT e.employee_id, CONCAT(e.first_name,' ',e.last_name) AS employee_name,
       CONCAT(m.first_name,' ',m.last_name) AS manager_name
FROM employees e LEFT JOIN employees m ON m.employee_id = e.manager_id
ORDER BY e.employee_id;

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
