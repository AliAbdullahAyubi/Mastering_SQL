--Join Statements
Use RetailDB;
Go

--Q96. List each order with the customer's full name.
Select 
	Concat(c.FirstName,' ',c.LastName) As CustomerName,
	o.*
From Orders As o
Inner Join Customers As c On c.CustomerID=o.CustomerID;

--Q97. Show each order with the store name where it was placed.
Select
	s.StoreName,
	o.*
From Orders AS o
Inner Join Stores As s On s.StoreID=o.StoreID;
--Q98. Display order details including the product name and quantity.
Select 
	od.*,
	p.ProductName
From OrderDetails As od
Inner Join Products As p On p.ProductID=od.ProductID;
--Q99. List employees with their department name.
Select 
	d.DeptName,
	e.* 
From Employees As e
Inner Join Departments As d On d.DepartmentID = e.DepartmentID;
--Q100. Show products with their category name.
Select 
	c.CategoryName,
	p.* 
From Products AS p
Inner Join Categories AS c On p.CategoryID= c.CategoryID;

--Q101. Display products with their supplier name and country.
Select
	s.SupplierName,
	s.Country,
	p.*
From Products As p
Inner Join Suppliers As s On s.SupplierID = p.SupplierID;
--Q102. List all orders with the employee's full name who handled them.
Select 
	Concat(e.FirstName,' ',e.LastName) As Employee_FullName,
	o.* 
From Orders As o
Inner Join Employees As e On e.EmployeeID = o.EmployeeID;

--Q103. Show order details with product name, quantity and total line price (Quantity * UnitPrice).
Select
	p.ProductName,
	(od.Quantity * p.UnitPrice) AS Total_line_price,
	od.* 
From OrderDetails As od
Inner Join Products AS p On p.ProductID = od.ProductID;

--Q104. List customers with their total number of orders.
Select 
	c.*,
	Total_Order.Total_Orders
From Customers As c
Inner Join(Select o.CustomerID,Count(OrderID) As Total_Orders From Orders As o Group by o.CustomerID) As Total_Order
On Total_Order.CustomerID = c.CustomerID;
--Q105. Display each store with its region name and country.
Select 
	s.*,
	r.RegionName,
	r.Country
From Stores As s
Inner Join Regions As r On r.RegionID = s.RegionID;
--Q106. Show employees with their manager's full name.
Select 
	e.*,
	Concat(m.FirstName,' ',m.LastName) As Manager_FullName
From Employees as e
Inner Join Employees as m On m.EmployeeID = e.ManagerID;
--Q107. List all products with their category and supplier name.
Select 
	p.*,
	c.CategoryName,
	s.SupplierName
From Products As p
Inner Join Categories As c On c.CategoryID = p.CategoryID
Inner Join Suppliers As s On s.SupplierID = p.SupplierID;
--Q108. Display orders with customer name, store name and order total.
Select 
	o.*,
	Concat(c.FirstName,' ',c.LastName) AS Customer_FullName,
	s.StoreName,
	TotalOrders.order_total
From Orders AS o
Inner Join Customers AS c On c.CustomerID = o.CustomerID
Inner Join Stores As s On s.StoreID = o.StoreID
Inner Join (Select od.OrderID,Count(od.OrderDetailID) As order_total From OrderDetails As od Group by od.OrderID) As TotalOrders
On TotalOrders.OrderID = o.OrderID;
--Q109. Show all reviews with the customer name and product name.
Select 
	r.*,
	Concat(c.FirstName,' ',c.LastName) AS Customer_FullName,
	p.ProductName
From Reviews As r
Inner Join Customers As c On c.CustomerID = r.CustomerID
Inner Join Products As p On p.ProductID = r.ProductID;
--Q110. List inventory records with store name and product name.
Select 
	i.*,
	s.StoreName,
	p.ProductName
From Inventory As i
Inner Join Stores As s On s.StoreID=i.StoreID
Inner Join Products AS p On p.ProductID =i.ProductID;
--Q111. Show returns with the product name and reason.
Select 
	r.*,
	p.ProductName
From Returns As r
Inner Join OrderDetails As od On od.OrderDetailID=r.OrderDetailID
Inner Join Products As p On p.ProductID = od.ProductID;
--Q112. Display promotions that are currently active (today between StartDate and EndDate).
Select * From Promotions
Where StartDate<=GETDATE() And EndDate>=GETDATE();
--Q113. List order details where the line discount > 10.
Select 
	od.* 
From OrderDetails AS od
Inner Join Orders As o On o.OrderID=od.OrderID
Where o.Discount>10;
--Q114. Show employees who work at the 'Online Store'.
Select 
	e.* 
From Employees As e
Inner Join Stores As s On s.StoreID = e.StoreID
Where s.StoreType = 'Online';

--Q115. List customers who have never placed an order (LEFT JOIN approach).
Select 
	c.*
From Customers As c
Left Join Orders As o On o.CustomerID = c.CustomerID
Where o.OrderID is Null;

--Q116. Show products that have never been ordered.
Select 
	p.* 
From Products As p
Left Join OrderDetails As od On od.ProductID=p.ProductID
Where od.ProductID Is Null;
--Q117. Find employees who have never managed anyone.
Select 
	m.* 
From Employees As m
Left Join Employees As e On m.EmployeeID = e.ManagerID
Where e.EmployeeID Is Null;
--Q118. List stores that have no inventory records.
select 
	s.* 
From Stores AS s
Left Join Inventory As i On s.StoreID=i.StoreID
Where i.InventoryID Is Null;
--Q119. Show customers who have written at least one review.
Select 
	c.* 
From Customers As c
Left Join Reviews As r On r.CustomerID=c.CustomerID
Where r.ReviewID Is Not Null;

--Q120. Display products reviewed by more than 10 customers.
Select 
	p.* 
From Products As p
Inner Join (Select ProductID,Count(Distinct CustomerID) As Distinct_Customers From Reviews Group by ProductID Having Count(Distinct CustomerID) > 10) As No_of_CustomerReviews_per_Product
On No_of_CustomerReviews_per_Product.ProductID = p.ProductID;