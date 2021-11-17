function [var,w] = get_random_variable_imp_func(u,clue_prob)
clue_prob = [0.4 0.1 0.25 0.10 0.15];
u = rand(29,1);
var = struct;
var.y_clue          = u(1:4)*100;
var.y_clue_type     = u(5:8)*100;
clues = {'trap','scroll','book','artefact','friend'};
prob_real = [0.2 0.4 0.25 0.10 0.05];
var.y_clue_type = randsample(clues,4,true,clue_prob)';
var.y_trap          = u(9:12)*50;
var.y_trap_avoid    = u(13:16);
var.y_scroll_add    = u(17:20)*10;
var.y_book_add      = u(21:24)*10;
var.y_artefact_add  = u(25:28)*10+10;
var.y_portal        = u(29)*100;

u = random('unif',0,1);
if u <= p_is(ii)
    P(ii) = 0;
    w(ii) = p(ii)/p_is(ii);
else
    w(ii) = (1-p(ii))/(1-p_is(ii));
end

w
end