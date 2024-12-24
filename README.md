Analyzing Data in a Model Car Database with MySQL Workbench <br>
This project provides an in-depth analysis of the Mint Classics Company's database, focusing on inventory management, customer behavior, and sales performance. The analysis is built upon a relational database provided by the Coursera Project Network, containing nine tables that represent various aspects of the company's operations. The SQL queries and views created during the project offer insights to help Mint Classics optimize its operations and make informed business decisions.

Project Overview
Mint Classics is a classic model car retailer considering the closure of one of its storage facilities while maintaining high levels of customer service. The analysis within this project explores sales trends, customer retention, and inventory management, providing actionable recommendations for improving efficiency and profitability.

Key Objectives:
Analyze product sales, inventory turnover, and warehouse utilization to recommend which facility to close.
Identify underperforming products that could be discontinued.
Examine customer purchasing behavior and suggest retention strategies.
Evaluate the performance of sales representatives across regions.
Dataset Overview
The data used in this project consists of nine tables from the Mint Classics database, which models the company’s operations. The tables include:

Products: Contains product details, availability, and pricing.
Warehouses: Stores information about Mint Classics’ storage facilities.
Order Details: Tracks the specifics of each customer order.
Orders: Contains details about customer orders, including dates and statuses.
Payments: Records payment transactions made by customers.
Customers: Stores customer contact and account information.
Employees: Contains employee details, job titles, and relationships with customers.
Offices: Holds information about Mint Classics' office locations.
Product Lines: Groups similar products into categories.
Files and Folders
The following files and folders are included in this project:

1. cluster-queries
This folder contains SQL queries used for exploratory data analysis (EDA) across various clusters of the Mint Classics database:

EDA_customers_cluster.sql: SQL queries to analyze customer data.
EDA_employees_cluster.sql: SQL queries to examine employee and managerial structures.
EDA_inter_cluster.sql: SQL queries to analyze relationships across products, customers, and employees.
EDA_products_cluster.sql: SQL queries focusing on product performance, inventory, and sales.
2. cluster-views
This folder contains SQL scripts that create views combining data from multiple tables for in-depth analysis:

customers_cluster_view.sql: SQL script creating a view that links customer, order, and payment data.
employees_cluster_view.sql: SQL script creating a view that analyzes employee roles, office locations, and customer management.
products_cluster_view.sql: SQL script creating a view that combines data from products, warehouses, and order details.
3. Analyzing Data in a Model Car Database with MySQL Workbench.pdf
This is the comprehensive report that summarizes the findings from the analysis, including recommendations for warehouse closure, inventory management, and customer retention.

4. mintclassicsmodel.mwb
A MySQL Workbench model file, which includes the database schema and an Extended Entity Relationship (EER) diagram.

5. README.md
This file provides an overview of the project, the dataset, and the included files.

Key Findings
Warehouse Optimization: Based on stock levels and inventory turnover, Warehouse D is the most likely candidate for closure, while Warehouse B is the most profitable and stocked.
Product Management: Certain products, like the 1985 Toyota Supra, have high stock but low sales and should be discontinued, while high-demand products such as the 1968 Ford Mustang should be prioritized for restocking.
Customer Retention: Key customers, such as Euro+ Shopping Channel, should be targeted for retention, and opportunities for expansion exist in underperforming regions like Tokyo and Sydney.
Sales Representative Performance: Sales reps like Gerard Hernandez and Leslie Jennings excel in revenue generation, while some other reps may require additional training or reassignment to improve performance.
