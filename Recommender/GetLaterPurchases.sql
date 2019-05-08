CREATE FUNCTION [dbo].[GetLaterPurchases]
(
	@CustID int,
	@PurchaseDate Date,
	@MaxDate Date
)
RETURNS TABLE AS RETURN
(
	SELECT f.ProdID, f.OrderDate
	from FactLineItem f where f.CustID = @CustID and f.OrderDate > @PurchaseDate and f.OrderDate <= @MaxDate 
)
