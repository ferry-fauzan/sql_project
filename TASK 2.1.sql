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