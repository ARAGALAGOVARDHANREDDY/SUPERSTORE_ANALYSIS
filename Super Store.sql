CREATE DATABASE superstore_analysis;

USE superstore_analysis;

CREATE TABLE superstore (
    row_id INT,
    order_id VARCHAR(20),
    order_date DATE,
    ship_date DATE,
    ship_mode VARCHAR(30),
    customer_id VARCHAR(20),
    customer_name VARCHAR(100),
    segment VARCHAR(30),
    country VARCHAR(50),
    city VARCHAR(100),
    state VARCHAR(100),
    postal_code VARCHAR(15),
    region VARCHAR(30),
    product_id VARCHAR(30),
    category VARCHAR(50),
    sub_category VARCHAR(50),
    product_name VARCHAR(255),
    sales DECIMAL(12,2),
    quantity INT,
    discount DECIMAL(5,2),
    profit DECIMAL(12,4)
);

SET GLOBAL local_infile = 1;

USE superstore_analysis;

LOAD DATA LOCAL INFILE 'C:/Users/tharu/Downloads/superstore_cleaned.csv'
INTO TABLE superstore
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    row_id,
    order_id,
    order_date,
    ship_date,
    ship_mode,
    customer_id,
    customer_name,
    segment,
    country,
    city,
    state,
    postal_code,
    region,
    product_id,
    category,
    sub_category,
    product_name,
    sales,
    quantity,
    discount,
    profit
);

SELECT COUNT(*) FROM superstore;

SELECT * FROM superstore LIMIT 10;

#What are the overall sales, profit, quantity and number of orders?
SELECT
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    SUM(quantity) AS total_quantity,
    COUNT(DISTINCT order_id) AS total_orders,
    COUNT(DISTINCT customer_id) AS total_customers
FROM superstore;

#What is the overall profit margin?
SELECT
    ROUND(
        SUM(profit) / SUM(sales) * 100, 2
    ) AS profit_margin_percentage
FROM superstore;

#Which product categories generate the highest sales and profit?
SELECT
    category,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit
FROM superstore
GROUP BY category
ORDER BY total_sales DESC;

#Which sub-categories generate the highest and lowest profits?
SELECT
    sub_category,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit
FROM superstore
GROUP BY sub_category
ORDER BY total_profit DESC;

#Which are the top 10 products by sales?
SELECT
    product_name,
    ROUND(SUM(sales), 2) AS total_sales
FROM superstore
GROUP BY product_name
ORDER BY total_sales DESC
LIMIT 10;


USE superstore_analysis;

# Q6. Which are the bottom 10 products by profit?
SELECT
    product_name,
    ROUND(SUM(profit), 2) AS total_profit
FROM superstore
GROUP BY product_name
ORDER BY total_profit ASC
LIMIT 10;


# Q7. Which customer segment contributes the highest revenue?
SELECT
    segment,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    COUNT(DISTINCT customer_id) AS total_customers
FROM superstore
GROUP BY segment
ORDER BY total_sales DESC;


# Q8. Which customer segment has the highest average order value?
SELECT
    segment,
    ROUND(SUM(sales) / COUNT(DISTINCT order_id), 2) AS average_order_value
FROM superstore
GROUP BY segment
ORDER BY average_order_value DESC;


# Q9. Which shipping mode generates the highest sales?
SELECT
    ship_mode,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    COUNT(DISTINCT order_id) AS total_orders
FROM superstore
GROUP BY ship_mode
ORDER BY total_sales DESC;


# Q10. Which shipping mode has the shortest average delivery time?
SELECT
    ship_mode,
    ROUND(AVG(DATEDIFF(ship_date, order_date)), 2) AS average_delivery_days
FROM superstore
GROUP BY ship_mode
ORDER BY average_delivery_days ASC;


# Q11. Which states generate the highest sales?
SELECT
    state,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit
FROM superstore
GROUP BY state
ORDER BY total_sales DESC
LIMIT 10;


# Q12. Which states are generating losses?
SELECT
    state,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit
FROM superstore
GROUP BY state
HAVING SUM(profit) < 0
ORDER BY total_profit ASC;


# Q13. Which region contributes the highest revenue?
SELECT
    region,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit
FROM superstore
GROUP BY region
ORDER BY total_sales DESC;


# Q14. How do sales and profit change year-wise?
SELECT
    YEAR(order_date) AS order_year,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit
FROM superstore
GROUP BY YEAR(order_date)
ORDER BY order_year;


# Q15. Which months generate the highest sales?
SELECT
    MONTHNAME(order_date) AS month_name,
    MONTH(order_date) AS month_number,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit
FROM superstore
GROUP BY MONTH(order_date), MONTHNAME(order_date)
ORDER BY total_sales DESC;


# Q16. What is the monthly sales trend across different years?
SELECT
    YEAR(order_date) AS order_year,
    MONTH(order_date) AS month_number,
    MONTHNAME(order_date) AS month_name,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit
FROM superstore
GROUP BY YEAR(order_date), MONTH(order_date), MONTHNAME(order_date)
ORDER BY order_year, month_number;


# Q17. How do discounts affect sales and profitability?
SELECT
    discount,
    COUNT(*) AS total_records,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(AVG(profit), 2) AS average_profit
FROM superstore
GROUP BY discount
ORDER BY discount;


# Q18. Which products generate losses despite generating sales?
SELECT
    product_name,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit
FROM superstore
GROUP BY product_name
HAVING SUM(profit) < 0
ORDER BY total_profit ASC
LIMIT 15;


# Q19. Which sub-categories have the lowest profit margins?
SELECT
    sub_category,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(SUM(profit) / NULLIF(SUM(sales), 0) * 100, 2) AS profit_margin
FROM superstore
GROUP BY sub_category
ORDER BY profit_margin ASC;


# Q20. Who are the top 10 customers by revenue?
SELECT
    customer_id,
    customer_name,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    COUNT(DISTINCT order_id) AS total_orders
FROM superstore
GROUP BY customer_id, customer_name
ORDER BY total_sales DESC
LIMIT 10;


# Q21. How many customers are repeat customers?
SELECT
    COUNT(*) AS repeat_customers
FROM (
    SELECT customer_id
    FROM superstore
    GROUP BY customer_id
    HAVING COUNT(DISTINCT order_id) > 1
) AS repeat_customer_list;


# Q22. Which cities generate the highest revenue?
SELECT
    city,
    state,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit
FROM superstore
GROUP BY city, state
ORDER BY total_sales DESC
LIMIT 10;


# Q23. Which products have the highest sales quantity?
SELECT
    product_name,
    SUM(quantity) AS total_quantity,
    ROUND(SUM(sales), 2) AS total_sales
FROM superstore
GROUP BY product_name
ORDER BY total_quantity DESC
LIMIT 10;


# Q24. Which category has the highest average discount?
SELECT
    category,
    ROUND(AVG(discount) * 100, 2) AS average_discount_percentage,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit
FROM superstore
GROUP BY category
ORDER BY average_discount_percentage DESC;


# Q25. What percentage of total sales does each category contribute?
SELECT
    category,
    ROUND(SUM(sales), 2) AS category_sales,
    ROUND(
        SUM(sales) * 100 /
        (SELECT SUM(sales) FROM superstore), 2
    ) AS sales_percentage
FROM superstore
GROUP BY category
ORDER BY sales_percentage DESC;
