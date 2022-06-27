
clear
load_settings;

wisdom = mages(2).wisdom;
magic = mages(2).magical_strength;

samples = 10000;

strata = {};
for kk = 1:samples
    u = rand(29,1);
    var = get_random_variable(u);
    [y_clues,y_portal,y_cluetype] = guess_strata_setting(var,wisdom,magic);
    stratum = get_strata_settings_invers(y_clues,y_portal,y_cluetype);
    strata{end+1} = char(stratum);
end
%%
[type,ia,ic] = unique(strata); 
share = sum(ic==1:8)/samples*100;
STRATA = type';
SHARE = share';
WEIGHTS = [];
for typ = type
   WEIGHTS(end+1,1) = get_stratum_weight(wisdom,magic,string(typ))*100;
end
table(STRATA,SHARE,WEIGHTS)