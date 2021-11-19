
clear; clc; close all;

%% Upload the data

p.list = {
'ETF', 'Equities',    'SPY US Equity',  'S&P500',          'BBG000BDTBL9',  'SPY';
'ETF', 'Equities',    'QQQ US Equity',  'Nasdaq',          'BBG000BSWKH7',  'QQQ';
'ETF', 'Equities',    'QQQ US Equity',  'DowJones',        'BBG000BTDS98',  'DIA';
'ETF', 'Govies',      'SHY US Equity',  'Treasury_1to3',   'BBG000NTFYM5',  'SHY';
'ETF', 'Govies',      'IEI US Equity',  'Treasury_3to7',   'BBG000QN0RR1',  'IEI';
'ETF', 'Govies',      'TLT US Equity',  'Treasury_20+',    'BBG000BJKYW3',  'TLT';
'ETF', 'Govies',      'TIP US Equity',  'TIP_US',          'BBG000C01W49',  'TIP';
'ETF', 'Credit',      'LQD US Equity',  'InvestmentGrade', 'BBG000BBV9N3',  'LQD';
'ETF', 'Credit',      'HYG US Equity',  'HighYield',       'BBG000R2T3H9',  'HYG';
'ETF', 'Commodities', 'GLD US Equity',  'Gold',            'BBG000CRF6Q8',  'GLD';};

% Request historical data using iexCloud
out = iexCloud_1(p.list(:,6), 50);
p.dt = out.comb.dt;
p.px = out.comb.px;
p.ret = out.comb.ret;

% Request the Vix data (including live update)
vix = vixDataDwd;
[a,b] = ismember(p.dt,vix.vix(:,1));
p.vix = zeros(size(p.dt,1),1);
p.vix(a) = vix.vix(b(a),2);

clearvars -except p

%% Run the model
load('rebo4.mat')
px = cumret(p.ret(:,1));
px2 = cumret(p.ret(:,9));  % invest grade
px3 = cumret(p.ret(:,10)); % gold
W = zeros(size(px,1),size(px,2),size(Model,2));
ind = [p.vix Aret(p.vix,2) Aret(p.vix,5) Aret(px,2) Aret(px,5) Aret(px2,5) Aret(px2,12) Aret(px3,5) Aret(px3,10)];
for n=1:size(Model,2) %n=n+1
    if n>11 && n<15
        ind = [p.vix Aret(p.vix,2) Aret(p.vix,5) Aret(p.vix,10) Aret(p.vix,15) Aret(px,2) Aret(px,5) Aret(px,10) Aret(px,15) Aret(px2,5) Aret(px2,12)  Aret(px2,20) Aret(px3,5) Aret(px3,10) Aret(px3,15)];
    elseif n>14 && n<17
       ind =  [p.vix [0;p.vix(1:end-1,1)] [0;0;p.vix(1:end-2,1)]];
    elseif n>17 && n<19
        ind = [p.vix Aret(p.vix,2) Aret(p.vix,5) Aret(px,2) Aret(px,5) Aret(px2,5) Aret(px2,12) Aret(px3,5) Aret(px3,10)];
    elseif n>19
        ind = [Aret(p.vix,10) Aret(p.vix,30) p.vix];
    end
    yy = predict(Model(n).model, ind);
    w = zeros(size(p.ret));
    for t=1+Model(n).delay:size(yy,1)
        if yy(t-Model(n).delay,1)==1
            w(t,:) = Model(n).risk_on;            
        else
            w(t,:) = Model(n).risk_off;
        end
    end
    W(:,:,n)=w;
end
w = mean(W,3);

output = [p.list(:,3) num2cell(w(end,:)')];


