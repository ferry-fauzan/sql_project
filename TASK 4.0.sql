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
