--Advanced JOINS & SET Operations
Use RetailDB;
Go

--Q312. Use a CROSS JOIN to generate all possible product-store combinations, then LEFT JOIN inventory to see which are stocked.
Select 
	i.InventoryID,
	i.ProductID,
	i.StoreID 
From Inventory AS i
Left Join
(Select p.ProductID,p.ProductName,s.StoreID,s.StoreName From Products AS p CROSS Join Stores AS s) AS Store_Product 
On Store_Product.ProductID=i.ProductID AND Store_Product.StoreID=i.StoreID;
--Q313. Self-join the Employees table to show each employee paired with their manager's details.
Select 
	e.EmployeeID,
	e.FirstName AS Emp_FirstName,
	e.LastName AS Emp_LastName,
	e.ManagerID,
	m.FirstName AS Mgr_FirstName,
	m.LastName AS Mgr_LastName
From Employees AS e
Inner Join Employees AS m ON m.EmployeeID = e.ManagerID;
--Q314. Join Orders to OrderDetails to Customers to Products in a single query to show full order breakdown.
Select * 
From Orders AS o
Inner Join OrderDetails AS od On od.OrderID = o.OrderID
Inner Join Customers AS c On c.CustomerID = o.CustomerID
Inner Join Products As p On p.ProductID = od.ProductID;
--Q315. Use a non-equi join to find customers who joined before the stores they ordered from opened.
Select 
	c.CustomerID,
	c.FirstName,
	c.LastName,
	c.JoinDate,
	o.OrderID,
	s.StoreID,
	s.StoreName,
	s.OpenDate 
From Customers As c
Inner Join Orders AS o On o.CustomerID = c.CustomerID
Inner Join Stores AS s On s.StoreID = o.StoreID
Where c.JoinDate < s.OpenDate;

--Q316. Find pairs of products frequently bought together (SELF JOIN on OrderDetails by OrderID).
--Q317. Use a CROSS APPLY to get each customer's most recent order.
Select c.CustomerID,fn_RecentOrder.* From Customers AS c
CROSS Apply fn_RecentOrder(c.CustomerID) AS fn_RecentOrder

Create Function fn_RecentOrder(@CustomerID int)
returns table
AS
Return
(
Select * From Orders AS o Where o.CustomerID= @CustomerID And o.OrderDAte = (Select MAx(o1.OrderDate) from Orders As o1 Where o1.CustomerID = o.CustomerID Group by o1.CustomerID)
);
--Q318. Use OUTER APPLY to get the top 2 products per category by revenue.
Select * From Categories As c
OUTER APPLY fn_TopTwoProduct(c.CategoryID) AS TopTwoProduct

Create Function fn_TopTwoProduct(@CategoryID int)
returns table
As
Return
( Select Top 2 r.* From
(Select p.CategoryID,od.ProductID,Sum(od.UnitPrice * od.Quantity) AS Revenue_per_Product From OrderDetails As od Inner Join Products AS p On p.ProductID=od.ProductID Where p.CategoryID = @CategoryID Group by p.CategoryID,od.ProductID) AS r
Order by r.Revenue_per_Product Desc
);

--Q319. Join the Returns table to trace the full return path: Return -> OrderDetail -> Order -> Customer -> Product.
Select * 
From Returns As r
Inner Join OrderDetails AS od On od.OrderDetailID = r.OrderDetailID
Inner JOin Orders AS o On o.OrderID = od.OrderDetailID
Inner Join Customers AS c On c.CustomerID = o.CustomerID
Inner Join Products As p On p.ProductID = od.ProductID;

--Q320. Use a derived table (subquery in FROM) to pre-aggregate order totals then join to Customers.
Select *
From
(Select o.OrderID,o.CustomerID,ordertotal.OrderTotal From (Select od.OrderID, Sum(od.UnitPrice * od.Quantity) AS OrderTotal From OrderDetails AS od Group by od.OrderID) As ordertotal Inner Join Orders AS o On o.OrderID=ordertotal.OrderID) As toc
Inner Join Customers AS c On c.CustomerID = toc.CustomerID;
--Q321. Perform a multi-table join to show employee shift details with store and region information.
Select * 
From Employees As e
Inner Join Stores AS s On s.StoreID = e.StoreID
Inner JOIn Regions AS r On r.RegionID = s.RegionID;
--Q322. Find customers who ordered in both 2022 and 2023 using JOIN on self-aggregated data.
Select 
	y22.*,
	y23.OrderID,
	y23.Order_Year23 
From
(Select o.CustomerID,o.OrderID,Year(o.OrderDAte) AS Order_Year22 From Orders As o Where Year(o.OrderDAte) = 2022) As y22
Inner Join
(Select o.CustomerID,o.OrderID,Year(o.OrderDate) As Order_Year23 From Orders AS o Where Year(o.OrderDate) = 2023) AS y23 On y23.CustomerID=y22.CustomerID;
--Q323. Use EXISTS to list products that have received 5-star reviews.
Select * 
From Products AS p1
Where Exists
(Select 1 From (Select r.ProductID,r.Rating From Reviews As r Where r.Rating=5)As p2 Where p2.ProductID=p1.ProductID);
--Q324. Use NOT EXISTS to find customers who have never returned a product.
Select * 
From Customers AS c1
Where Not Exists
(Select 1 From (Select o.CustomerID,r.ReturnID From Orders AS o Inner Join OrderDetails AS od On od.OrderID=o.OrderID Left Join Returns AS r On r.OrderDetailID=od.OrderDetailID Where r.ReturnID IS NULL) AS c2 Where c2.CustomerID=c1.CustomerID);


--Q325. Join promotions to orders to calculate how many orders qualified for each promotion.
Select 
	p.PromotionID,
	p.PromoName,
	o.OrderID,
	Count(o.OrderID) Over(Partition by p.PromotionID) AS Count_of_Order_per_Promotion
From Promotions As p
Inner Join Orders AS o On (o.OrderDate Between p.StartDate AND p.EndDate)
And (p.MinOrderAmount <= (Select Sum(od.UnitPrice * od.Quantity) AS OrderAmount From OrderDetails AS od Where od.OrderID = o.OrderID Group by od.OrderID));
--Q326. Find products that are both top-selling AND top-rated using JOINs between aggregated CTEs.
With CTE_TopSelling AS
(
Select TOP 100
	od.ProductID,
	Sum(od.Quantity) As Total_Sold 
From OrderDetails AS od 
Group by od.ProductID
Order by Total_Sold DESC
),
CTE_TopRated AS
(
Select TOP 100
	r.ProductID,
	Sum(r.Rating) As Total_Rating 
From Reviews As r
Group by r.ProductID
Order by Total_Rating DESC
)

Select * From CTE_TopSelling
Inner Join CTE_TopRated On CTE_TopRated.ProductID = CTE_TopSelling.ProductID;
