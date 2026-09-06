--1
select *  
from dbo.Central_Superstore


--2
Create table Customers(
	Customer_ID varchar(50) Primary Key,
	Customer_Name varchar(50),
	Segment varchar(50)
)


--3
Insert into Customers (Customer_ID , Customer_Name , Segment)
	select distinct (Customer_ID) , Customer_Name , Segment
	from dbo.Central_Superstore


--4
select *
from Customers


--5
Create table Products(
	Product_ID varchar(50) Primary Key,
	Product_Name varchar(150) not null,
	Category varchar(50) not null,
	Sub_Category varchar(50) not null,
)


--6
insert into Products(Product_ID , Product_Name , Category , Sub_Category)
	select Product_ID , max(Product_Name) , max(Category) , max(Sub_Category)
	from dbo.Central_Superstore
	group by Product_ID


--7
select *
from Products


--8
Create table Location(
	ID int Primary key,
	Country varchar(50) Not Null,
	City varchar(50) Not Null,
	State varchar(50) Not Null,
	Postal_Code varchar(50) Not Null,
	Region varchar(50) Not Null
)


--9
Drop table Location


--10
Create table Location(
	ID int identity(1,1) Primary key,
	Country varchar(50) Not Null,
	City varchar(50) Not Null,
	State varchar(50) Not Null,
	Postal_Code varchar(50),
	Region varchar(50)
)


--11
insert into Location(Country , City , State , Postal_Code , Region)
	select Country , City , State , Postal_Code , Region
	from dbo.Central_Superstore


--12
select *
from Location


--13
Create table Date(
	ID int identity(1,1) primary key,
	Order_Date Date Not Null,
	Year int not null,
	Month int not null,
	Month_Name varchar(20) Not Null,
	Day int not null,
	Day_Name varchar(20) Not Null
)


--14
insert into Date(Order_Date , Year , Month , Month_Name , Day , Day_Name)
	select Order_Date , YEAR(Order_Date) 'Year' , MONTH(Order_Date) 'Month' , DATENAME(MONTH , Order_Date) 'Month Name' , DAY(Order_Date) 'Day' , DATENAME(WEEKDAY , Order_Date) 'Day Name'
	from dbo.Central_Superstore


--15
select *
from Date


--16
create table Connections(
	ID int primary key identity(1,1),
	Customer_for varchar(50) not null,
	Product_for varchar(50) not null,
	Location_ID int not null,
	Date_ID int not null,
	foreign key (Customer_for) References Customers(Customer_ID),
	foreign key (Product_for) References Products(Product_ID),
	foreign key (Location_ID) References Location(ID),
	foreign key (Date_ID) References Date(ID)
)


--17
insert into Connections (Customer_for , Product_for, Location_ID, Date_ID)
	select c.Customer_ID 'Customer_for' , p.Product_ID 'Product_for' , l.ID 'Location_ID', d.ID 'Date_ID' 
	from dbo.Central_Superstore cs
	join Customers c on c.Customer_ID = cs.Customer_ID
	join Products p on p.Product_ID = cs.Product_ID
	join Location l on l.Country = cs.Country and l.City = cs.City and l.Postal_Code = cs.Postal_Code and l.Region = cs.Region and l.State = cs.State
	join Date d on d.Order_Date = cs.Order_Date


--18
select Customer_ID , avg(Quantity) 'average Qty' , Sum(Sales*Quantity) 'Total Sales'
from Central_Superstore
group by Customer_ID
Order by Sum(Sales*Quantity) desc , avg(Quantity) desc


--19
Create View Sales as
	select Customer_ID , avg(Quantity) 'average Qty' , Sum(Sales*Quantity) 'Total Sales'
	from Central_Superstore
	group by Customer_ID


--20
Create view State_Customer as
	select Customer_ID , sum(Sales*Quantity) 'Total Sales' ,
	case
		when sum(Sales*Quantity) > 10000 then 'VIP'
		when sum(Sales*Quantity) > 5000 then 'Large'
		when sum(Sales*Quantity) > 2000 then 'Medium'
		else 'Low'
	end 'State_Customer'
	from Central_Superstore
	group by Customer_ID


--21
with Customer_total as(
	select Customer_Name , Segment , count(*) 'total Order' 
	from Customers c
	join Connections co on c.Customer_ID = co.Customer_for
	group by Customer_Name , Segment
)
select * from Customer_total


--22
with Product_Date as(
	select count (*) 'Total Order' , Product_Name , Category , Year , Month , Month_Name
	from Products p
	join Connections c on p.Product_ID = c.Product_for
	join Date d on d.ID = c.Date_ID
	group by Product_Name , Year  , Category , Month , Month_Name
)
select * from Product_Date


--23
select Product_Name , Category , Sub_Category
from Products
where Product_ID IN (
	select Product_for
	from Connections
	where Date_ID IN (
		select ID 
		from Date
		where Year = 2013
	)
)


--24
Create Procedure Order_by_Year @year int
as
begin
	select Count(*) 'Total Orders' , Product_Name
	from Products
	join Connections on Product_for = Product_ID
	join Date on Date_ID = Date.ID
	where Year = @year
	group by Product_Name
end

exec Order_by_Year @year = 2014


--25
select p.Category , Sum(Sales) 'Total Sales' , Sum(Profit) 'Total Profit' , ROUND((Sum(Profit) / Sum(Sales)) * 100 ,2) 'Percentage'
from Connections c
join Products p on Product_ID = Product_for
join Central_Superstore on Customer_ID = Customer_for
group by p.Category


--26
select l.Region , Sum(Sales)
from Connections c
join Location l on c.ID = Location_ID
join Central_Superstore cs on c.Customer_for = cs.Customer_ID
group by l.Region


--27
select count (*) 'Total Order' , Product_Name , Category , Year , Month , Month_Name
from Products p
join Connections c on p.Product_ID = c.Product_for
join Date d on d.ID = c.Date_ID
group by Product_Name , Year  , Category , Month , Month_Name
Order by Year ASC , Month ASC


--28
select Customer_ID , sum(Sales*Quantity) 'Total Sales' ,
case
	when sum(Sales*Quantity) > 10000 then 'VIP'
	when sum(Sales*Quantity) > 5000 then 'Large'
	when sum(Sales*Quantity) > 2000 then 'Medium'
	else 'Low'
end 'State_Customer'
from Central_Superstore
group by Customer_ID
