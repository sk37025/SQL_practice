/*
매출 Z 차트 
- 월별 차트를 구함
- 월별 누적 차트 (시작은 1월 차트임)
- 연간 이동 평균 차트

WHERE 절이 먼저 수행되기 때문에 WINDOW 를 사용할 때는 사용 x 
*/
WITH month_chart AS (
    SELECT TO_CHAR(A.ORDER_DATE,'yyyymm') AS year_month, SUM(B.amount) as sum_amount
    FROM NW.ORDERS A 
        JOIN NW.ORDER_ITEMS B ON A.ORDER_ID = B.ORDER_ID
    GROUP BY TO_CHAR(A.ORDER_DATE,'yyyymm')
    ORDER BY TO_CHAR(A.ORDER_DATE,'yyyymm') ASC 
), temp_02 AS (
    SELECT year_month,substring(year_month,1,4) as year,sum_amount, 
            sum(sum_amount) OVER (partition by substring(year_month,1,4) order by year_month) AS acc_amount,
            sum(sum_amount) OVER (order by year_month rows between 11 preceding and current row) AS year_ma_amount
    FROM month_chart
    
)

SELECT * FROM temp_02;
where year = '1997'