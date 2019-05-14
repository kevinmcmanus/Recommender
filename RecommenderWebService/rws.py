from flask_restful import Resource, Api
from flask_restplus import reqparse
from flask_jwt import JWT, jwt_required

from recommender import Recommender, args_to_mb, args_to_params


class rws(Resource):
    """
    class for running the recommender web service
    """

    #@jwt_required()
    def get(self):
        args = parser.parse_args()
        params = args_to_params(args)
        result = args_to_mb(args['Product'], recom)
        result['Recommendations'] = recom.recommend(result['MarketBasket'],
                                        min_confidence = params['MinConfidence'],
                                        min_support = params['MinSupport'],
                                        NRecs = params['NRecs'])
        return result

# user authentication stuff
USER_DATA = {
    "Kevin": "abc123"
}
class User(object):
    def __init__(self, id):
        self.id = id

    def __str__(self):
        return "User(id='%s')" % self.id


def verify(username, password):
    if not (username and password):
        return False
    if USER_DATA.get(username) == password:
        return User(id=123)


def identity(payload):
    user_id = payload['identity']
    return {"user_id": user_id}

def config_jwt(app):
    app.config['SECRET_KEY'] = 'super-secret'
    # global jwt?
    jwt = JWT(app, verify, identity)


#some globals needed by the application
parser = reqparse.RequestParser()
parser.add_argument('Product',required=True, help="Must have at least one product", action='append')
parser.add_argument('MinSupport', help="Minimum Support Level")
parser.add_argument('MinConfidence', help="Minimum Confidence Level")
parser.add_argument('NRecs', help="Number of recommendations to return")

pclpath = r"C:\Users\kevin\Documents\Research\Recommender\Recommender\pickled"
recom = Recommender(pclpath)
	