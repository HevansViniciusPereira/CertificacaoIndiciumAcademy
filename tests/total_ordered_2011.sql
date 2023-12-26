-- 12.646.112,16
-- 10.883.864,4302

with
    orders_2011 as (
        select sum(total_trated_value) as total_trated_2011
        from {{ ref('Fact_Orders') }}
        where orderdate between '2011-01-01' and '2011-12-31'
    )

select total_trated_2011
from orders_2011
where total_trated_2011 not between 12646112 and 12646113