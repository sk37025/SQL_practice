/*
order별/ 고객별로 특정 상품 주문시 함께 가장 많이 주문된 다른 상품 추출하기 
logic 
- self join 
- 같은 이름일 경우 제외 
- group by and count 
*/
with temp_01 AS (
    select 'ord001' as order_id, 'A' as product_id
    union all 
    select 'ord001' as order_id, 'B' as product_id
    union all
    select 'ord001' as order_id, 'C' as product_id
    union all
    select 'ord002', 'B'
    union all
    select 'ord002', 'D'
    union all
    select 'ord003', 'A'
    union all
    select 'ord003', 'B'
    union all
    select 'ord003', 'D'
), temp_02 AS (
    select A.order_id, A.product_id as product_1, B.product_id as product_2
    from temp_01 A join temp_01 B 
    on A.order_id = B.order_id 
    WHERE A.product_id <> B.product_id),
    temp_03 AS (
        select product_1, product_2, count(order_id) as cnt
        FROM temp_02
        group by 1, 2
        order by 1, 2, 3),
    temp_04 AS (
        select product_1, product_2, cnt, row_number() over (partition by product_1 order by cnt desc) as rnum
        from temp_03
    )

SELECT *
FROM temp_04 
where rnum=1