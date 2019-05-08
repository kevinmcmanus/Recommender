CREATE PROCEDURE [dbo].[MakeConsequentPurchases]
	@samplepct int = 10,
	@rseed int = 1234
AS BEGIN
	declare @rval float
	set @rval = rand(@rseed)

	-- clean out the various tables
	delete from FactUniquePurchases
	delete from CustomerAntecedentConsequent
	delete from AntecedentConsequentCounts

	-- repopulate with purchase records from the sampled customers
	insert into FactUniquePurchases 
		select distinct li.CustID, li.OrderDate, li.ProdID
		from       FactLineItem li
		inner join SampleCustomers(@samplepct, @rval) sc on sc.CustID = li.CustID

	-- load up the Customer Antecedent Consequent table
	insert into CustomerAntecedentConsequent
		select l.CustID, l.ProdID Antecedent, l.OrderDate AntecedentOrderDate,
				 p.ProdID Consequent, p.OrderDate ConsequentOrderDate,
				 DATEDIFF(Day, l.OrderDate, p.OrderDate) 'NDays'
		from FactUniquePurchases l
		cross apply GetLaterPurchases(l.CustID,l.OrderDate, DATEADD(day, 120, l.OrderDate)) p

	-- update the counts table
	insert into AntecedentConsequentCounts
		select cac.Antecedent, cac.Consequent, count(distinct cac.CustID) NCust
		from CustomerAntecedentConsequent cac
		group by cac.Antecedent, cac.Consequent

END

RETURN 0