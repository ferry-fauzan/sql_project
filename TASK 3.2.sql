select date_part('year',ord.order_purchase_timestamp) as year,
		count(1) as cancel_order,
		ord.order_status
from orders ord
join order_items orti on orti.order_id=ord.order_id
where order_status='canceled'
group by 1,3