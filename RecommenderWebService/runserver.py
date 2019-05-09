"""
This script runs the RecommenderWebService application using a development server.
"""

from os import environ
from flask import Flask,request, jsonify
from flask_restful import Resource, Api
#from RecommenderWebService import app
from rws import rws, config_jwt
from flask_restplus import reqparse

app = Flask(__name__)
config_jwt(app)
api = Api(app)
api.add_resource(rws, '/Recommender')

if __name__ == '__main__':
    HOST = environ.get('SERVER_HOST', 'localhost')
    try:
        PORT = int(environ.get('SERVER_PORT', '5555'))
    except ValueError:
        PORT = 5555
 
    app.run(HOST, PORT, debug=True)

