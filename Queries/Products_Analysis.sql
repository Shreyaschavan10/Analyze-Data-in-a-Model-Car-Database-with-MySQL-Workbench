-------------------------------------------------------------------- Exploratory Data Analysis for Products---------------------------------------------------------------------------------
----------- The Products View displays data for all products carried by the Mint Classics Company joining rows across the Products, Orders Details, Orders, and Warehouses tables -----------
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------- Miscellaneous Statistics ---------------------------------------------------------------------------------------------
-- Number of products carried by the Mint Classics Company
SELECT COUNT(*) FROM products; -- There are 110 products for sale

-- Number of total products in stock
SELECT SUM(quantityInStock) FROM products; -- There are a total of 555,131 items in stock across 4 warehouses and 7 product lines

-- Is every product assigned to a product line
SELECT * FROM products WHERE productLine IS NULL; -- Empty Set: All products are assigned to a product line

-- Are there any products not being stored in Mint Classics warehouses
SELECT * FROM products_view WHERE warehouseCode IS NULL; -- Empty Set: All products sold by Mint Classics are currently being stored in MintClassics warehouses

-- Are there any products not being purchased, i.e, has no corresponding data from the Order Details table, e.g, orderNumber is null, priceEach = 0, quantityOrdered = 0
SELECT * FROM products_view WHERE orderNumber IS NULL; -- The 1985 Toyota Supra (productCode# S18_3233) currently has no sales, 7733 items in stock , and is stored in warehouse 'b'

----------------------------------------------------------------------------------- Space Utilization -----------------------------------------------------------------------------------------------
----------------------- All stock quantities represent static values for the time period 2003-01-10 to 2005-05-19, which are the dates of the first and last completed orders -----------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Rank warehouses by the quantity of items in stock and show their current fill capacity
SELECT pc.warehouseCode, pc.warehouseName, SUM(DISTINCT pc.quantityInStock) AS totalStock, w.warehousePctCap
FROM products_view pc
INNER JOIN warehouses w ON pc.warehouseCode = w.warehouseCode
GROUP BY pc.warehouseCode
ORDER BY totalStock DESC;
-- The East warehouse 'B' has the most items in stock at 219,183 units while the South warehouse 'D' has the least at 79,380 units; they are 67% full and 75% full, respectively
-- The sum of stock totals across all warehouses equals 555,131 units

-- Calculates total revenue and total items ordered for each product line: Filtered for completed orders ('Shipped', Resolved','Disputed')
SELECT 
    productLine, 
    SUM(quantityOrdered) AS totalOrdered, 
    SUM(priceEach*quantityOrdered) AS totalRevenue, 
    warehouseCode
FROM products_view
WHERE status IN ('Shipped','Resolved','Disputed')
GROUP BY productLine, warehouseCode
ORDER BY totalRevenue DESC;
-- The results of this query show that product lines are not distributed, but stored in distinct warehouses  
-- A: 'Motorcycles' and 'Planes', B: 'Classic Cars', C: 'Vintage Cars', and D: 'Trucks and Buses', 'Ships', and 'Trains'
-- 'Classic Cars' is both the most ordered and highest selling product line moving 33,817 units and generating $3,670,560.34 in sales
-- 'Trains' is both the least ordered and lowest selling product line with 2,651 units shipped and $175,030.77 in sales
-- The total revenue for all completed orders comes out to $9,060,489.30 while the total orders are 99,398 units

-- Cumulative Product Turnover Rate: Filtered for completed orders ('Shipped', 'Resolved','Disputed')
SELECT productCode, productName, 
       SUM(quantityOrdered) / MAX(quantityInStock) AS inventoryTurnover
FROM products_view
WHERE status IN  ('Shipped', 'Resolved','Disputed')
GROUP BY productCode, productName
ORDER BY inventoryTurnover DESC;
-- The '1960 BSA Gold Star DBD34', '1968 Ford Mustang', '1928 Ford Phaeton Deluxe', and '1997 BMW F650 ST' are on the high end of inventory turnover
-- They have a turnover rate of 67.6667, 13.3676, 6.2206, and 5.1685 respectively suggesting high demand
-- Nearly 100 products have a turnover rate of less than 1

-- Cumulative Warehouse Turnover Rate: Filtered for completed orders ('Shipped', 'Resolved','Disputed')
SELECT
    warehouseCode,
    SUM(quantityOrdered) / SUM(DISTINCT quantityInStock) AS inventoryTurnover
FROM products_view
WHERE status IN ('Shipped', 'Resolved','Disputed')
GROUP BY warehouseCode
ORDER BY inventoryTurnover DESC;
-- Rates are as follows - D: '0.2602', A: '0.1786', C: '0.1714', and B: '0.1599'

-------------------------------------------------------------------------------------- Summary Statistics -------------------------------------------------------------------------------------------
-- Determine which products are candidates for discontinuation by filtering for low sales, high stock, and low to moderate orders
-- Assigns a quartile range to a given product over 3 dimensions: 'totalStock', 'totalOrdered', and 'totalProfit'
-- Filtered for completed orders ('Shipped', 'Resolved', 'Disputed')
WITH products_distribution AS (
    SELECT
        productCode,
        productName,
        SUM(quantityOrdered) AS totalOrdered,
        SUM(priceEach * quantityOrdered) AS totalSales
    FROM products_view
    WHERE status IN ('Shipped', 'Resolved','Disputed')
    GROUP BY productCode, productName
),
products_stock AS (
	SELECT productCode, productName, quantityInStock AS totalStock
    FROM products
),
quartiles AS (
    SELECT
        ps.productCode,
		ps.productName,
		ps.totalStock,
		COALESCE(pd.totalOrdered, 0) AS totalOrdered,
		COALESCE(pd.totalSales, 0) AS totalSales,
        NTILE(4) OVER (ORDER BY ps.totalStock) AS quartileStock,
        NTILE(4) OVER (ORDER BY pd.totalOrdered) AS quartileOrdered,
        NTILE(4) OVER (ORDER BY pd.totalSales) AS quartileSales
    FROM products_distribution pd
    RIGHT JOIN products_stock ps ON pd.productCode = ps.productCode
    )
    SELECT * FROM quartiles WHERE quartileStock = 4 AND quartileOrdered <= 2 AND quartileSales = 1;
-- Five candidates for discontinuation: '1985 Toyota Supra', '1966 Shelby Cobra 427 S/C', '1982 Lamborghini Diablo', '1982 Ducati 996 R', and '1950's Chicago Surface Lines Streetcar'
-- Together they account for 41,495 items in stock, 3,499 ordered items, and $152,430.94 in sales
   
-- Determine which products are candidates for a stock increase by filtering for high profit, low stock, and moderate to high demand
-- Assigns a quartile range to a given product over 3 dimensions: 'totalStock', 'totalOrdered', and 'totalProfit'
-- Filtered for completed orders ('Shipped', 'Resolved', 'Disputed')
WITH products_distribution AS (
    SELECT
        productCode,
        productName,
        SUM(quantityOrdered) AS totalOrdered,
        SUM(priceEach * quantityOrdered) AS totalSales
    FROM products_view
    WHERE status IN ('Shipped', 'Resolved','Disputed')
    GROUP BY productCode, productName
),
products_stock AS (
	SELECT productCode, productName, quantityInStock AS totalStock
    FROM products
),
quartiles AS (
    SELECT
        ps.productCode,
		ps.productName,
		ps.totalStock,
		COALESCE(pd.totalOrdered, 0) AS totalOrdered,
		COALESCE(pd.totalSales, 0) AS totalSales,
        NTILE(4) OVER (ORDER BY ps.totalStock) AS quartileStock,
        NTILE(4) OVER (ORDER BY pd.totalOrdered) AS quartileOrdered,
        NTILE(4) OVER (ORDER BY pd.totalSales) AS quartileSales
    FROM products_distribution pd
    RIGHT JOIN products_stock ps ON pd.productCode = ps.productCode
    )
    SELECT * FROM quartiles WHERE quartileStock = 1 AND quartileOrdered >= 2 AND quartileSales = 4;
-- The '1968 Ford Mustang', '1962 Volkswagen Microbus', '1958 Setra Bus', '1969 Ford Falcon', and '1957 Corvette Convertible' are all candidates for a stock increase
-- Together they account for a total stock of 6,272, a total order quantity of 4,704, and a total profit of $654,280.34
    
-- Outlier Detection - Detect outliers for the products distribution over 3 different dimensions by calculating their interquartile ranges and establishing upper and lower bounds for each
-- Filtered for completed orders ('Shipped', 'Resolved', 'Disputed')

-- 1. Create table that calculates each products total orders and total sales for all completed orders

WITH products_ordered_sales AS (            
    SELECT
        productCode,
        productName,
        SUM(quantityOrdered) AS totalOrdered,
        SUM(priceEach * quantityOrdered) AS totalSales
    FROM products_view
    WHERE status IN ('Shipped', 'Resolved','Disputed')
    GROUP BY productCode, productName
),
-- 2. Create table that returns each products stock quantity regardless of order status
products_stock AS (
	SELECT productCode, productName, quantityInStock AS totalStock
    FROM products
),
-- 3. Join the previous 2 tables to include all products and impute potential null values for totalOrdered and totalSales with 0
products_distribution AS (
	SELECT ps.productCode, ps.productName,
		ps.totalStock, ROW_NUMBER() OVER (ORDER BY totalStock) AS indexStock,
		COALESCE(pos.totalOrdered, 0) AS totalOrdered, ROW_NUMBER() OVER (ORDER BY totalOrdered) AS indexOrdered,
		COALESCE(pos.totalSales, 0) AS totalSales, ROW_NUMBER() OVER (ORDER BY totalSales) AS indexSales
	FROM products_stock ps
	LEFT JOIN products_ordered_sales pos ON ps.productCode = pos.productCode
    GROUP BY ps.productCode, ps.productName
),
-- 4. Calculate statistics for each distribution: min, max, mean, q1, q2, q3, iqr
products_stats AS (
	SELECT
		MIN(totalStock) AS minStock, MAX(totalStock) AS maxStock,
		(SELECT totalStock FROM products_distribution WHERE indexStock = 28) AS Q1_Stock, (SELECT totalStock FROM products_distribution WHERE indexStock = 83) AS Q3_Stock,
		(SELECT totalStock FROM products_distribution WHERE indexStock = 83) - (SELECT totalStock FROM products_distribution WHERE indexStock = 28) AS IQR_Stock,
		MIN(totalOrdered) AS minOrdered, MAX(totalOrdered) AS maxOrdered,
		(SELECT totalOrdered FROM products_distribution WHERE indexOrdered = 28) AS Q1_Ordered, (SELECT totalOrdered FROM products_distribution WHERE indexOrdered = 83) AS Q3_Ordered,
		(SELECT totalOrdered FROM products_distribution WHERE indexOrdered = 83) - (SELECT totalOrdered FROM products_distribution WHERE indexOrdered = 28) AS IQR_Ordered,
		MIN(totalSales) AS minSales, MAX(totalSales) AS maxSales,
		(SELECT totalSales FROM products_distribution WHERE indexSales = 28) AS Q1_Sales, (SELECT totalSales FROM products_distribution WHERE indexSales = 83) AS Q3_Sales,
		(SELECT totalSales FROM products_distribution WHERE indexSales = 83) - (SELECT totalSales FROM products_distribution WHERE indexSales = 28) AS IQR_Sales
	FROM products_distribution
)
-- outliers AS (
	SELECT pd.productCode, pd.productName, pd.totalStock, pd.totalOrdered, pd.totalSales,
		(Q1_Stock - (1.5*IQR_Stock)) AS lowerStock,
        (Q3_Stock + (1.5*IQR_Stock)) AS upperStock,
        (Q1_Ordered - (1.5*IQR_Ordered)) AS lowerOrdered,
        (Q3_Ordered + (1.5*IQR_Ordered)) AS upperOrdered,
        (Q1_Sales - (1.5*IQR_Sales)) AS lowerSales,
        (Q3_Sales + (1.5*IQR_Sales)) AS upperSales
	FROM products_distribution pd
    CROSS JOIN products_stats ps 
    WHERE
		pd.totalStock < (Q1_Stock - (1.5*IQR_Stock)) OR pd.totalStock > (Q3_Stock + (1.5*IQR_Stock)) OR
        pd.totalOrdered < (Q1_Ordered - (1.5*IQR_Ordered)) OR pd.totalOrdered > (Q3_Ordered + (1.5*IQR_Ordered)) OR
		pd.totalSales < (Q1_Sales - (1.5*IQR_Sales)) OR pd.totalSales > (Q3_Sales + (1.5*IQR_Sales));
-- 4 outliers found:
-- S18_3232: '1985 Toyota Supra' - exceeds lower bound for total ordered items; (0 units)
-- S18_4933: '1957 Ford Thunderbird' - exceeds lower bound for total ordered items; (665 units)
-- S12_1108: '2001 Ferrari Enzo' - exceeds upper bound for total sales; ($182,439.52)
-- S18_3232: '1992 Ferrari 360 Spider red' - exceeds upper bound for total ordered items and upper bound for total sales; (1720 units and $264,132.78)
