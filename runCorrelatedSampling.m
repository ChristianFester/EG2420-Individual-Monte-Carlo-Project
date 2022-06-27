clear all
load_settings;

simulations = 100;
n_per_simulation = 1200;

%% Pre-Calculation for importance sampling
for ii = 1:length(mages)
    wisdom = mages(ii).wisdom;
    magic = mages(ii).magical_strength;

    add_magical = linear_function_magic(wisdom);
    mu_simple = (magic+add_magical) / 100;

    mages(ii).mu_simple = mu_simple;
end
p_magic_add=0.15; % add to old prob
p_magic_new = magic/100 + p_magic_add;


%% MAGE Difference with corelated sampling
mX_simple           = zeros(simulations,3);
mX_correlated       = zeros(simulations,3);
mX_complementary    = zeros(simulations,3);
mX_controlvariant   = zeros(simulations,3);
mX_importance       = zeros(simulations,3);

time_simple         = zeros(simulations,1);
time_correlated     = zeros(simulations,1);
time_complementary  = zeros(simulations,1);
time_controlvariant = zeros(simulations,1);
time_importance     = zeros(simulations,1);

f = waitbar(0,'Correlated Sampling','Name','Monte Carlo Simulation');
for nn = 1:simulations
    waitbar(nn/simulations,f,'Correlated Sampling');
    
    %% Simple Sampling
    tstart = tic;
    rng(nn,'twister'); % Seed for random number generator
    X_mage = zeros(length(mages),n_per_simulation);
    for ii = 1:length(mages)
        wisdom = mages(ii).wisdom;
        magic = mages(ii).magical_strength;

        for kk = 1:n_per_simulation        
            u = rand(29,1);
            vars = get_random_variable(u);

            X_mage(ii,kk) = magic_portal(wisdom, magic, vars);
        end
    end
    mX_simple(nn,1) = mean(X_mage(2,:)-X_mage(1,:));
    mX_simple(nn,2) = mean(X_mage(3,:)-X_mage(1,:));
    mX_simple(nn,3) = mean(X_mage(3,:)-X_mage(2,:));
    time_simple(nn) = toc(tstart);
    
    %% Correlated Sampling
    tstart = tic;
    rng(nn,'twister'); % Seed for random number generator
    X_mage = zeros(length(mages),n_per_simulation);
    for kk = 1:n_per_simulation
        u = rand(29,1);
        for ii = 1:length(mages)
            wisdom = mages(ii).wisdom;
            magic = mages(ii).magical_strength;
            
            vars = get_random_variable(u);
            X_mage(ii,kk) = magic_portal(wisdom, magic, vars);
        end
    end
    mX_correlated(nn,1) = mean(X_mage(2,:)-X_mage(1,:));
    mX_correlated(nn,2) = mean(X_mage(3,:)-X_mage(1,:));
    mX_correlated(nn,3) = mean(X_mage(3,:)-X_mage(2,:));
    time_correlated(nn) = toc(tstart);


    %% Complementary Random Numbers
    tstart = tic;
    rng(nn,'twister'); % Seed for random number generator
    X_mage = zeros(length(mages),n_per_simulation);
    for kk = 1:2:n_per_simulation
        u = rand(29,1);
%         vars = get_random_variable(u);

        u_ = u; u_(29) = 1 - u(29);
%         var_ = get_random_variable(u_);

        for ii = 1:length(mages)
            wisdom = mages(ii).wisdom;
            magic = mages(ii).magical_strength;
            
            vars = get_random_variable(u);
            var_ = get_random_variable(u_);
            X_mage(ii,kk) = magic_portal(wisdom, magic, vars);
            X_mage(ii,kk+1) = magic_portal( wisdom,magic,var_);
        end
    end
    mX_complementary(nn,1) = mean(X_mage(2,:)-X_mage(1,:));
    mX_complementary(nn,2) = mean(X_mage(3,:)-X_mage(1,:));
    mX_complementary(nn,3) = mean(X_mage(3,:)-X_mage(2,:));
    time_complementary(nn) = toc(tstart);


    %% Control Variant
    tstart = tic;
    rng(nn,'twister'); % Seed for random number generator
    X_mage = zeros(length(mages),n_per_simulation);
    for kk = 1:n_per_simulation
        u = rand(29,1);

        for ii = 1:length(mages)
            wisdom = mages(ii).wisdom;
            magic = mages(ii).magical_strength;

            % Expectation result of the simplified model
            mu_simple = mages(ii).mu_simple;
            
            vars = get_random_variable(u);
            X = magic_portal(wisdom, magic, vars);
            X_simple = magic_portal_simple(wisdom,magic,vars);

            X_mage(ii,kk) = X - X_simple + mu_simple;
        end
    end
    mX_controlvariant(nn,1) = mean(X_mage(2,:)-X_mage(1,:));
    mX_controlvariant(nn,2) = mean(X_mage(3,:)-X_mage(1,:));
    mX_controlvariant(nn,3) = mean(X_mage(3,:)-X_mage(2,:));
    time_controlvariant(nn) = toc(tstart);

    %% Importance Sampling
    tstart = tic;
    rng(nn,'twister'); % Seed for random number generator
    X_mage = zeros(length(mages),n_per_simulation);
    for kk = 1:n_per_simulation
        u = rand(29,1);
        for ii = 1:length(mages)
            wisdom = mages(ii).wisdom;
            magic = mages(ii).magical_strength;
            
            [vars,w] = get_random_variable_imp_func2(u,magic,p_magic_new);
            X = magic_portal(wisdom, magic, vars);
            X_mage(ii,kk) = X*w;
        end
    end
    mX_importance(nn,1) = mean(X_mage(2,:)-X_mage(1,:));
    mX_importance(nn,2) = mean(X_mage(3,:)-X_mage(1,:));
    mX_importance(nn,3) = mean(X_mage(3,:)-X_mage(2,:));
    time_importance(nn) = toc(tstart);
end
close(f)

%% Rearange Results
res = struct;
all_times = [
    time_simple';
    time_correlated';
    time_complementary';
    time_controlvariant';
    time_importance'];

comparison = ["X2-X1","X3-X1","X3-X2"]';
for jj = 1:length(comparison)
    res(jj).all_results = 100*[
        mX_simple(:,jj)';
        mX_correlated(:,jj)';
        mX_complementary(:,jj)';
        mX_controlvariant(:,jj)';
        mX_importance(:,jj)'];
end

%% Analyse of the results
time_pre_cv = 1.6369*1000;
method = [
    "Simple Sampling";
    "Correlated Sampling (CS)";
    "CS + Complementary Numbers";
    "CS + Control Variant";
    "CS + Importance Sampling"];

mX_mean     = zeros(length(method),length(comparison));
mX_Var      = zeros(length(method),length(comparison));

lgd = struct;
lgd.first = 'northeast';
lgd.second = 'none';

num_mages = [2 1; 3 1; 3 2;];
for jj = 1:length(comparison)
    all_results = res(jj).all_results;

    mX_mean(:,jj)     = mean(all_results,2);
    mX_Var(:,jj)      = var(all_results');

    name = sprintf('Difference Mage %i and %i',num_mages(jj,1),num_mages(jj,2));
    bin_width = .75;
    plot_histograms(method,all_results',jj,name,bin_width,'correlated_plus',lgd)
end
fprintf('\n\n')

mean_VAR = mean(mX_Var,2);
avg_time_ms = 1000*mean(all_times,2);
%ADD time of the precalculation for control variant
avg_time_ms(4) = avg_time_ms(4)+time_pre_cv/simulations;
Eff = avg_time_ms.*mean_VAR

data = reshape([method,avg_time_ms,mX_mean,mX_Var,Eff]',1,[]);
fprintf('%s & %.2f ms & %.2f\\%% & %.2f\\%% & %.2f\\%% & %.4f & %.4f & %.4f & %.4f \\\\ \n',data);

T = table(method,avg_time_ms,mX_mean,mX_Var,Eff)
sheet = ['corr_plus_w' num2str(wisdom) 'm' num2str(magic)];
writetable(T,'Results.xls','Sheet',sheet);
