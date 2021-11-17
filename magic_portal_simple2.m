function [portal_open] = magic_portal_simple2(wisdom,magical_strength,var)
u = rand(29,1);
var = get_random_variable(u);
wisdom = 60;
is_book = strcmp(var.y_clue_type,'book');
is_artefact = strcmp(var.y_clue_type,'artefact');
% is_friend = strcmp(var.y_clue_type,'artefact');
is_added = (wisdom>=var.y_clue);
add_book = sum(is_book.*var.y_book_add.*is_added);
add_artefact = sum(is_book.*var.y_book_add.*is_added);


add_magical = 0.2635*wisdom + 0.2635;

magical_strength = magical_strength + add_magical;
% Action Phase
if var.y_portal <= magical_strength
    portal_open = 1;
else
    portal_open = 0;
end
end

