select date_part('year',timme) as tahun,
		count(1)
from
(select 	cus.customer_unique_id as custom,
		min(ord.order_purchase_timestamp) as timme
from orders as ord
join customer as cus on cus.customer_id = ord.customer_id
group by 1) subq
group by 1