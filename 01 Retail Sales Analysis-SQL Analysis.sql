use intro;
-- Creating tables
CREATE TABLE categories (
    category_id INT PRIMARY KEY,
    category_name VARCHAR(100)
);

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(200),
    price DECIMAL(10, 2),
    category_id INT,
    FOREIGN KEY (category_id) REFERENCES categories(category_id)
);

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(150),
    email VARCHAR(100)
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    order_date DATE,
    customer_id INT,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- Inserting data into tables
INSERT INTO categories (category_id, category_name)
VALUES
    (1, 'Electronics'),
    (2, 'Home & Kitchen'),
    (3, 'Fashion'),
    (4, 'Books');

INSERT INTO products (product_id, product_name, price, category_id)
VALUES
    (1, 'Smartphone', 599.99, 1),
    (2, 'Laptop', 1199.99, 1),
    (3, 'Blender', 89.99, 2),
    (4, 'Dress', 49.99, 3),
    (5, 'Novel', 19.99, 4);

INSERT INTO customers (customer_id, customer_name, email)
VALUES
    (1, 'John Doe', 'john@example.com'),
    (2, 'Jane Smith', 'jane@example.com'),
    (3, 'Michael Johnson', 'michael@example.com');

INSERT INTO orders (order_id, order_date, customer_id)
VALUES
    (1, '2023-07-15', 1),
    (2, '2023-07-18', 2),
    (3, '2023-07-20', 3);

INSERT INTO order_items (order_item_id, order_id, product_id, quantity)
VALUES
    (1, 1, 1, 2),
    (2, 1, 3, 1),
    (3, 2, 4, 3),
    (4, 3, 2, 1),
    (5, 3, 5, 2);

-- Data analysis queries
-- Query 1: Total sales per category
SELECT  c.category_name, sum(p.price*oi.quantity)
from categories c
join products p on c.category_id=p.category_id
join order_items oi on p.category_id=oi.product_id
group by c.category_name;

-- Query 2: Top 5 customers with the highest total spending

SELECT c.customer_name, sum(p.price*oi.quantity) as total_spending
from customers c
join orders o on c.customer_id = o.customer_id
join order_items oi on o.order_id=oi.order_id
join products p on p.product_id=oi.product_id
group by c.customer_name
order by total_spending desc
limit 5;

-- Query 3: Total Revenue per day

SELECT day(order_date), month(order_date), sum(p.price*oi.quantity)
from orders o
join order_items oi on oi.order_id=o.order_id
join products p on p.product_id=oi.product_id
group by day(order_date), month(order_date);

-- Query 4: top 5 best-selling products based on the total quantity sold

select p.product_name, sum(oi.quantity) 
from products p 
join order_items oi on p.product_id=oi.product_id
group by p.product_name
order by sum(oi.quantity) desc
limit 5;

-- Query 5: number of orders placed by each customer per month

select c.customer_name, month(o.order_date) as month_time, count(o.order_id) as total_orders
from customers c
join orders o on c.customer_id=o.customer_id
group by c.customer_name, month(o.order_date);




