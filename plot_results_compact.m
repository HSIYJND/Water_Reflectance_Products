%% Plotting

fig = figure('Position', [0, 0 1900, 1000]);

% Plot boxplot ES
subplot(4,1,1);
grid on;
ES_boxplot = ...
    boxplot(full_trimmed(:,ES_range), 'PlotStyle', 'compact',...
    'Labels',num2cell(ES_label));
xlabel('Wavelength (nm)');
ylabel('uW/cm^2/nm');
title(sprintf("Boxplot ES - %s %s",...
    num2str(start_date),... 
    num2str(start_time)));

pause(1) % because MATLAB sucks

% Plot boxplot LS
subplot(4,1,2);
grid on;
LS_boxplot = ...
    boxplot(full_trimmed(:,LS_range), 'PlotStyle', 'compact',...
    'Labels',num2cell(LS_label));
xlabel('Wavelength (nm)');
ylabel('uW/cm^2/nm/sr');
title(sprintf("Boxplot LW - %s %s",...
    num2str(start_date),... 
    num2str(start_time)));

pause(1) % because MATLAB sucks

Rrs_data = full_trimmed(:,LS_range)./full_trimmed(:,ES_range);
Rrs_label = (ES_label+LS_label)/2;

Rrs_median = median(Rrs_data);

% Plot boxplot Rrs
subplot(4,1,3);
grid on;
Rrs_boxplot = ...
    boxplot(full_trimmed(:,LS_range)./full_trimmed(:,ES_range),...
    'PlotStyle', 'compact',...
    'Labels',num2cell(LS_label));
xlabel('Wavelength (nm)');
ylabel('uW/cm^2/nm/sr');
title(sprintf("Boxplot Rrs - %s %s",...
    num2str(start_date),... 
    num2str(start_time)));

% Convert from above- to below-surface remote sensing reflectance
%   rrs(lambda) -> Rrs2rrs(Rrs_lambda)
Rrs2rrs = @(Rrs_lambda)...
    Rrs_lambda/(0.52 + 1.7*Rrs_lambda);

rrs_median = Rrs_median;
for R2r_id = 1:length(rrs_median)
    rrs_median(R2r_id) = Rrs2rrs(Rrs_median(R2r_id));
end

pause(1) % because MATLAB sucks

% Plot boxplot rrs
subplot(4,1,4);
grid on;
Rrs_boxplot = ...
    boxplot(full_trimmed(:,LS_range)./full_trimmed(:,ES_range),...
    'PlotStyle', 'compact',...
    'Labels',num2cell(LS_label));
xlabel('Wavelength (nm)');
ylabel('uW/cm^2/nm/sr');
title(sprintf("Boxplot rrs - %s %s",...
    num2str(start_date),... 
    num2str(start_time)));

pause(1)

saveas(fig, join([file(1:end-4) '.fig']))
% saveas(gcf, eps_res,'epsc')

