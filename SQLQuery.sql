select * from orders

-- Data analysis --

-- Total sales, profit, number of orders, gross profit by year
select
	year(order_date) as year,
	sum(sales) as total_sales,
	sum(profit) as total_profit,
	count(distinct order_id) as number_of_orders,
	sum(profit)/sum(sales)*100 as gross_profit
from orders
group by year(order_date)
order by year

-- Sales and profit trend by month
select
	year(order_date) as year,
	month(order_date) as month_no,
	datename(month, order_date) as month,
	sum(sales) as sales,
	sum(profit) as profit
from orders
group by
	year(order_date),
	month(order_date),
	datename(month, order_date)
order by year, month_no


-- Sales and total quantity by category by year
select
	year(order_date) as year,
	category,
	sum(sales) as total_sales,
	sum(quantity) as total_quantity
from orders
group by year(order_date), Category
order by year


-- Pct of sales by category
select
	year(order_date) as year,
	category,
	sum(sales) as total_sales,
	sum(sales)/(select sum(sales) from orders where year(order_date)=2011)*100 as pct_of_sales
from orders
where year(order_date)=2011
group by year(order_date), category
union all
select
	year(order_date) as year,
	category,
	sum(sales) as total_sales,
	sum(sales)/(select sum(sales) from orders where year(order_date)=2012)*100 as pct_of_sales
from orders
where year(order_date)=2012
group by year(order_date), category
union all
select
	year(order_date) as year,
	category,
	sum(sales) as total_sales,
	sum(sales)/(select sum(sales) from orders where year(order_date)=2013)*100 as pct_of_sales
from orders
where year(order_date)=2013
group by year(order_date), category
union all
select
	year(order_date) as year,
	category,
	sum(sales) as total_sales,
	sum(sales)/(select sum(sales) from orders where year(order_date)=2014)*100 as pct_of_sales
from orders
where year(order_date)=2014
group by year(order_date), category


-- Total sales and profit by market
select
	year(order_date) as year,
	market,
	sum(sales) as total_sales,
	sum(profit) as total_profit
from orders
group by year(order_date), market
order by year 

-- Number of order by ship mode
select
	year(order_date) as year,
	ship_mode,
	count(distinct order_id) as number_of_orders
from orders
group by year(order_date), ship_mode
order by year

-- Customer analysis --

-- Total customer, Avg order value per customer, per order, RPR, PF, CV by year
select 
	year(order_date) as year,
	count(distinct customer_id) as total_customer,
	sum(sales)/count(distinct customer_id) as avg_order_value_per_customer,
	sum(sales)/count(distinct order_id) as avg_order_value_per_order
from orders
group by year(order_date)
order by year

-- RPR, PF, CV
select
	year(order_date) as year,
	count(distinct customer_id) as total_customer,
	count(distinct order_id) as total_order
from orders
group by year(order_date)
order by year

select
	year(order_date) as year,
	count(distinct customer_id) as cnt
from orders
group by year(order_date)
having count(customer_id)>1
order by year 


-- Number of customers by market
select
	year(order_date) as year,
	market,
	count(distinct customer_id) as number_of_customers
from orders
group by year(order_date), market
order by year
