-- DROP DATABASE IF EXISTS p1_retail_db;
-- CREATE DATABASE p1_retail_db;
-- USE p1_retail_db;


SELECT COUNT(*) FROM p1_retail_db.retail_sales;

SELECT * FROM p1_retail_db.retail_sales;



-- Fixing the error 'transaction name'
ALTER TABLE  retail_sales
CHANGE ï»¿transactions_id transactions_id INT;

--  CHECKING FOR NULL VALUES
SELECT * FROM retail_sales
WHERE age IS NULL 
OR quantity	IS NULL
OR price_per_unit IS NULL
OR cogs	IS NULL
OR total_sale IS NULL
;


-- **Record Count**: Determine the total number of records in the dataset. [ANS: 1987]

SELECT * FROM p1_retail_db.retail_sales;
SELECT COUNT(transactions_id) FROM retail_sales;


-- **Customer Count**: Find out how many unique customers are in the dataset. [ANS- 155]
SELECT COUNT( DISTINCT customer_id) FROM retail_sales;

-- **Category Count**: Identify all unique product categories in the dataset. [ANS: 3]
SELECT COUNT( DISTINCT category)  FROM retail_sales;


-- ----- Data Analysis & Business Kep Problems & Anwsers---

-- Q1. Write a SQL query to retrieve all columns for sales made on '2022-11-05:

-- step 1: fix date_format
SELECT STR_TO_DATE(`sale_date`, '%m/%d/%Y')  `sale_date`
FROM retail_sales;

UPDATE retail_sales
SET `sale_date` = STR_TO_DATE(`sale_date`, '%m/%d/%Y');

ALTER TABLE retail_sales
MODIFY COLUMN `sale_date` DATE;

-- STEP 2: query '2022-11-05'

SELECT * FROM p1_retail_db.retail_sales;

SELECT * 
FROM retail_sales
WHERE sale_date = '2022-11-05';

-- Q2: Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022:

SELECT * FROM retail_sales;

SELECT * 
FROM retail_sales
WHERE category = "Clothing"
AND sale_date like '2022-11%'
AND quantity >= 4;


-- Q3: Write a SQL query to calculate the total sales (total_sale) for each category.:

SELECT * FROM retail_sales;

SELECT 
	category,  
	COUNT(*) AS TOTAL_ORDERS, 
	SUM(total_sale) AS NET_SALES
FROM retail_sales
GROUP BY category;

-- Q4:  Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.:

SELECT 
	category, 
	ROUND(AVG(age), 2) AS avg_age
FROM retail_sales
WHERE category = "Beauty"
GROUP BY category;

-- Q5: Write a SQL query to find all transactions where the total_sale is greater than 1000.:
SELECT * FROM retail_sales;

SELECT *
FROM retail_sales
WHERE total_sale > 1000;

-- Q6: Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.:
SELECT category, gender, COUNT(transactions_id) total_transaction
FROM retail_sales
GROUP BY gender, category
ORDER BY category;


-- Q7: Write a SQL query to calculate the average sale for each month. Find out best selling month in each year:
SELECT * FROM retail_sales;

SELECT *
FROM
(
	SELECT
		YEAR(sale_date) `year`,
		SUBSTRING(sale_date, 1, 7)`month`,
		AVG(total_sale) avg_sales,
		RANK() OVER(PARTITION BY YEAR(sale_date) ORDER BY AVG(total_sale) DESC ) ranking
	FROM retail_sales
	GROUP BY `year`, `month`
) as best_selling_months
WHERE ranking = 1;


 -- Q8: Write a SQL query to find the top 5 customers based on the highest total sales **:
SELECT * FROM retail_sales;

SELECT
	customer_id, 
    SUM(total_sale) TOP_5_CUSTOMERS
FROM retail_sales
GROUP BY customer_id
ORDER BY TOP_5_CUSTOMERS DESC
LIMIT 5
;


 -- Q9: Write a SQL query to find the number of unique customers who purchased items from each category.:
SELECT * FROM retail_sales;

SELECT
	category,
	COUNT(DISTINCT customer_id) unique_customers
FROM
	retail_sales
GROUP BY
	category
;


-- Q10: Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17):
SELECT * FROM retail_sales;

-- step 1: convert time from `text` to `time` format.
SELECT STR_TO_DATE(`sale_time`, '%H:%i:%s') `sale_time`
FROM retail_sales;

UPDATE retail_sales
SET `sale_time` = STR_TO_DATE(`sale_time`, '%H:%i:%s');

ALTER TABLE retail_sales
MODIFY COLUMN `sale_time` TIME;

-- step2: answer question

WITH shift_summary AS
(
	SELECT sale_time, COUNT(transactions_id) num_of_orders,
	CASE
		WHEN SUBSTRING(sale_time, 1, 2) < 12 THEN "Morning"
		WHEN SUBSTRING(sale_time, 1, 2) BETWEEN 12 AND 17 THEN "Afternoon"
		ELSE "Evening"
	END work_shift
	FROM retail_sales
	GROUP BY work_shift, sale_time
)
SELECT work_shift, SUM(num_of_orders) total_orders
FROM shift_summary
GROUP BY work_shift;

-- end of EDA -------
