use Recommender
go


CREATE PROCEDURE [dbo].[co_lineitem]
	@co_param nvarchar(8) = '1'

AS
	SELECT * from lineitem where Company = @co_param
RETURN 0
