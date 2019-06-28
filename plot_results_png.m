%% Plotting

figure_sizes = [0, 0 1900, 1000];

% Plot boxplot ES
fig = figure('Position',figure_sizes);
ES_boxplot = ...
    boxplot(full_trimmed(:,ES_range), 'PlotStyle', 'compact',...
    'Labels',num2cell(ES_label));
xlabel('Wavelength (nm)');
ylabel('uW/cm^2/nm');
title(sprintf("Boxplot ES - %s %s",...
    num2str(start_date),... 
    num2str(start_time)));
grid on;
saveas(fig, join([file(1:end-4), '_ES']), 'png')

pause(1) % because MATLAB sucks

% Plot boxplot LS
fig = figure('Position',figure_sizes);
LS_boxplot = ...
    boxplot(full_trimmed(:,LS_range), 'PlotStyle', 'compact',...
    'Labels',num2cell(LS_label));
xlabel('Wavelength (nm)');
ylabel('uW/cm^2/nm/sr');
title(sprintf("Boxplot LW - %s %s",...
    num2str(start_date),... 
    num2str(start_time)));
grid on;
pause(1) % because MATLAB sucks
saveas(fig, join([file(1:end-4), '_LW']), 'png')

% Plot boxplot Rrs
fig = figure('Position',figure_sizes);
Rrs_boxplot = ...
    boxplot(full_trimmed(:,LS_range)./full_trimmed(:,ES_range),...
    'PlotStyle', 'compact',...
    'Labels',num2cell(LS_label));
xlabel('Wavelength (nm)');
ylabel('uW/cm^2/nm/sr');
title(sprintf("Boxplot Above Surface Reflectance - %s %s",...
    num2str(start_date),... 
    num2str(start_time)));
grid on;
pause(1)
saveas(fig, join([file(1:end-4), '_Rrs']), 'png')

%Plot before and after qunatile correction
fig = figure('Position',figure_sizes);

subplot(121); plot(LS_label, full_corrected(:,LS_range));
xlabel('Wavelength (nm)');
ylabel('uW/cm^2/nm/sr');
title(sprintf("Lw Before Quantile filtering - %s %s",...
    num2str(start_date),... 
    num2str(start_time)));
grid on;

subplot(122); plot(LS_label, full_trimmed(:,LS_range)); 
xlabel('Wavelength (nm)');
ylabel('uW/cm^2/nm/sr');
title(sprintf("Lw After Quantile filtering - %s %s",...
    num2str(start_date),... 
    num2str(start_time)));
grid on;

pause(1)
saveas(fig, join([file(1:end-4), '_BnA']), 'png')

