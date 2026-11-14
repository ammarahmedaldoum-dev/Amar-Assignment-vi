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


