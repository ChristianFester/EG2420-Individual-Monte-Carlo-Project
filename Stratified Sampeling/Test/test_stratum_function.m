
clear
load_settings;

wisdom = mages(2).wisdom;
magic = mages(2).magical_strength;

samples = 5000;
strata = ["A","B","C","D","E","F","G","H"]';

for jj = 1:length(strata)
    stratum = strata(jj);
    
    for kk = 1:samples
        u = rand(29,1);
        var = get_stratum_variable(u,wisdom,magic,stratum);
        [y_clues_g,y_portal_g,y_cluetype_g] = guess_strata_setting(var,wisdom,magic);
        [y_clues,y_portal,y_cluetype] = get_strata_settings(stratum);
        check1 = strcmp(y_clues_g,y_clues);
        check2 = strcmp(y_portal_g,y_portal);
        check3 = strcmp(y_cluetype_g,y_cluetype);
        if check1+check2+check3~=3
            error('FUCK')
        end
    end
end

