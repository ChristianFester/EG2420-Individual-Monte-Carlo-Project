clear all
load_settings;

simulations = 100;
n_per_simulation = 1200;

%% MAGE Difference with corelated sampling
mX_simple   = zeros(simulations,3);
mX_correlated   = zeros(simulations,3);

time_simplesampling   = zeros(simulations,1);
time_correlated    = zeros(simulations,1);

f = waitbar(0,'Correlated Sampling','Name','Monte Carlo Simulation');
for nn = 1:simulations
    waitbar(nn/simulations,f,'Correlated Sampling');
    
    %% Simple Sampling
    tstart = tic;
    rng(nn,'twister'); % Seed for random number generator
    X_mage = zeros(length(mages),n_per_simulation);
    for kk = 1:n_per_simulation

        for ii = 1:length(mages)
            u = rand(29,1);
            vars = get_random_variable(u);
            wisdom = mages(ii).wisdom;
            magic = mages(ii).magical_strength;

            X_mage(ii,kk) = magic_portal(wisdom, magic, vars);
        end
    end
    mX_simple(nn,1) = mean(X_mage(2,:)-X_mage(1,:));
    mX_simple(nn,2) = mean(X_mage(3,:)-X_mage(1,:));
    mX_simple(nn,3) = mean(X_mage(3,:)-X_mage(2,:));
    time_simplesampling(nn) = toc(tstart)/n_per_simulation;

    %% Correlated Sampling
    tstart = tic;
    X_mage = zeros(length(mages),n_per_simulation);
    for kk = 1:n_per_simulation
        u = rand(29,1);
        vars = get_random_variable(u);
        for ii = 1:length(mages)

            wisdom = mages(ii).wisdom;
            magic = mages(ii).magical_strength;

            X_mage(ii,kk) = magic_portal(wisdom, magic, vars);
        end
    end
    mX_correlated(nn,1) = mean(X_mage(2,:)-X_mage(1,:));
    mX_correlated(nn,2) = mean(X_mage(3,:)-X_mage(1,:));
    mX_correlated(nn,3) = mean(X_mage(3,:)-X_mage(2,:));

end
close(f)

%% Rearange Results
res = struct;
all_times = [
    time_simplesampling;
    time_correlated;
    ];

comparison = ["Mage 2 - Mage 1","Mage 3 - Mage 1","Mage 3 - Mage 2"]';
for jj = 1:length(comparison)
    res(jj).all_results = 100*[...
        mX_simple(:,jj),...
        mX_correlated(:,jj)];
end

%% Analyse of the results

method = ["Simple Sampling";"Correlated Sampling"];

mX_min      = zeros(length(method)*length(comparison),1);
mX_mean     = zeros(length(method)*length(comparison),1);
mX_max      = zeros(length(method)*length(comparison),1);
mX_Var      = zeros(length(method)*length(comparison),1);
COMPARISON  = string;

lgd = struct;
lgd.first = 'northeast';
lgd.second = 'none';

num_mages = [2 1; 3 1; 3 2;];
for jj = 1:length(comparison)
    comp = repmat(comparison(jj),length(method),1);
    all_results = res(jj).all_results;
    
    idx = (jj)*2-1;
    mX_min(idx:idx+length(method)-1)  = min(all_results)';
    mX_mean(idx:idx+length(method)-1) = mean(all_results)';
    mX_max(idx:idx+length(method)-1)  = max(all_results)';
    mX_Var(idx:idx+length(method)-1)  = var(all_results)';
    COMPARISON(idx:idx+length(method)-1,1)  = comp;

    name = sprintf('Difference Mage %i and %i',num_mages(jj,1),num_mages(jj,2));
    bin_width = .75;
    plot_histograms(method,all_results,jj,name,bin_width,'correlated',lgd)
end
METHOD = repmat(method,length(comparison),1);

data = reshape([METHOD,COMPARISON,mX_min,mX_mean,mX_max,mX_Var]',1,[]);
fprintf('%s & %s & %.2f\\%% & %.2f\\%% & %.2f\\%% & %.4f\\%%^2 \\\\ \n',data);

T = table(METHOD,COMPARISON,mX_min,mX_mean,mX_max,mX_Var)
sheet = ['corr_w' num2str(wisdom) 'm' num2str(magic)];
writetable(T,'Results.xls','Sheet',sheet);

res(jj).T = T;
res(jj).mX_mean = mX_mean;

avg_time_ms = 1000*mean(all_times)';


