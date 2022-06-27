function [] = plot_histograms(method,all_results,ii,name,bin_width,folder,lgd)
%%
n_column = ceil((length(method)+2)/2);

mX_mean = mean(all_results)';
mX_Var = var(all_results)';

c = colororder;

fig = figure(ii);clf
fig.Units = 'normalized';
fig.OuterPosition = [0 0.0398 n_column/4 0.9602];   
fig.WindowState = 'normal';
% fig.WindowState = 'maximized';

x1 = floor(min(min(all_results)));
x2 = ceil(max(max(all_results)));
x = x1:.05:x2;
y = zeros(length(method),length(x));
for mm = 1:length(method)
    mXs = all_results(:,mm);
    meanX = mX_mean(mm);
    varX = mX_Var(mm);

    subplot(2,n_column,mm)
    hold on
    h = histogram(mXs,'DisplayName','Results');
    if ~isinf(bin_width)
        h.BinWidth = bin_width;
    end
    bin_width = h.BinWidth;

    y(mm,:) = normpdf(x,meanX,sqrt(varX));%*length(mXs)
    plot(x,y(mm,:)*length(mXs)*bin_width,'LineWidth',1.5,'DisplayName','Normal Fit','Color',c(mm,:))

    xtickformat('percentage')
    xlabel('Chance of Winning')
    xlim([x1,x2])
    title(sprintf('%s',method(mm)))
    xm = (x1+x2)/2;
%     if meanX < xm+1
%         legend(Location='northwest')
%     else
%         legend(Location='northeast')
%     end
    grid on
end
sgtitle(['Distributions - ' name])

% fig4 = figure(4);
subplot(2,n_column,mm+1)
hold on
plot(x,y,'LineWidth',1.5)
xtickformat('percentage')
xlabel('Chance of Winning')
title('Comparison')
lg_txt = replace(method,{' Sampling',' Numbers'},'');
if lgd.second ~= 'none'
    legend(lg_txt,'Location',lgd.second,'AutoUpdate','off')
end
xlim([x1,x2])
grid on
saveas(fig,['..\figures\Distributions1_' strrep(name,' ','_') '.png'])

subplot(2,n_column,mm+2),cla reset
lg_txt = replace(method,{' Sampling',' Numbers'},'');
boxplot(all_results,lg_txt)
ytickformat('percentage')
ylabel('Chance of Winning')
title('Comparison')
grid on

if ~exist(['..\figures\' folder] ,'dir')
    mkdir(['..\figures\' folder]);
end
saveas(fig,['..\figures\' folder '\Distributions2_' strrep(name,' ','_') '.png'])
end