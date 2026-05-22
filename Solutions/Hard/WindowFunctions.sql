-- Window Function
Use RetailDB;
Go

--Q277. Rank customers by total spending using RANK().
Select 
	o.CustomerID,
	SUM(od.UnitPrice * od.Quantity * (1 - od.Discount/100)) As Total_Spending_per_Customer,
	Rank() Over(Order by SUM(od.UnitPrice * od.Quantity * (1 - od.Discount/100)) Desc) As Rank_over_totalSpendings
From Orders As o
Inner Join OrderDetails As od On od.OrderID=o.OrderID
Group by o.CustomerID;

--Q278. Use DENSE_RANK() to rank products within each category by UnitPrice.
Select 
	p.CategoryID,
	p.ProductID,
	p.UnitPrice,
	DENSE_RANK() Over(Partition by p.CategoryID Order by p.UnitPrice Desc) As Dense_Rank_over_UnitPrice_per_Category
From Products As p;

--Q279. Calculate a running total of daily revenue using SUM() OVER (ORDER BY OrderDate).
Select 
	o.OrderDate,
	Sum(od.UnitPrice * od.Quantity) As Revenue_per_Day,
	Sum(Sum(od.UnitPrice * od.Quantity)) Over (Order by o.OrderDate Rows Between Unbounded Preceding And Current Row) AS Running_TotalRevenue_over_Days
From Orders As o Inner Join OrderDetails As od On od.OrderID=o.OrderID
Group by o.OrderDate;
--Q280. Find the top 3 selling products in each category using ROW_NUMBER().
Select 
	tmp1.* 
From
	(Select 
		p.CategoryID,
		p.ProductID, 
		Sum(od.Quantity) AS Quantity_of_Product_Sold,
		ROW_NUMBER() Over (Partition by p.CategoryID Order by Sum(od.Quantity) Desc) AS Row_Number_Over_ProductSold
	From Products AS p
	Inner Join OrderDetails As od On od.ProductID=p.ProductID
	Group by p.CategoryID,p.ProductID) As tmp1
Where Row_Number_Over_ProductSold<=3;

--Q281. Calculate each employee's salary percentile using PERCENT_RANK().
Select 
	e.EmployeeID,
	Round(PERCENT_RANK() OVER(Order by e.Salary ASc),4) As Percentile_over_Salary 
From Employees As e;
--Q282. Use LAG() to compare each month's revenue to the previous month.
Select 
	Year(o.OrderDate) AS CurrentYear,
	Month(o.OrderDate) As CurrentMonth,
	Sum(od.UnitPrice * od.Quantity) As Revenue_per_CurrentMonth,
	LAG(Sum(od.UnitPrice * od.Quantity)) Over (Order by Year(o.OrderDAte),Month(o.OrderDate) Asc) As Revenue_per_PreviosMonth
From Orders AS o
Inner Join OrderDetails As od On od.OrderID=o.OrderID
Group by Year(o.OrderDate),Month(o.OrderDate);
--Q283. Use LEAD() to show the next order date for each customer.
Select 
	o.CustomerID,
	o.OrderDate As First_OrderDate,
	Lead(o.OrderDate) Over (Partition by o.CustomerID Order by o.OrderDate Asc) As Second_OrderDate
From Orders As o
Order by o.CustomerID;
--Q284. Calculate a 3-month moving average of sales revenue.
Select 
	Year(o.OrderDate) AS Year,
	Month(o.OrderDate) As Month,
	Sum(od.UnitPrice * od.Quantity) As Revenue_per_Month,
	Avg(Sum(od.UnitPrice * od.Quantity)) Over (Order by Year(o.OrderDate),Month(o.OrderDate) Rows Between 2 Preceding And Current Row) As Moving_Avg_over_3Month_Revenue
From Orders As o
Inner Join OrderDetails As od On od.OrderID=o.OrderID
Group by Year(o.OrderDate),Month(o.OrderDate);
--Q285. Find the first and last order date per customer using FIRST_VALUE() and LAST_VALUE().
Select Distinct
	o.CustomerID,
	FIRST_VALUE(o.OrderDate) Over (Partition by o.CustomerID Order by o.OrderDate ASC) AS FirstOrder_per_Customer,
	LAST_VALUE(o.OrderDate) Over(Partition by o.CustomerID Order by o.OrderDate ASC Rows Between Unbounded Preceding And Unbounded Following) AS LastOrder_per_Customer
From Orders AS o;
--Q286. Assign quartiles to employees by salary using NTILE(4).
Select 
	e.Salary,
	NTILE(4) Over(Order by e.Salary) As Quartile_over_Salary
From Employees As e;
--Q287. Calculate cumulative sales per store over time using SUM() OVER (PARTITION BY StoreID ORDER BYOrderDate).
Select 
	o.StoreID,
	o.OrderDate,
	Sum(od.UnitPrice * od.Quantity) AS Total_Sale_per_Store,
	Sum(Sum(od.UnitPrice * od.Quantity)) Over (Partition by o.StoreID Order by o.OrderDate) As Cummulative_Sales_over_Store
From Orders As o
Inner Join OrderDetails As od On od.OrderID=o.OrderID
Group by o.StoreID,o.OrderDate;
--Q288. Show each order's rank within its store by order value.
Select 
	o.StoreID,
	o.OrderID,
	(Sum(od.UnitPrice * od.Quantity) - Sum(od.Discount)) As OrderValue_per_Store,
	Rank() Over (Partition by o.StoreID Order by (Sum(od.UnitPrice * od.Quantity) - Sum(od.Discount)) ASC) AS Rank_over_OrderValue
From Orders As o
Inner Join OrderDetails As od On od.OrderID=o.OrderID
Group by o.StoreID,o.OrderID;
--Q289. Calculate the difference between each product's price and the category average using AVG() OVER(PARTITION BY CategoryID).
Select 
	p.CategoryID,
	p.ProductID,
	p.UnitPrice,
	AVG(p.UnitPrice) Over (Partition by p.CategoryID) Avg_Category_Price,
	Round((p.UnitPrice - Avg(p.UnitPrice) Over(Partition by p.CategoryID)),4) As Diff_btw_UnitPrice_Avg_CategoryPrice
From Products As p;
--Q290. Use ROW_NUMBER() to de-duplicate customers with duplicate emails (keep the earliest).
SELECT CustomerID, Email, JoinDate
FROM (
    SELECT
        c.CustomerID,
        c.Email,
        c.JoinDate,
        ROW_NUMBER() OVER (
            PARTITION BY c.Email 
            ORDER BY c.JoinDate ASC
        ) AS rn
    FROM Customers AS c
) AS tmp
WHERE rn = 1;
--Q291. Show running count of orders per customer over time.
Select 
	o.CustomerID,
	o.OrderDate,
	Count(o.OrderID) As Total_Order_per_Customer,
	Sum(Count(o.OrderID)) Over(Partition by o.CustomerID Order by o.OrderDate Asc Rows Between Unbounded Preceding And Current Row) AS Running_Count_Order_per_Customer
From Orders AS o
Group by o.CustomerID,o.OrderDate;
--Q292. Find months where revenue dropped compared to the previous month using LAG().
Select 
	tmp1.*
From
	(Select 
		Month(o.OrderDate) As Month,
		Sum(od.UnitPrice * od.Quantity) As Revenue_CurrentMonth,
		LAG(Sum(od.UnitPrice * od.Quantity),1,Sum(od.UnitPrice * od.Quantity)) Over (Order by Month(o.OrderDate) ASC) As Revenue_PreviousMonth
	From Orders As o
	Inner Join OrderDetails As od On od.OrderID=o.OrderID
	Group by Month(o.OrderDate)) As tmp1
Where tmp1.Revenue_CurrentMonth < tmp1.Revenue_PreviousMonth;
--Q293. Calculate each employee's salary as a percentage of the department total.
Select 
	e.DepartmentID,
	e.EmployeeID,
	e.Salary,
	Round((e.Salary/Sum(e.Salary) Over (Partition by e.DepartmentID) * 100),4) AS Percentage_Salary_of_Employee_over_Department
From Employees AS e;
--Q294. Use NTILE(10) to bucket customers into deciles by total spending.
Select 
	o.CustomerID,
	(Sum(od.UnitPrice * od.Quantity) - Sum(od.Discount)) As Total_Spending_per_Customer,
	NTILE(10) Over (Order by (Sum(od.UnitPrice * od.Quantity) - Sum(od.Discount)) DESC) AS Bucket_Customer_Decline_over_Spending
From Orders As o
Inner Join OrderDetails As od On od.OrderID=o.OrderID
Group by o.CustomerID;
--Q295. Compute a 7-day rolling average of daily order counts.
Select 
	Cast(o.OrderDAte AS Date) As Day,
	Count(o.OrderID) AS Count_Daily_Orders,
	Avg(Count(o.OrderID)) Over (Order by CAST(o.OrderDate AS DATE) Asc Rows Between 6 Preceding And Current Row) AS Avg_Daily_Orders
From Orders AS o
Group by Cast(o.OrderDAte AS DATE);
--Q296. Use CUME_DIST() to find the cumulative distribution of product prices.
Select 
	p.ProductID,
	p.UnitPrice, 
	CUME_DIST() Over(Order by p.UnitPrice Desc) As Cummulative_Distribution_over_UnitPrice
From Products AS p;