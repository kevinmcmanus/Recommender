
import numpy as np
import pandas as pd
from scipy.sparse import coo_matrix

class Recommender:
	"""
	methods and functions to make product recommendations based
	on market basket analysis
	"""

	def __init__(self, pclpath):
		"""
		initializes recommender object by loading up summary files
		"""
		import pickle
		import os

		#get the product dimension:
		self.products = pd.read_pickle(pclpath+os.sep+'DimProduct.pcl').set_index('Product Code')

		# product categories
		self.categories = pd.read_pickle(pclpath+os.sep+'ProductCategories.pcl')

		# Market basket summary
		self.marketbasketsummary = pd.read_pickle(pclpath+os.sep+'MarketBasketSummary.pcl')

		# load the antecedent/consequent lift and confidence into sparse arrays.
		ncat = len(self.categories) # shape of the associations
		self.ac_lift = coo_matrix((self.marketbasketsummary.ACLift,
							 (self.marketbasketsummary.Antecedent-1,
							  self.marketbasketsummary.Consequent-1)),
							  (ncat, ncat))
		self.ac_confidence = coo_matrix((self.marketbasketsummary.ACConfidence,
						(self.marketbasketsummary.Antecedent-1,
						self.marketbasketsummary.Consequent-1)),
						(ncat, ncat))

	def __repr__(self):
		"""
		stringifies the recommender
		"""
		s = 'Recommender object with '\
			'{0:d} products, ' \
			'{1:d} categories and ' \
			'{2:d} association rules'.format(len(self.products),len(self.categories),len(self.marketbasketsummary))
		return s

	def __len__(self):
		return len(self.marketbasketsummary)

	def recommend(self, mb_dict, min_confidence = 0.10, Nrecs=None):
		"""
		makes recommendations for the products in mb_dict
		mb_dict: dictionary of Product Code, weight pairs
		"""

		# get the antecedent categories for the input product codes
		p_codes = mb_dict.keys()
		ant_cats = self.products.loc[p_codes].CategoryID-1

		#make sparse version of weights (shape ncat x 1)
		ncat = self.ac_lift.shape[0]
		w = np.array([v for v in mb_dict.values()]) #weights
		r = np.array([c for c in ant_cats]) #category indices
		c = np.zeros_like(r) #column indices, all 0 (first column)
		weights = coo_matrix((w,(r,c)),shape = (ncat,1))

		# mask out the associations below minimum confidence
		m_lift = self.ac_lift.multiply(self.ac_confidence >= min_confidence)

		# multiply the consequents by the weights and get those for the antecedents
		cons = m_lift.multiply(weights)[np.unique(r)].todense()

		# summarize across antecedents
		w_cons = cons.sum(axis=0) #doesn't flatten since cons is a matrix
		w_cons = np.squeeze(np.asarray(w_cons)) #it's flat now!

		# put the recommendations into an easy to consume data frame and order it by ac_lift
		df = pd.DataFrame({	'CategoryID':self.categories.CategoryID,
							'ConsequentCategory':self.categories.Category,
							'AC_Lift': w_cons})
		df = df.sort_values('AC_Lift', ascending=False)

		# how many recommendations to return?
		if Nrecs is None:
			Nrecs = ncat # all of them

		return df.iloc[:Nrecs].to_dict('records')

def args_to_mb(plist,rec: Recommender):
    """
    Converts url argument of form &Product=pcode,share to a market basket dict
    of the form pcode:share with some error checking along the way
    """
    mb = {}
    result = {'ValidInputs':[], 'Errors':[]}
    for p in plist:
        try:
            pcode, share = p.split(',')
        except:
            result['Errors'].append(f'Invalid Product Specification: {p}, probably missing \',<share>\'')
            continue

        try:
            p = rec.products.loc[pcode]
        except:
            result['Errors'].append(f'Invalid Product Code: {pcode}')
            continue

        try:
            s=float(share)
        except:
            result['Errors'].append(f'Invalid Product Share for Product: {pcode}, Share: {share}')
            continue
        
        result['ValidInputs'].append(f'{pcode}: {p["Product Description"]}')
        mb[pcode]=float(s)

    result['MarketBasket'] = mb
    return result

if __name__ == "__main__":

    pclpath = r"C:\Users\kevin\Documents\Research\Recommender\Recommender\pickled"
    r = Recommender(pclpath)
    argl = ['H11782000-V6-26631,0.443',
        '00021200724077-DV2-31196,0.218',
        '720360MMX1000PK,0.097',
        '3M691181PK,0.083',
        '00051128558379-31196,0.054',
        '3M1350FB-52505,0.037',
        '720341MMX1000PK,0.035',
        '7203762MMX1000PK-,0.033']

    res = args_to_mb(argl,r)
    print(res)

    mb = {
			#'00021200724077-DV2-31196':0.6606000107692117,
			#'3M691181PK':0.33939998923078835
#			'3M691181PK':1.00
			"H11782000-V6-26631": 0.443,
			"00021200724077-DV2-31196": 0.218,
			"720360MMX1000PK": 0.097,
			"3M691181PK": 0.083,
			"00051128558379-31196": 0.054,
			"3M1350FB-52505": 0.037,
			"720341MMX1000PK": 0.035,
			"7203762MMX1000PK-": 0.033

		}

    print(r)
    print(len(r))

    print(r.recommend(mb, Nrecs=10))