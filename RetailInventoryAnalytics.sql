CREATE DATABASE RetailInventoryAnalytics;
USE RetailInventoryAnalytics;
SELECT COUNT(*) 
FROM sales_data;
RENAME TABLE sales_data TO Retail_Raw;
ALTER TABLE Retail_Raw RENAME COLUMN `Store ID` TO Store_ID;
ALTER TABLE Retail_Raw RENAME COLUMN `Product ID` TO Product_ID;
ALTER TABLE Retail_Raw RENAME COLUMN `Inventory Level` TO Inventory_Level;
ALTER TABLE Retail_Raw RENAME COLUMN `Units Sold` TO Units_Sold;
ALTER TABLE Retail_Raw RENAME COLUMN `Units Ordered` TO Units_Ordered;
ALTER TABLE Retail_Raw RENAME COLUMN `Weather Condition` TO Weather_Condition;
ALTER TABLE Retail_Raw RENAME COLUMN `Competitor Pricing` TO Competitor_Pricing;
SELECT COUNT(*) 
FROM retail_raw;
DESCRIBE Retail_Raw;
SELECT *
FROM Retail_Raw
LIMIT 10;
-- missing values check
SELECT *
FROM Retail_Raw
WHERE Units_Sold IS NULL
OR Inventory_Level IS NULL;
-- Duplicate records check
SELECT Date, Store_ID, Product_ID, COUNT(*)
FROM Retail_Raw
GROUP BY Date, Store_ID, Product_ID
HAVING COUNT(*) > 1;
-- total sales
SELECT SUM(Units_Sold) as Total_Sales
FROM Retail_Raw;
-- total sales by category
SELECT 
    Category,
    SUM(Units_Sold) AS Total_Sales
FROM Retail_Raw
GROUP BY Category
ORDER BY Total_Sales DESC;

-- Region wise performance
SELECT 
    Region,
    SUM(Units_Sold) AS Total_Sales,
    AVG(Inventory_Level) AS Avg_Inventory
FROM Retail_Raw
GROUP BY Region;

-- Stock Turnover Ratio
SELECT 
    Product_ID,
    SUM(Units_Sold) / AVG(Inventory_Level) AS Stock_Turnover
FROM Retail_Raw
GROUP BY Product_ID
ORDER BY Stock_Turnover DESC;

-- Fast / Slow moving products
SELECT 
    Product_ID,
    SUM(Units_Sold) AS Total_Sales,
    CASE
        WHEN SUM(Units_Sold) > 500 THEN 'Fast Moving'
        WHEN SUM(Units_Sold) BETWEEN 200 AND 500 THEN 'Moderate'
        ELSE 'Slow Moving'
    END AS Product_Movement
FROM Retail_Raw
GROUP BY Product_ID;

 -- Stock-out risk
 SELECT
    Product_ID,
    SUM(Demand) AS Total_Demand,
    AVG(Inventory_Level) AS Avg_Inventory,
    CASE
        WHEN SUM(Demand) > AVG(Inventory_Level)
        THEN 'Stock-Out Risk'
        ELSE 'Safe'
    END AS Risk_Level
FROM Retail_Raw
GROUP BY Product_ID;

-- Monthly sales trend

SELECT
    YEAR(Date) AS Year,
    MONTH(Date) AS Month,
    SUM(Units_Sold) AS Monthly_Sales
FROM Retail_Raw
GROUP BY YEAR(Date), MONTH(Date)
ORDER BY Year, Month;









