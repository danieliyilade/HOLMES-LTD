SELECT * FROM customers;
SELECT * FROM products;
SELECT * FROM sales;


-- 1. Analyze Product Category Performance:
-- Use SQL queries to determine the total revenue generated by each product category.
-- identify the top 3 customers by spending within each category to tailor personalized marketing strategies and loyalty programs.

SELECT category, SUM(quantity * saleprice) as TotalRevenue
FROM sales s
Join products p
on p.productid = s.productid
GROUP BY category;

SELECT firstname, lastname, SUM(quantity * saleprice) as TotalRevenue, category
FROM customers c
JOIN sales s
on c.customerid = s.customerid
JOIN products p
ON p.productid = s.productid
Group by firstname,lastname,category
ORDER BY TotalRevenue DESC
LIMIT 3;

SELECT firstname, lastname, SUM(quantity * saleprice) as TotalRevenue
FROM customers c
JOIN sales s
on c.customerid = s.customerid
Group by firstname,lastname
ORDER BY TotalRevenue DESC
LIMIT 3;


-- 2. Customer Purchasing Patterns: Perform an analysis on customers whose names start with 'J' 
--and have made purchases totaling over $1,000. 
--This task involves joining sales data with customer information, 
--which can help in understanding highvalue customer behaviors and preferences.



SELECT firstname,lastname , SUM(quantity * saleprice) as TotalRevenue
FROM customers c
JOIN sales s
on c.customerid = s.customerid
WHERE firstname like 'J%'
Group by firstname,lastname
Having  SUM(quantity * saleprice) > 1000
order by TotalRevenue desc;



-- 3. Inventory Management:Identify products that have never been sold by using subqueries. 
-- This analysis is crucial for inventory management, helping to decide on discontinuing certain products or 
-- initiating promotional efforts to boost their sales.


SELECT productid,productname, category, price
FROM products
WHERE productid NOT IN ( select distinct productid
FROM sales);

SELECT  distinct (s.productid), productname, category, price
FROM products p
LEFT JOIN sales s
ON p.productid = s.productid
WHERE s.productid = NULL


--4. Sales Trend Analysis: Analyze sales made in the first quarter and December, using UNION operations. 
-- This task will help in understanding seasonal trends and planning inventory and marketing efforts accordingly.


SELECT saleid, s.productid, saledate,quantity
FROM sales s
WHERE EXTRACT (YEAR from saledate) = 2023 AND
EXTRACT (MONTH from saledate) between 1 and 3

UNION 

SELECT saleid, s.productid, saledate,quantity
FROM sales s
WHERE EXTRACT (YEAR from saledate) = 2023 AND
EXTRACT (MONTH from saledate) = 12;


--5. Payment Method Insights: Evaluate the average, minimum, and maximum sale amounts for each payment method, excluding sales
-- below $50. These insights can inform payment process improvements and promotional offers.

SELECT paymentmethod, AVG (quantity * saleprice) AS Average_Salesamount,
MAX(quantity * saleprice) AS Max_Salesamount,
MIN(quantity * saleprice) AS MIN_Salesamount
FROM sales
WHERE quantity * saleprice >= 50
GROUP by paymentmethod
ORDER BY paymentmethod;

-- 6. Product Catalog Optimization: Determine the number of unique product categories and identify 
--products with the word 'smart' in their names. 
--This task can guide product development and marketing strategies, focusing on trending products and categories.

SELECT count(distinct(category)) 
from products;


SELECT productname
from products
where productname iLIKE 'smart%';


-- 7. Revenue Generation Analysis: Create a view showing total sales and revenue generated by each product, 
-- then select products that have generated significant revenue. 
-- This analysis helps in identifying star products and optimizing the product mix.


CREATE VIEW productsalessummary AS
SELECT s.productid, productname , COUNT(saleid) AS totalsale, SUM(quantity * saleprice) AS Revenue
from sales s
join products p
ON s.productid = p.productid
GROUP BY s.productid,productname;


SELECT productname,productid,totalsale,Revenue
FROM productsalessummary
WHERE Revenue > 10000;

--8.Stock Level Adjustment: Develop a stored procedure for updating stock levels by product category.  
-- This automated task will improve stock management efficiency, ensuring optimal inventory levels based on sales data.


CREATE OR REPLACE PROCEDURE update_stock_level (category_name VARCHAR, stock_increament INT)
language plpgsql
AS $$
Begin UPDATE products
SET stockquantity = stockquantity + stock_increament
WHERE category = category_name;
END;
$$

CALL update_stock_level ('Electronics', 10);

SELECT * FROM products
WHERE category ='Electronics';


-- 9.Customer Spending Ranking: Use window functions to rank customers based on their total spending and 
--   calculate cumulative revenue per product category over time. 
--   These tasks are vital for customer segmentation and targeted marketing campaigns.


SELECT s.customerid,firstname,lastname, SUM(quantity * saleprice) as Totalspent,
RANK() OVER (ORDER BY SUM(quantity * saleprice) DESC) as Spendingrank
FROM customers cu
JOIN sales s
ON cu.customerid = s.customerid
GROUP BY s.customerid,firstname,lastname
ORDER BY Totalspent;


SELECT category, saledate, SUM( quantity * saleprice)
OVER (PARTITION BY category  ORDER BY saledate) AS cumulativerevenue
FROM products pr
JOIN sales s
ON pr.productid = s.productid
ORDER BY category, saledate;


-- 10. Sales Performance Categorization:Categorize each sale into 'Low', 'Medium', and 'High' intensity based on the total sale amount 
-- using CASE statements. This analysis will help in identifying sales patterns and adjusting sales strategies accordingly.

SELECT saleid, quantity * saleprice as Revenue,
CASE
    WHEN quantity * saleprice < 100 THEN 'Low'
	WHEN quantity * saleprice BETWEEN  100 and 500 THEN 'Medium'
	ELSE  'High'
END as Saleintensity
FROM sales;

























