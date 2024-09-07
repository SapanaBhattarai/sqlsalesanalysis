-- Sample Data and SQL Queries for Sales Analysis

-- Create tables
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100)
);

CREATE TABLE Products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(50),
    price DECIMAL(10, 2)
);

CREATE TABLE Sales (
    sale_id INT PRIMARY KEY,
    customer_id INT,
    product_id INT,
    sale_date DATE,
    quantity INT,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

-- Insert sample data
INSERT INTO Customers (customer_id, first_name, last_name, email) VALUES
(1, 'John', 'Doe', 'john.doe@example.com'),
(2, 'Jane', 'Smith', 'jane.smith@example.com'),
(3, 'Bob', 'Brown', 'bob.brown@example.com');

INSERT INTO Products (product_id, product_name, price) VALUES
(101, 'Widget', 25.00),
(102, 'Gadget', 15.00),
(103, 'Doodad', 35.00);

INSERT INTO Sales (sale_id, customer_id, product_id, sale_date, quantity) VALUES
(1, 1, 101, '2024-01-10', 2),
(2, 2, 102, '2024-01-12', 5),
(3, 3, 103, '2024-01-15', 1),
(4, 1, 102, '2024-01-17', 3),
(5, 2, 103, '2024-01-20', 2);

-- Total Sales Per Product
SELECT p.product_name, 
       SUM(s.quantity * p.price) AS total_sales
FROM Sales s
JOIN Products p ON s.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_sales DESC;

-- Top Customers by Total Spend
SELECT c.first_name, 
       c.last_name, 
       SUM(s.quantity * p.price) AS total_spend
FROM Sales s
JOIN Customers c ON s.customer_id = c.customer_id
JOIN Products p ON s.product_id = p.product_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_spend DESC;

-- Monthly Sales Report
SELECT DATE_FORMAT(s.sale_date, '%Y-%m') AS month, 
       SUM(s.quantity * p.price) AS monthly_sales
FROM Sales s
JOIN Products p ON s.product_id = p.product_id
GROUP BY month
ORDER BY month;

-- Product Sales Summary
SELECT p.product_name, 
       COUNT(s.sale_id) AS number_of_sales, 
       SUM(s.quantity) AS total_quantity_sold
FROM Sales s
JOIN Products p ON s.product_id = p.product_id
GROUP BY p.product_name;

-- Customer Purchase History
SELECT c.first_name, 
       c.last_name, 
       p.product_name, 
       s.quantity, 
       s.sale_date
FROM Sales s
JOIN Customers c ON s.customer_id = c.customer_id
JOIN Products p ON s.product_id = p.product_id
ORDER BY c.last_name, s.sale_date;
