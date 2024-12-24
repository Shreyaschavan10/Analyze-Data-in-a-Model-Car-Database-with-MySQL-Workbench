# **Analyzing Data in a Model Car Database with MySQL Workbench**

This project conducts a thorough analysis of the Mint Classics Company's database, focusing on inventory management, customer behavior, and sales results. The analysis is based on a relational database provided by the Coursera Project Network, which includes nine tables representing various aspects of the company's operations. The SQL queries and views created during the project provide insights to help Mint Classics optimize its operations and make sound business decisions.

## **Project Overview**
Mint Classics is a classic model car retailer considering the closure of one of its storage facilities while maintaining high levels of customer service. The analysis within this project explores sales trends, customer retention, and inventory management, providing actionable recommendations for improving efficiency and profitability.

### **Key Objectives:**
- Analyse product sales, inventory turnover, and warehouse utilization to determine which facility should close.
- Identify underperforming products that may be discontinued.
- Analyze customer purchasing behavior and recommend retention strategies.
- Evaluate sales representatives' performance across regions.



## **Dataset Overview**
The data used in this project consists of nine tables from the Mint Classics database, which models the company’s operations. The tables include:

1. Products: Contains product details, availability, and pricing.<br>
2. Warehouses: Stores information about Mint Classics’ storage facilities.<br>
3. Order Details: Tracks the specifics of each customer order.<br>
4. Orders: Contains details about customer orders, including dates and statuses.<br>
5. Payments: Records payment transactions made by customers.<br>
6. Customers: Stores customer contact and account information.<br>
7. Employees: Contains employee details, job titles, and relationships with customers.<br>
8. Offices: Holds information about Mint Classics' office locations.<br>
9. Product Lines: Group similar products into categories.<br>


## **Files and Folders**
The following files and folders are included in this project:

1. **Queries** <br>
This folder contains SQL queries used for exploratory data analysis (EDA) across various clusters of the Mint Classics database:

* Customers_Analysis.sql: SQL queries to analyze customer data.
* Employees_Analysis.sql: SQL queries to examine employee and managerial structures.
* Inter_Views_Anaysis.sql: SQL queries to analyze relationships across products, customers, and employees.
* Products_analysis.sql: SQL queries focusing on product performance, inventory, and sales.

2. **Views** <br>
This folder contains SQL scripts that create views combining data from multiple tables for in-depth analysis: <br>

    2.1 All_Views.sql <br>
* SQL script creating a view that links customer, order, and payment data.
* SQL script creating a view that analyzes employee roles, office locations, and customer management.
* SQL script creating a view that combines data from products, warehouses, and order details.


3. **mintclassicsmodel.mwb** <br>
A MySQL Workbench model file, which includes the database schema and an Extended Entity Relationship (EER) diagram.

5. **README.md** <br>
This file provides an overview of the project, the dataset, and the included files.

## **Key Findings**

* Warehouse Optimization: According to stock levels and inventory turnover, Warehouse D is the most likely candidate for closure, whilst Warehouse B is the most profitable and well-stocked.
* Product Management: Certain items, such as the 1985 Toyota Supra, have a large inventory but low sales and should be discontinued, whilst high-demand products, such as the 1968 Ford Mustang, should be prioritized for restocking.
* Customer Retention: Key customers, such as Euro+ Shopping Channel, should be retained, and there are prospects for growth in lagging regions like Tokyo and Sydney.
* Sales Representative Performance: While some reps, such as Gerard Hernandez and Leslie Jennings, thrive in generating revenue, others may need further training or reassignment to improve their performance.

