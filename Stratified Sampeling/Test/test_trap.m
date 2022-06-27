clear
load_settings;

samples=10000;

wisdom = mages(2).wisdom;
magic = mages(2).magical_strength;

% res = zeros(8,5);
strata = ["A","B","C","D","E","F","G","H"]';
type = sort({'trap','scroll','book','artefact','friend'});
T = table;
T.TYPE = type';
for jj = 1:length(strata)
    stratum = strata(jj);


    types = {};
    for kk = 1:samples
        u = rand(29,1);
        var = get_stratum_variable(u,wisdom,magic,stratum);

        types = [types,var.y_clue_type];
    end
    nn = samples*4;
    [~,ia,ic] = unique(types);
    
    share = sum(ic==1:5)/nn*100;
    T.(stratum) = share';
%     res(jj,:) = share;
end
T.D_C =(0.8^4)*T.C+(1-0.8^4)*T.D;
T.F_G = (0.8^4)*T.F+(1-0.8^4)*T.G;
%%
T

% TYPE = type';
% SHARE = share';
% table(TYPE,SHARE)