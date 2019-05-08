-- makes FactLineItem
if object_id('FactLineItem') is not NULL
	drop table FactLineItem
--if object_id('CustDate') is not NULL
	--drop index CustDate on FactLineItem

select do.OrderID, cu.CustID, convert(DATE, li.[Order date],101) [OrderDate], pr.ProdID,
		li.[Total Cost], li.[Total Price], li.[Unit Cost], li.[Unit Price]
	into FactLineItem
	from co_lineitem('1') li
	left join DimCustomer cu on li.[Customer ID] = cu.[Customer ID]
	left join DimPRoduct pr on li.[Product code] = pr.[Product code]
	left join DimOrder do on li.[Order ID] = do.[Order ID]

create index CustDate on FactLineItem(CustID, OrderDate)