CREATE FUNCTION [dbo].[SampleCustomers]
(
	@pct int,
	@randval float
)
RETURNS TABLE AS RETURN
(
	SELECT *
	from DimCustomer
	WHERE (ABS(CAST(
		  (BINARY_CHECKSUM(*) *
		  @randval) as int)) % 100) < @pct
)
