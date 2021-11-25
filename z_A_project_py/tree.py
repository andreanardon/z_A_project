import pandas as pd
import numpy as np


def predict(X,id):
    


    tree = pd.read_csv('data/dtm' + str(id) + '.csv')
    weights = np.genfromtxt('data/alloc' + str(id) + '.csv',delimiter=',')
    
    pd.read_csv('data/dtm' + str(id) + '.csv')
    
    isstr = [type(x) is str for x in tree['XP'].values]
    tree.loc[isstr,'XP'] = [int(str.replace(x,'x','')) for x in tree.loc[isstr,'XP']]
    
    
    n = 0
    out = 0
        
    while True:
        
        if ~np.isnan(tree['XP'].iloc[n]):
            
            if X[tree['XP'].iloc[n]-1] < tree['CP'].iloc[n]:
                
                n = tree['CC_1'].iloc[n]
                
            elif X[tree['XP'].iloc[n]-1] >= tree['CP'].iloc[n]:
                
                n = tree['CC_2'].iloc[n]
                
            else:
                
                n = tree['NC'].iloc[n]
                    
            
        else:
            out = tree['NC'].iloc[n]
            break
        
        
        
    if out==1:
        out = 0
    elif out==-1:
        out = 1
        
    return weights[out-1,:]