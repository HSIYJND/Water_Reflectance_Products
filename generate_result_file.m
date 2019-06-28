%% Result Preamble
Result_text = sprintf("RESULTS FOR %s\n\n",file);

Result_text = Result_text+...
    sprintf("Removing absolute tilt angles above %d degrees\n", tilt_accept);
Result_text = Result_text+...
    sprintf("Keeping percentile %d to %d post tilt correction", ...
        prc_values(1), prc_values(2));

Result_text = Result_text + sprintf("\n\n\n");
Result_text = Result_text+...
    sprintf("Number of samples initially:                %d \n",size(full,1));
Result_text = Result_text+...
    sprintf("Number of samples after tilt correction:    %d\n",...
        size(full_corrected,1));
Result_text = Result_text+...
    sprintf("Number of samples after outlier removal:    %d\n\n\n",...
        size(full_trimmed,1));

Rrs_data = full_trimmed(:,LS_range)./full_trimmed(:,ES_range);
Rrs_label = (ES_label+LS_label)/2;

%% Median Calculations
Result_text = Result_text+sprintf("MEDIAN VALUES\n");
% ES values
ES_median = median(full_trimmed(:,ES_range));
ES_max_median = max(ES_median);
ES_max_median_wl = ES_label(find(ES_median == max(ES_median)));

Result_text = Result_text+...
    sprintf("Max ES median value:       %.3d at %.2fnm \n",...
        ES_max_median, ES_max_median_wl);

% LS Values
LS_median = median(full_trimmed(:,LS_range));
LS_max_median = max(LS_median);
LS_max_median_wl = LS_label(find(LS_median == max(LS_median)));

Result_text = Result_text+...
    sprintf("Max LW median value:       %.3d at %.2fnm \n",...
        LS_max_median, LS_max_median_wl);

% Rrs Values
Rrs_median = median(Rrs_data);
Rrs_max_median = max(Rrs_median);
Rrs_max_median_wl = Rrs_label(Rrs_median == max(Rrs_median));

Result_text = Result_text+...
    sprintf("Max Rrs median value:      %.3d at %.2fnm \n",...
        Rrs_max_median, Rrs_max_median_wl);

    
%% Variance calculations
Result_text = Result_text+sprintf("\nVARIANCE VALUES\n");
% ES values
ES_var = var(full_trimmed(:,ES_range));
ES_max_var = max(ES_var);
ES_max_var_wl = ES_label(find(ES_var == max(ES_var)));

Result_text = Result_text+...
    sprintf("Max ES variance value:     %.3d at %.2fnm \n",...
        ES_max_var, ES_max_var_wl);

% LS Values
LS_var = var(full_trimmed(:,LS_range));
LS_max_var = max(LS_var);
LS_max_var_wl = LS_label(find(LS_var == max(LS_var)));

Result_text = Result_text+...
    sprintf("Max LW variance value:     %.3d at %.2fnm \n",...
        LS_max_var, LS_max_var_wl);

% Rrs Values
Rrs_var = var(Rrs_data);
Rrs_max_var = max(Rrs_var);
Rrs_max_var_wl = Rrs_label(Rrs_var == max(Rrs_var));

Result_text = Result_text+...
    sprintf("Max Rrs variance value:    %.3d at %.2fnm \n\n\n",...
        Rrs_max_var, Rrs_max_var_wl);
    
%% Calculate whitecaps statistics
NIR_calculation;

%% Calculate Chlor_a Based on OC4
OC4_calculations;

%% Calculate QA based on Lee et. al. 2002
QAA_calculations;

%% Store to .results file
file_res = join([file(1:end-4) '.results']);

fid = fopen(file_res,'w');
fwrite(fid,Result_text);
fclose(fid);

%% Store to CSV file

% Computing total absoroption
% Needs QAA to be performed
a_tot = zeros(length(LS_label),1);

for wl = 1:length(LS_label)
    [~, rrs_wl_id] = min(abs(Rrs_label-LS_label(wl))); 
    rrs_wl = Rrs_median(rrs_wl_id);
    
    a_lambda(rrs_wl,LS_label(wl));
    a_tot(wl) = a_lambda(rrs_wl,LS_label(wl));
end

T = table(LS_label,... 
    ES_median', ES_var',... 
    LS_median', LS_var',... 
    Rrs_median', Rrs_var',...
    a_tot,...
    'VariableNames',...
    {'Wavelength_nm',... 
    'ES_Value', 'ES_CV'...
    'LS_Value', 'LS_CV'...
    'Rrs_Value', 'Rrs_CV',...
    'a_total'});

writetable(T, join([file(1:end-4) '.csv']))
