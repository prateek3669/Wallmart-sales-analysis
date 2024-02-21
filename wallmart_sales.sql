SELECT *
FROM wallmart;

-- Feature Engineering
-- Add a new column time_of_day
SELECT 
	time,
    CASE
		WHEN time BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
        WHEN time BETWEEN '12:00:01' AND '16:00:00' THEN 'Afternoon'
        Else 'Night'
    END AS time_of_day
FROM wallmart;

ALTER TABLE wallmart
ADD COLUMN time_of_day VARCHAR(20);

UPDATE wallmart
SET time_of_day = (
     CASE
		WHEN time BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
        WHEN time BETWEEN '12:00:01' AND '16:00:00' THEN 'Afternoon'
        Else 'Night'
    END
);

-- Add a new column day_name
SELECT
    date,
    DAYNAME(date) AS day_of_week
FROM wallmart;

ALTER TABLE wallmart
ADD COLUMN day_of_week VARCHAR(20);

UPDATE wallmart
SET day_of_week = DAYNAME(date);

-- Add a new column month_name
ALTER TABLE wallmart
ADD COLUMN month VARCHAR(20);

UPDATE wallmart
SET month = MONTHNAME(date);

-- Generic Questions
-- 1. How many unique cities does the data have?

SELECT COUNT(DISTINCT city) AS number_of_cities
FROM wallmart;

-- 2. In which city is each branck?
SELECT DISTINCT branch, city
FROM wallmart
ORDER BY 1;

-- Product related Questions
-- 1. How many unique product lines does the data have?
-- First we need to change the column name
ALTER TABLE wallmart
CHANGE COLUMN `Product Line` `product_line` VARCHAR(255);

SELECT DISTINCT product_line
FROM wallmart;

-- 2. What is the most common payment method?
SELECT 
    payment, 
    COUNT(*) AS number_of_uses
FROM wallmart
GROUP BY 1
ORDER BY 1 DESC
LIMIT 1;

-- 3. What is the most selling product line?
SELECT
    product_line,
    COUNT(*) AS count
FROM wallmart
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;

-- 4. What is the total revenue by month?
SELECT
    month,
    ROUND(SUM(total),2) AS total_revenue
FROM wallmart
GROUP BY 1
ORDER BY 2 DESC;

-- 5. Which month had the largest COGS?
SELECT
    month,
    ROUND(SUM(cogs),2) AS cogs
FROM wallmart
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;

-- 6. Which product line had the largest revenue?
SELECT
    product_line,
    ROUND(SUM(total),2) AS total_revenue
FROM wallmart
GROUP BY 1
ORDER BY 2 DESC;

-- 7. Which city had the largest revenue?
SELECT
    city,
    ROUND(SUM(total),2) AS total_revenue
FROM wallmart
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;

-- 8. Which product line had the largest VAT?
SELECT
    product_line,
    ROUND(SUM(`Tax 5%`),2) AS total_VAT
FROM wallmart
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;

-- 9.
SELECT
    product_line,
    CASE
        WHEN total > AVG(total) THEN 'Good'
        ELSE 'Bad'        
    END AS 'Good/Bad'
FROM wallmart
GROUP BY 1, total;

-- 10. Which branch sold more products than average product sold?
SELECT 
    branch,
    SUM(quantity) AS total_qty
FROM wallmart
GROUP BY 1
HAVING SUM(quantity) > (SELECT AVG(quantity) FROM wallmart);

-- 11. What is the most common product line by gender?
SELECT
    product_line,
    gender,
    COUNT(gender) AS total
FROM wallmart
GROUP BY 1,2
ORDER BY 3 DESC;

-- 12. What is the average rating of each product line.
SELECT
    product_line,
    ROUND(AVG(rating),2) AS avg_rating
FROM wallmart
GROUP BY 1
ORDER BY 2 DESC;

-- Sales related questions
-- 1. Number of sales made in each time of the day per weekday
SELECT day_of_week, time_of_day, COUNT(*)
FROM wallmart
GROUP BY 1,2
ORDER BY 1;

-- 2. Which of the customer types brings the most revenue?
SELECT 
    `Customer type`, 
    ROUND(SUM(Total),2) AS total_revenue
FROM wallmart
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;

-- 3. Which city has the largest tax percent/VAT?
SELECT
    city,
    MAX(`tax 5%`)
FROM wallmart
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;

-- 4. Which customer type pays the most in VAT?
SELECT
    `customer type`,
    MAX(`Tax 5%`)
FROM wallmart
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;

-- Customer related questions
-- 1. How many unique customer types does the data have?
SELECT COUNT(DISTINCT `customer type`) AS customer_type_cnt
FROM wallmart;

-- 2. How many unique payment methods does the data have?
SELECT COUNT(DISTINCT payment) AS payment_type_cnt
FROM wallmart;

-- 3. What is the most common customer type?
SELECT
    `customer type`,
    COUNT(*) AS customer_type_cnt
FROM wallmart
GROUP BY 1;

-- 4. Which customer type buys the most?
SELECT
    `customer type`,
    COUNT(*) AS customer_type_cnt
FROM wallmart
GROUP BY 1;

-- 5. What is the gender of most of the customers?
SELECT
    gender,
    COUNT(*) AS total
FROM wallmart
GROUP BY 1;

-- 6. What is the gender distribution per branch?
SELECT
    branch,
    gender,
    COUNT(*)
FROM wallmart
GROUP BY 1,2
ORDER BY 1,2;

-- 7. Which time of the day do customers give most ratings?
SELECT 
    time_of_day,
    COUNT(rating)
FROM wallmart
GROUP BY 1;

-- 8. Which time of the day do customers give most ratings per branch?
SELECT 
    branch,
    time_of_day,
    COUNT(rating)
FROM wallmart
GROUP BY 1,2
ORDER BY 1;

-- 9. Which day fo the week has the best avg ratings?
SELECT
    day_of_week,
    ROUND(AVG(rating),2) AS avg_rating
FROM wallmart
GROUP BY 1
ORDER BY 2 DESC;

-- 10.Which day of the week has the best average ratings per branch?
SELECT
    branch,
    day_of_week,
    ROUND(AVG(rating),2) AS avg_rating
FROM wallmart
GROUP BY 1,2
ORDER BY 1;