--execute MakeConsequentPurchases 

declare @TotNCust float

select @TotNCust = cast(count(distinct CustID) as float) from FactLineItem

;with ProdSupport as (
	select li.CategoryID, count(distinct CustID) NCust,
		cast(count(distinct CustID) as float)/@TotNCust 'Support'
	from FactLineItem li
	group by CategoryID
	),
AntConSupport as	(
	select acc.Antecedent, acc.Consequent,
		ant.NCust AntecedentCustomers, ant.Support AntecedentSupport,
		con.NCust ConsequentCustomers, con.Support ConsequentSupport,
		acc.NCust ACCustomers, cast(acc.Ncust as float)/@TotNCust 'ACSupport'
	 from AntecedentConsequentCounts acc
	 left join ProdSupport ant on acc.Antecedent = ant.CategoryID
	 left join ProdSupport con on acc.Consequent = con.CategoryID
	 )

select pca.Category Antecendent, acs.AntecedentSupport,
		pcc.Category Consequent, acs.ConsequentSupport,
		acs.ACSupport,
		acs.ACSupport/acs.AntecedentSupport ACConfidence,
		acs.ACSupport/(AntecedentSupport*ConsequentSupport) ACLift,
		cast(acs.ACCustomers as float)/cast((acs.AntecedentCustomers+acs.ConsequentCustomers-acs.ACCustomers) as float) ACJaccard
from AntConSupport acs
left join ProductCategories pca on acs.Antecedent = pca.CategoryID
left join ProductCategories pcc on acs.Consequent = pcc.CategoryID
where acs.AntecedentCustomers >= 200 and acs.ConsequentCustomers >= 100
order by Antecedent, ACJaccard desc