function [weigth] = get_stratum_weight_fast(wisdom,magic,stratum)
% Propabilities Wisdom and Magic
p = wisdom/100;
q = magic/100;
p_trap = 0.2;

% Strata
[y_clues,y_portal,y_cluetype] = get_strata_settings_fast(stratum);

% Calculate Weigth
weigth = 1;

switch y_clues
    case 2  %"<wisdom"
        weigth = weigth*p^4; 
    case 1  %">=wisdom"
       weigth = weigth*(1-p)^4; 
    case 3  %"Else"
       weigth = weigth*(1-(1-p)^4-p^4); 
end

switch y_portal
    case 1  %"<magic"
        weigth = weigth*q;    
    case 2  %">=magic"
        weigth = weigth*(1-q); 
end

switch y_cluetype
    case 1  %"None"
        weigth = weigth*1; 
    case 2  %"noTrap"
       weigth = weigth*(1-p_trap)^4;
    case 3  %"Trap"
        weigth = weigth*(1-(1-p_trap)^4);
end


end