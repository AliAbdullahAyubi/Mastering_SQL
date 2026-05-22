-- Common Table Expression (CTEs)
Use RetailDB;
Go

--Q297. Use a CTE to find the top 5 customers by lifetime value.
With CTE_CustomerList AS
(
Select Top 5 With Ties
	o.CustomerID,
	SUM(od.UnitPrice * od.Quantity * (1 - od.Discount/100)) AS Life_time_value 
From Orders AS o
Inner Join OrderDetails As od On od.OrderID=o.OrderID
Group by o.CustomerID
Order by Life_time_value Desc
)
Select *
From CTE_CustomerList;
--Q298. Write a recursive CTE to display the full employee reporting hierarchy.
With CTE_EmployeeHierarchy AS
(
Select 
	1 As Level,
	e1.EmployeeID,
	e1.FirstName,
	e1.LastName,
	e1.ManagerID 
From Employees As e1
Where e1.ManagerID IS NULL
Union All
Select 
	eh.Level+1,
	e2.EmployeeID,
	e2.FirstName,
	e2.LastName,
	e2.ManagerID 
From Employees AS e2
Inner Join CTE_EmployeeHierarchy As eh On eh.EmployeeID = e2.ManagerID)
Select * From CTE_EmployeeHierarchy;
--Q299. Use a CTE to calculate monthly revenue then compare to the annual average.
WITH CTE_MonthlyRevenue AS (
    SELECT
        Year(o.OrderDate)  AS Year,
        Month(o.OrderDate) AS Month,
        SUM(od.UnitPrice * od.Quantity) AS Revenue_per_Month
    FROM Orders AS o
    INNER JOIN OrderDetails AS od ON od.OrderID = o.OrderID
    GROUP BY Year(o.OrderDate), Month(o.OrderDate)
)
, CTE_AnnualAverage AS (
    SELECT Year, AVG(Revenue_per_Month) AS Avg_Annual_Monthly_Revenue
    FROM CTE_MonthlyRevenue
    GROUP BY Year
)
SELECT
    mr.*,
    aa.Avg_Annual_Monthly_Revenue,
    CASE
        WHEN mr.Revenue_per_Month >= aa.Avg_Annual_Monthly_Revenue
        THEN 'Above Average'
        ELSE 'Below Average'
    END AS Comparison
FROM CTE_MonthlyRevenue AS mr
INNER JOIN CTE_AnnualAverage AS aa ON aa.Year = mr.Year
ORDER BY mr.Year, mr.Month;
--Q300. Create a CTE that finds products never ordered and another that finds slow movers, then UNION them.
With CTE_ProductNeverOrdered As
(Select p.ProductID From Products AS p Left Join OrderDetails As od On od.ProductID=p.ProductID where od.OrderID is NULL)
, CTE_TotalSold AS
(Select od.ProductID,Sum(od.Quantity) AS total_sold
From OrderDetails AS od Group by od.ProductID)
, CTE_AvgInventory AS
(Select i.ProductID,Avg(i.Quantity) As Avg_Inventory From Inventory as i Group by i.ProductID)
, CTE_TurnOverRatio AS
(Select ts.ProductID,(ts.total_sold/ai.Avg_Inventory) As TurnOver_Ratio From CTE_TotalSold AS ts Inner Join CTE_AvgInventory As ai On ai.ProductID=ts.ProductID)
, CTE_SlowMovers AS
(Select tor.ProductID From CTE_TurnOverRatio As tor Where tor.TurnOver_Ratio < 0.7)
, CTE_NoOrder_SlowMover AS
(Select pno.ProductID From CTE_ProductNeverOrdered AS pno 
Union
Select sm.ProductID From  CTE_SlowMovers As sm)
Select * From CTE_NoOrder_SlowMover;
--Q301. Use a CTE to identify customers at risk of churn (no order in 180 days).
WITH CTE_CustomerChurnRisk AS (
    SELECT
        o.CustomerID,
        MAX(o.OrderDate) AS Last_OrderDate,
        DATEDIFF(Day, MAX(o.OrderDate), GETDATE()) AS Days_Since_Last_Order
    FROM Orders AS o
    GROUP BY o.CustomerID
    HAVING DATEDIFF(Day, MAX(o.OrderDate), GETDATE()) >= 180
)
SELECT * FROM CTE_CustomerChurnRisk;
--Q302. Write a CTE chain to compute: orders -> order totals -> customer totals -> top customers.
With CTE_Orders As
(Select 
	o.OrderID, 
	o.CustomerID, 
	od.UnitPrice , 
	od.Quantity 
From Orders As o 
Inner Join OrderDetails As od On od.OrderID =o.OrderID
)
, CTE_OrderTotals As
(
Select 
	o.OrderID,
	o.CustomerID,
	Sum(o.UnitPrice * o.Quantity) AS Order_Totals 
From CTE_Orders As o 
Group by o.OrderID,o.CustomerID
)
, CTE_CustomerTotals AS
(
Select 
	ot.CustomerID,
	Sum(ot.Order_Totals) As Customer_Totals 
From CTE_OrderTotals As ot 
Group by ot.CustomerID
)
, CTE_TopCustomers AS
(
Select 
	ct.CustomerID,
	ct.Customer_Totals 
From CTE_CustomerTotals AS ct 
Where ct.Customer_Totals>50000
)
Select * From CTE_TopCustomers;
--Q303. Use a recursive CTE to traverse the product category hierarchy.
With CTE_ProductCategoryHierarchy AS
(
Select 
	1 As Level,
	c1.CategoryID,
	p1.ProductID 
From Categories As c1 
Inner Join Products As p1 On p1.CategoryID=c1.CategoryID 
Where c1.ParentCategoryID IS NULL
Union All
Select 
	pch.Level+1,
	c2.CategoryID,
	p2.ProductID 
From Categories As c2 
Inner Join CTE_ProductCategoryHierarchy As pch On pch.CategoryID=c2.ParentCategoryID 
Inner Join Products As p2 On p2.CategoryID=c2.CategoryID
)
Select * From CTE_ProductCategoryHierarchy;
--Q304. Create a CTE to calculate each store's market share of total revenue.
With CTE_RevenuePerStore As
(Select 
	o.StoreID,
	Sum(od.UnitPrice * od.Quantity) As Revenue_per_Store 
From Orders As o 
Inner Join OrderDetails As od On od.OrderID=o.OrderID 
Group by o.StoreID
)
,CTE_TotalRevenue As
(Select 
	Sum(od.UnitPrice * od.Quantity) As Total_Revenue 
From OrderDetails AS od
)
,CTE_MarketShare_Revenue As
(Select 
	rps.StoreID,
	rps.Revenue_per_Store,
	(Select tr.Total_Revenue From CTE_TotalRevenue As tr) As Total_Revenue,
	(rps.Revenue_per_Store/ (Select tr.Total_Revenue From CTE_TotalRevenue As tr) * 100) AS MarketShare_per_Store
From CTE_RevenuePerStore AS rps
)
Select * From CTE_MarketShare_Revenue;
--Q305. Use a CTE to find the nth highest salary without using TOP.
With CTE_HighestSalary As 
(
Select 
	e.EmployeeID,
	e.Salary, 
	DENSE_RANK() Over (Order by e.Salary DESC) AS rnk 
From Employees As e
)
Select * From CTE_HighestSalary As hs
Where hs.rnk = 5;

--Q306. Write a CTE to identify which promotions resulted in the highest order values.
With CTE_HighestOrderValue As
(Select 
	p.PromotionID,
	Sum(od.UnitPrice * od.Quantity) As orderValue 
From Promotions AS p 
Inner Join Orders AS o On o.OrderDate Between p.StartDate And p.EndDate 
Inner Join OrderDetails As od On od.OrderID= o.OrderID
Group by p.PromotionID
)
Select Top 1 with Ties * 
From CTE_HighestOrderValue
Order by orderValue DESC;

--Q307. Use multiple CTEs to compare revenue: current year vs prior year.
With CTE_RevenueCurrentYear As
(
Select Year(o.OrderDate) As Current_Year, Sum(od.UnitPrice * od.Quantity) As Revenue_of_CurrentYear 
From Orders AS o 
Inner Join OrderDetails As od On od.OrderID=o.OrderID 
Where Year(o.OrderDate) = Year(GetDate())
Group by Year(o.OrderDate))
, CTE_RevenuePriorYear As
(
Select Year(o.OrderDate) AS Prior_Year, Sum(od.UnitPrice * od.Quantity) AS Revenue_of_PriorYear
From Orders AS o 
Inner Join OrderDetails AS od On od.OrderID=o.OrderID
Where Year(GetDATE()) - Year(o.OrderDate) = 1
Group by Year(o.OrderDate))
, CTE_CompareRevenue As
(
Select rcy.*,rpy.Revenue_of_PriorYear 
From CTE_RevenueCurrentYear As rcy 
Inner Join CTE_RevenuePriorYear As rpy ON rpy.Prior_Year +1 = rcy.Current_Year
)
Select * From CTE_CompareRevenue;
--Q308. Create a CTE that computes a 'health score' for each supplier (rating, order volume, return rate).
With CTE_Ratings As
(
Select 
	s.SupplierID,
	s.Rating 
From Suppliers As s
)
, CTE_OrderVolume As
(
Select 
	p.SupplierID,
	Count(od.OrderID) As Order_Volume 
From OrderDetails AS od 
Inner Join Products As p On p.ProductID=od.ProductID 
Group by p.SupplierID
)
, CTE_ReturnRate AS
(
Select 
	p.SupplierID,
	Count(r.OrderDetailID) AS Return_Rate 
From Returns As r 
Inner Join OrderDetails AS od On od.OrderDetailID=r.OrderDetailID 
Inner Join Products As p On p.ProductID=od.ProductID 
Group by p.SupplierID
)
, CTE_HealthScore AS
(
Select 
	r.*,
	ov.Order_Volume,
	rr.Return_Rate
From CTE_Ratings As r
Inner Join CTE_OrderVolume As ov On ov.SupplierID=r.SupplierID
Inner Join CTE_ReturnRate AS rr On rr.SupplierID = r.SupplierID
)
Select * From CTE_HealthScore;
--Q309. Use a CTE to find the longest streak of consecutive days with at least one order.
With CTE_DistinctDays As
(
Select Distinct o.OrderDate From Orders As o
)
, CTE_Numbered As 
(
Select dd.OrderDate,ROW_NUMBER() Over(Order by dd.OrderDate) AS rn From CTE_DistinctDays AS dd
)
,CTE_Grouped AS
(
Select n.OrderDate, DateAdd(Day,-rn,n.OrderDate) As grp_key From CTE_Numbered AS n
)
,CTE_Streaked AS
(
Select g.grp_key,Count(*) AS streak_length,Min(g.OrderDate) AS start_date,Max(g.OrderDate) As end_date From CTE_Grouped As g Group by g.grp_key
)
Select Top 1
	s.streak_length,
	s.start_date,
	s.end_date
From CTE_Streaked As s
Order by s.streak_length DESC;
--Q310. Write a CTE to calculate average order value per customer cohort (by join year).
With CTE_Cohort As
(Select c.CustomerID,Year(c.JoinDate) AS Join_Year From Customers As c)
, CTE_OrderValue As
(Select o.CustomerID,Sum(od.UnitPrice * od.Quantity) AS OrderValue From Orders AS o Inner Join OrderDetails As od On od.OrderID=o.OrderID Group by o.CustomerID)
, CTE_AvgOrderValue As
(
Select c.Join_Year, Avg(ov.OrderValue) AS Avg_OrderValue From CTE_OrderValue as ov Inner Join CTE_Cohort AS c On c.CustomerID= ov.CustomerID Group by c.Join_Year
)
Select * From CTE_AvgOrderValue
Order by Join_Year;

--Q311. Create a recursive CTE that generates a sequence of dates for a given range.

With CTE_GeneratingNumbers AS
(
Select 1 As mynum
Union All
Select mynum + 1 From CTE_GeneratingNumbers Where mynum+1 <= 20
)
Select * From CTE_GeneratingNumbers
OPtion (MaxREcursion 20);
