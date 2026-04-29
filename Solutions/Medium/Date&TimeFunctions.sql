-- Date & Time Functions
Use RetailDB;
Go

--Q171. Calculate each employee's tenure in years from HireDate to today.
Select *,
	(Year(GetDate())- Year(e.HireDate)) As Tenure_in_Years 
From Employees  As e;
--Q172. Show orders placed in the last 30 days.
Select * From Orders As o
Where DateDiff(DaY,o.OrderDate,GetDate()) <=30;
--Q173. Extract the month and year from OrderDate.
Select *,
	Month(o.OrderDate) As Month,
	Year(o.OrderDate) As Year
From Orders As o;
--Q174. Find employees hired in the first quarter (Jan-Mar) of any year.
Select *
From Employees As e
Where DateName(Month,e.HireDate) In ('January','Feburary','March');
--Q175. Show customers who joined in the last 6 months.
Select *
From Customers As c
Where DATEDIFF(Month,c.JoinDate,GetDate()) <=6;
--Q176. Calculate the days between OrderDate and ShippedDate for each order.
Select *,
	DateDiff(Day,o.OrderDate,o.ShippedDate) As Days_btw_OrderDate_ShippedDate
From Orders As o;
--Q177. Find orders that took more than 7 days to ship.
Select *
From Orders As o
Where DateDiff(Day,o.OrderDate,o.ShippedDate) > 7;
--Q178. Show the day of week for each order date.
Select *,
	DateName(DW,o.OrderDate) As Day_of_Week
From Orders As o;
--Q179. Find customers whose birthday is this month.
Select *
From Customers As c
Where (Month(GetDate())-Month(c.BirthDate)) = 0;
--Q180. Calculate the age of each customer based on BirthDate.
Select *,
	DATEDIFF(Year,c.BirthDate,GetDate())-
	Case
		When (Month(c.BirthDate) > Month(GetDate())) Or ((Month(c.BirthDate) = Month(GetDate())) AND (Day(c.BirthDate)>Day(GetDAte())))
		Then 1 Else 0 
	End As Age
From Customers As c;
--Q181. Show orders placed on weekends.
Select *
From Orders As o
Where DateName(DW,o.OrderDate) In ('Saturday','Sunday');
--Q182. Find products added (via first order) more than 2 years ago.
SELECT 
    p.*,
    MIN(o.OrderDate) AS First_Order_Date
FROM Products AS p
INNER JOIN OrderDetails AS od ON od.ProductID = p.ProductID
INNER JOIN Orders AS o ON o.OrderID = od.OrderID
GROUP BY 
    p.ProductID, p.ProductName, p.CategoryID, p.SupplierID,
    p.UnitPrice, p.CostPrice, p.StockQuantity, p.ReorderLevel,
    p.Discontinued, p.ProductCode, p.Weight, p.Description
HAVING MIN(o.OrderDate) < DATEADD(Year, -2, GETDATE());
--Q183. Show the most recent order date per customer.
Select 
	CustomerID,
	MAx(o.OrderDate) AS Recent_OrderDate
From Orders As o
Group by CustomerID;
--Q184. Calculate how long each promotion ran in days.
Select *,
	DATEDIFF(Day,p.StartDate,p.EndDate) AS Days_of_Promotion
From Promotions As p;
--Q185. Find all orders where ShippedDate was after the RequiredDate.
Select *
From Orders AS o
Where o.ShippedDate > o.RequiredDate;
