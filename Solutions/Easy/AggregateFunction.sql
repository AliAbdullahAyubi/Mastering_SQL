--Aggregate Function
Use RetailDB;
Go

--Q66. Find the maximum UnitPrice among all products.
Select 
	Max(UnitPrice) As Max_UnitPrice
From Products;
--Q67. Find the minimum Salary among all employees.
Select 
	Min(Salary) As Min_Salary
From Employees;
--Q68. Calculate the average UnitPrice of all products.
Select
	Avg(UnitPrice) AS Avg_UnitPrice
From Products;
--Q69. Calculate the total (SUM) of all salaries.
Select
	Sum(Salary) AS Total_of_Salaries
From Employees;
--Q70. Count how many products are in CategoryID = 1.
Select 
	Count(ProductID) As Count_Product_in_CategoryID_equal_1
From Products
Where CategoryID = 1;

--Q71. Find the highest LoyaltyPoints among all customers.
Select
	Max(LoyaltyPoints) As Highest_LoyaltyPoints
From Customers;
--Q72. Find the average Salary grouped by DepartmentID.
Select
	DepartmentID,
	Avg(Salary) As DeptWise_Avg_Salary
From Employees
Group by DepartmentID;
--Q73. Count the number of orders per Status.
Select
	Status,
	Count(OrderID) AS StatusWise_Total_Orders
From Orders
Group by Status;
--Q74. Sum the StockQuantity by CategoryID.
Select
	CategoryID,
	Sum(StockQuantity) AS CategoryWise_Total_StockQuantity
From Products
Group by CategoryID;
--Q75. Find the minimum and maximum UnitPrice per category.
Select 
	CategoryID,
	Min(UnitPrice) As CategoryWise_Min_UnitPrice,
	Max(UnitPrice) AS CategoryWise_Max_UnitPrice
From Products
Group by CategoryID;
--Q76. Count how many customers joined each year.
Select 
	Year(JoinDate) AS Join_Year,
	Count(CustomerID) AS Count_New_Customers_Yearly
From Customers
Group by Year(JoinDate);

--Q77. Find the average rating per product using the Reviews table.
Select 
	ProductID,
	Avg(Rating) As ProductWise_Avg_Rating
From Reviews
Group by ProductID;
--Q78. Count orders per StoreID.
Select
	StoreID,
	Count(OrderID) As StoreWise_Count_of_Orders
From Orders
Group by StoreID;

--Q79. Sum the total Salary per JobTitle.
Select 
	JobTitle,
	Sum(Salary) As JobTitleWise_Sum_of_Salary
From Employees
Group by JobTitle;
--Q80. Find the maximum salary per department.
Select
	DepartmentID,
	Max(Salary) AS DeptWise_Max_Salary
From Employees
Group by DepartmentID;
--Q81. Count how many employees each manager supervises.
Select
	ManagerID,
	Count(EmployeeID) AS Count_of_Employee_Under_Each_Manager
From Employees
Group by ManagerID;
--Q82. Show CategoryID groups with more than 5 products (HAVING).
Select 
	CategoryID
From Products
Group by CategoryID
Having Count(ProductID) > 5;
--Q83. Show DepartmentIDs where the average salary > 50000.
Select
	DepartmentID
From Employees
Group by DepartmentID
Having Avg(Salary) > 50000;
--Q84. List StoreIDs with more than 100 orders.
Select
	StoreID
From Orders
Group by StoreID
Having Count(OrderID) > 100;
--Q85. Find job titles where the maximum salary exceeds 90000.
Select
	JobTitle
From Employees
Group by JobTitle
Having Max(Salary) > 90000;