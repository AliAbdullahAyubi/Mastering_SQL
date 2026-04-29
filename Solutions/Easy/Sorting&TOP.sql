--Sorting & Top
Use RetailDB;
Go

--Q86. List all products ordered by UnitPrice ascending.
Select *
From Products
Order by UnitPrice ASC;
--Q87. List all employees ordered by Salary descending.
Select *
From Employees
Order by Salary DESC;
--Q88. Show orders sorted by OrderDate descending.
Select *
From Orders
Order by OrderDate DESC;
--Q89. Display customers sorted by LastName, then FirstName.
Select *
From Customers
Order by LastName ASC, FirstName ASC;
--Q90. List products sorted by CategoryID ascending, then ProductName ascending.
Select *
From Products
Order by CategoryID ASC, ProductName ASC;
--Q91. Show employees sorted by HireDate ascending.
Select *
From Employees
Order by HireDate ASC;
--Q92. Display suppliers sorted by Rating descending.
Select *
From Suppliers
Order by Rating DESC;
--Q93. List orders sorted by Status ascending, then OrderDate descending.
Select *
From Orders
Order by Status ASC, OrderDate DESC;
--Q94. Show customers sorted by LoyaltyPoints descending.
Select *
From Customers
Order by LoyaltyPoints DESC;
--Q95. List reviews sorted by Rating descending, ReviewDate descending.
Select *
From Reviews
Order by Rating DESC, ReviewDate DESC;
