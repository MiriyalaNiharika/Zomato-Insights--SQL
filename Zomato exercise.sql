Use zomato;
show tables;

##1) Find customers who have never ordered
select name from users where user_id not in (select user_id from orders);

#2#) Average Price/dish
select * from menu;

select avg(price) from menu
group by f_id;

##3) Find the top restaurant in terms of the number of orders for a given month
select r.r_id,count(*) as 'orders'
from orders o
join restaurants r
on o.r_id=r.r_id
where monthname(date) like 'June' 
group by r.r_id
order by count(*) desc limit 1;

##4) Restaurants with monthly sales greater than x for a given month:
select r_id,sum(amount) as revenue from orders
where monthname(date) = 'June'
group by r_id
having revenue>500;

##5) Show all orders with order details for a particular customer in a particular date range
select * 
from orders
where user_id=(select user_id from users where name like "Ankit")
and (date > '2022-06-10' and date <'2022-07-10');

##6) Find restaurants with max repeated customers 

select r_id,count(*) as loyal_customers
from(
	select r_id,user_id,count(*) as visits from orders
	group by r_id,user_id
	Having visits>1
    ) t    
group by r_id
order by loyal_customers desc limit 1;  

##7) Customer - favorite food
with temp as(
	select o.user_id, od.f_id,count(*) as "frequency"
	from orders o
	join order_details od
	on o.order_id=od.order_id
	group by o.user_id,od.f_id
)

select u.name,f.f_name,t1.frequency from
temp t1 
join users u
on u.user_id=t1.user_id
join food f
on f.f_id=t1.f_id
where t1.frequency = (select max(frequency) from temp t2 where t2.user_id=t1.user_id); 