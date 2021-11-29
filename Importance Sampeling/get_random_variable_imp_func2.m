function [var,w] = get_random_variable_imp_func2(u,magic,p_new)
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

u29 = u(29);

p_magic_new = p_new;
p_magic_before = magic/100;
if u29 < p_magic_new
    y_portal = (u29/p_magic_new)*magic;
    w = p_magic_before/p_magic_new;
else
    u29_=u29-p_magic_new;
    y_portal = (u29_/(1-p_magic_new))*(100-magic)+magic;
    w = (1-p_magic_before)/(1-p_magic_new);
end

var.y_portal = y_portal;
end




% p_else = 1 - p_win_sure;
% p_magic = magic/100;
% if  u(29) >= p_else
%     y_portal = magic+(100-magic)+(u(29)-p_else)/p_win_sure
%     p_real=1-p_magic;
%     w = p_real/p_win_sure;
% else
%     y_portal = u(29)/p_else*magic
%     p_real = p_magic;
%     w = p_real/p_else;
% end