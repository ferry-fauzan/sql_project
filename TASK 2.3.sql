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