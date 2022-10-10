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
