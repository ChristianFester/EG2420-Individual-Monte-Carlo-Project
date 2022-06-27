function [mX,time] = importance_sampling(magic,wisdom,samples_per_simulation)
tstart = tic;

p_magic_add=0.15; % add to old prob
p_magic_new = magic/100 + p_magic_add;

X = zeros(samples_per_simulation,1);
for kk = 1:samples_per_simulation
    u = rand(29,1);

    %Importance Sampeling
    [variables,w] = get_random_variable_imp_func2(u,magic,p_magic_new);
    portal_open = magic_portal(wisdom,magic,variables);
    X(kk) = portal_open*w;
end

mX = mean(X);
time = toc(tstart);
end