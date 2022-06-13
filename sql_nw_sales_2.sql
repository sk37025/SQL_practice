/****************************
월별 상품 카테고리별 매출액 및 주문 건수, 월 전체 매출액 대비 비율 
STEP 1: 상품 카테고리별 월별 매출액 추출 
STEP 2: Step 1의 집합에서 전체 매출액을 analytic으로 구한 뒤에 매출액 비율 계산 
****************************/

WITH TEMP_01 AS (
    SELECT 
        d.category_name, to_char(date_trunc('month',order_date),'yyyymm') as month_day, 
        sum(amount) as sum_amount, count(distinct a.order_id) as daily_ord_cnt
    FROM 
    nw.orders a 
        join nw.order_items b on a.order_id = b.order_id
        join nw.products c on b.product_id = c.product_id
        join nw.categories d on c.category_id = d.category_id
    GROUP BY d.category_name, to_char(date_trunc('month',order_date),'yyyymm')
)

SELECT * , sum(sum_amount) over (partition by month_day) as month_tot_amount, 
        round(sum_amount/sum(sum_amount) over (partition by month_day),3) as month_ratio
FROM TEMP_01;

/****************************
상품별 전체 매출액 및 해당 상품 카테고리 전체 매출액 대비 비율, 해당 상품 카테고리에서 비율 
STEP 1: 상품별 전체 매출액을 구함  
STEP 2: Step 1의 집합에서 상품 카테고리별 전체 매출액을 구하고, 비율과 매출 순위를 계산.
****************************/

WITH TEMP_01 AS (
    SELECT a.product_id,max(b.product_name) as product_name, max(c.category_name) as category_name ,sum(a.amount) sum_amount
    FROM nw.order_items a 
        join nw.products b on a.product_id = b.product_id
        join nw.categories c on b.category_id = c.category_id
    GROUP BY a.product_id)
    
select category_name, product_name,sum_amount,
        sum(sum_amount) over (partition by category_name) as category_sum,
        round(sum_amount/sum(sum_amount) over (partition by category_name),3) as sum_ratio,
        row_number() over (partition by category_name order by sum_amount desc) as product_rn
        
from TEMP_01
order by category_name, sum_amount desc
;


