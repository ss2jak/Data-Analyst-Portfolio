CREATE DATABASE IF NOT EXISTS salesDataWalmart;

-- Create table
CREATE TABLE IF NOT EXISTS sales(
	invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(30) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    tax_pct FLOAT(6,4) NOT NULL,
    total DECIMAL(12, 4) NOT NULL,
    date DATETIME NOT NULL,sales
    time NOT NULL,
    time_of_day VARCHAR(20),
    payment VARCHAR(15) NOT NULL,
    cogs DECIMAL(10,2) NOT NULL,
    gross_margin_pct FLOAT(11,9),
    gross_income DECIMAL(12, 4),
    rating FLOAT(2, 1)
);

SELECT * FROM salesDataWalmart.sales;

-- creating time column

SELECT 
	time,
	(CASE
	when `time` between '00:00:00' AND "12:00:00" THEN "Morning" 
	when `time` between '00:00:00' AND "16:00:00" THEN "Afternoon" 
	Else "Evening"
    END
	) AS time_of_day
FROM salesDataWalmart.sales;

ALTER TABLE sales ADD COLUMN time_of_day VARCHAR(20);

-- Update 'time_of_day' based on the 'time' column
UPDATE sales
SET time_of_day = CASE
    WHEN `time` BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning' 
    WHEN `time` BETWEEN '12:00:01' AND '16:00:00' THEN 'Afternoon' 
    ELSE 'Evening'
END;

Select * FROM sales;

-- creating day column

SELECT date, DAYNAME(date) FROM sales;

ALTER TABLE sales ADD COLUMN day VARCHAR(10);

UPDATE sales
SET day = DAYNAME(date);

Select * FROM sales;

-- creating month column

SELECT date, MONTHNAME(date) FROM sales;

ALTER TABLE sales ADD COLUMN month VARCHAR(10);

UPDATE sales
SET month = MONTHNAME(date);

Select * FROM sales;

-- ---------------------------------------------------
-- ---------------------------------------------------

-- How many unique cities does the data have?

SELECT DISTINCT city FROM sales; 

-- In which city is each branch?
SELECT DISTINCT branch FROM sales;

SELECT DISTINCT city, branch FROM sales; 

					-- PRODUCT--
-- How many unique product lines does the data have?
SELECT DISTINCT product_line FROM sales;

-- What is the most common payment method?

SELECT payment,
		COUNT(payment) AS cnt
FROM sales
GROUP BY payment
ORDER BY cnt DESC;

-- What is the best selling product line
SELECT product_line,
		COUNT(product_line) AS cnt
FROM sales
GROUP BY product_line
ORDER BY cnt DESC;

-- What is the total revenue by month?
SELECT month,
	SUM(total) as total_revenue
FROM sales
GROUP BY month
ORDER BY total_revenue DESC;

-- What month had the largest COGS?
SELECT month,
	SUM(COGS) AS COGS
FROM sales
GROUP BY month
ORDER BY COGS DESC;

-- What is the city with the lowest revenue?
SELECT city,
	SUM(total) as total_revenue
FROM sales
GROUP BY city
ORDER BY total_revenue;

-- What product line had the least revenue?
SELECT product_line,
	SUM(total) as total_revenue
FROM sales
GROUP BY product_line
ORDER BY total_revenue;

-- What product line had the largest VAT?
SELECT product_line,
	AVG(tax_pct) as avg_tax
FROM sales
GROUP BY product_line
ORDER BY avg_tax DESC;

-- Which branch sold more products than average product sold?
SELECT branch,
	SUM(quantity) AS qty
FROM sales
GROUP BY branch
HAVING SUM(quantity) > (SELECT AVG(quantity) FROM sales);

-- What is the most common product line by gender?
SELECT gender, product_line,
	COUNT(gender) AS total_cnt
    FROm sales
    GROUP BY gender, product_line
    ORDER BY total_cnt DESC;
    
-- What is the average rating of each product line?
SELECT product_line,
	AVG(rating) AS avg_rating
    FROM sales
    GROUP BY product_line
    ORDER BY avg_rating DESC;

							-- SALES --
SELECT * FROM salesDataWalmart.sales;

-- Number of sales made in each time of the day per weekday
SELECT time_of_day,
	COUNT(*) AS total_sales
FROM sales
# use where to find number of sales within specific day WHERE day = "Saturday"
GROUP BY time_of_day
ORDER BY total_sales;

-- Which customer types brings the most revenue?

SELECT customer_type,
	SUM(total) as total_revenue
FROM sales
GROUP BY customer_type
ORDER BY total_revenue DESC;

-- Which city has the largest tax percent?
SELECT city,
	AVG(tax_pct) as avg_tax
FROM sales
GROUP BY city
ORDER BY avg_tax DESC;

-- Which customer type pays the most in tax?
SELECT customer_type,
	SUM(total) as avg_tax
FROM sales
GROUP BY customer_type
ORDER BY avg_tax DESC;

				-- CUSTOMER-- 

-- How many unique customer types does the data have?
SELECT DISTINCT customer_type
FROM sales;

-- How many unique payment methods does the data have?
SELECT DISTINCT payment
FROM sales;

-- What is the most common customer type?
SELECT customer_type,
	COUNT(*) AS customer_count
FROM sales
GROUP BY customer_type;

-- Which customer type buys the most?
SELECT customer_type,
	COUNT(gender) AS gender_count
FROM sales
GROUP BY gender
ORDER BY gender_count DESC;
    
-- What is the gender of most of the customers?
SELECT gender,
	COUNT(gender) AS gender_count
FROM sales
GROUP BY gender
ORDER BY gender_count DESC;

-- What is the gender distribution per branch?
SELECT branch,
	COUNT(*) AS gender_count
FROM sales
WHERE branch = "B"
GROUP BY gender
ORDER BY gender_count DESC;
    
-- Which time of the day do customers give most ratings?
SELECT time_of_day,
	AVG(rating) AS avg_rating
FROM sales
GROUP BY time_of_day
ORDER BY avg_rating;

-- Which time of the day do customers give most ratings per branch?
SELECT time_of_day, branch,
	AVG(rating) AS avg_rating
FROM sales
WHERE branch = "B"
GROUP BY time_of_day
ORDER BY avg_rating;

-- Which day of the week has the highest avg ratings?
SELECT day,
	AVG(rating) AS avg_rating
FROM sales
GROUP BY day
ORDER BY avg_rating DESC;

-- Which day of the week has the highest average ratings per branch?
SELECT day, branch,
	AVG(rating) AS avg_rating
FROM sales
WHERE branch = "B"
GROUP BY day
ORDER BY avg_rating DESC;