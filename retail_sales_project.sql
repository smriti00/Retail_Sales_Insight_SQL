-- 1. Customers Table
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(100),
    age INT,
    location VARCHAR(100)
);
INSERT INTO customers VALUES
(1, 'Smriti', 24, 'Delhi'),
(2, 'Rahul', 30, 'Mumbai'),
(3, 'Anjali', 27, 'Bangalore');
SELECT * FROM customers;

-- 2. Products Table
CREATE TABLE products (
    product_id INT PRIMARY KEY,
    name VARCHAR(100),
    category VARCHAR(50),
    price DECIMAL(10,2)
);
INSERT INTO products VALUES
(1, 'Laptop', 'Electronics', 55000),
(2, 'Phone', 'Electronics', 20000),
(3, 'Table', 'Furniture', 5000),
(4, 'Chair', 'Furniture', 3000);
SELECT * FROM products;

-- 3. Orders Table
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);
INSERT INTO orders VALUES
(101, 1, '2024-06-10'),
(102, 2, '2024-06-15'),
(103, 1, '2024-07-01');
SELECT * FROM orders;

-- 4. Order_Items Table
CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);
INSERT INTO order_items VALUES
(1, 101, 1, 1),
(2, 101, 4, 2),
(3, 102, 2, 1),
(4, 103, 3, 1),
(5, 103, 4, 1);
SELECT * FROM order_items;

-- Total Sales by Product
SELECT 
    p.name AS product_name,
    SUM(oi.quantity * p.price) AS total_sales
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.name
ORDER BY total_sales DESC;

-- Monthly Revenue
SELECT 
    MONTH(o.order_date) AS month,
    SUM(oi.quantity * p.price) AS revenue
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
GROUP BY MONTH(o.order_date)
ORDER BY month;

-- Top Customers by Spend
SELECT 
    c.name,
    SUM(oi.quantity * p.price) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
GROUP BY c.name
ORDER BY total_spent DESC;

-- Create View for Sales Summary
CREATE VIEW sales_summary AS
SELECT 
    o.order_id,
    c.name AS customer,
    o.order_date,
    p.name AS product,
    oi.quantity,
    (oi.quantity * p.price) AS total_price
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id;

