--Select & Basic Queries

Use RetailDB;
Go

--Q1. Select all columns from the Customers table.

Select *
From Customers;
--Q2. Select only the FirstName and LastName from Customers.
Select 
	FirstName,
	LastName
From Customers;
--Q3. Select all products from the Products table.
Select * 
From Products;
--Q4. Display the ProductName and UnitPrice of all products.
Select
	ProductName,
	UnitPrice
From Products;
--Q5. List all employees with their JobTitle.
Select 
	EmployeeID,
	FirstName,
	LastName,
	JobTitle
From Employees;
--Q6. Show all orders from the Orders table.
Select *
From Orders;
--Q7. Display the OrderID, OrderDate and Status of every order.
Select
	OrderID,
	OrderDate,
	Status
From Orders;
--Q8. Select all columns from the Stores table.
Select *
From Stores;
--Q9. Show all suppliers with their country.
Select 
	SupplierID,
	SupplierName,
	Country
From Suppliers;
--Q10. List all departments and their budgets.
Select *
From Departments;
--Q11. Select the Email and Phone of all customers.
Select
	Email,
	Phone
From Customers;
--Q12. Show the HireDate and Salary of all employees.
Select 
	HireDate,
	Salary
From Employees;
--Q13. Display all product categories.
Select *
From Categories;
--Q14. List all regions and countries.
Select *
From Regions;
--Q15. Show the first 10 rows from the Orders table.
Select Top 10 *
From Orders;

--Q16. Retrieve the top 5 most expensive products by UnitPrice.
Select Top 5 *
From Products
Order by UnitPrice Desc;
--Q17. Select the top 20 customers ordered by JoinDate.
Select Top 20 *
From Customers
Order by JoinDate;
--Q18. Display the top 10 orders by OrderDate descending.
Select Top 10 *
From Orders
Order by OrderDate DESC;
--Q19. Show the first 15 employees ordered alphabetically by LastName.
Select Top 15 *
From Employees
Order by LastName;
--Q20. Select the distinct countries from the Customers table.
Select 
	Distinct Country
From Customers;
--Q21. List all distinct job titles from the Employees table.
Select 
	Distinct JobTitle
From Employees;
--Q22. Show all distinct payment methods used in Orders.
Select 
	Distinct PaymentMethod
From Orders;
--Q23. Display distinct order statuses from the Orders table.
Select 
	Distinct Status
From Orders;
--Q24. List distinct customer tiers from the Customers table.
Select 
	Distinct CustomerTier
From Customers;
--Q25. Show all distinct store types from the Stores table.
Select 
	Distinct StoreType
From Stores;
--Q26. Count the total number of customers.
Select 
	Count(*) As Total_No_of_Customers
From Customers;
--Q27. Count how many products are in the Products table.
Select 
	Count(*) As Total_No_of_Products
From Products;
--Q28. Count all orders in the Orders table.
Select
	Count(*) AS Total_No_of_Orders
From Orders;
--Q29. Count distinct countries in the Suppliers table.
Select
	Count( Distinct Country) As Total_No_of_Distinct_Countries
From Suppliers;
--Q30. How many employees are stored in the database?
Select
	Count(*) As Total_No_of_Employees
From Employees;