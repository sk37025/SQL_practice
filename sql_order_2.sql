/*
월별 사용자 평균 주문 건수 
*/
WITH MONTHLY_ORDER AS (
    SELECT DATE_TRUNC('MONTH',ORDER_DATE)::date AS Month_day, CUSTOMER_ID, COUNT(ORDER_ID) AS ORDER_CNT
    FROM NW.ORDERS
    GROUP BY DATE_TRUNC('MONTH', ORDER_DATE)::date, CUSTOMER_ID
    )

SELECT month_day, round(avg(order_cnt),2) AS avg_order, max(order_cnt), min(order_cnt), count(*) as order_cnt
FROM MONTHLY_ORDER
GROUP BY month_day
ORDER BY month_day asc
