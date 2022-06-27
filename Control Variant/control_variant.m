function [mX,time] = control_variant(magic,wisdom,samples_per_simulation)

tstart = tic;
% Find expectation result of the simplified model
add_magical = linear_function_magic(wisdom);
mu_simple = (magic+add_magical) / 100;

X = zeros(samples_per_simulation,1);
X_simple = zeros(samples_per_simulation,1);
for kk = 1:samples_per_simulation
    u = rand(29,1);
    variables = get_random_variable(u);
    % Normal Model
    portal_open = magic_portal(wisdom,magic, variables);
    X(kk) = portal_open;
    % Simple Model
    sportal_open = magic_portal_simple(wisdom,magic,variables);
    X_simple(kk) = sportal_open;
end

mX = mean(X)-mean(X_simple) + mu_simple;
time = toc(tstart);
end