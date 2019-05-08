CREATE TABLE [dbo].[DimProduct]
(
	[ProdID] INT NOT NULL PRIMARY KEY, 
    [Company] NCHAR(8) NULL, 
    [Primary Code] NCHAR(64) NULL, 
    [Primary Description] NCHAR(128) NULL, 
    [Secondary Code] NCHAR(64) NULL, 
    [Secondary Description] NCHAR(128) NULL, 
    [Product Code] NCHAR(64) NULL, 
    [Produce Description] NCHAR(128) NULL, 
    [Supplier] NCHAR(128) NULL, 
    [CategoryID] INT NULL, 
    [Category] NCHAR(128) NULL
)
