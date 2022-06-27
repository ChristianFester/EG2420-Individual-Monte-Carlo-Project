function [mX,time,std0] = stratified_sampling_fast(magic,wisdom,n_total,percent_pilot,show_results)
std0 = 0;

s = struct;
% s.strata = ["A","B","C","D","E","F","G","H"]';
s.strata = 1:8;
% s.strata_EX1 = ["A","C","F"]';
s.strata_EX1 = [1,3,6]';
% s.strata_EX0 = ["B"]';
s.strata_EX0 = [2];
% s.strata_duo = ["D","E","G","H"]';
s.strata_duo = [4,5,7,8]';
strata_duo = s.strata_duo;

n_pilot_total = percent_pilot*n_total;

% Take strata_pilot% of the samples for the pilot study
n_pilot_stratum = ceil(n_pilot_total/length(strata_duo));

%% Strata Weights
% Get the Strata weights of the duogeneous strata
strata_weigths = zeros(length(strata_duo),1);
for jj = 1:length(strata_duo)
    stratum = strata_duo(jj);
    strata_weigths(jj) = get_stratum_weight_fast(wisdom,magic,stratum);
end

% Get weight for strata with EX=1
weigths_EX1 = zeros(1,length(s.strata_EX1));
for jj = 1:length(s.strata_EX1)
    stratum = s.strata_EX1(jj);
    weigths_EX1(jj) = get_stratum_weight_fast(wisdom,magic,stratum);
end

% Get weight for strata with EX=0
weigths_EX0 = zeros(1,length(s.strata_EX0));
for jj = 1:length(s.strata_EX0)
    stratum = s.strata_EX0(jj);
    weigths_EX0(jj) = get_stratum_weight_fast(wisdom,magic,stratum);
end

%% Start time
tstart = tic;
%% Pilot Study
STDs_pilot = zeros(length(strata_duo),1);
X_pilot = cell(1,length(strata_duo));

for jj = 1:length(strata_duo)
    stratum = strata_duo(jj);

    [X] = sampling_stratum(n_pilot_stratum,wisdom,magic,stratum);
    X_pilot(jj) = {X};
    STDs_pilot(jj) = std(X);
end
STDs = STDs_pilot;

% Used Samples
n_used = n_pilot_stratum*ones(1,length(strata_duo));


%% Sampling of the rest with reallocation every n_pilot_total samples
X_total = X_pilot;
while sum(n_used) < n_total

    % Next sample size (either +n_pilot_total or untill max)
    if sum(n_used)+n_pilot_total < n_total
        n_total_step = sum(n_used)+n_pilot_total;
    else
        n_total_step = n_total;
    end

    %The Newman allocation should be repeated every n_pilot samples
    [add_samples] = newman_allocation(n_total_step,n_used,STDs,strata_weigths);


    EX_strata = zeros(length(strata_duo),1);
    for jj = 1:length(strata_duo)
        stratum = strata_duo(jj);
        n_stratum_add = add_samples(jj);
        
        % Stratum Sampling
        [X] = sampling_stratum(n_stratum_add,wisdom,magic,stratum);
        
        % Collect all Samples
        X_total{jj} = [X_total{jj}, X];
        
        % Udate standart deviation and numbers of used samples 
        STDs(jj) = std(X_total{jj});
        n_used(jj) = n_used(jj) + n_stratum_add;
    end
end

% Get Final mean of the results
for jj = 1:length(strata_duo)
    EX_strata(jj) = mean(X_total{jj});
end


%% Final Mean
mX = sum(EX_strata.*strata_weigths)+1*sum(weigths_EX1)+0*sum(weigths_EX0);
time = toc(tstart);

% Display warning if pilot study didnt detect the duogenousity
if any(STDs_pilot==0)
    warning('STD = 0 for duoginouse strata! Please choose higher samplenumber for the Pilotstudy.')
    std0 = 1;
end

end

%% SAMPLING
function [X] = sampling_stratum(n_sampeling,wisdom,magic,stratum)
X = zeros(1,n_sampeling);
for kk = 1:n_sampeling
    u = rand(29,1);
    variables = get_stratum_variable_fast(u,wisdom,magic,stratum);
    portal_open = magic_portal( wisdom, magic, variables);
    X(kk) = portal_open;
end
end

%% NEWMAN ALLOCATION
function [add_samples] = newman_allocation(nn,n_used,STDs,weights)
% n_used, STDs and weight are VECTORS!!
% Calculate best sample allocation - Neyman allocation
n_sample_best = nn*(STDs.*weights)/sum(STDs.*weights);
samples_left = nn-sum(n_used);

% Zero if samples are already over perfect allocation
add_samples_float = max(n_sample_best,n_used)-n_used;

%Get integers in proportion to the best allocation, close to the left samples
add_samples = round(add_samples_float/sum(add_samples_float)*samples_left);
end