/*
카테고리별 기준 월 대비 매출 비율 추이 (aka 매출 팬차트)
STEP 1. 상품 카테고리별 월별 매출액 추출 
STEP 2. STEP 1의 집합에서 기준 월이 되는 첫월의 매출액을 동일 카테고리에 모두 복제한 뒤 매출 비율을 계산함
*/

WITH TEMP01 AS (
    SELECT d.category_name, to_char(date_trunc('month',order_date),'yyyymm') as month_day,SUM(AMOUNT) AS SUM_AMOUNT
    FROM nw.orders a
        JOIN nw.order_items b on a.order_id = b.order_id
        JOIN nw.products c on b.product_id = c.product_id
        JOIN nw.categories d on d.category_id = c.category_id
    WHERE order_date between to_date('1996-07-01','yyyy-mm-dd') and to_date('1997-06-30', 'yyyy-mm-dd')
    group by d.category_name, to_char(date_trunc('month',order_date),'yyyymm')
)

SELECT category_name, month_day, sum_amount,
       first_value(sum_amount) over (partition by category_name order by month_day) as base_amount,
       round(100.0*sum_amount/first_value(sum_amount) over (partition by category_name order by month_day),2) base_ratio
FROM TEMP01
ORDER BY category_name, month_day
