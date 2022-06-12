select * from nw.customers; 

-- 고객의 주문수 
select customer_id,count(*) from nw.orders group by customer_id 
having count(*)>1
order by count(*) desc;

