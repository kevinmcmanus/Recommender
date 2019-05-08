-- prodsk (surrogate key) only the product ids that appear in the lineitems file

CREATE TABLE [dbo].[ProdSKmapper]
(
	[ProdSK] INT NOT NULL PRIMARY KEY #over only the products that are in the lineitems file
	[ProdID] Int Not NULL # over all of the products in the product catalog
)
