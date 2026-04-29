--Aggregation & Grouping
Use RetailDB;
Go

--Q121. Find the total revenue per store (SUM of Quantity * UnitPrice in OrderDetails).
Select
	o.StoreID,
	Sum(od.Quantity*od.UnitPrice) As Revenue_per_Store 
From OrderDetails As od
Inner Join Orders As o On o.OrderID=od.OrderID
Group by o.StoreID;
--Q122. Calculate the total revenue per customer.
Select 
	o.CustomerID,
	Sum(od.Quantity*od.UnitPrice) As Revenue_per_Customer
From OrderDetails As od
Inner Join Orders As o On o.OrderID=od.OrderID
Group by o.CustomerID;
--Q123. Show the top 10 best-selling products by total units sold.
Select p.* From Products As p
Inner Join(Select Top 10 With Ties
	od.ProductID,
	Sum(od.Quantity) AS Total_Unit_Sold_per_Product 
From OrderDetails AS od
Inner Join Products AS p On p.ProductID=od.ProductID
Group by od.ProductID
Order by Total_Unit_Sold_per_Product) AS Top_10_ProductID On Top_10_ProductID.ProductID=p.ProductID;
--Q124. Find the average order value per customer (Total Revenue / Total Customers).
Select (Total_Revenue/Total_Customers) As Avg_Order_Value_per_Customer
From(Select	
	Count(Distinct o.CustomerID) AS Total_Customers,
	Sum(od.Quantity*od.UnitPrice) AS Total_Revenue
From OrderDetails AS od
Inner Join Orders AS o On o.OrderID=od.OrderID) As TotalRevenue_TotalCustomers;
--Q125. Calculate total revenue by year.
Select 
	Year(o.RequiredDate) AS Year, 
	Sum(Total_Revenue_per_Order) As Total_Revenue_per_Year
From Orders As o
Inner Join(Select 
	od.OrderID,
	Sum(od.Quantity*od.UnitPrice) As Total_Revenue_per_Order
From OrderDetails As od
Group by od.OrderID) As OrderWise_Revenue On OrderWise_Revenue.OrderID=o.OrderID
Group by Year(o.RequiredDate);
--Q126. Show monthly sales totals for the year 2023.
Select 
	Month(o.RequiredDate) As Month,
	Sum(Sales_per_Order) As Total_Sales
From Orders As o
Inner Join(Select 
	od.OrderID,
	Sum(od.Quantity*od.UnitPrice) As Sales_per_Order
From OrderDetails As od
Group by od.OrderID) As OrderWise_Sales On OrderWise_Sales.OrderID = o.OrderID
Where Year(o.RequiredDate) = 2023
Group by Month(o.RequiredDate);

--Q127. Find the total revenue by product category.
Select 
	c.CategoryID,
	Sum(od.Quantity * od.UnitPrice) As Total_Revenue_per_Category
From OrderDetails AS od
Inner Join Products As p On p.ProductID=od.ProductID
Inner Join Categories As c On c.CategoryID=p.CategoryID
Group by c.CategoryID;
--Q128. Calculate the profit margin per product ((UnitPrice - CostPrice) / UnitPrice * 100).
Select 
	od.ProductID,
	Sum((od.UnitPrice - p.CostPrice)/od.UnitPrice*100) As Profit_Margin_per_Product
From OrderDetails As od
Inner Join Products As p On p.ProductID=od.ProductID
Group by od.ProductID;
--Q129. Show total orders per month per store.
Select 
	s.StoreID,
	Month(o.OrderDate) As Month,
	Count(o.OrderID) AS Total_Orders
From Orders AS o
Inner Join Stores As s On s.StoreID=o.StoreID
Group by Month(o.OrderDate), s.StoreID;
--Q130. Find employees with the highest total sales revenue.
Select Top 1 With Ties
	o.EmployeeID,
	Sum(od.Quantity*od.UnitPrice) As Total_Sales_per_Employee
From OrderDetails As od
Inner Join Orders As o On o.OrderID=od.OrderID
Group by o.EmployeeID
Order by Total_Sales_per_Employee DESC;
--Q131. Calculate the average discount given per order.
Select 
	od.OrderID,
	Avg(od.Discount) As Avg_Discount_per_Order
From OrderDetails As od
Group by od.OrderID;
--Q132. Show the count and total revenue of orders per payment method.
Select 
	o.PaymentMethod,
	Count(od.OrderID) AS Count_Orders_per_PaymentMethod,
	Sum(od.Quantity * od.UnitPrice) As Total_Revenue_per_PaymentMethod
From OrderDetails As od
Inner Join Orders As o On o.OrderID=od.OrderID
Group by o.PaymentMethod;
--Q133. Find the most popular product category by units sold.
Select Top 1 With Ties
	c.CategoryID,
	Count(od.Quantity) As Total_Unit_Sold_per_Category
From OrderDetails AS od
Inner Join Products As p On p.ProductID=od.ProductID
Inner Join Categories As c On c.CategoryID=p.CategoryID
Group by c.CategoryID
Order by Total_Unit_Sold_per_Category DESC;

--Q134. Show total loyalty points earned per customer tier.
Select 
	c.CustomerTier,
	Sum(c.LoyaltyPoints) AS Total_LoyaltyPoints_per_CustomerTier
From Customers As c
Group by c.CustomerTier;
--Q135. Calculate the average salary per store.
Select 
	e.StoreID,
	Avg(e.Salary) AS Avg_Salary_per_Store
From Employees As e
Group by e.StoreID;
--Q136. Find departments where average salary exceeds the company-wide average.
Select 
	e.DepartmentID,
	Avg(e.Salary) AS Avg_Salary_per_Dept
From Employees As e
Group by e.DepartmentID
Having Avg(e.Salary) > (Select Avg(Salary) From Employees);
--Q137. Show stores with revenue above the average store revenue.
Select
	o.StoreID,
	Sum(od.Quantity*od.UnitPrice) AS Revenue_per_Store
From OrderDetails As od
Inner Join Orders As o On o.OrderID=od.OrderID
Group by o.StoreID
Having Sum(od.Quantity*od.UnitPrice) > (Select 
	--StoreWise_Revenue.StoreID,
	Avg(Revenue_per_Store) As Avg_Store_Revenue
From(Select 
	o.StoreID,
	Sum(od.Quantity*od.UnitPrice) As Revenue_per_Store
From OrderDetails As od
Inner Join Orders As o On o.OrderID=od.OrderID
Group by o.StoreID) AS StoreWise_Revenue);
--Q138. List customers whose total spending exceeds $5000.
Select 
	o.CustomerID,
	Sum(od.Quantity*od.UnitPrice* (1 - od.Discount/100)) As total_Spending
From OrderDetails As od
Inner Join Orders As o On o.OrderID=od.OrderID
Group by CustomerID
Having Sum(od.Quantity*od.UnitPrice* (1 - od.Discount/100)) > 5000;
--Q139. Find products where total revenue > $10,000.
Select 
	od.ProductID,
	Sum(od.Quantity*od.UnitPrice) AS Total_Revenue_per_Product
From OrderDetails As od
Group by od.ProductID
Having Sum(od.Quantity*od.UnitPrice)> 10000;
--Q140. Calculate year-over-year revenue growth.
Select
	Second_YearWise.Year,
	First_YearWise.Total_Revenue_per_Year,
	Second_YearWise.Total_Revenue_per_Year,
	((Second_YearWise.Total_Revenue_per_Year-First_YearWise.Total_Revenue_per_Year)/First_YearWise.Total_Revenue_per_Year*100) As Year_over_Year_Growth
From
(Select 
	Year(o.RequiredDate) As Year,
	Sum(od.Quantity*od.UnitPrice) As Total_Revenue_per_Year
From OrderDetails As od
Inner Join Orders As o On o.OrderID=od.OrderID
Group by Year(o.RequiredDate)) As First_YearWise
Inner Join
(Select 
	Year(o.RequiredDate) As Year,
	Sum(od.Quantity*od.UnitPrice) As Total_Revenue_per_Year
From OrderDetails As od
Inner Join Orders As o On o.OrderID=od.OrderID
Group by Year(o.RequiredDate)) As Second_YearWise On (Second_YearWise.Year-First_YearWise.Year)=1
Order by First_YearWise.Year;


