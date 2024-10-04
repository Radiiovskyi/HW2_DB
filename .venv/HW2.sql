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


EXPLAIN select c.name, c.surname, p.product_name, o.order_date
        from opt_orders o
        join opt_clients c ON o.client_id = c.id
        join opt_products p ON o.product_id = p.product_id
        where c.status = 'active'
        and p.product_category != 'Category2' and p.product_category != 'Category3'
        and p.product_category != 'Category4' and p.product_category != 'Category5'
        AND o.order_date between '2024-01-01' and '2024-12-31';
# 50
#37
#52
create index idx_clients_status ON opt_clients (status);
create index idx_products_category ON opt_products (product_category);
create index  idx_orders_order_date ON opt_orders (order_date);


EXPLAIN with ActiveClients AS (
    select id, name, surname
    from opt_clients
    where status = 'active'
),
Category1Products AS (
    select product_id, product_name
    from opt_products
    where product_category = 'Category1'
),
FilteredOrders AS (
    select order_id, client_id, product_id, order_date
    from opt_orders
    where order_date between '2024-01-01' and '2024-12-31'
)
select ActiveClients.name, ActiveClients.surname, Category1Products.product_name, FilteredOrders.order_date
    from FilteredOrders
    join ActiveClients  on FilteredOrders.client_id = ActiveClients.id
    join Category1Products  on FilteredOrders.product_id = Category1Products.product_id;

# 30
#26
#33





















