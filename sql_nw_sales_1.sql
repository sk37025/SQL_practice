/************************************
   일/주/월/분기별 매출액 및 주문건수
*************************************/
-- ::date를 해주면 해당 column의 속성을 정의할 수 있게 됨 
select date_trunc('day',order_date)::date as day, sum(b.amount) as sum_amount, count(distinct a.order_id) as daily_ord_cnt
from nw.orders a 
    join nw.order_items b on a.order_id = b.order_id
group by date_trunc('day',order_date)::date
order by 1;

/*
주별 매출액 및 주문건수
*/
select date_trunc('week',order_date)::date as week, sum(b.amount) as sum_amount, count(distinct a.order_id) as weekly_ord_cnt
from nw.orders a 
    join nw.order_items b on a.order_id = b.order_id
group by date_trunc('week',order_date)::date
order by 1;

/*
월별 매출액 및 주문건수
*/
select date_trunc('month',order_date)::date as month, sum(b.amount) as sum_amount, count(distinct a.order_id) as monthlys_ord_cnt
from nw.orders a 
    join nw.order_items b on a.order_id = b.order_id
group by date_trunc('month',order_date)::date
order by 1;

/*
분기별 매출액 및 주문건수
*/
select date_trunc('quarter',order_date)::date as quarter, sum(b.amount) as sum_amount, count(distinct a.order_id) as quarterly_ord_cnt
from nw.orders a 
    join nw.order_items b on a.order_id = b.order_id
group by date_trunc('quarter',order_date)::date
order by 1;

/************************************
   일/주/월/분기별 상품별 매출액 및 주문건수
*************************************/

select date_trunc('day',order_date)::date as day, b.product_name as prd_name, sum(b.amount) as sum_amount, count(distinct a.order_id) as daily_ord_cnt
from nw.orders a 
    join (select tmp.order_id, tmp.product_id, tmp.amount, prd.product_name
          from nw.order_items tmp left join nw.products prd on tmp.product_id = prd.product_id) b on a.order_id = b.order_id 
group by date_trunc('day',order_date)::date, b.product_name
order by day, prd_name ; 