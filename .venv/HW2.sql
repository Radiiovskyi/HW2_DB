create database opt_db;
USE opt_db;


CREATE TABLE IF NOT EXISTS opt_clients (
    id CHAR(36) PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    surname VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    phone VARCHAR(50) NOT NULL,
    address TEXT NOT NULL,
    status ENUM('active', 'inactive') NOT NULL
);

CREATE TABLE IF NOT EXISTS opt_products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(255) NOT NULL,
    product_category ENUM('Category1', 'Category2', 'Category3', 'Category4', 'Category5') NOT NULL,
    description TEXT
);

CREATE TABLE IF NOT EXISTS opt_orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    order_date DATE NOT NULL,
    client_id CHAR(36),
    product_id INT,
    FOREIGN KEY (client_id) REFERENCES opt_clients(id),
    FOREIGN KEY (product_id) REFERENCES opt_products(product_id)

);


DROP INDEX idx_clients_status ON opt_clients;
DROP INDEX idx_products_category ON opt_products;
DROP INDEX idx_orders_order_date ON opt_orders;


EXPLAIN SELECT c.name, c.surname, p.product_name, o.order_date
FROM opt_orders o
JOIN opt_clients c ON o.client_id = c.id
JOIN opt_products p ON o.product_id = p.product_id
WHERE c.status = 'active'
  AND p.product_category != 'Category2'
  and p.product_category != 'Category3'
  and p.product_category != 'Category4'
  and p.product_category != 'Category5'
  AND o.order_date BETWEEN '2024-01-01' AND '2024-12-31';
# 50
#37
#52

CREATE INDEX idx_clients_status ON opt_clients (status);
CREATE INDEX idx_products_category ON opt_products (product_category);
CREATE INDEX idx_orders_order_date ON opt_orders (order_date);


EXPLAIN WITH ActiveClients AS (
    SELECT id, name, surname
    FROM opt_clients
    WHERE status = 'active'
),
Category1Products AS (
    SELECT product_id, product_name
    FROM opt_products
    WHERE product_category = 'Category1'
),
FilteredOrders AS (
    SELECT order_id, client_id, product_id, order_date
    FROM opt_orders
    WHERE order_date BETWEEN '2024-01-01' AND '2024-12-31'
)
SELECT ac.name, ac.surname, cp.product_name, fo.order_date
FROM FilteredOrders fo
JOIN ActiveClients ac ON fo.client_id = ac.id
JOIN Category1Products cp ON fo.product_id = cp.product_id;

# 30
#26
#33





















