--select top 100 *, checksum(*) as 'CheckSum', rand() from DimCustomer

--select count(*) from DimCustomer

--select * from SampleCustomers(10,rand())

--select count(*) from FactLineItem
--select count(*) from (select distinct CustID, OrderDate, ProdID from FactLineItem) d

--exec MakeConsequentPurchases @param2 = 66

--declare @rval float
--set @rval = rand()
--;with s1 as (
--	select * from SampleCustomers(10, rand())
--	)
--, s2 as (
--	select * from SampleCustomers(10,@rval)
--	)

--select s1.CustID from s1 left join s2 on s1.CustID=s2.CustID
--where s2.CustID is NULL

--execute MakeConsequentPurchases 25, 1234

select dpa.[Product Description] Antecedent,
	   dpc.[Product Description] Consequent,
	   acc.NCust
 from AntecedentConsequentCounts acc
 join DimProduct dpa on acc.Antecedent = dpa.ProdID
 join DimProduct dpc on acc.Consequent = dpc.ProdID
 where acc.Antecedent = 28753
order by NCust desc