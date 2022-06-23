AdventureWorks2008R2 Data Exploration

Skills used: select, where, joins, order by, top, between, like, aggregate function, having, CTE, TOP, date functions, tempt table, declare, union, round, case

--1. Show the first 10 employees whose surnames are "Anderson"
select TOP 10 
FirstName, LastName 
from AdventureWorks2008R2.Person.Person
where LastName = 'anderson'

--2 . View all employees.
select firstname,lastname,PersonType from AdventureWorks2008R2.Person.Person
where PersonType = 'em' --employee
or PersonType = 'sp'  --salesperson

--3 . View a list of positions in the company.
select distinct JobTitle from AdventureWorks2008R2.HumanResources.Employee

--4 . View all female employees.
select E.BusinessEntityID, E.Gender, P.FirstName, P.LastName, P.PersonType
from AdventureWorks2008R2.HumanResources.Employee as E
inner join AdventureWorks2008R2.Person.Person as P
on E.BusinessEntityID = P.BusinessEntityID
where Gender = 'F'
and 
(P.PersonType = 'em'  or P.PersonType = 'sp')

--5. Poka¿ wszystkie produkty.
select Name  from AdventureWorks2008R2.Production.Product

--6. Poka¿ listê sklepów.
select Name from AdventureWorks2008R2.Sales.Store

--7. Poka¿ pracowników którzy maj¹ ponad 50 lat.
select E.BusinessEntityID, E.Gender, P.FirstName, P.LastName, P.PersonType, E.BirthDate, DATEDIFF(year,E.BirthDate,'2016-01-01') as AGE
from AdventureWorks2008R2.HumanResources.Employee as E
inner join AdventureWorks2008R2.Person.Person as P
on E.BusinessEntityID = P.BusinessEntityID
where (P.PersonType = 'em'  or P.PersonType = 'sp') 
and DATEDIFF(year,E.BirthDate,'2016-01-01') > 50
order by AGE desc 

--8. Wyœwietl ID oraz iloœæ pozycji zamówienia o najwiêkszej iloœci pozycji.
select TOP 1 SalesOrderID, COUNT(*) Quantity from AdventureWorks2008R2.Sales.SalesOrderDetail
group by SalesOrderID
order by 2 DESC

--9. Wyœwietl informacje o zamówieniu (ID zamówienia , Wartoœæ zamówienia) o najwiêkszej wartoœci.
select TOP 1 SalesOrderID, sum(unitprice*orderqty) Value from AdventureWorks2008R2.Sales.SalesOrderDetail
group by SalesOrderID
order by 2 DESC

--10. Poka¿ ostatnie zamówienie dla ka¿dego klienta.
select t1.CustomerID, t1.OrderID, t2.OrderDate from 
(
select CustomerID, max(SalesOrderID) as OrderID from AdventureWorks2008R2.Sales.SalesOrderHeader
group by CustomerID
) as t1
inner join AdventureWorks2008R2.Sales.SalesOrderHeader as t2 
on t1.OrderID = t2.SalesOrderID
order by CustomerID 

--11. Oblicz ile zamówieñ z³o¿y³ ka¿dy z klientów.
select CustomerID, COUNT(*) number_of_orders from adventureWorks2008R2.Sales.SalesOrderHeader
group by CustomerID

--12. Wyœwietl sprzedawców (10) którzy obs³u¿yli najwiêksz¹ iloœæ zamówieñ.
select TOP 10 SalesPersonID, COUNT(*) as number_of_orders from adventureWorks2008R2.Sales.SalesOrderHeader
where SalesPersonID is not null
group by SalesPersonID
order by 2 DESC

--13. Wyœwietl sprzedawcê który obs³u¿y³ zamówienia o najwiêkszej wartoœci.
select TOP 1 t2.SalesPersonID, sum(t1.UnitPrice*t1.OrderQty) as Price, t3.FirstName, t3.LastName 
from AdventureWorks2008R2.Sales.SalesOrderDetail as t1
inner join AdventureWorks2008R2.Sales.SalesOrderHeader as t2
on t1.SalesOrderID = t2.SalesOrderID
inner join AdventureWorks2008R2.Person.Person as t3
on t2.SalesPersonID = t3.BusinessEntityID
group by t2.SalesPersonID, t3.FirstName, t3.LastName
order by 2 DESC

--14. Oblicz œredni¹ wartoœæ zamówieñ.
select AVG(unitprice*orderqty) avg from AdventureWorks2008R2.Sales.SalesOrderDetail

--15. Oblicz czy wartoœæ zamówienia jest poni¿ej czy powy¿ej, œredniej wartoœæ zamówieñ.
select *, 
(case 
	when Value > avg then 'more than avg' 
	else 'less than avg' 
	end) as 'less/more'
from
(
select SalesOrderID, sum(unitprice*orderqty) Value , (select AVG(unitprice*orderqty) avg from AdventureWorks2008R2.Sales.SalesOrderDetail) as Avg
from AdventureWorks2008R2.Sales.SalesOrderDetail
group by SalesOrderID
) as t1
order by SalesOrderID 


--16. Oblicz wartoœæ wszystkich zamówieñ z paŸdziernika 2005.
select round(SUM(linetotal), 2) as total from AdventureWorks2008R2.Sales.SalesOrderDetail as t1
inner join AdventureWorks2008R2.Sales.SalesOrderHeader as t2
on t1.SalesOrderID = t2.SalesOrderID
where YEAR(t2.OrderDate) = 2005
and MONTH(t2.OrderDate) = 10

--17. Wyœwietl s³u¿bowe numery telefonów pracowników.
select t1.LastName, t1.FirstName, t2.PhoneNumber, t3.Name  from AdventureWorks2008R2.Person.Person as t1
inner join AdventureWorks2008R2.Person.PersonPhone as t2
on t1.BusinessEntityID = t2.BusinessEntityID
inner join AdventureWorks2008R2.Person.PhoneNumberType as t3
on t2.PhoneNumberTypeID =t3.PhoneNumberTypeID
where t3.Name = 'work'
order by 1

--18. Wyœwietl zamówienia które maj¹ tylko po jednej pozycji.
select SalesOrderID, COUNT(*) number_of_postiion from AdventureWorks2008R2.Sales.SalesOrderDetail
group by SalesOrderID
having COUNT(*) = 1
order by 1

--19. Wyœwietl 5 zamówieñ które maj¹ najwiêcej pozycji. Wyniki posortuj malej¹co wg iloœci pozycji.
select top 5 SalesOrderID, COUNT(*) number_of_postiion from AdventureWorks2008R2.Sales.SalesOrderDetail
group by SalesOrderID
order by 2 DESC

--20. Policz ilu pracowników pracuje w ka¿dym dziale. Wyniki posortuj wg iloœci pracowników malej¹co.
select t2.Name, COUNT(*) as number_of_employees  from AdventureWorks2008R2.HumanResources.EmployeeDepartmentHistory as t1
inner join AdventureWorks2008R2.HumanResources.Department as t2
on t1.DepartmentID = t2.DepartmentID
where t1.EndDate is null
group by t2.Name
order by 2 DESC	

--21. Która kategoria zawiera najwiêcej produktów.
select t3.Name,  COUNT(*) as quantity 
from AdventureWorks2008R2.Production.Product as t1
left join AdventureWorks2008R2.Production.ProductSubcategory as t2
on t1.ProductSubcategoryID = t2.ProductSubcategoryID
left join AdventureWorks2008R2.Production.ProductCategory as t3
on t2.ProductCategoryID = t3.ProductCategoryID
group by t3.Name

--22. Wyœwietl informacje o zamówieniach z grudnia 2005 r. U¿yj funkcji OVER(Partition by).
select 
t1.SalesOrderID, t1.OrderQty, t1.UnitPrice, round(t1.OrderQty*t1.UnitPrice,2) subOrderValue, t1.ProductID, t2.OrderDate,
round(SUM(t1.OrderQty*t1.UnitPrice) over (partition by t1.salesorderID),2) OrderValue,
count(*) over (partition by t1.salesorderID) number_of_position,
sum(t1.orderqty) over (partition by t1.salesorderID) quantyity_in_order
from AdventureWorks2008R2.Sales.SalesOrderDetail as t1
inner join AdventureWorks2008R2.Sales.SalesOrderHeader as t2
on t1.SalesOrderID = t2.SalesOrderID
where YEAR(t2.OrderDate) = 2005
and MONTH(t2.OrderDate) = 12

--23. Policz produkty wg modeli. Wyniki posortuj malej¹co wg liczby produktów danego modelu.
select t1.Name, COUNT(*) as number  from AdventureWorks2008R2.Production.ProductModel as t1
right join AdventureWorks2008R2.Production.Product as t2
on t1.ProductModelID = t2.ProductModelID
group by t1.Name
order by 2 DESC

--24. Oblicz sumê zamówieñ o najwiêkszej i najmniejszej wartoœci.
Select 
(
select TOP 1 round(sum(UnitPrice*OrderQty),2) as Value from AdventureWorks2008R2.Sales.SalesOrderDetail
group by SalesOrderID
order by 1 DESC
)
+
(
select TOP 1 round(sum(UnitPrice*OrderQty),2) as Value from AdventureWorks2008R2.Sales.SalesOrderDetail
group by SalesOrderID
order by 1 ASC
) as 'Max+MinValue'

--25. Oblicz œredni¹ wartoœæ zamówieñ.
select AVG(Value) as 'avgValue' from
(
select  round(sum(UnitPrice*OrderQty),2) as Value from AdventureWorks2008R2.Sales.SalesOrderDetail
group by SalesOrderID
) as t1

--26. Oblicz czy wartoœæ zamówienia jest mniejsza czy wiêksza/równa œredniej wartoœæ zamówieñ.
WITH CTE (SalesOrderID, Value, Avg)
as
(
select SalesOrderID, sum(unitprice*orderqty) Value , (select AVG(unitprice*orderqty) avg from AdventureWorks2008R2.Sales.SalesOrderDetail) as Avg
from AdventureWorks2008R2.Sales.SalesOrderDetail
group by SalesOrderID
)
select *,
(case
	when Value >= Avg then 'more or equals'
	else 'less'
	end 
) as column4
from CTE

--DECLARE 
declare @avg float;
set @avg = (select AVG(unitprice*orderqty) avg from AdventureWorks2008R2.Sales.SalesOrderDetail)

select salesorderid, sum(unitprice*orderqty) as Value, @avg as avg,
(
case
	when sum(unitprice*orderqty) >= @avg then 'more or equals'
	else 'less'
	end
) as column4
from AdventureWorks2008R2.Sales.SalesOrderDetail 
group by SalesOrderID

--27. Oblicz wartoœæ ka¿dego zamówienia.
select SalesOrderID, sum(unitprice*orderqty) Value 
from AdventureWorks2008R2.Sales.SalesOrderDetail
group by SalesOrderID

--28. ZnajdŸ pierwsze i ostatnie zamówienie.
select * from
(
select top 1 t1.SalesOrderID, max(t2.OrderDate) AS DATE, SUM(t1.UnitPrice*t1.OrderQty) as Value
from AdventureWorks2008R2.Sales.SalesOrderDetail as t1
inner join AdventureWorks2008R2.Sales.SalesOrderHeader as t2
on t1.SalesOrderID = t2.SalesOrderID
group by t1.SalesOrderID
order by 1 ASC, 2 DESC
) AS T1

UNION ALL

select * from
(
select top 1 t1.SalesOrderID, max(t2.OrderDate) as Date, SUM(t1.UnitPrice*t1.OrderQty) as Value
from AdventureWorks2008R2.Sales.SalesOrderDetail as t1
inner join AdventureWorks2008R2.Sales.SalesOrderHeader as t2
on t1.SalesOrderID = t2.SalesOrderID
group by t1.SalesOrderID
order by 1 DESC, 2 DESC
) AS T2

-- 29. Zaprezentuj zestawienie sprzeda¿y w latach (wg liczby zamówieñ i wartosci)
select YEAR(t1.orderdate) as year , COUNT(*) as number_of_orders, round(SUM(t2.unitprice*t2.OrderQty),2) as Value
from AdventureWorks2008R2.Sales.SalesOrderHeader as t1
inner join AdventureWorks2008R2.Sales.SalesOrderDetail as t2
on t1.SalesOrderID = t2.SalesOrderID
group by YEAR(t1.OrderDate)
order by 2 DESC

--30. Oblicz sumê wartoœci pierwszego i ostatniego zamówienia.
select 'Sum of first and last order', SUM(value) from
(
select * from 
(
select top 1 round(SUM(t1.UnitPrice*t1.OrderQty),2) as Value
from AdventureWorks2008R2.Sales.SalesOrderDetail as t1
inner join AdventureWorks2008R2.Sales.SalesOrderHeader as t2
on t1.SalesOrderID = t2.SalesOrderID
group by t1.SalesOrderID, t2.OrderDate
order by t1.SalesOrderID, t2.OrderDate
) AS T1

union all

select * from 
(
select top 1 round(SUM(t1.UnitPrice*t1.OrderQty),2) as Value
from AdventureWorks2008R2.Sales.SalesOrderDetail as t1
inner join AdventureWorks2008R2.Sales.SalesOrderHeader as t2
on t1.SalesOrderID = t2.SalesOrderID
group by t1.SalesOrderID, t2.OrderDate
order by t1.SalesOrderID DESC, t2.OrderDate DESC
) AS T2
) as t3

--31. Wyœwietl klientów którzy z³o¿yli najwiêksz¹ liczbê zamówieñ. Policz tylko te zamówienia które s¹ zwi¹zane z jakimœ sklepem
DECLARE @number float;
set @number = 
(
select TOP 1 COUNT(*) number_of_orders 
from AdventureWorks2008R2.Sales.SalesOrderHeader as t1
inner join AdventureWorks2008R2.Sales.Customer as t2
on t1.CustomerID = t2.CustomerID
inner join AdventureWorks2008R2.Sales.Store as t3
on t2.StoreID = t3.BusinessEntityID
group by t1.CustomerID, t3.Name
order by 1 DESC
)

select t1.CustomerID, t3.Name, COUNT(*) number_of_orders 
from AdventureWorks2008R2.Sales.SalesOrderHeader as t1
inner join AdventureWorks2008R2.Sales.Customer as t2
on t1.CustomerID = t2.CustomerID
inner join AdventureWorks2008R2.Sales.Store as t3
on t2.StoreID = t3.BusinessEntityID
group by t1.CustomerID, t3.Name
having COUNT(*) = @number
order by 3 DESC

--32. Jak prezentowa³a siê liczba zamówieñ w poszczególnych latach dla sklepu „Twin Cycles”
select year(t1.OrderDate) as year, t3.Name, COUNT(*) as number
from AdventureWorks2008R2.Sales.SalesOrderHeader as t1
inner join AdventureWorks2008R2.Sales.Customer as t2
on t1.CustomerID = t2.CustomerID
inner join AdventureWorks2008R2.Sales.Store as t3
on t2.StoreID = t3.BusinessEntityID
where t3.Name like 'twin%'
group by YEAR(t1.OrderDate), t3.Name

--33. Wyœwietl zamówienia (najmniejsza i najwiêksza wartoœæ + ich suma) 
DROP TABLE IF EXISTS temptable
create table temptable
(
info varchar(40),
value money
)

insert into temptable
select TOP 1 SalesOrderID, sum(UnitPrice*OrderQty) 
from AdventureWorks2008R2.Sales.SalesOrderDetail
group by SalesOrderID
order by 2 DESC

insert into temptable
select TOP 1 SalesOrderID, sum(UnitPrice*OrderQty) 
from AdventureWorks2008R2.Sales.SalesOrderDetail
group by SalesOrderID
order by 2 ASC

select INFO, ROUND(value,2) as value from
(
select * from temptable
union all
select 'sum', SUM(value) from temptable
) as t1