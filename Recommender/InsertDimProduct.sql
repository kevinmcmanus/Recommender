--execute [dbo].[CreateCategories] '1'

--select * from ProductCategories

--create view DimProduct as
	with co1_product as
	(
		select * from co_product('1')
	)
	select ROW_NUMBER() over(order by pr.[Product code]) ProdID,
		pr.*,
		pc.CategoryID,
		pc.Category

	from co1_product pr 
	left join ProductCategories pc on pc.[Primary code] = pr.[Primary Code] and pc.[Secondary code] = pr.[Secondary Code]