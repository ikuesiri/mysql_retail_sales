# Retail Sales Data Analysis  MYSQL Project

## Project Overview

**Project Title**: Retail Sales Analysis  
**Database**: `p1_retail_db`

This project is designed to demonstrate SQL skills and techniques typically used by data analysts to explore, clean, and analyze retail sales data. The project involves setting up a retail sales database, performing exploratory data analysis (EDA), and answering specific business questions through SQL queries (on MySQL).

## Objectives

1. **Set up a retail sales database**: Create and populate a retail sales database with the provided sales dataset.
2. **Data Cleaning**: Identify and remove any records with BLANK or null values and standardize the data.
3. **Exploratory Data Analysis (EDA)**: Perform basic exploratory data analysis to understand the dataset.
4. **Business Analysis**: Use SQL to answer specific business questions and derive insights from the sales data.

## Project Structure

### 1. Database Setup

- **Database Creation**: The project starts by creating a database named `p1_retail_db`.
- **Table Creation**: A table named `retail_sales` is created to store the sales data. The table structure includes columns for transactions_id,	sale_date, sale_time, customer_id	gender, age, category, quantity, price_per_unit, cogs(cost of goods), total_sale.

Load the dataset automatically by first creating a schema and navigating to upload the data,     OR

```sql
CREATE DATABASE p1_retail_db;
USE p1_retail_db;

CREATE TABLE retail_sales
(
    transactions_id INT PRIMARY KEY,
    sale_date DATE,	
    sale_time TIME,
    customer_id INT,	
    gender TEXT,
    age INT,
    category TEXT,
    quantity INT,
    price_per_unit INT,	
    cogs INT,
    total_sale INT
);
```

### 2. Data Exploration & Cleaning

- **Record Count**: Determine the total number of records in the dataset.
- **Standardize**: fix error on **transaction_id** name (issue only mySQL).
- **Null Value Check**: Check for any null values in the dataset and delete records with missing data.
- **Customer Count**: Find out how many unique customers are in the dataset.
- **Category Count**: Identify all unique product categories in the dataset.


```sql

SELECT COUNT(*) 
FROM p1_retail_db.retail_sales;

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
-- **Record Count**: Determine the total number of records in the dataset.

SELECT * FROM p1_retail_db.retail_sales;
SELECT COUNT(transactions_id) FROM retail_sales;


-- **Customer Count**: Find out how many unique customers are in the dataset.
SELECT COUNT( DISTINCT customer_id) FROM retail_sales;

-- **Category Count**: Identify all unique product categories in the dataset.
SELECT COUNT( DISTINCT category)  FROM retail_sales;
```

### 3. Data Analysis & Business Key Problems and Findings

The following SQL queries were developed to answer specific business questions:

1. **Write a SQL query to retrieve all columns for sales made on '2022-11-05**:
```sql
- step 1: fix date_format (issue only mySQL)
SELECT STR_TO_DATE(`sale_date`, '%m/%d/%Y')  `sale_date`
FROM retail_sales;

UPDATE retail_sales
SET `sale_date` = STR_TO_DATE(`sale_date`, '%m/%d/%Y');

ALTER TABLE retail_sales
MODIFY COLUMN `sale_date` DATE;

- analyze and solve the question
SELECT * 
FROM retail_sales
WHERE sale_date = '2022-11-05';

```

2. **Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is equal to, or more than 4 in the month of Nov-2022:**:
```sql
SELECT * 
FROM retail_sales
WHERE category = "Clothing"
AND sale_date like '2022-11%'
AND quantity >= 4;
```

3. **Write a SQL query to calculate the total sales (total_sale) for each category.**:
```sql
SELECT 
	category,  
	COUNT(*) AS TOTAL_ORDERS, 
	SUM(total_sale) AS NET_SALES
FROM retail_sales
GROUP BY category;
```

4. **Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.**:
```sql
SELECT 
	category, 
	ROUND(AVG(age), 2) AS avg_age
FROM retail_sales
WHERE category = "Beauty"
GROUP BY category;
```

5. **Write a SQL query to find all transactions where the total_sale is greater than 1000.**:
```sql
SELECT *
FROM retail_sales
WHERE total_sale > 1000;
```

6. **Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.**:
```sql
    SELECT
        category,
        gender,
        COUNT(transactions_id) total_transaction
    FROM
        retail_sales
    GROUP BY
        gender,
        category
    ORDER BY
        category;
```

7. **Write a SQL query to calculate the average sale for each month. Find out best selling month in each year**:
```sql
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
```

8. **Write a SQL query to find the top 5 customers based on the highest total sales**:
```sql
SELECT
	customer_id, 
    SUM(total_sale) TOP_5_CUSTOMERS
FROM retail_sales
GROUP BY customer_id
ORDER BY TOP_5_CUSTOMERS DESC
LIMIT 5
;
```

9. **Write a SQL query to find the number of unique customers who purchased items from each category.**:
```sql
SELECT
	category,
	COUNT(DISTINCT customer_id) unique_customers
FROM
	retail_sales
GROUP BY
	category
;
```

10. **Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)**:
```sql

-- step 1: convert time from `text` to `time` format. [mySQL issue]
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
```

## Findings

- **Customer Demographics**: The dataset includes customers from various age groups, with sales distributed across 3 categories, such as Clothing, Beauty, and Electronics.
- **High-Value Transactions**: Several transactions had a total sale amount greater than 1000, indicating premium purchases.
- **Sales Trends**: Monthly analysis shows variations in sales, helping identify peak seasons.
- **Customer Insights**: The analysis identifies the top-spending customers and the most popular product categories.

## Reports

- **Sales Summary**: A detailed report summarizing total sales, customer demographics, and category performance.
- **Trend Analysis**: Insights into sales trends across different months and shifts.
- **Customer Insights**: Reports on top customers and unique customer counts per category.

## Conclusion

This project serves as a comprehensive introduction to SQL for data analysts, covering database setup, data cleaning, exploratory data analysis, and business-driven SQL queries. The findings from this project can help drive business decisions by understanding sales patterns, customer behavior, and product performance.

## How to Use

1. **Clone the Repository**: Clone this project repository from GitHub.
2. **Set Up the Database**: Run the SQL scripts provided in the `database_setup.sql` file to create and populate the database.
3. **Run the Queries**: Use the SQL queries provided in the `analysis_queries.sql` file to perform your analysis.
4. **Explore and Modify**: Feel free to modify the queries to explore different aspects of the dataset or answer additional business questions.
