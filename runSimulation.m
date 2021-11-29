clear all
load_settings;

simulations = 200;
samples_per_simulation = 1000;


for ii = 1:length(mages)
    f = waitbar(0,['Simulation mage ' num2str(ii) '...'],'Name','Monte Carlo Simulation');

    wisdom = mages(ii).wisdom
    magic = mages(ii).magical_strength
    
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

    for nn = 1:simulations
        waitbar(nn/simulations,f,['Simulation mage ' num2str(ii) '...']);

        %% Simple Sampling
        rng(nn,'twister'); % Seed for random number generator
        tstart = tic;

        X = zeros(samples_per_simulation,1);
        for kk = 1:samples_per_simulation
            u = rand(29,1);
            variables = get_random_variable(u);
            portal_open = magic_portal(wisdom, magic, variables);
            X(kk) = portal_open;
        end

        mX_simplesampling(nn) = mean(X);
        time_simplesampling(nn) = toc(tstart);



        %% Complementary random numbers
        rng(nn,'twister'); % Seed for random number generator
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

        mX_complementary(nn) = mean(X);
        time_complementary(nn) = toc(tstart);
    



        %% Control Variant
        rng(nn,'twister'); % Seed for random number generator
        tstart = tic;

        % Find expectation result of the simplified model
        add_magical = 0.2635*wisdom -0.32732;
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

        mX_controlvariant(nn) = mean(X)-mean(X_simple) + mu_simple;
        time_controlvariant(nn) = toc(tstart);


        %% Importance Sampling
        rng(nn,'twister'); % Seed for random number generator
        tstart = tic;

        p_magic_add=0.15; % add to old prob
        
        X = zeros(samples_per_simulation,1);
        for kk = 1:samples_per_simulation
            u = rand(29,1);

            %Importance Sampeling
            p_magic_new = magic/100 + p_magic_add;
            [variables,w] = get_random_variable_imp_func2(u,magic,p_magic_new);
            portal_open = magic_portal(wisdom,magic,variables);
            X(kk) = portal_open*w;
        end

        mX_importance(nn) = mean(X);
        time_importance(nn) = toc(tstart);


        %% Stratified Sampeling
        rng(nn,'twister'); % Seed for random number generator
        tstart = tic;

        strata = ["A","B","C","D","E","F","G","H"]';
        strata_EX1 = ["A","C","F"]';
        strata_EX0 = ["B"]';
        strata_duo = ["D","E","G","H"]';

        % Take 10% of the samples for the pilot study
        samples_pilot = ceil(0.1*samples_per_simulation/length(strata_duo));

        StdX_pilot = zeros(length(strata_duo),1);
        strata_weigths = zeros(length(strata_duo),1);
        X_pilot = {};

        for jj = 1:length(strata_duo)
            stratum = strata_duo(jj);
            samples_stratum = samples_pilot;

            X = [];
            for kk = 1:samples_stratum
                u = rand(29,1);
                variables = get_stratum_variable(u,wisdom,magic,stratum);
                portal_open = magic_portal( wisdom, magic, variables);
                X = [X,portal_open];
            end
            X_pilot(nn) = {X};
            STDs_pilot(jj) = std(X);
            strata_weigths(jj) = get_stratum_weight(wisdom,magic,stratum);
        end

        % Calculate best sample allocation - Neyman allocation
        n_sample_best = samples_per_simulation*(STDs_pilot.*strata_weigths)/sum(STDs_pilot.*strata_weigths); 
        samples_left = samples_per_simulation-samples_pilot*length(strata_duo);

        add_samples_float = max(n_sample_best,samples_pilot)-samples_pilot;
        add_samples = round(add_samples_float/sum(add_samples_float)*samples_left);
        
        EX_strata = zeros(length(strata_duo),1);
        for jj = 1:length(strata_duo)
            stratum = strata_duo(jj);
            samples_stratum_add = add_samples(jj);

            X = [];
            for kk = 1:samples_stratum_add
                u = rand(29,1);
                variables = get_stratum_variable(u,wisdom,magic,stratum);
                portal_open = magic_portal(wisdom,magic,variables);
                X = [X,portal_open];
            end
            X = [X,X_pilot{nn}];
            EX_strata(jj) = mean(X);
        end
        % Get weight for strata with EX=1
        weigth_EX1 = 0;
        for stratum = strata_EX1'
            weigth_EX1 = weigth_EX1 + get_stratum_weight(wisdom,magic,stratum);
        end
            
        mX_stratified(nn) = sum(EX_strata.*strata_weigths)+1*weigth_EX1;
        time_stratified(nn) = toc(tstart);
    
    end % End simulation loop
    
    method = ["Simple Sampling";"Complementary Random Numbers";"Control Variant";"Importance Sampling";"Stratified Sampling"];
    
    all_times = [time_simplesampling,time_complementary,time_controlvariant,time_importance,time_stratified];
    avg_time_ms = 1000*mean(all_times)';
    
    all_results = 100*[mX_simplesampling,mX_complementary,mX_controlvariant,mX_importance,mX_stratified];
    mX_min = min(all_results)';
    mX_mean = mean(all_results)';
    mX_max = max(all_results)';
    Var = var(all_results)';
    Eff = avg_time_ms.*Var;
    
    data = reshape([method,avg_time_ms,mX_min,mX_mean,mX_max,Var,Eff]',1,[]);
    fprintf(sprintf('%s & %.2f ms & %.2f & %.2f & %.2f & %.4f & %.2f\\\\\\\\ \n',data));

    T = table(method,avg_time_ms,mX_min,mX_mean,mX_max,Var,Eff)
    sheet = ['w' num2str(wisdom) 'm' num2str(magic)];
    writetable(T,'Results.xls','Sheet',sheet);
    close(f)
end % End mage loop
