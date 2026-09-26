/*Q1/10 — Customers Above Their City’s Average Spending

Write a query to return customers whose total order spending
is greater than the average total spending of customers in their own city.

Expected output
customer_id | customer_name | city | total_spending
Requirements
Calculate each customer's total spending first.
Compare that customer total with the average customer spending within the same city.
Use a subquery or CTE.
Include only customers who are above their city's average.*/
with customer_data as(
	select c.customer_id, c.customer_name, c.city, sum(o.amount) as amount_spend
    from customers c inner join orders o 
    on c.customer_id=  o.customer_id
    group by c.customer_id, c.customer_name, c.city
),
city_avg as(
	select city, avg(amount_spend) as city_cus_avg from customer_data
    group by city)
    
select * from customer_data cd 
inner join city_avg ca  
ON cd.city = ca.city
where cd.amount_spend>city_cus_avg
;

/*Q2 — Customers Above Overall Average Spending

Using a subquery, find customers whose total spending is greater than the average
total spending of all customers.*/


/*Q3/10 — Customers With No Orders
Using a subquery, find all customers who have never placed an order.
Expected output:
customer_id | customer_name | city
Constraint
Use a subquery.*/

select c.customer_id,c.customer_name, c.city
from customers c 
where not exists(
	select 1
    from orders o 
    where o.customer_id= c.customer_id);
    
/* Q4 — Highest-Spending Customer in Each City
Find the customer(s) who have the highest total spending within their city.
Output:
customer_id | customer_name | city | total_spending*/

with customer_data as(
	select c.customer_id, c.customer_name,c.city, sum(o.amount) as total_spent
    from customers c inner join orders o
    on c.customer_id=o.customer_id
    group by c.customer_id, c.customer_name,c.city
),
city_high as(
	select customer_data.city, max(total_spent) as highest
    from customer_data 
    group by city
)
select * from customer_data cd
inner join city_high as ch
ON cd.city = ch.city
where cd.total_spent=ch.highest;

/*Q5 — Products Selling Above Average
Find products whose total sales amount is greater than the average 
total sales amount across all products that have orders.*/

with prod_data as(
	select p.product_id,p.product_name,sum(o.amount) as sales
    from orders o inner join products p  
    on p.product_id=o.product_id
    group by p.product_id,p.product_name
),
prod_avg_sales as(
	select avg(sales) as avg_sales
    from prod_data
)
select *from  prod_data pd
cross join prod_avg_sales ps
where pd.sales>ps.avg_sales;

/* Q6 — Customers With More Orders Than Average
Find customers whose number of orders is greater than the average number
of orders per customer among customers who have placed at least one order.
Output:
customer_id | customer_name | total_orders*/

with customer_data as(
	select c.customer_id, c.customer_name, count(o.customer_id) as total_orders
    from customers c inner join orders o 
    on c.customer_id = o.customer_id
    group by c.customer_id, c.customer_name
),
cust_high as(
	select avg(total_orders) as avg_oders
    from customer_data
)

select* from customer_data cd
cross join cust_high ch
where cd.total_orders>ch.avg_oders;
    
/* Q7 — Above-City-Average Order Value
Find individual orders whose amount is greater than the 
average order amount for their customer's city.
Output:
order_id | customer_id | city | amount | city_avg_order*/

with city_data as(
	select o.order_id,c.customer_id,c.city,o.amount
	from customers c inner join orders o 
    on c.customer_id=o.customer_id
),
city_aov as(
	select city,avg(amount) as city_avg
    from city_data
    group by city
)
select cd.order_id,cd.customer_id,cd.city,cd.amount,ca.city_avg
from city_data cd
inner join city_aov ca
on cd.city=ca.city
where cd.amount> ca.city_avg;

/*Q8 — Cancellation Risk Analysis
Find customers whose cancellation rate is higher than the overall customer cancellation rate.
Define:
cancellation_rate =
cancelled_orders / total_orders × 100
Return:
customer_id | customer_name | total_orders | cancelled_orders | cancellation_rate
Only customers with at least one order should be considered.*/

with customer_data as(
	select c.customer_id, c.customer_name, count(o.customer_id) as total_orders,
    sum(case when o.status='Cancelled' then 1 else 0 end) as cancelled_orders,
    sum(case when o.status='Cancelled' then 1 else 0 end)/count(*)*100 as cancellation_rate
    from customers c inner join orders o 
    on c.customer_id=o.customer_id
    group by c.customer_id, c.customer_name
),
ACL as(
		select avg(cancellation_rate)as avg_cancel
        from customer_data 
)

select *from customer_data cd
cross join ACL ac
where cd.cancellation_rate>ac.avg_cancel;

/*Q9— Business Case: High-Value but High-Risk Customers
Identify customers who satisfy both:
1.	Their total spending is above the overall average customer spending 
2.	Their cancellation rate is above the overall average customer cancellation rate */

with customer_data as(
	select c.customer_id, c.customer_name, count(o.customer_id) as total_orders,
    sum(o.amount) as gross_total,
    sum(case when o.status='Cancelled' then 1 else 0 end)/count(*)*100 as cancellation_rate
    from customers c inner join orders o 
    on c.customer_id=o.customer_id
    group by c.customer_id, c.customer_name
),
ACL as(
		select avg(cancellation_rate)as avg_cancel
        from customer_data 
),
a_spend as(
			select avg(gross_total) as avg_total
            from customer_data
)
select * from customer_data cd
cross join ACL as a
cross join a_spend as asp
where cd.cancellation_rate>a.avg_cancel
and cd.gross_total>asp.avg_total;           



