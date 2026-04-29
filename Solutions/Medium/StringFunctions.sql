-- String Functions
Use RetailDB;
Go

--Q156. Concatenate FirstName and LastName as FullName for all employees.
Select 
	Concat(e.FirstName,' ',e.LastName) As FullName 
From Employees As e;
--Q157. Convert all customer email addresses to uppercase.
Select 
	Upper(c.Email) As UpperCase_Email
From Customers As c;
--Q158. Extract the domain part from customer emails (after '@').
Select 
	SubString(c.Email,CHARINDEX('@',c.Email)+1,Len(c.Email)) As Domain_Name
From Customers As c;
--Q159. Show the first 3 characters of each product code.
Select 
	SUBSTRING(p.ProductCode,1,3) As First_3_Char_of_ProductCode
From Products As p;
--Q160. Find customers whose name length exceeds 10 characters.
Select * 
From Customers As c
Where (Len(c.FirstName)+Len(c.LastName))> 10;
--Q161. Replace 'Street' with 'St.' in store city names.
Select *,
	Replace(StoreType,'Street','St.') As Changed_StoreType
From Stores;
--Q162. Show employees with a reversed first name.
Select *,
	Reverse(e.FirstName) AS Reversed_FirstName
From Employees As e;
--Q163. Trim whitespace from supplier contact names.
Select *,
	Trim(s.Phone) As Trimmed_PhoneNo
From Suppliers AS s;
--Q164. Find products whose name starts with a vowel.
Select * From Products As p
Where SubString(p.ProductName,1,1) In ('a','e','i','o','u','A','E','I','O','U');
--Q165. Show the length of each product's description.
Select *,
	Len(p.Description) As Len_Description
From Products As p;
--Q166. Format product prices as strings with 2 decimal places.
Select 
	SUBSTRING(Cast(p.UnitPrice As VARCHAR(50)),1,CHARINDEX('.',Cast(p.UnitPrice As VARCHAR(50)))+2) As Upto_2_Decimal_Places_UnitPrice,
	SUBSTRING(Cast(p.CostPrice As VARCHAR(50)),1,CHARINDEX('.',Cast(p.CostPrice As VARCHAR(50)))+2) As Upto_2_Decimal_Places_CostPrice
From Products As p;
--Q167. Show customers whose email contains 'gmail'.
Select *
From Customers As c
Where SUBSTRING(c.Email,CHARINDEX('@',c.Email)+1,Len(c.Email)) = 'gmail.com';
--Q168. Split the ProductCode to get only the numeric portion.
Select *,
	SUBSTRING(p.ProductCode,4,Len(p.ProductCode)) As Numeric_ProductCode
From Products As p;
--Q169. Concatenate StoreName and City as 'StoreName – City'.
Select *,
	CONCAT(s.StoreName,' - ',s.City) As StoreName_City	
From Stores As s;
--Q170. Find all employees whose last name contains exactly 5 characters.
Select * 
From Employees As e
Where Len(e.LastName)=5;
