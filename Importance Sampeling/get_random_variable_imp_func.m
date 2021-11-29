function [var,w] = get_random_variable_imp_func(u,clue_prob)
% clue_prob = [0.4 0.1 0.25 0.10 0.15];
% u = rand(29,1);
var = struct;
var.y_clue          = u(1:4)*100;

clues = {'trap','scroll','book','artefact','friend'};
prob_real = [0.2 0.4 0.25 0.10 0.05];
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

w=1;
for ii = 1:length(var.y_clue_type)
    idx = find(strcmp(var.y_clue_type(ii),clues));
    p_new = clue_prob(idx);
    p_real = prob_real(idx);
    w=w*p_real/p_new;
end
end