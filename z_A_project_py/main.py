# -*- coding: utf-8 -*-
"""
Created on Thu Nov 25 10:35:11 2021

@author: benhu
"""

import pandas as pd
import numpy as np
import tree as tree
import downloads as dl

# load the universe
univ = pd.read_csv('data/univ.csv')


px = dl.download_etfs(univ)


vix = dl.download_vix()

vix = vix.reindex(px.index)
vix = vix[['CLOSE']]

px[('vol','VIX')] = vix


X = np.zeros((9,1))
X[0,0] = px[('vol','VIX')].iloc[-1]
X[1,0] = px[('vol','VIX')].pct_change(2).iloc[-1]
X[2,0] = px[('vol','VIX')].pct_change(5).iloc[-1]
X[3,0] = px[('close','SPY')].pct_change(2).iloc[-1]
X[4,0] = px[('close','SPY')].pct_change(5).iloc[-1]
X[5,0] = px[('close','HYG')].pct_change(5).iloc[-1]
X[6,0] = px[('close','HYG')].pct_change(12).iloc[-1]
X[7,0] = px[('close','GLD')].pct_change(5).iloc[-1]
X[8,0] = px[('close','GLD')].pct_change(10).iloc[-1]


W = np.zeros((20,len(univ)))

for i in range(0,11):
    
    W[i,:] = tree.predict(X,i+1)

    
        

X = np.zeros((15,1))
X[0,0] = px[('vol','VIX')].iloc[-1]
X[1,0] = px[('vol','VIX')].pct_change(2).iloc[-1]
X[2,0] = px[('vol','VIX')].pct_change(5).iloc[-1]
X[3,0] = px[('vol','VIX')].pct_change(10).iloc[-1]
X[4,0] = px[('vol','VIX')].pct_change(15).iloc[-1]
X[5,0] = px[('close','SPY')].pct_change(2).iloc[-1]
X[6,0] = px[('close','SPY')].pct_change(5).iloc[-1]
X[7,0] = px[('close','SPY')].pct_change(10).iloc[-1]
X[8,0] = px[('close','SPY')].pct_change(15).iloc[-1]
X[9,0] = px[('close','HYG')].pct_change(5).iloc[-1]
X[10,0] = px[('close','HYG')].pct_change(12).iloc[-1]
X[11,0] = px[('close','HYG')].pct_change(20).iloc[-1]
X[12,0] = px[('close','GLD')].pct_change(5).iloc[-1]
X[13,0] = px[('close','GLD')].pct_change(10).iloc[-1]
X[14,0] = px[('close','GLD')].pct_change(15).iloc[-1]

    
for i in range(11,14):
    
    W[i,:] = tree.predict(X,i+1)
    

X = np.zeros((3,1))
X[0,0] = px[('vol','VIX')].iloc[-1]
X[1,0] = px[('vol','VIX')].iloc[-2]
X[2,0] = px[('vol','VIX')].iloc[-3]

for i in range(14,17):
    
    W[i,:] = tree.predict(X,i+1)


X = np.zeros((9,1))
X[0,0] = px[('vol','VIX')].iloc[-1]
X[1,0] = px[('vol','VIX')].pct_change(2).iloc[-1]
X[2,0] = px[('vol','VIX')].pct_change(5).iloc[-1]
X[3,0] = px[('close','SPY')].pct_change(2).iloc[-1]
X[4,0] = px[('close','SPY')].pct_change(5).iloc[-1]
X[5,0] = px[('close','HYG')].pct_change(5).iloc[-1]
X[6,0] = px[('close','HYG')].pct_change(12).iloc[-1]
X[7,0] = px[('close','GLD')].pct_change(5).iloc[-1]
X[8,0] = px[('close','GLD')].pct_change(10).iloc[-1]  

for i in range(17,19):
    
    W[i,:] = tree.predict(X,i+1)
    
    
i = 19

X = np.zeros((3,1))
X[0,0] = px[('vol','VIX')].pct_change(10).iloc[-1]
X[1,0] = px[('vol','VIX')].pct_change(30).iloc[-1]
X[2,0] = px[('vol','VIX')].iloc[-1]

W[i,:] = tree.predict(X,i+1)


W = W.mean(axis=0)


univ['Weight'] = W

