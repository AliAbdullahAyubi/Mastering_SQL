-- Combined Challenges
Use RetailDB;
Go

--Q196. Show total revenue by store per quarter for 2023.
Select 
	o.StoreID,
	CASE
	When Month(o.OrderDate) between 1 and 3 then 'Quater1'
	When Month(o.OrderDate) between 4 and 6 then 'Quater2'
	When Month(o.OrderDate) between 7 and 9 then 'Quater3'
	Else 'Quater4'
	END As Quaters,
	Sum(od.Quantity * od.UnitPrice) As Revenue 
From Orders AS o
Inner Join OrderDetails As od On od.OrderID=o.OrderID
Where Year(o.OrderDate) = 2023
Group by 
	o.StoreID,
	(CASE
	When Month(o.OrderDate) between 1 and 3 then 'Quater1'
	When Month(o.OrderDate) between 4 and 6 then 'Quater2'
	When Month(o.OrderDate) between 7 and 9 then 'Quater3'
	Else 'Quater4'
	END)
Order by StoreID Asc, Quaters Asc; 
--Q197. Find customers who placed more than 5 orders but have a CustomerTier of 'Bronze'.

Select 
	Customers_With_MoreThan_5_Orders.*,
	c.CustomerTier 
From Customers As c
Inner Join
	(Select 
		o.CustomerID,
		Count(o.OrderID) AS No_of_Orders 
	From Orders As o
	Group by o.CustomerID
	Having Count(o.OrderID) > 5) As Customers_With_MoreThan_5_Orders 
On Customers_With_MoreThan_5_Orders.CustomerID=c.CustomerID
Where c.CustomerTier = 'Bronze';

--Q198. List employees who earn more than the average salary of their job title.
Select 
	e.*
From Employees As e
Inner Join 
	(Select 
		e.JobTitle,
		Avg(e.Salary) As Avg_Salary 
	From Employees As e
	Group by e.JobTitle)As Avg_per_JobTitle 
ON e.JobTitle = Avg_per_JobTitle.JobTitle
Where e.Salary > Avg_per_JobTitle.Avg_Salary;
--Q199. Show the 3 most recent orders for each customer.
Select 
	o1.OrderID,
	o1.CustomerID, 
	o1.OrderDate
From Orders AS o1
Where (Select Count(*) From (Select o2.CustomerID,o2.OrderDate From Orders As o2) As o2 
	Where o1.CustomerID=o2.CustomerID 
	And o2.OrderDate<o1.OrderDate) < 3
Order by o1.CustomerID, o1.OrderDate Desc;
--Q200. Find stores where the total number of returned items exceeds 50.
Select 
	o.StoreID,
	Sum(od.Quantity) As Total_Returned_Items 
From Returns AS r 
Inner Join OrderDetails As od On od.OrderDetailID=r.OrderDetailID 
Inner Join Orders As o On o.OrderID=od.OrderID 
Group by o.StoreID 
Having Sum(od.Quantity) > 50;
--Q201. Calculate the percentage of orders that were cancelled per store.
Select
	PercentOrderTab.StoreID,
	(PercentOrderTab.No_of_Orders_per_Store * 100.0 /PercentOrderTab.Total_Orders) As Percentage_Orders_per_Store
From
(Select 
	o1.StoreID, 
	Count(o1.OrderID) AS No_of_Orders_per_Store,
	totalOrdersTab.Total_Orders
From Orders As o1
Inner Join(
	Select 
		o2.StoreID,
		Count(o2.OrderID) AS Total_Orders
	From Orders As o2
	Group by o2.StoreID) AS totalOrdersTab On totalOrdersTab.StoreID=o1.StoreID
Where o1.Status = 'Cancelled'
Group by o1.StoreID,totalOrdersTab.Total_Orders) As PercentOrderTab;

--Q202. List products where the average review rating is below 3 and total units sold > 100.
Select 
	r.ProductID, 
	Avg(r.Rating) AS Avg_Rating_per_Product,
	UnitSold_Products.Total_Unit_Sold_per_Product 
From Reviews As r
Inner Join (
	Select 
		od.ProductID, 
		Sum(od.Quantity) As Total_Unit_Sold_per_Product
	From OrderDetails As od
	Group by od.ProductID
	Having Sum(od.Quantity) > 100) As UnitSold_Products On UnitSold_Products.ProductID=r.ProductID
Group by r.ProductID,UnitSold_Products.Total_Unit_Sold_per_Product 
Having Avg(r.Rating) < 3;
--Q203. Show the employee with the highest sales in each department.
SELECT e.EmployeeID, e.DepartmentID, emp_sales.Total_Sales
FROM Employees AS e
INNER JOIN (
    SELECT o.EmployeeID, SUM(od.UnitPrice * od.Quantity) AS Total_Sales
    FROM Orders AS o
    INNER JOIN OrderDetails AS od ON od.OrderID = o.OrderID
    GROUP BY o.EmployeeID
) AS emp_sales ON emp_sales.EmployeeID = e.EmployeeID
WHERE emp_sales.Total_Sales = (
    SELECT MAX(emp_sales2.Total_Sales)
    FROM Employees AS e2
    INNER JOIN (
        SELECT o.EmployeeID, SUM(od.UnitPrice * od.Quantity) AS Total_Sales
        FROM Orders AS o
        INNER JOIN OrderDetails AS od ON od.OrderID = o.OrderID
        GROUP BY o.EmployeeID
    ) AS emp_sales2 ON emp_sales2.EmployeeID = e2.EmployeeID
    WHERE e2.DepartmentID = e.DepartmentID  
);

--Q204. Find customers who have ordered every product in CategoryID = 1.
Select o.CustomerID,Count(Distinct od.ProductID) As Total_Product_per_Customer_of_Cat1 From Orders As o
Inner Join OrderDetails As od On od.OrderID=o.OrderID
Where od.ProductID In (Select p1.ProductID From Products As p1 Where p1.CategoryID=1)
Group by o.CustomerID
Having Count(Distinct od.ProductID) = (Select Count(*) AS Total_Product_Cat1 From Products As p2
Where p2.CategoryID = 1);
--Q205. Calculate the average time (in days) from OrderDate to ShippedDate by store.
Select 
	o.StoreID,
	Avg(DATEDIFF(Day,o.OrderDate,o.ShippedDate)) As Avg_DateDiff_per_Store 
From Orders As o
Group by o.StoreID;
--Q206. Show products whose stock has fallen below the reorder level.
Select * From Products As p
Where p.StockQuantity < p.ReorderLevel;
--Q207. List promotions that were never used in any order.
Select 
	p.* 
From Promotions As p
Left Join Orders As o On o.OrderDate Between p.StartDate and p.EndDate
Where o.OrderID Is Null;
--Q208. Find the top 5 cities by total customer spending.
Select Top 5 With Ties
	o.ShipCity,
	(Sum(od.Quantity * od.UnitPrice)-Sum(od.Discount)) As Spending_per_Customer 
From Orders As o
Inner Join OrderDetails As od On od.OrderID=o.OrderID
Group by o.ShipCity
Order By Spending_per_Customer Desc;
--Q209. Show customers who have placed orders in at least 3 different stores.
Select 
	o.CustomerID, 
	Count(Distinct o.StoreID) As Distinct_Store_Count
From Orders As o
Group by o.CustomerID
Having Count(Distinct o.StoreID)>=3;
--Q210. Calculate the revenue impact if all Bronze-tier customers upgraded to Silver (assuming 10% more
--      spending).
SELECT 
    o.CustomerID,
    SUM(od.UnitPrice * od.Quantity) AS Current_Revenue,
    SUM(od.UnitPrice * od.Quantity) * 1.10 AS Projected_Revenue,
    SUM(od.UnitPrice * od.Quantity) * 0.10 AS Revenue_Impact
FROM Orders AS o
INNER JOIN OrderDetails AS od ON od.OrderID = o.OrderID
INNER JOIN Customers AS c ON c.CustomerID = o.CustomerID
WHERE c.CustomerTier = 'Bronze'
GROUP BY o.CustomerID;
--Q211. Find employees who have worked shifts in more than one store.
Select es.EmployeeID,Count(Distinct es.StoreID) As Count_Shifts_Diff_Stores
From EmployeeShifts As es
Group by es.EmployeeID
Having Count(Distinct es.StoreID)>1;
--Q212. Show the most common payment method per store.
Select Common_Payment_Method.StoreID,Count_Payment_Method.PaymentMethod,Count_Payment_Method.Count_PaymentMethods
From
(Select Count_Payment_Method.StoreID, Max(Count_Payment_Method.Count_PaymentMethods) As Common_Payment_per_Store From
(Select o.StoreID,o.PaymentMethod, Count(o.PaymentMethod) As Count_PaymentMethods
From Orders as o
Group by o.StoreID,o.PaymentMethod
) As Count_Payment_Method
Group by Count_Payment_Method.StoreID) As Common_Payment_Method
Inner Join
(Select o.StoreID,o.PaymentMethod, Count(o.PaymentMethod) As Count_PaymentMethods
From Orders as o
Group by o.StoreID,o.PaymentMethod
) As Count_Payment_Method On Count_Payment_Method.StoreID = Common_Payment_Method.StoreID
Where Count_Payment_Method.Count_PaymentMethods >= Common_Payment_Method.Common_Payment_per_Store;
--Q213. List products that have been reviewed but never ordered (data quality check).
Select 
	r.ProductID
From Reviews As r
Left Join OrderDetails As od On od.ProductID = r.ProductID
Where od.ProductID Is Null;

--Q214. Find customers whose average order value exceeds $500.
SELECT o.CustomerID, AVG(OrderTotals.Order_Total) AS Avg_Order_Value
FROM Orders AS o
INNER JOIN (
    SELECT OrderID, SUM(UnitPrice * Quantity) AS Order_Total
    FROM OrderDetails GROUP BY OrderID
) AS OrderTotals ON OrderTotals.OrderID = o.OrderID
GROUP BY o.CustomerID
HAVING AVG(OrderTotals.Order_Total) > 500;
--Q215. Show the total discount given per promotion.
Select 
	p.PromotionID,
	Sum(o.Discount) As Total_Discount_per_Promotion 
From Promotions as p
Inner Join Orders As o On o.OrderDate Between p.StartDate And p.EndDate
Group by p.PromotionID;
--Q216. Calculate the revenue per employee for the Sales department.
Select 
	o.EmployeeID,
	Sum(od.UnitPrice * od.Quantity) As Revenue_Per_Employee
From Orders As o
Inner Join OrderDetails As od On od.OrderID=o.OrderID
Inner Join Employees As e On e.EmployeeID = o.EmployeeID
Inner Join Departments As d On d.DepartmentID = e.DepartmentID
Where d.DeptName = 'Sales'
Group by o.EmployeeID;
--Q217. Find suppliers whose average product price is above $75.
Select 
	p.SupplierID,
	Avg(p.UnitPrice) As Avg_Unit_Price
From Products As p
Group by p.SupplierID
Having Avg(p.UnitPrice) > 75;
--Q218. List stores with an average order value above the overall average.
Select 
	o.StoreID,
	Avg(od.UnitPrice * od.Quantity) From Orders As o
Inner Join OrderDetails As od On od.OrderID = o.OrderID
Group by o.StoreID
Having Avg(od.UnitPrice * od.Quantity) > (Select Avg(od.UnitPrice * od.Quantity) As Overall_OrderValue From OrderDetails As od);
--Q219. Show the month with the highest number of new customer registrations.
Select Top 1 With Ties
	Month(JoinDate) As Month,
	Count(Distinct CustomerID)As Count_Customers 
From Customers As c
Group by Month(JoinDate)
Order By Count_Customers Desc;
--Q220. Calculate what percentage of total revenue comes from Gold and Platinum customers.
Select 
	c.CustomerTier,
	(Sum(od.UnitPrice * od.Quantity)*100/(Select Sum(od.UnitPrice * od.Quantity) From OrderDetails As od)) As Percentage_total_Revenue
From Customers As c
Inner Join Orders As o On o.CustomerID=c.CustomerID
Inner Join OrderDetails As od On od.OrderID=o.OrderID
Where c.CustomerTier In ('Gold','Platinum')
Group by c.CustomerTier;
--Q221. Find products that generated the most returns by value.
Select Top 1 With Ties
	od.ProductID,
	Sum(od.UnitPrice * od.Quantity) As Return_by_Value
From Orders As o
Inner Join OrderDetails As od On od.OrderID=o.OrderID
Where o.Status = 'Returned'
Group by od.ProductID
Order by Return_by_Value Desc;
--Q222. Show the city with the most customers.
Select Top 1 With Ties
	c.City, 
	Count(Distinct c.CustomerID) As Total_Customer_per_City
From Customers As c
Group by c.City
Order by Total_Customer_per_City Desc;
--Q223. List employees who have been with the company for more than 5 years and earn less than $50,000.
Select * From Employees As e
Where DateDiff(Year,e.HireDate,GetDate())>5 And e.Salary < 50000;
--Q224. Find the product with the highest profit margin.
Select Top 1 With Ties
	p.*,
	(p.UnitPrice - p.CostPrice) As Profit_Margin
From Products As p
Order by Profit_Margin Desc;
Select * From OrderDetails as od Order by od.ProductID;
--Q225. Show total units sold per supplier.
Select 
	p.SupplierID,
	Sum(od.Quantity) As Unit_Sold_per_Supplier 
From Products AS p
Inner Join OrderDetails As od On od.ProductID = p.ProductID
Group by p.SupplierID;
--Q226. Calculate the average number of products per order.
SELECT AVG(Products_per_Order) AS Avg_Products_per_Order
FROM (
    SELECT OrderID, COUNT(DISTINCT ProductID) AS Products_per_Order
    FROM OrderDetails
    GROUP BY OrderID
) AS OrderProductCount;
--Q227. Find customers who have never given a review despite having placed 3+ orders.
Select 
	o.CustomerID, 
	Count(o.OrderID) As Total_Orders_per_Customer
From Orders As o
Left Join Reviews As r On r.CustomerID = o.CustomerID
Where r.CustomerID is NULL
Group by o.CustomerID
Having Count(o.OrderID) > 3;
--Q228. Show which day of the week generates the most revenue on average.
Select Top 1 With Ties
	DateName(WeekDay,o.OrderDate) As Day_Of_Week,
	Avg(od.UnitPrice*od.Quantity) As Avg_Revenue_per_Day
From Orders As o
Inner Join OrderDetails As od On od.OrderID=o.OrderID
Group by DateName(WeekDay,o.OrderDate)
Order by Avg(od.UnitPrice*od.Quantity) Desc;
--Q229. List all products that appear in returns more than twice.
Select 
	od.ProductID,
	Count(o.OrderID) As Count_of_Returned_Orders_per_Product
From Orders As o
Inner Join OrderDetails As od On od.OrderID=o.OrderID
Where o.Status = 'Returned'
Group by od.ProductID
Having Count(o.OrderID) > 2;
--Q230. Calculate cumulative revenue per month for the current year.
Select 
	o1.Month, 
	o1.Revenue_per_Month,
	(Select  Sum(o2.Revenue_per_Month) From (Select Month(o2.OrderDate) AS Month, Sum(od2.UnitPrice * od2.Quantity) As Revenue_per_Month From Orders As o2 Inner Join OrderDetails As od2 On od2.OrderID=o2.OrderID Where DateDiff(Year,o2.OrderDate,GetDAte())=0 Group by Month(o2.OrderDate)) As o2
	Where o2.Month <= o1.Month) AS Cumulative_Revenue
From
(Select Month(o1.OrderDAte) AS Month,
Sum(od1.UnitPrice * od1.Quantity) As Revenue_per_Month
From Orders As o1
Inner Join OrderDetails As od1 On od1.OrderID=o1.OrderID
Where DateDiff(Year,o1.OrderDate,GetDate())=0
Group by Month(o1.OrderDate)) As o1;
--Q231. Find stores whose revenue has grown in each of the last 3 years.
Select 
	o.StoreID,
	Year(o.OrderDate) As year,
	Sum(od.UnitPrice * od.Quantity) As Revenue_per_Store_Yearly	
From Orders AS o
Inner Join OrderDetails As od On od.OrderID = o.OrderID
Where DateDiff(Year,o.OrderDate,GetDate()) <=3
Group by o.StoreID,Year(o.OrderDate)
Order by o.StoreID Asc, year Desc;
--Q232. Show the top 10 employees by number of orders processed.
Select Top 10 With Ties
	o.EmployeeID,
	Count(o.OrderID) As No_of_Orders_per_Employee
From Orders AS o
Group by o.EmployeeID
Order by Count(o.OrderID) DESC;
--Q233. Find product categories where average cost-to-price margin is below 20%.
Select p.CategoryID,
	AVg((p.UnitPrice-p.CostPrice)*100.0 / p.UnitPrice) As Avg_Cost_to_Price
From Products As p
Group by p.CategoryID
Having AVg((p.UnitPrice-p.CostPrice)*100.0 / p.UnitPrice) < 20;
--Q234. List customers who placed their first order within 7 days of joining.
Select 
	c.CustomerID,
	c.JoinDate,
	FirstOrder_Table.First_Order_per_Customer
From
(Select 
	o.CustomerID,
	Min(o.OrderDate) As First_Order_per_Customer
From Orders As o
Group by o.CustomerID) As FirstOrder_Table
Inner Join Customers As c On c.CustomerID = FirstOrder_Table.CustomerID
Where c.JoinDate < FirstOrder_Table.First_Order_per_Customer And DateDiff(Day,c.JoinDate,FirstOrder_Table.First_Order_per_Customer) <= 7;
--Q235. Find orders containing more than 5 unique products.
Select 
	od.OrderID, 
	Count(Distinct od.ProductID) As Count_Unique_Products_per_Order
From OrderDetails As od
Group by od.OrderID
Having Count(Distinct od.ProductID) > 5;
--Q236. Show suppliers that have not supplied a new product in the last 2 years.
Select  Distinct p1.SupplierID
From Products AS p1
Where p1.SupplierID Not In (Select p2.SupplierID From Products As p2 Inner Join Inventory AS i On i.ProductID=p2.ProductID Where Year(i.LastUpdated)>=DateAdd(Year,-2,GetDate()));
--Q237. Calculate each store's share of total company revenue.
Select 
	o.StoreID,
	(Sum(od.UnitPrice * od.Quantity)*100/(Select Sum(od.UnitPrice*od.Quantity) From OrderDetails As od)) As Store_Share_in_Revenue
From Orders As o
Inner Join OrderDetails As od On od.OrderID=o.OrderID
Group by o.StoreID;
--Q238. Find employees who have processed orders for cancelled status more than 10 times.
Select 
	o.EmployeeID, 
	Count(o.Status) As Count_of_Order_Cancelled_per_Employee
From Orders As o
Where o.Status = 'Cancelled'
Group by o.EmployeeID
Having Count(o.Status) > 10;
--Q239. Show the top 3 most returned products per category.
Select Top 3
	od.ProductID,
	r.ReturnDate 
From Returns As r
Inner Join OrderDetails As od On od.OrderDetailID=r.OrderDetailID
Order by r.ReturnDate Desc;
--Q240. Calculate the average loyalty points earned per order.
Select 
	o.OrderID,
	Avg(c.LoyaltyPoints) AS Avg_LoyaltyPoint_per_Order
From Customers As c
Inner Join Orders As o On o.CustomerID = c.CustomerID
Group by o.OrderID;

--Q241. Find customers whose spending increased year over year.
Select * From 
(Select 
	o.CustomerID,
	Year(o.OrderDate) As Year,
	Sum(od.UnitPrice * od.Quantity)-Sum(od.Discount) As Total_Spending_per_Year 
From Orders AS o
Inner Join OrderDetails As od On od.OrderID=o.OrderID
Group by o.CustomerID,Year(o.OrderDate)) As Cust_Spending_Yearly1
Where Exists(
Select 1 From
	(Select
		o2.CustomerID,
		Year(o2.OrderDate) As Year,
		Sum(od2.UnitPrice * od2.Quantity)-Sum(od2.Discount) As Total_Spending_per_Year 
	From Orders AS o2
	Inner Join OrderDetails As od2 On od2.OrderID=o2.OrderID
	Group by o2.CustomerID,Year(o2.OrderDate)) As Cust_Spending_Yearly2
	Where Cust_Spending_Yearly1.CustomerID = Cust_Spending_Yearly2.CustomerID 
	And Cust_Spending_Yearly2.Year=Cust_Spending_Yearly1.Year-1
	And Cust_Spending_Yearly1.Total_Spending_per_Year > Cust_Spending_Yearly2.Total_Spending_per_Year)
Order by Cust_Spending_Yearly1.CustomerID,Cust_Spending_Yearly1.Year;
--Q242. Show monthly revenue with a comparison label: 'Above Average' or 'Below Average'.
Select Month_Revenue.*,
    CASE
        WHEN Monthly_Revenue >= (
            SELECT AVG(Monthly_Revenue)
            FROM (
                SELECT Month(o.OrderDate) AS Month,
                    SUM(od.UnitPrice * od.Quantity) AS Monthly_Revenue
                FROM Orders AS o
                INNER JOIN OrderDetails AS od ON od.OrderID = o.OrderID
                GROUP BY Month(o.OrderDate)
            ) AS Monthly
        ) THEN 'Above Average'
        ELSE 'Below Average'
    END AS Revenue_Label
From
(Select Month(o.OrderDate) As Month, Sum(od.UnitPrice * od.Quantity) As Monthly_Revenue
From Orders As o 
Inner Join OrderDetails As od On od.OrderID=o.OrderID
Group by Month(o.OrderDate)) As Month_Revenue;
--Q243. List products where the number of 1-star reviews exceeds 5-star reviews.
Select 
	OneStar.*,
	FiveStar.Count_5_StarReviews 
From 
(Select r1.ProductID,Count(r1.Rating) As Count_1_StarReviews From Reviews As r1 Where r1.Rating=1 Group by r1.ProductID) AS OneStar
Inner Join
(Select r2.ProductID,Count(r2.Rating) As Count_5_StarReviews From Reviews AS r2 Where r2.Rating=5 Group by r2.ProductID) As FiveStar
On FiveStar.ProductID=OneStar.ProductID
Where OneStar.Count_1_StarReviews>FiveStar.Count_5_StarReviews;
--Q244. Find the store that has the highest employee-to-revenue ratio.
Select Top 1 With Ties
	Employee_Store.StoreID,
	(Revenue_Store.Revenue_per_Store*1.0/Employee_Store.No_of_Employee_per_Store) As Employee_to_Revenue_Ratio 
From
(Select o.StoreID,Count(Distinct o.EmployeeID) As No_of_Employee_per_Store
From Orders As o
Group by o.StoreID) As Employee_Store
Inner Join
(Select o.StoreID, Sum(od.UnitPrice * od.Quantity) As Revenue_per_Store
From Orders AS o
Inner Join OrderDetails As od On od.OrderID = o.OrderID
Group by o.StoreID) As Revenue_Store On Revenue_Store.StoreID = Employee_Store.StoreID
Order by Employee_to_Revenue_Ratio Desc;
--Q245. Calculate total revenue for each combination of CustomerTier and PaymentMethod.
Select 
	c.CustomerTier,
	o.PaymentMethod,
	Sum(od.UnitPrice * od.Quantity) As Revenue_per_CustomerTier_PaymentMethod
From Orders As o
Inner Join Customers As c On c.CustomerID=o.CustomerID
Inner Join OrderDetails AS od On od.OrderID=o.OrderID
Group by c.CustomerTier,o.PaymentMethod;
--Q246. Find the product that has the longest average time between repeat purchases.
--Q247. List customers who have shopped at every store (excluding the Online Store).
Select 
	o.CustomerID,
	Count(Distinct o.StoreID) As Count_Stores_Customer_Shopped From Orders AS o
Inner Join Stores AS s On s.StoreID = o.StoreID
Where s.StoreName != 'Online Store'
Group by o.CustomerID
Having Count(Distinct o.StoreID) = (Select Count(*) From Stores As s Where s.StoreName !='Online Store');
--Q248. Show year-over-year change in total orders and revenue side-by-side.
Select 
	yearly_revenue.*,
	yearly_orders.Order_per_Year 
From
(Select Year(o.OrderDate) AS Year1, Sum(od.UnitPrice * od.Quantity) AS Revenue_per_Year From Orders As o
Inner Join OrderDetails As od On od.OrderID=o.OrderID
Group by Year(o.OrderDate)) As yearly_revenue 
Inner Join
(Select Year(o.OrderDate) AS Year2, Count(o.OrderID) AS Order_per_Year From Orders AS o
Group by Year(o.OrderDate)) AS yearly_orders On yearly_orders.Year2=yearly_revenue.Year1;
--Q249. Find employees whose salary is above average for their store AND their department.
Select 
	e1.EmployeeID,
	e1.Salary
From Employees As e1
Where e1.Salary > (Select Avg(e2.Salary) From Employees As e2 Where e1.StoreID=e2.StoreID Group by e2.StoreID) 
	And e1.Salary > (Select Avg(e3.Salary) From Employees As e3 Where e1.DepartmentID=e3.DepartmentID Group by e3.DepartmentID);
--Q250. Calculate the return rate by payment method.
Select 
	sold_items.PaymentMethod,
	sold_items.Total_Item_Sold_per_PaymentMethod,
	returned_items.Total_Items_Returned_per_PaymentMethod,
	((returned_items.Total_Items_Returned_per_PaymentMethod * 100) / sold_items.Total_Item_Sold_per_PaymentMethod) As Returned_Rate_per_PaymentMethod
From 
(Select 
	o.PaymentMethod,
	Sum(od.Quantity) As Total_Item_Sold_per_PaymentMethod 
From Orders As o
Inner Join OrderDetails As od On od.OrderID=o.OrderID
Group by o.PaymentMethod) As sold_items
Inner Join
(Select 
	o.PaymentMethod,
	Sum(od.Quantity) As Total_Items_Returned_per_PaymentMethod From Returns As r
Inner Join OrderDetails As od On od.OrderDetailID=r.OrderDetailID
Inner Join Orders As o On o.OrderID=od.OrderID
Group by o.PaymentMethod) As returned_items On returned_items.PaymentMethod=sold_items.PaymentMethod;
--Q251. Show the distribution of order values by bucket: <$50, $50-$200, $200-$500, $500+.
Select Order_Value.*,Order_Bucket.Order_Value_Bucket 
From
(Select
	od.OrderID,
	Sum(od.UnitPrice*od.Quantity) Order_Value
From OrderDetails As od
Group by od.OrderID) As Order_Value
Inner Join
(Select 
	od.OrderID,
	Case
		When Sum(od.UnitPrice * od.Quantity) Between 0 And 50 Then '$50'
		When Sum(od.UnitPrice * od.Quantity) Between 51 And 200 Then '$50-$200'
		When Sum(od.UnitPrice * od.Quantity) Between 201 And 500 Then '$200-$500'
		Else '$500+'
	End As Order_Value_Bucket
From OrderDetails As od
Group by od.OrderID) As Order_Bucket On Order_Bucket.OrderID=Order_Value.OrderID;
--Q252. Find the best and worst performing product in each category by revenue.
Select 
	max_product_category.*,
	min_product_category.ProductID,
	min_product_category.Min_Performming 
From
(Select max_revenue.CategoryID,product_revenue1.ProductID, max_revenue.Max_Performing From
(Select product_revenue.CategoryID, Max(Revenue_per_Product_Category) As Max_Performing From
(Select p.CategoryID,p.ProductID,Sum(od.UnitPrice * od.Quantity) AS Revenue_per_Product_Category 
From OrderDetails AS od
Inner Join Products AS p On p.ProductID=od.ProductID
Group by p.CategoryID,p.ProductID) AS product_revenue
Group by product_revenue.CategoryID) AS max_revenue
Inner Join 
(Select p.CategoryID,p.ProductID,Sum(od.UnitPrice * od.Quantity) AS Revenue_per_Product_Category 
From OrderDetails AS od
Inner Join Products AS p On p.ProductID=od.ProductID
Group by p.CategoryID,p.ProductID) AS product_revenue1 
On product_revenue1.Revenue_per_Product_Category=max_revenue.Max_Performing) As max_product_category
Inner Join 
(Select min_revenue.CategoryID,product_revenue3.ProductID,min_revenue.Min_Performming From
(Select product_revenue2.CategoryID,Min(Revenue_per_Product_Category) As Min_Performming From
(Select p.CategoryID,p.ProductID,Sum(od.UnitPrice * od.Quantity) AS Revenue_per_Product_Category 
From OrderDetails AS od
Inner Join Products AS p On p.ProductID=od.ProductID
Group by p.CategoryID,p.ProductID) AS product_revenue2
Group by product_revenue2.CategoryID) As min_revenue
Inner Join
(Select p.CategoryID,p.ProductID,Sum(od.UnitPrice * od.Quantity) AS Revenue_per_Product_Category 
From OrderDetails AS od
Inner Join Products AS p On p.ProductID=od.ProductID
Group by p.CategoryID,p.ProductID) AS product_revenue3
On product_revenue3.Revenue_per_Product_Category = min_revenue.Min_Performming) AS min_product_category
On min_product_category.CategoryID=max_product_category.CategoryID;


--Q253. List customers who placed orders in consecutive months for at least 6 months.
--Q254. Calculate total and average order value by store type.
Select 
	s.StoreType, 
	Sum(od.UnitPrice*od.Quantity) As Total_OrderValue_per_Store,
	Avg(od.UnitPrice * od.Quantity) As Avg_OrderValue_per_Store
From Orders As o
Inner Join OrderDetails As od On od.OrderID=o.OrderID
Inner Join Stores As s On s.StoreID=o.StoreID
Group by s.StoreType;
--Q255. Show the top 5 employees with the highest average basket value per transaction.
Select Top 5 With Ties
	Employee_OrderValue.*,
	(Employee_OrderValue.Total_Revenue_per_Employee/Employee_OrderValue.Total_Order_per_Employee) As Avg_BasketValue_per_Employee
From
(Select 
	o.EmployeeID,
	Sum(od.UnitPrice * od.Quantity) As Total_Revenue_per_Employee,
	Count(o.OrderID) As Total_Order_per_Employee
From Orders As o
Inner Join OrderDetails As od On od.OrderID=o.OrderID
Group by o.EmployeeID) As Employee_OrderValue
Order by Avg_BasketValue_per_Employee Desc;
--Q256. Find products frequently purchased together with a specific product (e.g., ProductID = 10).
Select od.ProductID,Count(Distinct od.ORderID) AS Orders_per_Product From OrderDetails As od 
Where od.OrderID In (Select od.OrderID From OrderDetails As od Where od.ProductID = 10) And od.ProductID != 10
Group by od.ProductID
Order by Orders_per_Product DESC;
--Q257. Calculate the number of active customers (at least 1 order) per quarter.
SELECT Quaters, COUNT(DISTINCT CustomerID) AS Active_Customers
FROM (
    SELECT o.CustomerID,
        CASE
            WHEN MONTH(o.OrderDate) BETWEEN 1 AND 3  THEN 'Q1'
            WHEN MONTH(o.OrderDate) BETWEEN 4 AND 6  THEN 'Q2'
            WHEN MONTH(o.OrderDate) BETWEEN 7 AND 9  THEN 'Q3'
            ELSE 'Q4'
        END AS Quaters
    FROM Orders AS o
) AS QuarterOrders
GROUP BY Quaters;
--Q258. Show orders that include both ProductID = 5 and ProductID = 10.
Select od1.OrderID
From OrderDetails AS od1
Where Exists
(Select 1 From OrderDetails As od2 Where od2.OrderID=od1.OrderID And od2.ProductID=5) 
And Exists
(Select 1 From OrderDetails AS od3 Where od3.OrderID=od1.OrderID And od3.ProductID=10);

--Q259. Find the average number of days between a customer's first and second order.
Select 
	Avg(DayDiff_FirstSecond_Order.DateDiff_btw_First_and_Second_Order) AS Avg_DateDiff_btw_First_and_Second_Order
From
(Select FirstOrder.*, SecondOrder.OrderDate,DateDiff(Day,FirstOrder.First_OrderDate,SecondOrder.OrderDate) As DateDiff_btw_First_and_Second_Order
From
(Select o.CustomerID,Min(o.OrderDAte) As First_OrderDate From Orders As o
Group by o.CustomerID) As FirstOrder
Inner Join
(Select o1.CustomerID,o1.OrderDate From Orders As o1 Where 1 = (Select Count(*) From Orders AS o2 Where o2.CustomerID=o1.CustomerID And o2.OrderDate < o1.OrderDate)) AS SecondOrder On SecondOrder.CustomerID=FirstOrder.CustomerID) As DayDiff_FirstSecond_Order;

--Q260. List regions ranked by total revenue.
Select s.RegionID,Sum(od.UnitPrice * od.Quantity) AS Revenue_per_Region From Orders As o
Inner Join OrderDetails As od On od.OrderID=o.OrderID
Inner Join Stores As s On s.StoreID = o.StoreID
Group by s.RegionID;
--Q261. Show each employee's total managed revenue including their subordinates' revenue.
Select 
	mr.EmployeeID,
	ser.Revenue_per_subEmployees
	,mr.Revenue_per_Manager,
	(mr.Revenue_per_Manager+ser.Revenue_per_subEmployees) AS Total_Managed_Revenue_per_Employee 
From
(Select er.ManagerID,Sum(Revenue_per_Employee) AS Revenue_per_subEmployees From 
(Select o.EmployeeID,e.ManagerID, Sum(od.UnitPrice * od.Quantity) AS Revenue_per_Employee From Orders AS o
Inner Join OrderDetails As od On od.OrderID=o.OrderID
Inner Join Employees AS e On e.EmployeeID=o.EmployeeID
Where e.ManagerID Is NOT NULL
Group by e.ManagerID,o.EmployeeID) AS er
Group by er.ManagerID) AS ser
Inner Join
(Select o.EmployeeID, Sum(od.UnitPrice * od.Quantity) As Revenue_per_Manager From Orders AS o
Inner Join OrderDetails AS od On od.OrderID=o.OrderID
Inner Join Employees As e On e.EmployeeID = o.EmployeeID
Where e.ManagerID Is NULL
Group by o.EmployeeID) AS mr On mr.EmployeeID=ser.ManagerID;
--Q262. Find the product category with the fastest growth in revenue between 2022 and 2023.
Select Top 1 With Ties
	y22.*,
	y23.Revenue_per_Category_Y23,
	((y23.Revenue_per_Category_Y23-y22.Revenue_per_Category_Y22)/y22.Revenue_per_Category_Y22 * 100.0) As Growth_btw_y22_y23 
From 
(Select p.CategoryID,Sum(od.UnitPrice * od.Quantity) AS Revenue_per_Category_Y22
From OrderDetails AS od
Inner Join Products AS p On p.ProductID=od.ProductID
Inner Join Orders As o On o.OrderID=od.OrderID
Where Year(o.OrderDate)= 2022
Group by p.CategoryID) AS y22
Inner Join
(Select p.CategoryID,Sum(od.UnitPrice * od.Quantity) AS Revenue_per_Category_Y23
From OrderDetails As od 
Inner Join Products AS p On p.ProductID=od.ProductID
Inner Join Orders As o On o.OrderID=od.OrderID
Where Year(o.OrderDate) = 2023
Group by p.CategoryID) AS y23 On y23.CategoryID = y22.CategoryID
Order by Growth_btw_y22_y23 Desc;
--Q263. Calculate customer tier upgrade potential: Bronze customers who spent > $2000 last year.
Select 
	Bronze_Customer.*, 
	LastYear_Spending_greater_2000_Customers.Total_Spending_per_Customer 
From
(Select c.CustomerID,c.CustomerTier From Customers As c
Where c.CustomerTier='Bronze') AS Bronze_Customer
Inner Join
(Select o.CustomerID,Sum(od.UnitPrice*od.Quantity) As Total_Spending_per_Customer
From Orders AS o
Inner Join OrderDetails AS od On od.OrderID=o.OrderID
Where DateDiff(Year,o.OrderDate,GetDAte()) = 1
Group by o.CustomerID
Having Sum(od.UnitPrice*od.Quantity) > 2000) As LastYear_Spending_greater_2000_Customers On LastYear_Spending_greater_2000_Customers.CustomerID=Bronze_Customer.CustomerID;

--Q264. Show the 10 customers who have been waiting the longest for an order to ship.
Select Top 10
	o.CustomerID,
	DateDiff(Day,o.OrderDate,GETDATE()) As DayDiff_btw_OrderDate_ShippedDate 
From Orders As o
Where o.ShippedDate IS NULL
Order by DayDiff_btw_OrderDate_ShippedDate DESC;
--Q265. Find stores where more than 30% of orders are from repeat customers.
Select order_store.* From
(Select 
	os.StoreID,
	os.Total_Orders_per_RepeatedCustomer_in_Stores,
	tos.Orders_per_Store,
	os.Total_Orders_per_RepeatedCustomer_in_Stores*100/tos.Orders_per_Store AS Percent_Orders_From_RepeatedCustomers_per_Store
From 
(Select order_per_store.StoreID,Sum(order_per_store.Order_per_RepeatedCustomers) As Total_Orders_per_RepeatedCustomer_in_Stores From
(Select o.StoreID,o.CustomerID,Count(o.OrderID) AS Order_per_RepeatedCustomers From Orders As o 
Where o.CustomerID IN (Select rc.CustomerID From(Select o.CustomerID,Count(o.OrderID) AS Orders_per_Customer_in_Store From Orders AS o Group by o.CustomerID Having Count(o.OrderID) > 1) AS rc)
Group by o.StoreID,o.CustomerID) AS order_per_store
Group by order_per_store.StoreID) As os
Inner Join
(Select o.StoreID,Count(o.OrderID) AS Orders_per_Store From Orders AS o Group by o.StoreID) AS tos On tos.StoreID = os.StoreID) 
AS order_store
Where order_store.Percent_Orders_From_RepeatedCustomers_per_Store > 30;
--Q266. Calculate the average review rating for products by price bracket.
Select p.ProductID,p.UnitPrice,
 Case 
	When p.UnitPrice Between 1 And 20 Then 'Very Low'
	When p.UnitPrice Between 21 And 50 Then 'Low'
	When p.UnitPrice Between 51 And 100 Then 'Affordable'
	When p.UnitPrice Between 101 And 250 Then 'Mid'
	When p.UnitPrice Between 251 And 500 Then 'Upper-Mid'
	ELSE 'High'
 End AS Price_Bracket,
 AVg(r.Rating) Over (Partition by 
	 Case 
	When p.UnitPrice Between 1 And 20 Then 'Very Low'
	When p.UnitPrice Between 21 And 50 Then 'Low'
	When p.UnitPrice Between 51 And 100 Then 'Affordable'
	When p.UnitPrice Between 101 And 250 Then 'Mid'
	When p.UnitPrice Between 251 And 500 Then 'Upper-Mid'
	ELSE 'High'
 End) AS Avg_Rating_by_Price_Bracket
From Products AS p
Inner Join Reviews As r On r.ProductID=p.ProductID;
--Q267. Show the employee hierarchy depth using a recursive CTE (count levels).
With CTE_Managers As
(
	Select 1 AS Emplevel,e1.EmployeeID,e1.FirstName,e1.LastName, e1.ManagerID From Employees As e1 Where e1.ManagerID Is NULL
	Union All
	Select m.Emplevel+1,e2.EmployeeID,e2.FirstName,e2.LastName,e2.ManagerID From Employees AS e2 Inner Join CTE_Managers As m On m.EmployeeID=e2.ManagerID
)
Select * From CTE_Managers;
--Q268. Find any duplicate customer emails (potential data issues).
Select 
	c1.CustomerID,
	c1.Email 
From Customers As c1
Where Exists(Select 1 From Customers As c2 Where c2.CustomerID!=c1.CustomerID and c2.Email=c1.Email);
--Q269. Show total orders and revenue for each combination of StoreType and PaymentMethod.
Select 
	o.StoreID,
	o.PaymentMethod,
	Count(o.OrderID) As Total_Orders_per_Store_and_PaymentMethod,
	Sum(od.UnitPrice * od.Quantity) As Total_Revenue_per_Store_and_PaymentMethod
From Orders As o
Inner Join OrderDetails As od On od.OrderID=o.OrderID
Group by o.StoreID,o.PaymentMethod
Order by o.StoreID,o.PaymentMethod;
--Q270. Find products that have been ordered every single month in the past year.
Select 
	od.ProductID,
	Count(Distinct Month(o.OrderDate)) As Count_of_Month_Order_occur_per_Product 
From OrderDetails As od
Inner Join Orders As o ON o.OrderID=od.OrderID
Where DAteDiff(Year,o.OrderDate,GetDate()) = 1
Group by od.ProductID
Having Count(Distinct Month(o.OrderDate))= 12;
--Q271. Calculate the 'win back' opportunity: customers who were active in 2022 but placed no orders in 2023.
Select Distinct y22.*,y23.Year23 From
(Select o.CustomerID, Year(o.OrderDate) As Year22  From Orders AS o
Where Year(o.OrderDate) = '2022') As y22
Left Join (Select o.CustomerID,Year(o.OrderDate) As Year23 From Orders As o Where Year(o.OrderDate)='2023') As y23 On y23.CustomerID=y22.CustomerID
Where y23.Year23 Is NUll;

--Q272. Show how many days on average it took to fulfil orders by store, by year.
Select 
	o.StoreID,
	Year(o.OrderDate) As Year,
	Avg(DateDiff(DAy,o.OrderDate,o.ShippedDate)) As Avg_Fulfil_Days_per_Store
From Orders AS o
Group by o.StoreID,Year(o.OrderDate)
Order by o.StoreID,Year(o.OrderDate);

--Q273. Find the top 3 revenue-generating employees in each store.
Select * From
(Select o.StoreID,o.EmployeeID,Sum(od.UnitPrice * od.Quantity) As Total_Revenue_per_Employee
From Orders As o
Inner Join OrderDetails As od On od.OrderID=o.OrderID
Group by o.StoreID,o.EmployeeID) AS Revenue_by_Store_Employee1
Where (Select Count(*) From
	(Select o.StoreID,o.EmployeeID,Sum(od.UnitPrice * od.Quantity) As Total_Revenue_per_Employee
	From Orders As o
	Inner Join OrderDetails As od On od.OrderID=o.OrderID
	Group by o.StoreID,o.EmployeeID) AS Revenue_by_Store_Employee2
	Where Revenue_by_Store_Employee2.StoreID=Revenue_by_Store_Employee1.StoreID
	And Revenue_by_Store_Employee2.Total_Revenue_per_Employee>Revenue_by_Store_Employee1.Total_Revenue_per_Employee) < 3
Order by Revenue_by_Store_Employee1.StoreID,Revenue_by_Store_Employee1.Total_Revenue_per_Employee;
--Q274. Calculate percentage of revenue from new vs returning customers per quarter.
Select 
	CASE
	When Month(Customer_OrderDate.OrderDate) between 1 and 3 then 'Quater1'
	When Month(Customer_OrderDate.OrderDate) between 4 and 6 then 'Quater2'
	When Month(Customer_OrderDate.OrderDate) between 7 and 9 then 'Quater3'
	Else 'Quater4'
	END As Quaters,
	Sum(Revenue_Customer.Revenue_per_Customer) AS Total_Revenue_of_Returning_Customer_per_Quater
From
(Select o.CustomerID,o.OrderDate From Orders As o) Customer_OrderDate
Inner Join
(Select o.CustomerID, Sum(od.UnitPrice * od.Quantity) As Revenue_per_Customer From Orders AS o
Inner Join OrderDetails As od On od.OrderID=o.OrderID
Group by o.CustomerID) AS Revenue_Customer On Revenue_Customer.CustomerID=Customer_OrderDate.CustomerID
Group by 
	CASE
	When Month(Customer_OrderDate.OrderDate) between 1 and 3 then 'Quater1'
	When Month(Customer_OrderDate.OrderDate) between 4 and 6 then 'Quater2'
	When Month(Customer_OrderDate.OrderDate) between 7 and 9 then 'Quater3'
	Else 'Quater4'
	END;


Select * From Customers AS c
Inner Join Orders As o On o.CustomerID=c.CustomerID
Inner Join OrderDetails As od On od.OrderID=od.OrderID;



--Q275. Show products with a review count greater than the category average.
SELECT r.ProductID, COUNT(r.ReviewID) AS Review_Count
FROM Reviews AS r
INNER JOIN Products AS p ON p.ProductID = r.ProductID
GROUP BY r.ProductID, p.CategoryID
HAVING COUNT(r.ReviewID) > (
    SELECT AVG(CAST(Cat_Reviews.Review_Count AS FLOAT))
    FROM (
        SELECT p2.CategoryID, COUNT(r2.ReviewID) AS Review_Count
        FROM Reviews AS r2
        INNER JOIN Products AS p2 ON p2.ProductID = r2.ProductID
        GROUP BY p2.CategoryID, p2.ProductID
    ) AS Cat_Reviews
    WHERE Cat_Reviews.CategoryID = p.CategoryID 
);
--Q276. Find customers who only ever buy from one specific store.
Select o.CustomerID,Count(Distinct o.StoreID) AS Count_of_Store_Customer_Buy From Orders As o
Group by o.CustomerID
Having Count(Distinct o.StoreID)=1;

