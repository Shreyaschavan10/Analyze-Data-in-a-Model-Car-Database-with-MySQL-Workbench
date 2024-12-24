-------------------------------------------------------------------- Exploratory Data Analysis for Employees_view----------------------------------------------------------------------------------
----------------- The Employees_view contains data pertaining to all employees of the Mint Classics Company joining rows across the Employees, Offices, and Customers tables ------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------- Employee Statistics ------------------------------------------------------------------------------------------
-- How many people work at Mint Classics
SELECT COUNT(employeeNumber) AS totalEmployees FROM employees_view; -- Mint Classics employs a total of 108 employees

-- Count of Employees by Job Title
SELECT jobTitle, COUNT(employeeNumber) AS totalEmployees
FROM employees_view
GROUP BY jobTitle
ORDER BY totalEmployees DESC;
-- Of the 108 employees at Mint Classics most (102) are Sales Reps 

-- List of Employees with No Assigned Customers
SELECT employeeNumber, lastName, firstName, jobTitle
FROM employees_view
WHERE customerNumber IS NULL;
-- 6 out of the 8 returned employees occupy upper-management positions including the President, VP of Sales, VP of Marketing, and sales managers three major regions: (APAC), (NA), and (EMEA)
-- Sales Reps Tom King and Yoshimi Kato are currently not handling any customers

-------------------------------------------------------------------------------- Geographic Analysis ------------------------------------------------------------------------------------------------
-- Employees Without Assigned Offices
SELECT employeeNumber, lastName, firstName
FROM employees_view
WHERE officeCode IS NULL;
-- Empty Set: All employees of the Mint Classics Company are currently assigned to an office location

-- Employees by Country
SELECT officeCountry, COUNT(employeeNumber) AS totalEmployees
FROM employees_view
GROUP BY officeCountry
ORDER BY totalEmployees DESC;
-- Japan has the fewest employees at 6 while the U.S. has the most at 43

-- Customers Managed by Office Location
SELECT officeCity, officeCountry, COUNT(DISTINCT customerNumber) AS totalCustomers
FROM employees_view
WHERE customerNumber IS NOT NULL
GROUP BY officeCity, officeCountry
ORDER BY totalCustomers DESC;
-- At 29 customers Paris represents a key market for business
-- With 3 major city locations the U.S. boasts a strong presence managing a total of 39 customers
-- However, the Sydney and Tokyo markets may present opportunities for growth having relatively lower customer counts (10 and 5, respectively)

----------------------------------------------------------------------------------- Managerial Structure --------------------------------------------------------------------------------------------
-- Rank manager by the number of most direct reports
SELECT 
    m.employeeNumber AS managerID,
    m.lastName AS managerLastName,
    m.firstName AS managerFirstName,
    m.jobTitle AS managerJobTitle,
    COUNT(e.employeeNumber) AS totalReports
FROM 
    employees_view e
JOIN 
    employees_view m ON e.reportsTo = m.employeeNumber
GROUP BY 
    m.employeeNumber, m.lastName, m.firstName, m.jobTitle
ORDER BY 
    totalReports DESC;
-- Gerard Bondur 'Sales Manager (EMEA)' is responsible for the most employees with a total of 46

-- Count of Customers Managed by Each Employee
SELECT employeeNumber, lastName, firstName, jobTitle, COUNT(DISTINCT customerNumber) AS totalCustomers
FROM employees_view
GROUP BY employeeNumber, lastName, firstName
ORDER BY totalCustomers DESC;
-- Sales Rep Pamela Castillo manages the most customers at 10
-- Of Sales Reps that manage customers Andy Fixter, Peter Marsh, and Mami Nishi all handle the least at 5