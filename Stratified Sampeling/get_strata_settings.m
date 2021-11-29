function [y_clues,y_portal,y_cluetype] = get_strata_settings(stratum)
switch stratum

    case "A"
        y_clues = ">=wisdom";
        y_portal = "<magic";
        y_cluetype = "None";

    case "B"
        y_clues = ">=wisdom";
        y_portal = ">=magic";
        y_cluetype = "None";

    case "C"
        y_clues = "<wisdom";
        y_portal = "<magic";
        y_cluetype = "noTrap";

    case "D"
        y_clues = "<wisdom";
        y_portal = "<magic";
        y_cluetype = "Trap";

    case "E"
        y_clues = "<wisdom";
        y_portal = ">=magic";
        y_cluetype = "None";

    case "F"
        y_clues = "Else";
        y_portal = "<magic";
        y_cluetype = "noTrap";

    case "G"
        y_clues = "Else";
        y_portal = "<magic";
        y_cluetype = "Trap";

    case "H"
        y_clues = "Else";
        y_portal = ">=magic";
        y_cluetype = "None";
end
end