create database customers;
use customers;
create table customers(
customer_id int auto_increment primary key ,
first_name varchar(50),
last_name varchar(50),
email varchar(50)
);
-- Generate 1000 random order records
delimiter // 
CREATE PROCEDURE GenerateRandomCustomers()
BEGIN
  DECLARE i INT DEFAULT 1;
  WHILE i <= 1000 DO
    INSERT INTO customers (first_name, last_name, email)
    VALUES (
      CONCAT('First', i),
      CONCAT('Last', i),
      CONCAT('email', i, '@example.com')
    );
      SET i = i + 1;
  END WHILE;
END//
delimiter ;
call generaterandomcustomers();

-- Create the Orders table
CREATE TABLE orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    total_amount DECIMAL(10, 2)
);

-- generate 1000 random order records

delimiter //
create procedure generaterandomorders()
begin
 declare i int default 1;
 while i<= 1000 do
       insert into orders (customer_id, order_date, total_amount) 
	values (
          floor(1+ rand()*1000),
          date_add('2023-01-01', interval floor(rand()*365) day ),
          round(rand()*500,2)
          );
          set i = i+1;
	end while;
end//
delimiter ;
call generaterandomorders();

show tables;
select * from customers;
select * from orders;

-- 1. How many customers are in the database?
select count(*) from customers;

-- 2. What are the names of all the customers?
select concat(first_name,' ',last_name) as full_name from customers;

-- 3. What is the total number of orders placed?
select count(*) from orders;

-- 4. Who placed the most recent order, and when was it placed?
select concat(first_name,' ',last_name) as customer_name, max(order_date) as recent_order_placed 
from customers c
join orders o on c.customer_id=o.customer_id
group by customer_name
order by recent_order_placed desc
limit 1; 
 
 -- 5. What is the total revenue generated from all orders?
  select sum(total_amount) as total_revenue from orders;
  
  -- 6. Which customer has spent the most money in total?

select first_name, sum(total_amount) as total_spent from customers c 
join orders o on c.customer_id = o.customer_id
group by first_name
order by total_spent desc
limit 1;

-- 7. What is the average order total?
select avg(total_amount) from orders;

-- 8. How many orders were placed in each month?
select monthname(order_date) as order_month,count(*) as monthly_orders from orders 
group by monthname(order_date);

-- 9. Which customer has placed the most orders?

select c.customer_id, concat(c.first_name,' ',c.last_name) as customer_name,count(o.order_id) as total_orders
from customers c 
join orders o on c.customer_id = o.customer_id
group by c.customer_id
order by total_orders desc;

SELECT first_name, COUNT(*) AS orders_placed
FROM customers
LEFT JOIN orders ON customers.customer_id = orders.customer_id
GROUP BY first_name
ORDER BY orders_placed DESC
LIMIT 1;

-- 10. What is the largest order amount?
select max(total_amount) as largest_order_amount from orders;

-- 11. What is the smallest order amount?
select min(total_amount) as smallest_order_amount from orders;

-- 12. How many unique email addresses are in the database?
select count(distinct (email)) from customers;

-- 13. What is the total amount spent by each customer?
select  c.customer_id,c.first_name, sum(total_amount) as total_spent from customers c 
join orders o on c.customer_id = o.customer_id
group by c.customer_id;

-- 14. On which date was the first order placed?
select  min(order_date) as first_order_date from orders;

-- 15. How many orders did each customer place?
select c.customer_id, count(o.order_id) as total_orders from customers c 
join orders o on c.customer_id = o.customer_id
group by c.customer_id
order by total_orders desc;

-- 16. What is the average order total for each customer?
select c.customer_id, avg(o.total_amount) as avg_total_amount from customers c 
left join orders o on c.customer_id = o.customer_id
group by c.customer_id
order by c.customer_id ;

-- 17. Which month had the highest total order amount?
select monthname(order_date) as month_name,sum(total_amount) from orders 
group by month_name
order by sum(total_amount) desc
limit 1;

-- 18. What is the customer ID of the customer with the highest total order amount?

select customer_id , sum(total_amount) as total_order_amount from orders 
group by customer_id
order by total_order_amount desc
limit 1;

-- 19. How many customers have placed orders in each month?
select monthname(order_date) as month , count(distinct customer_id) as total_customer from orders
group by month;

-- 20. Which customer has not placed any orders?
select c.customer_id,c.first_name from customers c 
left join orders o on c.customer_id = o.customer_id
where o.order_id is null;
