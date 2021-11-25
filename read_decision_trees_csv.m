function out = read_decision_trees_csv(location,nmodel,input)

fn = [location 'data/dtm' num2str(nmodel) '.csv'];
T = readtable(fn);
CP = T.CP;
NC = T.NC;
XP = T.XP;
CC = [T.CC_1 T.CC_2];
clear DT
for ii=1:size(CP,1)
   if ~isnan(CP(ii))
       DT(ii,1) = ii;
       DT(ii,2) =  str2num(regexprep(XP{ii},'x','')); % if this input is <
       DT(ii,3) =  CP(ii); % than this number here
       DT(ii,4) = CC(ii,1); % then go this node 
       DT(ii,5) =  CP(ii); % else if DT(ii,2) is greater or equal to this number here
       DT(ii,6) = CC(ii,2); % then go this node
       DT(ii,7) = NC(ii); % otherwise the outcome is this one here
   else
       DT(ii,1) = ii;
       DT(ii,2) = NaN;
       DT(ii,7) = NC(ii);
   end
end

out = []; 
n = 1;
while isempty(out)
    if ~isnan(DT(n,2))
        if input(DT(n,2)) < DT(n,3)
            n = DT(n,4);
        elseif input(DT(n,2)) >= DT(n,3)
            n = DT(n,6);
        else 
            out = DT(n,7); 
        end
    else
        out = DT(n,7);
    end
end
