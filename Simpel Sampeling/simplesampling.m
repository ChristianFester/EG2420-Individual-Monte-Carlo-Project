function [mX,time] = simplesampling(magic,wisdom,n_per_simulation)
tstart = tic;

X = zeros(n_per_simulation,1);
for kk = 1:n_per_simulation
    u = rand(29,1);
    variables = get_random_variable(u);
    portal_open = magic_portal(wisdom, magic, variables);
    X(kk) = portal_open;
end

mX = mean(X);
time = toc(tstart);
end