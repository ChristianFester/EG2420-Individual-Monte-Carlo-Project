function [stratum] = get_strata_settings_invers(y_clues,y_portal,y_cluetype)
if y_clues == ">=wisdom" && y_portal == "<magic" && y_cluetype == "None"
    stratum = "A";
elseif y_clues == ">=wisdom" && y_portal == ">=magic" && y_cluetype == "None"
    stratum ="B";
elseif y_clues == "<wisdom" && y_portal == "<magic" && y_cluetype == "noTrap"
    stratum = "C";
elseif y_clues == "<wisdom" && y_portal == "<magic" && y_cluetype == "Trap"
    stratum = "D";
elseif y_clues == "<wisdom" && y_portal == ">=magic" && y_cluetype == "None"
    stratum ="E";
elseif y_clues == "Else" && y_portal == "<magic" &&  y_cluetype == "noTrap"
    stratum ="F";
elseif y_clues == "Else" && y_portal == "<magic" && y_cluetype == "Trap"
    stratum ="G";
elseif y_clues == "Else" && y_portal == ">=magic" && y_cluetype == "None"
    stratum ="H";
end
end