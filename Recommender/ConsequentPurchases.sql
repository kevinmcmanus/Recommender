
with custs as 
(
select top 100 * from DimCustomer
)
,lines as 
	(
	select f.* from FactLineItem f
	inner join custs c on f.CustID = c.CustID
	)

select l.CustID, l.ProdID Antecedent, l.OrderDate AntecedentOrderDate,
		 p.ProdID Consequent, p.OrderDate ConsequentOrderDate,
		 DATEDIFF(Day, l.OrderDate, p.OrderDate) 'NDays'
from lines l
cross apply GetLaterPurchases(l.CustID,l.OrderDate, DATEADD(day, 120, l.OrderDate)) p
order by l.CustID, l.OrderDate, p.OrderDate
