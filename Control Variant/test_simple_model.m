clear
samples = 100;

step = 1;
wisdoms = 1:step:100;
magics = 1:step:100;

f = waitbar(0,'Please wait...');

X = zeros(length(wisdoms),length(magics));
X_simple = zeros(length(wisdoms),length(magics));
error = zeros(length(wisdoms),length(magics));
for ii = 1:length(wisdoms)
    wisdom = wisdoms(ii);
    for jj = 1:length(magics)
        magic = magics(jj);
        open = zeros(1,samples);
        sopen = zeros(1,samples);
        for kk = 1:samples
            u = rand(29,1);
            variables = get_random_variable(u);
            % Simple Model
            portal_open= magic_portal( wisdom, magic, variables);
            sportal_open= magic_portal_simple( wisdom, magic, variables);
            open(1,kk) = portal_open;
            sopen(1,kk) = sportal_open;
        end
        X(ii,jj) = mean(open);
        X_simple(ii,jj) = mean(sopen);
        error(ii,jj) = sum(open~=sopen)/samples;
    end
    waitbar(ii/length(wisdoms),f,['wisdom = ' num2str(round(wisdom))]);
end
close(f)

fig = figure(1);clf

subplot(2,2,1)
surf(wisdoms,magics,error*100)
xlabel('Wisdom')
ylabel('Magical Strength')
ztickformat('percentage')
title('Error')

X_diff = X-X_simple;
subplot(2,2,2)
surf(wisdoms,magics,X_diff)
xlabel('Wisdom')
ylabel('Magical Strength')
title('Difference Means (Model-Simple)')

subplot(2,2,3)
surf(wisdoms,magics,X)
xlabel('Wisdom')
ylabel('Magical Strength')
title('Mean Model')

subplot(2,2,4)
surf(wisdoms,magics,X_simple)
xlabel('Wisdom')
ylabel('Magical Strength')
title('Mean simpified Model')