--create table sellers_dataset
create table sellers (
	seller_id varchar,
	seller_zip_code_prefix int,
	seller_city varchar,
	seller_state varchar
)

--create table products_dataset
create table products(
	numbr integer,
	product_id varchar,
	product_category_name varchar,
	product_name_length numeric,
	product_descripton_length numeric,
	product_photos_qty numeric,
	product_weight_g numeric,
	product_length_cm numeric,
	product_height_cm numeric,
	product_width_cm numeric
)

--create table orders_dataset
create table orders(
	order_id varchar primary key,
	customer_id varchar,
	order_status varchar,
	order_purchase_timestamp timestamp without time zone,
	order_approved_at timestamp without time zone,
	order_delivered_carrier_date timestamp without time zone,
	order_delivered_customer_date timestamp without time zone,
	order_estimated_delivered_date timestamp without time zone
	
)

--create table order_review
create table order_reviews(
	review_id varchar,
	order_id varchar references orders(order_id),
	review_score integer,
	review_comment_title varchar,
	review_comment_message varchar,
	review_creation_date varchar,
	review_answer_timestamp varchar
)


--create table order payments
create table order_payments(
	order_id varchar references orders (order_id),
	payment_sequential integer,
	payment_type varchar,
	payment_installment integer,
	payment_value numeric
)

--ceate order items 
create table order_items(
	order_id varchar references orders(order_id),
	order_item_id integer,
	product_id varchar,
	seller_id varchar,
	shipping_limit_date timestamp without time zone,
	price numeric,
	feight_value numeric
)


--create table geolocation
create table geolocation(
	geolocation_zip_code_prefix integer,
	geolocation_lat numeric,
	geolocation_lng numeric,
	geolocation_city varchar,
	geolocation_state varchar
)

--create table customer
create table customer(
	customer_id varchar,
	customer_unique_id varchar,
	customer_zip_code_prefix integer,
	customer_city varchar,
	customer_state varchar
)