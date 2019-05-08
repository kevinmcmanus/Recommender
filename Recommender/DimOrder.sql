-- creates a 'hidden' order table with only those order ids appearing in the line item table
-- then creates a DimOrder with product names if they exist.

if object_id('__DimOrder') is not NULL
	drop table __DimOrder
if object_id('DimOrder') is not NULL
	drop view DimOrder


select distinct(co1.[Order ID]) into __DimOrder from co_lineitem('1') co1
alter table __DimOrder add OrderID INT IDENTITY;
go


create view DimOrder as

	select * from __DimOrder