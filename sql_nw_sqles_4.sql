/************************************************
* 5일  이동 평균 매출액 구하기, 매출액의 경우 주로 1주일 이동 평균 매출을 구하나 데이터가 토,일  매출이 없음 
*************************************************/
with temp_01 as (
select date_trunc('day',order_date)::date as d_day, sum(amount) as sum_amount
from nw.orders a
    join nw.order_items b on a.order_id = b.order_id
where order_date >= to_date('1996-07-08', 'yyyy-mm-dd')
group by date_trunc('day',order_date)::date)

select d_day, sum_amount, 
    avg(sum_amount) over (order by d_day rows between 4 preceding and current row) as m_avg_5day
from temp_01 ;

-- 5일 이동 평균을 구하되 5일을 채울 수 없는 경우는 NULL로 표시함 
with temp_01 as (
select date_trunc('day',order_date)::date as d_day, sum(amount) as sum_amount
from nw.orders a
    join nw.order_items b on a.order_id = b.order_id
where order_date >= to_date('1996-07-08', 'yyyy-mm-dd')
group by date_trunc('day',order_date)::date),
temp_02 as (
    select d_day, sum_amount, 
    avg(sum_amount) over (order by d_day rows between 4 preceding and current row) as m_avg_5day,
    row_number() over (order by d_day) as rnum 
    from temp_01)
select d_day, sum_amount, 
        rnum, case when rnum<5 then Null
                  else  m_avg_5day end as m_avg_5day
from temp_02;

/************************************************
 *  5일 이동 가중평균 매출액 구하기, 당일 날짜에서 가까운 날짜일 수록 가중치를 증대함 
    5일중, 가장 먼 날짜는 매출액의 0.5, 중간 날짜 2,3,4는 매출액 그대로, 당일은 1.5*매출액으로 가중치를 부여함  
*************************************************/

with temp_01 as (
select date_trunc('day',order_date)::date as d_day, 
        sum(amount) as sum_amount,
        row_number() over (order by date_trunc('day',order_date)::date) as r_num
from nw.orders a
    join nw.order_items b on a.order_id = b.order_id
where order_date >= to_date('1996-07-08', 'yyyy-mm-dd')
group by date_trunc('day',order_date)::date),

temp_02 as (
    select a.d_day, a.sum_amount, a.r_num, b.d_day as d_day_back, b.sum_amount as sum_amount_back, b.r_num as rnum_back
    from temp_01 a 
        join temp_01 b on a.r_num between b.r_num and b.r_num+4 
)

select d_day, 
        avg(sum_amount_back) as m_avg_5days, -- sum을 건수인 5로 나누면 평균이 됨,
        sum(sum_amount_back)/5 as m_avg_5days_01,
        sum(case when r_num - rnum_back =4 then 0.5 *sum_amount_back
                 when r_num - rnum_back in (3,2,1) then sum_amount_back
                 when r_num - rnum_back = 0 then 1.5*sum_amount_back
            end) as m_weighted_sum,
       sum(case when r_num - rnum_back =4 then 0.5 *sum_amount_back
                 when r_num - rnum_back in (3,2,1) then sum_amount_back
                 when r_num - rnum_back = 0 then 1.5*sum_amount_back
            end)/5 as m_w_avg_sum,
       count(*) as cnt --5건이 안되는 초기 데이터는 삭제하기 위함 
from temp_02
group by d_day
having count(*)=5
order by d_day



