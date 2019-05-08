-- creates a 'hidden' customer table with only those customer ids appearing in the line item table
-- then creates a DimCustomer with customer names if they exist.

if object_id('__DimCustomer') is not NULL
	drop table __DimCustomer
if object_id('DimCustomer') is not NULL
	drop view DimCustomer


select distinct(co1.[Customer ID]) into __DimCustomer from co_lineitem('1') co1
alter table __DimCustomer add CustID INT IDENTITY;
go

create view DimCustomer as
	select dc.CustID, dc.[Customer ID],
		ISNULL(cu.[Customer Name],concat('Customer ID: ', dc.[Customer ID])) [Customer Name]
	from __DimCustomer dc
	left join Customer cu on dc.[Customer ID] = cu.[Customer ID]