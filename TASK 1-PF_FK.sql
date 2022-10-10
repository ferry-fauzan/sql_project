select count(distinct seller_id),count (seller_id) from sellers

-- PK table products
alter table products add primary key (product_id)

--fk table order_items
alter table order_items add foreign key (product_id) 
references products (product_id)

--pk table customer 
alter table customer add primary key (customer_id)

--fk table orders
alter table orders add foreign key (customer_id)
references customer (customer_id)

-- pk sellers
alter table sellers add primary key (seller_id)

--fk order_items
alter table order_items add foreign key (seller_id)
references sellers (seller_id)

--fk sellers
select * from sellers
alter table sellers add foreign key seller_zip_code_prefix
references geolocation (geolocation_zip_code_prefix)