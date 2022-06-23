Northwind Data Exploration 

Skills used: select, where, joins, order by, top, between, like aggregate function, having, CTE, TOP, date functions

-- 1. View all employees.
select * from Northwind..Employees

--2. View all clients.
select * from Northwind..Customers

--3. View all suppliers.
select * from Northwind..Suppliers

--4. View all suppliers. Limit the number of columns (CompanyName,Address,City,Country)
select CompanyName, Address, City, Country from Northwind..Suppliers

--5. View all employees. Limit the number of column (LastName,FirstName,Tittle)
select FirstName+' '+LastName as Name, Title from Northwind..Employees

--6. View all suppliers. Limit the number of column (CompanyName, Address, City, Country)
select CompanyName, Address, City, Country from Northwind..Suppliers

--7. View all products. Limit the number of column (ProductName, QuantityPerUnit, (UnitPrice)
select ProductName,QuantityPerUnit,UnitPrice from Northwind..Products

--8. View all shippers. Limit the number of column (companyname,phone)
select CompanyName,Phone from Northwind..Shippers

--9. Calculate the difference between the orders with the highest and lowest value.
WITH TableA (OrderID, Price)
as 
(
select OrderID, sum((UnitPrice*Quantity)-(UnitPrice*Quantity)*Discount) as Value  from Northwind..[Order Details] group by OrderID
)
select	MAX(price) as MaxValue, 
		MIN(price) as MinValue, 
		MAX(price)-MIN(price) as DifferenceValue 
from tableA

--10. Calculate the total orders of 2 customers with the most orders.
select SUM(number_of_orders) as total_orders from 
(
select TOP 2 customerID, count(CustomerID) as number_of_orders
from  Northwind..Orders 
group by CustomerID 
order by 2 DESC
) as tableB

--11. View all employees in the format: Last Name, First Name and Title.
select LastName, FirstName, Title from Northwind..Employees

--12. Display all employees in the format: Last Name, First Name, Job Title, but only from the United States.
select LastName, FirstName, Title, Country 
from Northwind..Employees
where Country = 'USA'

--13. ZnajdŸ dane firmy o nazwie „Alfreds Futterkiste”.
select * 
from Northwind..Customers 
where CompanyName = 'Alfreds Futterkiste'

--14. Find chocolate suppliers.
select ProductID, p.SupplierID, ProductName, CompanyName, ContactName, Phone, Address, City
from Northwind..Products as P
inner join Northwind..Suppliers as S
on P.SupplierID=S.SupplierID
where ProductName = 'chocolade'

--15. 1996 sales report.
select
YEAR(orderdate) as Year,
MONTH(orderdate) as Month, 
round(sum((UnitPrice*Quantity)-(UnitPrice*Quantity)*Discount),2) as Sale
from Northwind..Orders as o
inner join Northwind..[Order Details] as od 
on o.OrderID=od.OrderID
where year(OrderDate) = 1996
group by YEAR(orderdate), MONTH(orderdate)
order by 1,2 ASC

--16. Display the number of employees.
select COUNT(*) as number_of_employees from Northwind..Employees

--17. View the current product list.
select ProductID, ProductName, Discontinued from Northwind..Products
where Discontinued = 0
order by ProductName ASC

--18. Show all employees whose surnames start with the letter D.
select * from Northwind..Employees
where LastName like 'd%'

--19. Show products whose unit price is greater than 100.
select ProductName, UnitPrice from Northwind..Products
where UnitPrice > 100
order by 1 DESC

--20. Show products whose unit price is greater than 50 and less than 100.
select ProductName, UnitPrice from  Northwind..Products
where UnitPrice between 50 and 100
order by UnitPrice ASC

--21. View orders with a value greater than $ 100.
select OD.OrderID, sum(OD.UnitPrice) as Value, YEAR(o.orderdate) as YEAR, MONTH(o.orderdate) as MONTH
from Northwind..[Order Details] as OD
inner join Northwind..Orders as O
on OD.OrderID = O.OrderID
group by OD.OrderID, YEAR(o.orderdate), MONTH(o.orderdate)
having sum(OD.UnitPrice) > 100
order by  YEAR(o.orderdate) ASC, MONTH(o.orderdate) ASC

--22. Calculate what percentage of all orders are pre-holiday orders
select 
		(
		select COUNT(*) from Northwind..Orders
		) as 'all',
		(
		select COUNT(*) from Northwind..Orders 
				where DAY(OrderDate) between 1 and 23
				and MONTH(OrderDate) = 12
		) as 'pre',
		(
		(select COUNT(*) from Northwind..Orders 
		where DAY(OrderDate) between 1 and 23
		and MONTH(OrderDate) = 12)*100 /(select COUNT(*) from Northwind..Orders)
		) as percentage

--23. Which shippers handled the most orders
select S.CompanyName, count(CompanyName) as Quantity from Northwind..Orders as O
inner join Northwind..Shippers as S
on O.ShipVia=S.ShipperID
group by CompanyName
order by 2 DESC

--24. Which shippers has handled the orders for the highest value.
select S.CompanyName, SUM(unitprice*quantity) as Value
from Northwind..[Order Details] as OD
inner join Northwind..Orders as O on OD.OrderID = O.OrderID
inner join Northwind..Shippers as S on S.ShipperID = O.ShipVia
group by S.CompanyName
order by 2 DESC

--25. Calculate the sum of the orders with the highest and lowest value
select
(
select TOP 1 SUM(unitprice*quantity) from Northwind..[Order Details] 
group by OrderID
order by 1 DESC
)
+
(
select TOP 1 SUM(unitprice*quantity) from Northwind..[Order Details] 
group by OrderID
order by 1 ASC
) as 'SUM'

WITH CTE (prices)
as
(
select SUM(unitprice*quantity) as Prices from Northwind..[Order Details] 
group by OrderID
)
select MAX(prices) as MaxValue,
	   MIN(prices) as MinValue,
	   MAX(prices)+MIN(prices) as SUM
from CTE

--30. Calculate the value of each order.
select OrderID, SUM(unitprice*quantity) as Value from Northwind..[Order Details] 
group by OrderID
order by 1 ASC

--31. Calculate the value of all orders in Q1 1997.
select SUM(value) as value_of_all_orders_Q1_1997 from
(
select SUM(unitprice*quantity) as Value
from Northwind..[Order Details] as OD
inner join Northwind..Orders as O on OD.OrderID = O.OrderID
where YEAR(O.OrderDate) = 1997 and (MONTH(o.OrderDate) between 1 and 3)
group by OD.OrderID
) as a

--32. Calculate the number of customers who have not placed any orders.
select count(*) none_orders
from Northwind..Customers as C
left join Northwind..Orders as O
on O.CustomerID = C.CustomerID
where O.CustomerID is null 

--33. Oblicz iloœæ klientów z min.1 zamówieniem i bez zamówienia.
select 
(
select COUNT(*) xd from Northwind..Customers 
) -
(
select count(*) none_orders
from Northwind..Customers as C
left join Northwind..Orders as O
on O.CustomerID = C.CustomerID
where O.CustomerID is null 
) as Min_1_orders
,
(
select count(*) none_orders
from Northwind..Customers as C
left join Northwind..Orders as O
on O.CustomerID = C.CustomerID
where O.CustomerID is null 
) as none_orders

--34. Wyœwietl informacje o pierwszym i ostatnim zamówieniu.
select * from 
	(select TOP 1 O.OrderID, O.CustomerID, O.OrderDate, 
	sum(OD.UnitPrice*OD.Quantity) as Value, 
	COUNT(*) as number_of_items 
	from Northwind..Orders as O
	inner join Northwind..[Order Details] as OD on O.OrderID = OD.OrderID
	group by O.OrderID, O.CustomerID, O.OrderDate
	ORDER BY OrderDate DESC, O.OrderID desc) as tablea

UNION ALL

select * from
	(select TOP 1 O.OrderID, O.CustomerID, O.OrderDate, 
	sum(OD.UnitPrice*OD.Quantity) as Value, 
	COUNT(*) as number_of_items 
	from Northwind..Orders as O
	inner join Northwind..[Order Details] as OD on O.OrderID = OD.OrderID
	group by O.OrderID, O.CustomerID, O.OrderDate
	ORDER BY OrderDate ASC, O.OrderID ASC) as tableb


   

--35. View the customers who placed the highest number of orders.
create view QuantityOfOrders as 
select CustomerID, COUNT(*) QuantityOfOrders from Northwind..Orders
group by CustomerID

select * from QuantityOfOrders
order by 2 DESC
