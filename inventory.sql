create database inventory;

use inventory;

-- users schema
create table users (
    id INT NOT NULL, 
    is_admin boolean,
    firstname VARCHAR(50) NOT NULL,
    lastname VARCHAR(50) NOT NULL,
    phone VARCHAR(11), 
    email VARCHAR(255) NOT NULL,
    password VARCHAR(12),
    address VARCHAR(255),
    is_verified boolean,
    created_at datetime DEFAULT CURRENT_TIMESTAMP,
    updated_at datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY(id)
);
-- tables schema 
create table products (
    id INT,
    name VARCHAR(255) NOT NULL,
    price DECIMAL(10,2),
    size enum("large", "small", "medium", "extra-large"),
    description VARCHAR(300),
    category enum("accessories", "shoes", "electronics"),
    is_available boolean,
    is_shipped boolean,
    PRIMARY KEY(id)
);
create table orders(
    id INT,
    user_id INT REFERENCES users(id),
    order_amount DECIMAL(10, 2),
    order_status enum("pending", "successful", "failed", "cancelled") DEFAULT "pending"
    order_date datetime DEFAULT CURRENT_TIMESTAMP,
    payment_status enum("pending", "successful", "failed", "cancelled") DEFAULT "pending",
    is_delivered boolean,
    PRIMARY KEY(id)
);
create table order_product(
    id INT,
    product_id INT REFERENCES products(id),
    order_id INT REFERENCES orders(id),
    quantity INT,
    unit_price DECIMAL(10, 2)
);

-- creating users
insert into users 
(id, is_admin, firstname, lastname,phone, email, password, address, is_verified, created_at, updated_at)
values( 1, false, "john", "doe", "12346578910", "johndoe@gmail.com", "yuyu#_7Hq@23", "23rd festac, lagos", "false", DEFAULT, DEFAULT)

insert into users 
(id, is_admin, firstname, lastname,phone, email, password, address, is_verified, created_at, updated_at)
values( 2, false, "jane", "doe", "01987564321", "janedoe@gmail.com", "893938923kqx", "admiralty way lekki lagos", "false", DEFAULT, DEFAULT)

-- creating products
insert into products
(id, name, size, price, description, category, is_available, is_shipped )
values(1, "airforce 1", "small", 49999.99, "nike custom made air force ones in limited qty", "footwears", true, true)

insert into products
(id, name, size, price, description, category, is_available, is_shipped )
values(2, "ashluxe hoodies", "extra-large", 65000.00, "quality designer hoodie, made in africa", "clothing", true, true)

-- creating orders
insert into orders
(id, user_id, order_amount, order_status, order_date, payment_status, is_delivered )
values(1, 2, 65000.00, DEFAULT, DEFAULT, "successful", false)

insert into orders
(id, user_id, order_amount, order_status, order_date, payment_status, is_delivered )
values(2, 1, 49999.99, DEFAULT, DEFAULT, "successful", true)

-- creating order_product
insert into order_product
(id, product_id, order_id, quantity, unit_price)
values(1, 1, 1, 1, 49999.99)


-- to get records from 2 or more entities
select users.firstname, orders.id, orders.order_date 
from users, orders
where users.id = orders.user_id

-- update user email
update users
set email = 'newemail@example.com'
where id = 1;

-- update the status of an order
update orders
set order_status = 'cancelled'
WHERE order_id = 1;


-- delete order
delete from order_product
WHERE order_id = 1;

delete from orders
WHERE id = 1;

-- select user details along with the products they ordered
select users.firstname, products.name, order_product.quantity
from users
join orders on users.id = orders.user_id
join order_product on orders.order_id = order_product.order_id
join products on order_product.product_id = products.product_id;
