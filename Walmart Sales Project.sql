use [WalmartSales]

-- Cleaning data 
select * 
from [dbo].[WalmartSalesData.csv]


-- ADD COLUMN time_of_day 
ALTER TABLE [dbo].[WalmartSalesData.csv] ADD time_of_day VARCHAR(20)
UPDATE [dbo].[WalmartSalesData.csv]
SET time_of_day=
	(CASE
		WHEN time BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
        WHEN time BETWEEN '12:01:00' AND '16:00:00' THEN 'Afternoon'
        ELSE 'Evening'
    END) 
FROM [dbo].[WalmartSalesData.csv];


-- ADD COLUMN day_name
select 
	date,
	datename (dw, date) 
from [dbo].[WalmartSalesData.csv];

ALTER TABLE [dbo].[WalmartSalesData.csv] ADD day_name VARCHAR(25);
UPDATE [dbo].[WalmartSalesData.csv]
SET day_name=
	(datename (dw, date))
from [dbo].[WalmartSalesData.csv]


-- AD COLUMN mont_name
select 
	date,
	datename (mm, date)
from [dbo].[WalmartSalesData.csv]

ALTER TABLE [dbo].[WalmartSalesData.csv] ADD mont_name VARCHAR(25)
UPDATE [dbo].[WalmartSalesData.csv]
SET mont_name = (datename (mm, date))
from [dbo].[WalmartSalesData.csv]



-- Generic Question 

--1. How many unique cities does the data have?
select count(distinct city) as cunt_unique_city
from [dbo].[WalmartSalesData.csv]

--2. In which city is each branch?
select distinct(Branch) as branch, city
from [dbo].[WalmartSalesData.csv]
order by branch

-- Product Question
--1. How many unique product lines does the data have?
select count(distinct product_line) as prodouct_unique
from [dbo].[WalmartSalesData.csv]

--2. What is the most selling product line
select product_line, SUM(Quantity) as sum_product_sales
from [dbo].[WalmartSalesData.csv]
group by product_line
order by SUM(Quantity) DESC

--3. How much total revenue by month	
select mont_name, sum(Unit_price * quantity) as revenue
from [dbo].[WalmartSalesData.csv]
group by mont_name
order by mont_name

--4. Month have largest COGS 
select mont_name, sum(cogs) as sum_cogs
from [dbo].[WalmartSalesData.csv]
group by mont_name
order by mont_name

--5. Product line have largest revenue
select product_line, sum(unit_price * quantity) as total_revenue
from [dbo].[WalmartSalesData.csv]
group by product_line 
order by product_line  DESC

--6. City line have largest revenue
select city, sum(unit_price * quantity) as total_revenue
from [dbo].[WalmartSalesData.csv]
group by city 
order by city DESC

--7. product line have largest VAT
select Product_line, avg(Tax_5) as avg_tax
from [dbo].[WalmartSalesData.csv]
group by Product_line 
order by Product_line DESC

--8. What is payment methode use?
select payment, count(Invoice_ID) as total_paymment 
from [dbo].[WalmartSalesData.csv]
group by Payment

-- 9. Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales
select avg(quantity)
from [dbo].[WalmartSalesData.csv]

SELECT 
	product_line,
CASE WHEN AVG(QUANTITY) > 5 THEN 'Good'
	ELSE 'BAD'
	END as remark
from [dbo].[WalmartSalesData.csv]
group by product_line

--10. Which branch sold more products than average product sold?
-- Average product sold 
select avg(quantity) as avg_quantity 
from [dbo].[WalmartSalesData.csv]

-- Branch have sold product more than avg product sold
select branch, avg(quantity) as avg_quantity
from [dbo].[WalmartSalesData.csv]
group by branch
having avg(quantity) > (select avg(quantity) 
							  from [dbo].[WalmartSalesData.csv])

--11. What is the most common product line by gender?
select gender, product_line, count(gender) as sold
from [dbo].[WalmartSalesData.csv]
group by gender, Product_line
order by Gender,count(gender) DESC

--12. What is the average rating of each product line?
select product_line, round (avg(rating),0) as rating
from [dbo].[WalmartSalesData.csv]
group by product_line


--- Sales Question 
--1. Number of sales made in each time of the day per weekday
select day_name, count(quantity) as total_sold
from [dbo].[WalmartSalesData.csv]
group by day_name
order by total_sold

--2. Which of the customer types brings the most revenue?
select customer_type, sum(unit_price * quantity) as revenue
from [dbo].[WalmartSalesData.csv]
group by customer_type
order by revenue

--3. What is the most common customer type?
select customer_type, count(customer_type) as count_customer
from [dbo].[WalmartSalesData.csv]
group by customer_type

--4. Which customer type buys the most?
select customer_type, sum(quantity) as sum_quantity
from [dbo].[WalmartSalesData.csv]
group by customer_type

--5. What is the gender of most of the customers?
select gender, count(gender) as count_gender
from [dbo].[WalmartSalesData.csv]
group by gender

--6. What is the gender distribution per branch?
select gender, branch, count(gender) as count_gender 
from [dbo].[WalmartSalesData.csv]
group by gender, branch
order by Branch

--7. Which time of the day do customers give most ratings?
select day_name, count(rating) as count_rating 
from [dbo].[WalmartSalesData.csv]
group by day_name
order by count_rating DESC

-- 8. Which time of the day do customers give most ratings per branch?
select day_name, BRANCH, count(rating) as count_rating 
from [dbo].[WalmartSalesData.csv]
group by day_name, Branch
order by count_rating DESC

--9. Which day fo the week has the best avg ratings?
select day_name, avg(rating) as avg_rating 
from [dbo].[WalmartSalesData.csv]
group by day_name
order by avg_rating DESC

--10. Which day of the week has the best average ratings per branch?
select day_name, BRANCH, avg(rating) as avg_rating 
from [dbo].[WalmartSalesData.csv]
group by day_name, Branch
order by avg_rating DESC 