function [var] = get_random_variable(u)
var = struct;
var.y_clue          = u(1:4)*100;
var.y_clue_type     = u(5:8)*100;
var.y_trap          = u(9:12)*50;
var.y_trap_avoid    = u(13:16);
var.y_scroll_add    = u(17:20)*10;
var.y_book_add      = u(21:24)*10;
var.y_artefact_add  = u(25:28)*10+10;
var.y_portal        = u(29)*100;
end