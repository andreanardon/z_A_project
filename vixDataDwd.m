function out = vixDataDwd

% Get the historical dataset
url = 'https://cdn.cboe.com/api/global/us_indices/daily_prices/VIX_History.csv';
tmp = webread(url);
vix = [datenum(tmp.DATE) tmp.CLOSE]; % datestr(vix(end,1))

% Get the live Vix
url = 'https://www.google.com/finance/quote/VIX:INDEXCBOE?sa=X&ved=2ahUKEwiCzeTG0Z_0AhXogv0HHRP3DcEQ_AUoAXoECAEQAw';
tmp = webread(url);

% Find the time stamp
keyw = 'data-last-normal-market-timestamp="';
pos = findstr(keyw,tmp);
st1 = pos+size(keyw,2);
st2 = st1+9;

vixUpd = [num2cell(floor(unixtime_to_datenum(str2num(tmp(st1:st2)))))...
          cellstr(datestr(unixtime_to_datenum(str2num(tmp(st1:st2))),'HH:MM:SS'))];

keyw = 'data-last-price="';
pos = findstr(keyw,tmp);
st1 = pos+size(keyw,2);
st2 = st1+4;
txt = tmp(st1:st2);
txt = regexprep(txt,'"','');
vixUpd(1,3) = num2cell(str2num(txt));
clearvars -except vix vixUpd

out.vix = [vix; [vixUpd{1,1} vixUpd{1,3}]];
out.vixTime = vixUpd(2);



