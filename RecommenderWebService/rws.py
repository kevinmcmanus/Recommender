from flask_restful import Resource, Api
from flask_restplus import reqparse

from recommender import Recommender, args_to_mb


class rws(Resource):
    """
    class for running the recommender web service
    """

    def get(self):
        args = parser.parse_args()
        result = args_to_mb(args['Product'], recom)
        result['Recommendations'] = recom.recommend(result['MarketBasket'],Nrecs=5)
        return result



#some globals needed by the application
parser = reqparse.RequestParser()
parser.add_argument('Product',required=True, help="Must have at least one product", action='append')


pclpath = r"C:\Users\kevin\Documents\Research\Recommender\Recommender\pickled"
recom = Recommender(pclpath)
	