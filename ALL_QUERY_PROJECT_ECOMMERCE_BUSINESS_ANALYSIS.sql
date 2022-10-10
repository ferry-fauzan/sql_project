--TASK 1 Data Preparation
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


--TASK 2.1 Annual Customer Activity Growth Analysis 
select monthh,
		yearr,
		round(avg(mau),0) MAU
FROM(
	select  count(distinct customer_id) as mau,
		date_part('month',order_purchase_timestamp) as monthh,
		date_part('year',order_purchase_timestamp) as yearr
	from orders 
	group by 2,3
	order by 3,2
) subq
group by 1,2
order by 2,1


--TASK 2.2 Annual Customer Activity Growth Analysis 
select date_part('year',timme) as tahun,
		count(1)
from
(select 	cus.customer_unique_id as custom,
		min(ord.order_purchase_timestamp) as timme
from orders as ord
join customer as cus on cus.customer_id = ord.customer_id
group by 1) subq
group by 1


-- TASK 2.3 Annual Customer Activity Growth Analysis 
select years,
		count (repeat_order) as customer_ord
from
(select date_part('year',ord.order_purchase_timestamp) as years,
		cust.customer_unique_id as customer ,
		count(1)as repeat_order
from orders ord
join customer cust on cust.customer_id=ord.customer_id
group by 1,2
having count(1)>1
)subq
group by 1
order by 1


-- TASK 2.4 Annual Customer Activity Growth Analysis 
select years,
		round(avg(cust),2) as avg_order
from(
select date_part('year',ord.order_purchase_timestamp) as years,
		cust.customer_unique_id as custs,
		count(1) as cust
from orders ord
join customer cust on cust.customer_id=ord.customer_id
group by 1,2
)subq
group by 1
order by 1


-- TASK 3.1 Annual Product Category Quality Analysis
select y as year,
		round(sum(c),0) as revenue
from
(select date_part('year',ord.order_purchase_timestamp) as y,
		orti.price as p,
		orti.feight_value as f,
		(price+feight_value) as c
from order_items orti
join orders ord on ord.order_id=orti.order_id
where order_status='delivered'
group by 1,2,3,4)subq
group by 1


-- TASK 3.2 Annual Product Category Quality Analysis
select date_part('year',ord.order_purchase_timestamp) as year,
		count(1) as cancel_order,
		ord.order_status
from orders ord
join order_items orti on orti.order_id=ord.order_id
where order_status='canceled'
group by 1,3


-- TASK 3.3 Annual Product Category Quality Analysis
select  
    year,
    product_category_name as product_category,
    round(revenue,0) as revenue
from (
    select
        date_part('year', od.order_purchase_timestamp) as year,
        p.product_category_name,
        sum (oid.price + oid.feight_value) as revenue,
        rank()over(partition by date_part('year', od.order_purchase_timestamp)
                    order by sum(oid.price + oid.feight_value) desc) as rk
    from order_items oid
    join orders od on od.order_id = oid.order_id
    join products p on p.product_id = oid.product_id
    where od.order_status = 'delivered'
    group by 1,2) sq
where rk = 1


-- TASK 3.4 Annual Product Category Quality Analysis
select  
    year,
    product_category_name,
    num_canceled AS order_canceled
from (
    select
        date_part('year', od.order_purchase_timestamp) as year,
        p.product_category_name,
        count (1) as num_canceled,
        rank()over(partition by date_part('year', od.order_purchase_timestamp)
                    order by count(1) desc) as rk
    from order_items oid
    join orders od on od.order_id = oid.order_id
    join products p on p.product_id = oid.product_id
    where od.order_status = 'canceled'
    group by 1,2) sq
where rk = 1 


-- TASK 4 Analysis of Annual Payment Type Usage
with 
project as(
select    
    date_part('year', od.order_purchase_timestamp) as tahun,
    opd.payment_type,
    count(1) as num_used
from order_payments opd
join orders od on od.order_id = opd.order_id
group by 1,2
)

     select
        payment_type,
        sum(case when tahun = '2016' then num_used else 0 end) as year_2016,
        sum(case when tahun = '2017' then num_used else 0 end) as year_2017,
        sum(case when tahun = '2018' then num_used else 0 end) as year_2018
    from project
    group by 1