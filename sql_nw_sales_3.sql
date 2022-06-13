/**********************************
동년도 월별 누적 매출 및 동일 분기 월별 누적 매출
STEP 1: 월별 매출액을 구함 
STEP 2: 월별 매출액 집합에 동일 년도의 월별 누적 매출과 동일 분기의 월별 누적 매출을 구함. 
**********************************/

with temp_01 as (
select date_trunc('month',b.order_date)::date as month_day , sum(a.amount) as sales_amount
from nw.order_items a 
    join nw.orders b on a.order_id=b.order_id
group by month_day)

select month_day, sum(sales_amount) over (partition by date_trunc('year',month_day) order by month_day) as cume_year_amount,
        sum(sales_amount) over (partition by date_trunc('quarter',month_day) order by month_day) as cume_quarter_amount
from temp_01; 