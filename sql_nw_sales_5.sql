/*******************************
*  작년 대비 동월 매출 비교, 작년 동월 대비 차이/비율/매출 성장 비율 추출

STEP 1. 상품 카테고리별 월별 매출액 추출 
STEP 2. STEP 1의 집합에서 12개월 이전 매출 데이터를 가져와서 현재 월과 매출 비교 

*******************************/ 
WITH TEMP01 AS
	(SELECT DATE_TRUNC('month',ORDER_DATE)::date AS MONTH_DAY ,
			SUM(AMOUNT) AS SUM_AMOUNT
		FROM NW.ORDERS A
		JOIN NW.ORDER_ITEMS B ON A.ORDER_ID = B.ORDER_ID
		GROUP BY DATE_TRUNC('month',ORDER_DATE)::date),
    TEMP02 AS
    (SELECT MONTH_DAY, SUM_AMOUNT AS CURR_AMOUNT,
            LAG(MONTH_DAY,12) OVER (ORDER BY MONTH_DAY) AS PREV_MONTH_1YEAR,
            LAG(SUM_AMOUNT, 12) OVER (ORDER BY MONTH_DAY) AS PREV_AMOUNT_1YEAR
    FROM TEMP01)

SELECT *,
        CURR_AMOUNT - PREV_AMOUNT_1YEAR AS DIFF_AMOUNT,
        CURR_AMOUNT/PREV_AMOUNT_1YEAR * 100.0 AS PREV_PCT, -- 1보다 크면 상승 
        (CURR_AMOUNT-PREV_AMOUNT_1YEAR)/PREV_AMOUNT_1YEAR *100 AS PREV_GROWTH_PCT
        
FROM TEMP02
WHERE PREV_MONTH_1YEAR IS NOT NULL

/*******************************
*  작년 대비 동분기 매출 비교, 작년 동분기 대비 차이/비율/매출 성장 비율 추출

STEP 1. 상품 카테고리별 월별 매출액 추출 
STEP 2. STEP 1의 집합에서 12개월 이전 매출 데이터를 가져와서 현재 월과 매출 비교 

*******************************/ 

WITH TEMP01 AS
	(SELECT DATE_TRUNC('quarter',ORDER_DATE)::date AS QUARTER_DAY,
			SUM(AMOUNT) AS SUM_AMOUNT
		FROM NW.ORDERS A
		JOIN NW.ORDER_ITEMS B ON A.ORDER_ID = B.ORDER_ID
		GROUP BY DATE_TRUNC('quarter',ORDER_DATE)::date),
    TEMP02 AS 
    (SELECT QUARTER_DAY, 
            SUM_AMOUNT AS CURR_AMOUNT,
            LAG(QUARTER_DAY,4) OVER (ORDER BY QUARTER_DAY) AS PREV_QUARTER_DAY,
            LAG(SUM_AMOUNT,4) OVER (ORDER BY QUARTER_DAY) AS PREV_QUARTER_AMOUNT
    FROM TEMP01)
SELECT * FROM TEMP02
WHERE PREV_QUARTER_DAY IS NOT NULL

                                               