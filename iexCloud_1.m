function out = data_dwn_iex_cloud(tickers, nDays)


key = 'pk_3d1495afc18f4ea884cdbbee5a569afb';
ntickers = strjoin(tickers,',');

% Get the historical fully adjusted prices
url = ['https://cloud.iexapis.com/v1/stock/market/batch?&types=chart&symbols=' ntickers '&range=' num2str(nDays) 'd&token=' key];
tmp = webread(url);
h.dt = datenum(vertcat(tmp.SPY.chart.date),'yyyy-mm-dd');
h.px = vertcat(tmp.SPY.chart.fClose);
for n=2:size(tickers,1)
    x = [datenum(vertcat(tmp.(tickers{n}).chart.date),'yyyy-mm-dd')   vertcat(tmp.(tickers{n}).chart.fClose)];
    [a,b] = ismember(h.dt(:,1),x(:,1));
    h.px(a,n) = x(b(a),2);
end

% Get the live prices
url = ['https://cloud.iexapis.com/v1/stock/market/batch?&types=quote&symbols=' ntickers '&token=' key];
tmp = webread(url);

for n=1:size(tickers,1)
    lastUpdate(n,1) = {datestr(tmp.(tickers{n}).quote.lastTradeTime/1000/60/60/24 + datenum('01/01/1970'))};
    lastUpdate(n,2) = num2cell(tmp.(tickers{n}).quote.latestPrice);
end

out.hist = h;
out.today = lastUpdate;

% Combine the information
ldt = floor(max(datenum((datestr(out.today(:,1))))));
out.comb.dt = [out.hist.dt; ldt];
out.comb.px = [out.hist.px; cell2mat(lastUpdate(:,2)')];
out.comb.ret = Aret(out.comb.px);




