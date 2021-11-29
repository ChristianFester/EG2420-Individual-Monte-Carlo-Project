function [weigth] = get_stratum_weight(wisdom,magic,stratum)
% Propabilities Wisdom and Magic
p = wisdom/100;
q = magic/100;
p_trap = 0.2;

% Strata
[y_clues,y_portal,y_cluetype] = get_strata_settings(stratum);

% Calculate Weigth
weigth = 1;

switch y_clues
    case "<wisdom"
        weigth = weigth*p^4; 
    case ">=wisdom"
       weigth = weigth*(1-p)^4; 
    case "Else"
       weigth = weigth*(1-(1-p)^4-p^4); 
end

switch y_portal
    case "<magic"
        weigth = weigth*q;    
    case ">=magic"
        weigth = weigth*(1-q); 
end

switch y_cluetype
    case "noTrap"
       weigth = weigth*(1-p_trap)^4;
    case "Trap"
        weigth = weigth*(1-(1-p_trap)^4);
    case "None"
        weigth = weigth*1; 
end


end