%% MountCap - production code

clear; clc; close all;

%% Download the most recent data
p.location = '/Volumes/Z/z_A_project/';

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

%% Run the Model

clearvars -except p

px = cumret(p.ret(:,1));
px2 = cumret(p.ret(:,9));  % high yield
px3 = cumret(p.ret(:,10)); % gold

for n = 1:11
    ind = [p.vix Aret(p.vix,2) Aret(p.vix,5) Aret(px,2) Aret(px,5) Aret(px2,5) Aret(px2,12) Aret(px3,5) Aret(px3,10)];
    out = read_decision_trees_csv(p.location, n, ind(end,:));
    A = readmatrix([p.location 'data/alloc' num2str(n) '.csv']);
    if out == 1
        w(n,:) = A(1,:);
    else
        w(n,:) = A(2,:);
    end
end

for n = 12:14
    ind = [p.vix Aret(p.vix,2) Aret(p.vix,5) Aret(p.vix,10) Aret(p.vix,15) Aret(px,2) Aret(px,5) Aret(px,10) Aret(px,15) Aret(px2,5) Aret(px2,12)  Aret(px2,20) Aret(px3,5) Aret(px3,10) Aret(px3,15)];
    out = read_decision_trees_csv(p.location, n, ind(end,:));
    A = readmatrix([p.location 'data/alloc' num2str(n) '.csv']);
    if out == 1
        w(n,:) = A(1,:);
    else
        w(n,:) = A(2,:);
    end
end

for n = 15:17
    ind = [p.vix [0;p.vix(1:end-1,1)] [0;0;p.vix(1:end-2,1)]];
    out = read_decision_trees_csv(p.location, n, ind(end,:));
    A = readmatrix([p.location 'data/alloc' num2str(n) '.csv']);
    if out == 1
        w(n,:) = A(1,:);
    else
        w(n,:) = A(2,:);
    end
end

for n = 18:19
    ind = [p.vix Aret(p.vix,2) Aret(p.vix,5) Aret(px,2) Aret(px,5) Aret(px2,5) Aret(px2,12) Aret(px3,5) Aret(px3,10)];
    out = read_decision_trees_csv(p.location, n, ind(end,:));
    A = readmatrix([p.location 'data/alloc' num2str(n) '.csv']);
    if out == 1
        w(n,:) = A(1,:);
    else
        w(n,:) = A(2,:);
    end
end

n = 20;
ind = [Aret(p.vix,10) Aret(p.vix,30) p.vix];
out = read_decision_trees_csv(p.location, n, ind(end,:));
A = readmatrix([p.location 'data/alloc' num2str(n) '.csv']);
if out == 1
    w(n,:) = A(1,:);
else
    w(n,:) = A(2,:);
end

w = mean(w);

output = [p.list(:,3) num2cell(w(end,:)')];






















