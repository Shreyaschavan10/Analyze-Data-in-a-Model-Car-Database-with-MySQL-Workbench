----------------------------------------------------------------------- Inter-department Exploratory Data Analysis ---------------------------------------------------------------------------------------
----------------------------------------------- This script explores relationships across all 3 departments: Products, Customers, and Employees ----------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Top Sales Reps by Product Revenue (similar but distinct from 'Total Payments by Sales Rep' found in the 3rd section of EDA_customers_cluster)
-- Filtered for completed orders ('Shipped', Resolved','Disputed')
SELECT c.salesRepEmployeeNumber, c.firstName, c.lastName, SUM(p.quantityOrdered * p.priceEach) AS totalRevenue
FROM customers_view c
JOIN products_view p ON c.orderNumber = p.orderNumber
WHERE c.status IN ('Shipped', 'Resolved','Disputed')
GROUP BY c.salesRepEmployeeNumber, c.firstName, c.lastName
ORDER BY totalRevenue DESC;
-- The distribution of total revenue closely resembles that of total payments; however this query reflects a Rep's completed sales and not received payments
-- Again, Gerard Hernandez ($1,140,578.71) and Leslie Jennings ($1,021,661.89) are in the lead, while Marting Gerard, Julie Firreli, and Leslie Thompson sold the least ($1,121,673.7) combined

-- Warehouse Utilization by Region: Filtered for completed orders ('Shipped', Resolved','Disputed')
SELECT p.warehouseCode, p.warehouseName, 
       COUNT(DISTINCT c.customerNumber) AS totalCustomers, 
       SUM(p.quantityOrdered) AS totalProductsShipped
FROM products_view p
JOIN customers_view c ON p.orderNumber = c.orderNumber
WHERE p.status IN ('Shipped','Resolved','Disputed')
GROUP BY p.warehouseCode, p.warehouseName
ORDER BY totalProductsShipped DESC;
-- Warehouse 'B' has the most customers '94' and has shipped the most products '33817'
-- Insights from the 'EDA_products_cluster' analysis reveal that it's also the most stocked and most profitable Mint Classics warehouse


-- Product Popularity by Sales Region: Filtered for completed orders ('Shipped', Resolved','Disputed')
SELECT e.officeCity, e.officeCountry, p.productLine, 
       COUNT(DISTINCT p.orderNumber) AS totalOrders, 
       SUM(p.quantityOrdered) AS totalProductsOrdered
FROM employees_view e
JOIN customers_view c ON e.employeeNumber = c.salesRepEmployeeNumber
JOIN products_view p ON c.orderNumber = p.orderNumber
WHERE c.status IN ('Shipped', 'Resolved','Disputed')
GROUP BY e.officeCity, e.officeCountry, p.productLine
ORDER BY totalProductsOrdered DESC;
-- Both the Classic and Vintage product lines are popular in the Paris, France region; occupying the top 2 spots for most products ordered and total completed orders

-- Customer Retention by Product Line: Customers having ordered items from a distinct product line more than once
-- Filtered for completed orders ('Shipped', Resolved','Disputed')
WITH repeatCustomers AS (
    SELECT c.customerNumber, p.productLine, COUNT(DISTINCT p.orderNumber) AS orderCount
    FROM customers_view c
    JOIN products_view p ON c.orderNumber = p.orderNumber
    WHERE c.status IN ('Shipped', 'Resolved','Disputed')
    GROUP BY c.customerNumber, p.productLine
    HAVING COUNT(DISTINCT p.orderNumber) > 1
)
SELECT productLine, COUNT(DISTINCT customerNumber) AS repeatCustomerCount
FROM repeatCustomers
GROUP BY productLine
ORDER BY repeatCustomerCount DESC;
-- 'Classic Cars' and 'Vintage Cars' have the highest retention with 57 and 51 repeat customers
-- This result continues a trend of several queries establishing these two product lines as the most popular and profitable
-- 'Trains', however, has the lowest repeat customer count at 4

 --  Analysis of Non-Completed and Disputed orders
SELECT 
	o.customerNumber,
    c.customerName,
    o.orderNumber,
    o.status,
    o.comments,
    c.creditLimit,
    NTILE(4) OVER (ORDER BY creditLimit) AS quartileCredit,
    c.totalPayments
 FROM orders o
 JOIN customers_view c ON o.customerNumber = c.customerNumber
 WHERE o.status NOT IN ('Shipped', 'Resolved')
GROUP BY o.orderNumber;
-- Orders were cancelled for various reasons including: 'Order was mistakenly placed', '..customer found a better offer...', or 'Customer heard complaints from their customers...'
-- Orders were disputed over claims of damage or that products didn't meet customer expectations
-- All orders placed on hold were due to customer having exceeded their credit limit; all of whom had a low credit rating

-- Sales Rep Performance by Customer Retention: Includes orders of all statuses
SELECT e.employeeNumber, e.firstName, e.lastName, 
       COUNT(DISTINCT o.orderNumber) AS totalOrders, 
       COUNT(DISTINCT c.customerNumber) AS retainedCustomers
FROM employees_view e
JOIN customers_view c ON e.employeeNumber = c.salesRepEmployeeNumber
JOIN orders o ON c.customerNumber = o.customerNumber
GROUP BY e.employeeNumber, e.firstName, e.lastName
ORDER BY retainedCustomers DESC;
-- Pamela Castillo has retained the most customer (10) with an order count of 31
-- Martin Gerard has retained the least customers (5) with and order count of 12
-- While having only retained 7 customers, Gerard Hernandez has the most orders with 43