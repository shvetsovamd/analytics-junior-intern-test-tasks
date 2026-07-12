-- task 1

select round(sum(amount_rur), 2) max_amount
from transactions
where success_flg=True
group by customer_id
order by max_amount desc, customer_id
limit 1;


-- task 2

with t as (
    select avg(amount_rur) avg_amount, customer_id
    from transactions
    group by customer_id
)
select count(*)
from transactions join t using(customer_id)
where amount_rur > t.avg_amount;


-- task 3

select count(*) customers_count
from (
    select c.customer_id 
    from customer c left join transactions t on c.customer_id = t.customer_id 
        and t.success_flg=true
    group by c.customer_id
    having count(t.transaction_id) < 2
) t;


-- task 4

with t as (
    select transaction_dttm - lag(transaction_dttm) over (
        partition by customer_id
        order by transaction_dttm
    ) time_diff
    from transactions
)
select extract(day from max(time_diff))
from t;


-- task 5

with groups as (
    select n - row_number() over (order by n) group_num
    from numbers
)
select count(*) group_size
from groups
group by group_num
order by group_size desc
limit 1;