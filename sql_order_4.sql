/*
order별/ 고객별로 특정 상품 주문시 함께 가장 많이 주문된 다른 상품 추출하기 
logic 
- self join 
- 같은 이름일 경우 제외 
- group by and count 
*/

with product_comb AS (
    select a.order_id, a.product_id as product1, b.product_id as product2
    from ga.order_items a
        join ga.order_items b on a.order_id = b.order_id
    where a.product_id <> b.product_id),
-- product1과 product2 레벨로 cnt 
    temp_02 AS (
    select product1, product2, count(order_id) as cnt 
    from product_comb
    group by 1,2
    order by 1,2,3 desc
    )
-- product1 별로 가장 많은 건수를 가진 product2를 찾기 위해 cnt가 높은 순으로순위 추출
    , temp_03 AS( 
        select *,
        row_number() over (partition by product1 order by cnt desc) as rn 
        from temp_02
    )
select *
from ga.order_items
where product_id in ('GGOEAAAB034814','GGOEAAAB034815')