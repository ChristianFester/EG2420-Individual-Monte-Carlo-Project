function [portal_open] = magic_portal_simple(wisdom,magical_strength,var)

add_magical = linear_function_magic(wisdom);

magical_strength = magical_strength + add_magical;
% Action Phase
if var.y_portal <= magical_strength
    portal_open = 1;
else
    portal_open = 0;
end
end
%y(x) = 0.26268*x + -0.32732
