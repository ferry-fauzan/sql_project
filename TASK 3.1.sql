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