function [portal_open] = magic_portal(wisdom,magical_strength,var)
global print
clues = [""];
magical_strengths = [magical_strength];
wisdoms = [wisdom];
met_friends = [0];

%Preparatory phase
met_friend = 0;
for ii = 1:4
    y_clue = var.y_clue(ii);
    if y_clue <= wisdom
        [magical_strength,wisdom,met_friend,clue] ...
            = get_clue(var,ii,magical_strength,wisdom,met_friend);
    else 
        clue = "None";
    end
    if print == 1
        clues = [clues; clue];
        magical_strengths = [magical_strengths; magical_strength];
        wisdoms = [wisdoms; wisdom];
        met_friends = [met_friends; met_friend];
    end
end



% Action Phase
if var.y_portal <= magical_strength
    portal_open = 1;
else
    portal_open = 0;
end
if print == 1
    print_result(clues,magical_strengths, wisdoms, met_friends,portal_open,var)
end
end


function [magic_strength,wisdom,met_friend,clue] = get_clue(var,ii,magic_strength,wisdom,met_friend)
y_clue_type = var.y_clue_type(ii);
if y_clue_type <= 20
    % The mage triggers a trap protecting the tower.
    clue = "Trap";
    
    y_trap = var.y_trap(ii);
    y_trap_avoid = var.y_trap_avoid(ii)*wisdom;
    
    if y_trap >= y_trap_avoid
        magic_strength = magic_strength - 10;
    end
    
    
elseif y_clue_type<= 60
    % The mage finds a scroll which describes the tower.
    % Adds U(0,10) to wisdom attribute
    clue = "scroll";
    
    wisdom = wisdom + var.y_scroll_add(ii);
    
elseif y_clue_type<= 85
    % The mage finds a book describing a ritual to open the portal.
    % Adds y_book_add U(0,10) to the magic strength if not already at 95
    clue = "book";
    if ~met_friend
        magic_strength = magic_strength + var.y_book_add(ii);
    end
    
elseif y_clue_type<= 95
    % The mage finds a magical artefact that can help open the portal.
    clue = "artefact";
    
    if ~met_friend
        magic_strength = magic_strength + var.y_artefact_add(ii);
    end
    
elseif y_clue_type<= 100
    % The mage meets a friendly mage which has travelled the portal from the other
    % side and who is willing to show the player’s mage how to open the portal.
    clue = "friend";
    
    magic_strength = 95;
    met_friend = 1;
end
end

function print_result(clues,magical_strengths, wisdoms, met_friends,portal_open,var)
y_clue = var. y_clue;
y_clue_type = var.y_clue_type;
y_trap = var.y_trap;
trap_avoid = var.y_trap_avoid.*wisdoms(2:end);
y_scroll = var.y_scroll_add;
y_book = var.y_book_add;
y_artefact = var.y_artefact_add;
inputs = table(y_clue, y_clue_type,y_trap, trap_avoid, y_scroll, y_book,y_artefact)
algorithm = table(clues,magical_strengths, wisdoms, met_friends)
y_portal = var.y_portal
output = portal_open
end