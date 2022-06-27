function [mX,time] = complementary_numbers(magic,wisdom,samples_per_simulation)
tstart = tic;

X = zeros(samples_per_simulation,1);
for kk = 1:2:samples_per_simulation
    u = rand(29,1);
    variables = get_random_variable(u);
    portal_open = magic_portal( wisdom,magic,variables);
    X(kk) = portal_open;

    % Complementary
    u_ = u;
    u_(29) = 1 - u(29);
    variables_ = get_random_variable(u_);
    portal_open = magic_portal( wisdom,magic,variables_);
    X(kk+1) = portal_open;
end

mX = mean(X);
time = toc(tstart);
end