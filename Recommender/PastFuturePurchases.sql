declare @custid int
declare @order_date date

set @custid = 4327 -- Sanyo
set @order_date='2013-08-29'


select li.ProdID, count(*) NPurchases
from FactLineItem li
where li.CustID = @custid and li.OrderDate >= DateADD(Month, -6, @order_date) and li.OrderDate <= @order_date
group by li.ProdID
order by li.ProdID

--select distinct orderdate from FactLineItem where CustID=4327

--select @order_date, DateADD(Month, -6, @order_date) 'six months'
select li.ProdID, count(*) NPurchases
from FactLineItem li
where li.CustID = @custid and li.OrderDate >= dateadd(day,1,@order_date) and li.OrderDate <= DateADD(Month, 6, @order_date)
group by li.ProdID
order by li.ProdID


