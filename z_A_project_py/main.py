# -*- coding: utf-8 -*-
"""
Created on Thu Nov 25 10:35:11 2021

@author: benhu
"""

import pandas as pd
import requests
import json
from datetime import datetime
import downloads as dl
import numpy as np


# load the universe
univ = pd.read_csv('data/univ.csv')


px = dl.download_etfs(univ)


vix = dl.download_vix()

vix = vix.reindex(px.index)
vix = vix[['CLOSE']]

px[('vol','VIX')] = vix



#%%

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


    
    

#%%








#%%
vix = [datenum(tmp.DATE) tmp.CLOSE]; % datestr(vix(end,1))