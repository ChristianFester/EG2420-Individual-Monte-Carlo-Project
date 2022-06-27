function [y_clues,y_portal,y_cluetype] = guess_strata_setting(var,wisdom,magic)
%Y CLUES
if all(var.y_clue >= wisdom)
    y_clues = ">=wisdom";
elseif all(var.y_clue < wisdom)
    y_clues = "<wisdom";
else
    y_clues = "Else";
end

%Y PORTAL
if var.y_portal <  magic
    y_portal = "<magic";
else
    y_portal = ">=magic";
end

%TRAP
if strcmp(y_portal,"<magic") && ~strcmp(y_clues,">=wisdom")
    if any(strcmp(var.y_clue_type,'trap'))
        y_cluetype = "Trap";
    else
        y_cluetype = "noTrap";
    end
else
    y_cluetype = "None";
end

end