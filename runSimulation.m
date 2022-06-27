clear all
addpath 'Complementary Random Numbers'\
addpath 'Control Variant'\
addpath 'Importance Sampeling'\
addpath 'Simpel Sampeling'\
addpath 'Stratified Sampeling'\
addpath 'Stratified Sampeling'\'Fast'\
load_settings;

simulations = 100;
samples_per_simulation = 1200;
%Share of samples used for the pilot study
strata_pilot = 0.34; 

%% 
res = struct;
for ii = 1:length(mages)
    f = waitbar(0,['Simulation mage ' num2str(ii) '...'],'Name','Monte Carlo Simulation');

    wisdom = mages(ii).wisdom;
    magic = mages(ii).magical_strength;
    fprintf('Mage %i: %i Wisdom and %i Magical Strength',ii,wisdom,magic)

    % Vectors to save results
    % Estimated mean
    mX_simplesampling = zeros(simulations,1);
    mX_complementary = zeros(simulations,1);
    mX_controlvariant = zeros(simulations,1);
    mX_importance = zeros(simulations,1);
    mX_stratified = zeros(simulations,1);

    % Simulation Time
    time_simplesampling = zeros(simulations,1);
    time_complementary = zeros(simulations,1);
    time_controlvariant = zeros(simulations,1);
    time_importance = zeros(simulations,1);
    time_stratified = zeros(simulations,1);
    
    std0s =0;
    for nn = 1:simulations
        idx_rnd = (ii-1)*simulations+nn;
        waitbar(nn/simulations,f,['Simulation mage ' num2str(ii) '...']);

        %% Simple Sampling
        rng(idx_rnd,'twister'); % Seed for random number generator
                
        [mX,time] = simplesampling(magic,wisdom,samples_per_simulation);

        mX_simplesampling(nn) = mX;
        time_simplesampling(nn) = time;


        %% Complementary random numbers
        rng(idx_rnd,'twister'); % Seed for random number generator
        
        [mX,time] = complementary_numbers(magic,wisdom,samples_per_simulation);

        mX_complementary(nn) = mX;
        time_complementary(nn) = time;


        %% Control Variant
        rng(idx_rnd,'twister'); % Seed for random number generator
        
        [mX,time] = control_variant(magic,wisdom,samples_per_simulation);

        mX_controlvariant(nn) = mX;
        time_controlvariant(nn) = time;


        %% Importance Sampling
        rng(idx_rnd,'twister'); % Seed for random number generator
        
        [mX,time] = importance_sampling(magic,wisdom,samples_per_simulation);
        
        mX_importance(nn) = mX;
        time_importance(nn) = time;


        %% Stratified Sampeling
        rng(idx_rnd,'twister'); % Seed for random number generator
        
        [mX,time,std0] = stratified_sampling_fast(magic,wisdom,samples_per_simulation,strata_pilot,false);

        mX_stratified(nn) = mX;
        time_stratified(nn) = time;
        std0s = std0s + std0;
    
    end % End simulation loop
    fprintf('Mage %i had %i STD=0 after the pilot study.\n',ii,std0s)
    % Save the results
    res(ii).all_times = [time_simplesampling,time_complementary,time_controlvariant,time_importance,time_stratified];
    res(ii).all_results = 100*[mX_simplesampling,mX_complementary,mX_controlvariant,mX_importance,mX_stratified];
    
    close(f)
end % End mage loop

%% Analyse of the results
time_pre_cv = 1.6369*1000/3;
method = [
    "Simple Sampling";
    "Complementary Numbers";
    "Control Variant";
    "Importance Sampling";
    "Stratified Sampling"];

lgd = struct;
lgd.first = 'northeast';
lgd.second = 'none';

for ii = 1:length(mages)
    all_results = res(ii).all_results;
    all_times = res(ii).all_times;

    avg_time_ms = 1000*mean(all_times)';
    % ADD time of precalculation to
    avg_time_ms(3) = avg_time_ms(3)+time_pre_cv/simulations;
    mX_min      = min(all_results)';
    mX_mean     = mean(all_results)';
    mX_max      = max(all_results)';
    mX_Var      = var(all_results)';
    Eff         = avg_time_ms.*mX_Var;
    
    name = sprintf('Mage %i',ii);
    bin_width = .6;
    plot_histograms(method,all_results,ii,name,bin_width,'normal',lgd)

    data = reshape([method,avg_time_ms,mX_min,mX_mean,mX_max,mX_Var,Eff]',1,[]);
    fprintf('%s & %.2f ms & %.2f%% & %.2f%% & %.2f%% & %.4f & %.2f\\\\ \n',data);

    T = table(method,avg_time_ms,mX_min,mX_mean,mX_max,mX_Var,Eff)
    sheet = ['w' num2str(wisdom) 'm' num2str(magic)];
    writetable(T,'Results.xls','Sheet',sheet);
    res(ii).T = T;
end

%% Comparison between mages
% % To compare these with the results of correlated sampling
% meanX12 = res(2).T.mX_mean - res(1).T.mX_mean;
% meanX13 = res(3).T.mX_mean - res(1).T.mX_mean; 
% meanX23 = res(3).T.mX_mean - res(2).T.mX_mean;
% 
% %% MAGE Difference with corelated sampling
% 
% mX12_cs = zeros(simulations,1);
% mX13_cs = zeros(simulations,1);
% mX23_cs = zeros(simulations,1);
% mX_stratified = zeros(simulations,1);
% time_correlatedsampling = zeros(simulations,1);
% 
% for nn = 1:simulations
%     rng(nn,'twister'); % Seed for random number generator
%     tstart = tic;
% 
%     X12 = zeros(samples_per_simulation,1);
%     X13 = zeros(samples_per_simulation,1);
%     X23 = zeros(samples_per_simulation,1);
%     for kk = 1:samples_per_simulation
%         u = rand(29,1);
%         variables = get_random_variable(u);
% 
%         portal_open_mage = zeros(1,length(mages));
%         for ii = 1:length(mages)
%             wisdom = mages(ii).wisdom;
%             magic = mages(ii).magical_strength;
% 
%             portal_open_mage(ii) = magic_portal(wisdom, magic, variables);
%         end
%         X12(kk) = portal_open_mage(2)-portal_open_mage(1);
%         X13(kk) = portal_open_mage(3)-portal_open_mage(1);
%         X23(kk) = portal_open_mage(3)-portal_open_mage(2);
%     end
% 
%     mX12_cs(nn) = mean(X12);
%     mX13_cs(nn) = mean(X13);
%     mX23_cs(nn) = mean(X23);
%     time_correlatedsampling(nn) = toc(tstart);
% end
% all_results = [mX12_cs,mX13_cs,mX23_cs];
% avg_time_ms = 1000*mean(time_correlatedsampling);
% 
% mX_min = min(all_results)'*100;
% mX_mean = mean(all_results)'*100;
% mX_max = max(all_results)'*100;
% mX_Var = var(all_results*100)';
% 
% Eff = avg_time_ms*mean(mX_Var)/3;
% 
% comparison = ["X2-X1","X3-X1","X3-X2"]';
% table(comparison,mX_min,mX_mean,mX_max,mX_Var)
% % data = reshape([comparison,mX_min,mX_mean,mX_max,Var,Eff]',1,[]);
% % fprintf('%s & %.2f & %.2f & %.2f & %.4f & %.2f\\\\\\\\ \n',data);
% 
% 
% fprintf('Avg. Time: %.2f ms\n',avg_time_ms)
% fprintf('Mean Variance: %.2f ms\n',mean(mX_Var))
% fprintf('Efficiency: %.2f ms\n',Eff)
% 
% method(end+1) = "Correlated Sampling";
% meanX12(end+1) = mX_mean(1);
% meanX13(end+1) = mX_mean(2);
% meanX23(end+1) = mX_mean(3);
% 
% T = table(method,meanX12,meanX13,meanX23)
