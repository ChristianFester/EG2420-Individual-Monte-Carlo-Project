function [y_clues,y_portal,y_cluetype] = get_strata_settings_fast(stratum)
switch stratum

    case 1%"A"
        y_clues = 1;    %">=wisdom";
        y_portal = 1;   %"<magic";
        y_cluetype = 1; % "None";

    case 2%"B"
        y_clues = 1;    %">=wisdom";
        y_portal = 2;   %">=magic";
        y_cluetype = 1; %"None";

    case 3%"C"
        y_clues = 2;    %"<wisdom";
        y_portal = 1;   %"<magic";
        y_cluetype = 2; %"noTrap";

    case 4%"D"
        y_clues = 2;    %"<wisdom";
        y_portal = 1;   %"<magic";
        y_cluetype = 3; %"Trap";

    case 5%"E"
        y_clues = 2;    %"<wisdom";
        y_portal = 2;   %">=magic";
        y_cluetype = 1; %"None";

    case 6%"F"
        y_clues = 3;    %"Else";
        y_portal = 1;   %"<magic";
        y_cluetype = 2; %"noTrap";

    case 7%"G"
        y_clues = 3;    %"Else";
        y_portal = 1;   %"<magic";
        y_cluetype = 3; %"Trap";

    case 8%"H"
        y_clues = 3;    %"Else";
        y_portal = 2;   %">=magic";
        y_cluetype = 1; %"None";
end
end