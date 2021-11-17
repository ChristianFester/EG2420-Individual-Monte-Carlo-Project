clear
global print
print = 0;

f = waitbar(0,'Please wait...');



% Test different wisdoms
step = 0.1;
samples = 200;
wisdoms_test = 0:step:100;


magics = zeros(length(wisdoms_test),samples);
wisdoms = zeros(length(wisdoms_test),samples);
for ii = 1:length(wisdoms_test)
    wisdom = wisdoms_test(ii);
    waitbar(wisdom/wisdoms_test(end),f,['wisdom = ' num2str(round(wisdom))]);
    
    for kk = 1:samples
        u = rand(29,1);
        variables = get_random_variable(u);
        % Simple Model
        [portal_open,m,w]= magic_portal( wisdom, 0, variables);
        magics(ii,kk) = m;
        wisdoms(ii,kk) = (w-wisdom);
    end
%     results_m = [results_m, magics/samples];
%     results_w = [results_w, wisdoms/samples];
end
close(f)
results_m = mean(magics,2);

results_w = mean(wisdoms,2);

P_magical = polyfit(wisdoms_test,results_m,1);
P_wisdom = polyfit(wisdoms_test,results_w,1);

fig = figure(1); clf
hold on
scatter(wisdoms_test,results_m,'DisplayName','Add. Magic')
scatter(wisdoms_test,results_w,'DisplayName','Add. Wisdom')
syms x
magical_fit(x) = P_magical(1)*x+P_magical(2);
wisdom_fit(x) = P_wisdom(1)*x+P_wisdom(2);
hold on;

fplot(magical_fit,'r-.','LineWidth',2,'DisplayName','Fit magical');
fplot(wisdom_fit,'b-.','LineWidth',2,'DisplayName','Fit wisdom');
legend('Location','northwest')
xlim([0,100])

figure(2); clf
n = ceil(length(wisdoms_test)/50);
magic_boxplot = magics(1:n:end,:)';
labels = wisdoms_test(1:n:end)';
boxplot(magic_boxplot,labels,'PlotStyle','compact','OutlierSize',1,'Symbol','.')

fprintf(['y(x) = ' num2str(P_magical(1)) '*x + ' num2str(P_magical(2)) '\n']);

% polynominal_magical_fit = P_magical;
% save('ployfit_magical.mat','polynominal_magical_fit');
