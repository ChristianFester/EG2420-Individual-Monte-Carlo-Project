function [var,w] = get_random_variable_imp_func3(u,wisdom,p_new_clue)
var = struct; w=1;
for ii = 1:4
    [y_clue,w_add] = new_clue_prob(u(ii),wisdom,p_new_clue);
    var.y_clue(ii) = y_clue;
    w = w*w_add;
end

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
var.y_portal = u(29)*100;
end

function [y_clue,w] = new_clue_prob(u_clue,wisdom,p_new_wisdom)

% p_new = 0.1; %Prob that y_portal > magic
p_wisdom_new = p_new_wisdom;
p_wisdom_before = wisdom/100;
if u_clue < p_wisdom_new
    y_clue = (u_clue/p_wisdom_new)*wisdom;
    w = p_wisdom_before/p_wisdom_new;
else
    u_clue_ = u_clue-p_wisdom_new;
    y_clue = (u_clue_/(1-p_wisdom_new))*(100-wisdom)+wisdom;
    w = (1-p_wisdom_before)/(1-p_wisdom_new);
end

end