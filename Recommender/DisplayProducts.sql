select up.ProdID, dpa.[Product Description], count(distinct CustID) Ncust
from FactUniquePurchases up
 join DimProduct dpa on up.ProdID = dpa.ProdID
 where [Product Description] like '%24 v%'
 --where [Product Description] = 'HAK 472D-02 ESD Digital Des. Station w/gun'
group by up.ProdID, dpa.[Product Description]
order by Ncust desc

--select * from DimProduct
--where [Product Description] like '%24 v%'