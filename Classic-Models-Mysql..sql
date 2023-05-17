-- Find the customers details who are from USA. 

Select * 
From Customers 
Where upper(Country) = 'USA' ;

-- Find the customers whose postal code is missing. 
Select * 
from Customers 
Where Postalcode is null;

-- Find the customers whose postal code and state are missing. 
Select * 
from Customers 
Where Postalcode is null and State is null;

-- Find customers who don’t have any credit limit. 
Select * 
from customers
where creditLimit is null or Creditlimit = 0;

-- Find customers who are from one of the countries USA, France, Norway. 
Select * 
from customers
where country in ('USA', 'France', 'Norway');

-- Find all the customers whose customer number is from 100 to 150. 
Select * 
from customers
where Customernumber between 100 and 150;

-- Find all the customer details who has the highest credit limit. 
Select * 
from customers
order by creditlimit desc
 limit 1 ;
 
 -- Find the customers details whose name start with A. 
Select * 
from customers
where customername like 'A%';

-- Find count of customers whose name end with ‘.’ (dot).
Select count(customername) 
, count(*)
, Count(customernumber) as customercount
from customers
where customername like '%.';

-- Find highest, lowest, average and sum of credit limit.
Select max(creditlimit) as maximum_credit_limit
, Min(creditlimit) as minimun_credit_limit
, avg(creditlimit) as Average_credit_limit
, Sum(creditlimit) as total_credit_limit
from customers;

-- Find customers who have placed at least 1 order. 
select * from customers
 where customernumber in ( select customernumber from orders);
Select c.*
from customers as c
inner join orders as od
on c.customernumber = od.customerNumber;
-- Find customers who have not ordered anything. 
select * from customers
 where customernumber not in (select customernumber from orders);
Select c.* 
from customers as c
left join orders as od
on c.customernumber = od.customerNumber
where od.Customernumber is null;
-- Find the no. of orders from each country. 
Select country
, Count(distinct ordernumber) as cnt
from customers as c
Inner join orders as od
on c.customernumber = od.customerNumber
group by Country;
 
-- Find the details of top 5 customers who have placed more no of orders.
 select c.*
from customers as c
inner join
( select customernumber, count(ordernumber) cnt
from orders 
group by customernumber 
order by cnt desc
limit 5 ) o
on c.customernumber = o.customernumber;

select * from customers
 where customernumber in 
 (select customernumber 
 from 
( select customernumber, count(ordernumber) cnt
 from orders 
 group by customernumber 
 order by cnt desc
 limit 5 ) o 
)
;

-- Find out which employee is responsible for the most no of orders. 
 select e.*, od.cnt from employees as e
 inner join
 ( select c.salesrepemployeenumber
, count(o.ordernumber) cnt
 from customers as c
 inner join orders as o 
 on c.customernumber = o.customernumber
 group by c.salesrepemployeenumber
 order by cnt desc
 limit 1) od
 on e.employeenumber = od.salesrepemployeenumber
;

-- Find out which customer has placed the most valuable order. 
select cus.*
, dos.Total_order_value
, dos.Count_of_orders from customers as cus
inner join
 ( Select 
c.customernumber
 , Count(odts.ordernumber) as Count_of_orders
, sum(odts.quantityOrdered*odts.priceEach) as Total_order_value 
from customers as c
left join orders as od
on c.customernumber = od.customerNumber
left join orderdetails as odts
on od.orderNumber = odts.ordernumber 
group by odts.ordernumber , c.customernumber
order by Total_order_value desc
limit 1 ) as dos
 on cus.customernumber = dos.customernumber;
 
-- Find the top 5 most valuable orders and the customer details who placed the order
 Select cus.*
, dos.ordernumber, dos.total_order_value 
from customers as cus
inner join 
( select c.customernumber, od.ordernumber
, sum(odts.quantityOrdered*odts.priceEach) as Total_order_value 
 from customers as c
left join orders as od
on c.customernumber = od.customerNumber
left join orderdetails as odts
on od.orderNumber = odts.ordernumber 
group by od.ordernumber , c.customernumber
order by Total_order_value desc
 limit 5 ) as dos
on cus.customernumber = dos.customernumber;

-- Rank the performance of employees based on the number of orders. 
Select *
, dense_rank() over (order by total_order desc) as rnk
from 
(Select c.salesRepEmployeeNumber , count(od.orderNumber) as total_order 
 from customers as c
inner join orders as od
on c.customernumber = od.customerNumber
group by c.salesRepEmployeeNumber
order by total_order desc) as performance;

-- Calculate the orders distribution by month and by year. 
 select year(orderdate) as Order_year
, month(orderdate) as order_month
, count(ordernumber) as cnt
from orders
group by year(orderdate), month(orderdate); 
-- Find the no. of days taken to ship each order. And find the average shipping days (Order id , ) 
	-- DIFF of Dates :- 
select 
 ordernumber
, orderDate
, shippedDate
, datediff(shippeddate ,orderdate) as no_of_days 
from orders;
	-- AVG:-
select
avg(datediff(shippeddate ,orderdate)) as difference
from orders;

-- Find the customer details who have placed an order and then cancelled it. 
 select cust.* 
from orders as ord 
left join customers as cust 
on cust.customerNumber = ord.customerNumber
where ord.status = 'Cancelled' ;

-- Calculate Orders distribution by product category
select p.productline
, count(distinct od.ordernumber) cnt from
 orderdetails od
left join products as p
on od.productcode = p.productcode
group by p.productline
order by cnt desc;