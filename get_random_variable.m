function [var] = get_random_variable(u)
var = struct;
var.y_clue          = u(1:4)*100;

clues = {'trap','scroll','book','artefact','friend'};
clue_prob = [0.2 0.4 0.25 0.10 0.05];
for ii = 5:8
    u_clue = u(ii);
    idx = 1;
    for prob = cumsum(clue_prob)
        if u_clue <= prob
            break;
        end
        idx = idx +1;
    end
    var.y_clue_type(ii-4) = clues(idx);
end

var.y_trap          = u(9:12)*50;
var.y_trap_avoid    = u(13:16);
var.y_scroll_add    = u(17:20)*10;
var.y_book_add      = u(21:24)*10;
var.y_artefact_add  = u(25:28)*10+10;
var.y_portal        = u(29)*100;
end