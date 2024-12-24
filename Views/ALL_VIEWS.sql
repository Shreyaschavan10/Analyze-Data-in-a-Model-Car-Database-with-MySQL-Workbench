-- Creates a view combining relevant data from a cluster of tables including: Customers, Employees, Orders, and Payments
-- This approach joins data to represent all customers across multiple dimensions to assess customer purchase behavior, sales rep performance, and time series and geographic analysis
CREATE OR REPLACE VIEW customers_view AS
WITH order_totals AS (
    SELECT o.orderNumber, o.customerNumber, SUM(od.quantityOrdered * od.priceEach) AS totalOrderAmount
    FROM orders o
    JOIN orderdetails od ON o.orderNumber = od.orderNumber
    GROUP BY o.orderNumber, o.customerNumber
),
aggregated_payments AS (
    SELECT p.customerNumber, SUM(p.amount) AS totalPayments, MAX(p.paymentDate) AS latestPaymentDate
    FROM payments p
    GROUP BY p.customerNumber
)
SELECT c.customerNumber, c.customerName, c.city, c.country, 
       c.creditLimit, c.salesRepEmployeeNumber, e.lastName, e.firstName, 
       ot.orderNumber, o.orderDate, o.shippedDate, o.status, 
       ap.latestPaymentDate, COALESCE(ap.totalPayments, 0) AS totalPayments,
       ot.totalOrderAmount
FROM customers c
LEFT JOIN employees e ON c.salesRepEmployeeNumber = e.employeeNumber
LEFT JOIN orders o ON c.customerNumber = o.customerNumber
LEFT JOIN order_totals ot ON o.orderNumber = ot.orderNumber
LEFT JOIN aggregated_payments ap ON c.customerNumber = ap.customerNumber
GROUP BY c.customerNumber, c.customerName, c.city, c.country, 
         c.salesRepEmployeeNumber, c.creditLimit, e.lastName, e.firstName, 
         ot.orderNumber, o.orderDate, o.shippedDate, o.status, 
         ap.latestPaymentDate, ot.totalOrderAmount;
         
         
        -- Creates a view combining relevant data from a cluster of tables including: Employees, Offices, and Customers
-- This approach allows for the aggregation of data across multiple dimensions for assessing geographic analysis, managerial structure, and customer management
-- This view captures data for all employees of the Mint Classics company and as such should contain null values for top-level executives or employees not currently managing customers
CREATE OR REPLACE VIEW employees_view AS
SELECT 
    e.employeeNumber,
    e.lastName,
    e.firstName,
    e.jobTitle,
    e.reportsTo,
    m.lastName AS managerLastName,
    m.firstName AS managerFirstName,
    o.officeCode,
    o.city AS officeCity,
    o.country AS officeCountry,
    c.customerNumber,
    c.customerName,
    c.city AS customerCity,
    c.country AS customerCountry
FROM 
    employees e
LEFT JOIN 
    employees m ON e.reportsTo = m.employeeNumber
INNER JOIN 
    offices o ON e.officeCode = o.officeCode
LEFT JOIN 
    customers c ON e.employeeNumber = c.salesRepEmployeeNumber; 
         
         
         -- Creates a view combining relevant data from a cluster of interelated tables including: Products, Order Details, Orders, and Warehouses
-- The query displays data for all products carried by the Mint Classics Company regardless of corresponding data from Order Details, Orders, or Warehouses
-- This approach allows for the aggregation of data across multiple dimensions for assessing product profitability and warehousing storage dynamics
         
         CREATE OR REPLACE VIEW products_view AS
SELECT p.productCode,
	   p.productName,
       p.productLine,
       p.quantityInStock,
       p.buyPrice,
       COALESCE(od.priceEach, 0) AS priceEach,
       COALESCE((od.priceEach - p.buyPrice), 0) AS profitPerItemOrder,
       COALESCE(od.quantityOrdered, 0) AS quantityOrdered,
       COALESCE(((od.priceEach - p.buyPrice) * od.quantityOrdered), 0) AS profitPerOrder,
       od.orderNumber,
       o.orderDate,
       o.shippedDate,
       o.status,
       w.warehouseCode, 
       w.warehouseName
FROM mintclassics.products p
LEFT JOIN mintclassics.orderdetails od ON p.productCode = od.productCode
LEFT JOIN mintclassics.orders o ON od.orderNumber = o.orderNumber
LEFT JOIN mintclassics.warehouses w ON p.warehouseCode = w.warehouseCode;
         
		
         
