import pandas as pd
import requests
import json
from datetime import datetime
import io
from bs4 import BeautifulSoup

def download_etfs(univ):

    key = 'pk_3d1495afc18f4ea884cdbbee5a569afb'
    ndays = 50
    tickers = ','.join(univ['ticker'])
    url = 'https://cloud.iexapis.com/v1/stock/market/batch?&types=chart&symbols=' + tickers + '&range=' + str(ndays) + 'd&token=' + key
    response = requests.get(url)
    data = response.json()
    
    df = pd.DataFrame()
    
    for etf in data:
        
        x = pd.DataFrame(data[etf]['chart'])[['close','high','low','open','key','date']]
        
        df = pd.concat((df,x))
    
    
    df['date'] = [datetime.strptime(x,'%Y-%m-%d').date() for x in df['date']]
    px = df[['date','key','close']].pivot(index='date',columns='key')
    
    
    url = 'https://cloud.iexapis.com/v1/stock/market/batch?&types=quote&symbols=' + tickers + '&token=' + key
    response = requests.get(url)
    data = response.json()
    
    for etf in data:
        
        price = data[etf]['quote']['latestPrice']
        time = datetime.fromtimestamp( data[etf]['quote']['lastTradeTime']/1000).date()
        px.loc[time,('close',etf)] = price
        
    
    return px



def download_vix():
    
    url = 'https://cdn.cboe.com/api/global/us_indices/daily_prices/VIX_History.csv'
    
    response = requests.get(url)
    
    urlData = response.content
    data = pd.read_csv(io.StringIO(urlData.decode('utf-8')))
    data['DATE'] = [datetime.strptime(x, '%m/%d/%Y').date() for x in data['DATE']]
    data = data.set_index('DATE')
    
    
    
    url = 'https://www.google.com/finance/quote/VIX:INDEXCBOE?sa=X&ved=2ahUKEwiCzeTG0Z_0AhXogv0HHRP3DcEQ_AUoAXoECAEQAw'
    
    response = requests.get(url)
    soup = BeautifulSoup(response.text,features='html.parser')
    
    divs = soup.findAll('div')
    
    for div in divs:
        if div.has_key('data-last-price'):
            px = float(div['data-last-price'])
            ut = datetime.fromtimestamp(int(div['data-last-normal-market-timestamp'])).date()
            
            data.loc[ut,'CLOSE'] = px
        
        
    return data



