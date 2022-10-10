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