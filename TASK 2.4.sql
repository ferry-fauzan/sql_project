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