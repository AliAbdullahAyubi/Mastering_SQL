-- NULL Functions
Use RetailDB;
Go

--Q186. Show products replacing NULL CostPrice with 0.
Select *,
	NullIF(p.CostPrice,0) AS Replace_Null_to_0
From Products As p;
--Q187. Display employee names using COALESCE for ManagerID (show 'Top Manager' if NULL).
Select *,
	Coalesce(Cast(e.ManagerID As VarChar(50)),'Top Manager') As TopManagers
From Employees AS e
Where e.ManagerID Is Null;
--Q188. Show orders where ShippedDate is NULL and Status is 'Processing'.
Select * 
From Orders AS o
Where o.ShippedDate is Null and o.Status = 'Processing';
--Q189. Replace NULL descriptions with 'No description available'.
Select *,
	Coalesce(p.Description,'No description available') As Handled_Description
From Products As p;
--Q190. Find the count of products with and without a description.
Select 
	Count(p.Description) As Count_Products_With_Description,
	Count(*)-Count(p.Description) AS Count_Products_WithOut_Description
From Products As p;
--Q191. Use ISNULL to replace NULL phone numbers with 'N/A' in Customers.
Select *,
	ISNULL(c.Phone,'N/A') As Handling_Phone
From Customers As c;
--Q192. Show products where Weight is unknown (NULL).
Select * 
From Products As p
Where p.Weight Is Null;
--Q193. Handle NULL discounts in OrderDetails treating them as 0.
Select *,
	ISNULL(od.Discount,0) As Handling_Discount
From OrderDetails As od;
--Q194. Find orders where RequiredDate is NULL.
Select *
From Orders As o
Where o.RequiredDate Is Null;
--Q195. Show the percentage of employees with missing phone numbers.
Select(
(Select Count(*) From Employees As e Where e.Phone is NULL)/
(Select Count(*)From Employees As e)*100) AS Percentage_of_Employees_with_Missing_PhoneNo;