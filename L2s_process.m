%% init
clc; close all; clear all;

% Filter Params
tilt_accept = 5.0; % All angles below (absolute value) will be kept
prc_values  = [20, 80]; % Percentile of ES and LS data to be kept
tilt_id     = 1; % Not useful

% Output Params
do_result_txt   = true;  % write .results file of derived products
do_plots        = false; % plot a compact figure with essential data
do_plots_png    = false; % print 4x png plots

% QAA Params
a_w_410  = 0.0162; % Absorption coefficient of pure seawater at 410 nm
a_w_440  = 0.0145; % Absorption coefficient of pure seawater at 440 nm
xi_Slope = 0.03;  % Slope of absorption coefficient for phtyoplankton pigments

%% Choose batch or single file processing
answer = questdlg('Choose processing method', ...
    'Processing Method', ...
    'Batch Processing','Single File', 'No');
% Handle response
switch answer
    case 'Batch Processing'
        is_batch = true;
    case 'Single File'
        is_batch = false;
    otherwise
        is_batch = -1;
end

%% Read L2s file
% Opens GUI to read .mat and .dat files
% .mat files read a lot faster
% Data is formatted in the same way for the next section
%
% data matrix is given in the following format
% full_xx = [relative_time_vec Tilt_table ES_table LS_table];
%       with time_range, tilt_range, ES_range, LS_range for ranges
%
% Outputs a text file for the results: filename.results

if is_batch == false
    [ file, path ] = uigetfile(...
        {'*L2s.mat;*.dat',...
        'L2s Files (*L2s.mat,*.dat)';}, ...
        'Select a L2s File');
elseif is_batch == true
    selpath = uigetdir("Select a folder which contains L2s.mat files");
    
    folder_contents = dir(selpath);
    folder_cell = {folder_contents.name};
    folder_str_array = convertCharsToStrings(folder_cell);
    file_ids = find(contains(folder_str_array, 'L2s.mat' ));
    
    file = folder_str_array(file_ids)';
    
    if ispc
        foldsep = "\";
    else
        foldsep = "/";
    end
    
    path = repmat(selpath+foldsep,[size(file_ids),1])';
else
    error("No valid processing method selected");
end


file_list_cell = {file, path};

for file_id = 1:size(file_list_cell{1},1)
    if is_batch
        file = convertStringsToChars(file_list_cell{1}(file_id));
        path = convertStringsToChars(file_list_cell{2}(file_id));
    end
    
    if file(end-3:end) == ".dat"
        L2s_process_dat;
    elseif file(end-3:end) == ".mat"
        L2s_process_mat;
    else
        disp("Wrong file type selected")
        f = msgbox('Wrong file type selected', 'Error','error');
    end
    
    %% Filtering script
    % Outputs:
    %   full_trimmed = [relative_time_vec Tilt_table ES_table LS_table];
    L2s_filtering;
    
    if isempty(full_trimmed)
        % Display warning and abort furthere processing of file
        warning(sprintf("%s had no valid entries after filtering",file));
        continue;
    end

    %% Get results file
    if do_result_txt
        generate_result_file;
    end
    
    %% Do compact plot
    if do_plots
        plot_results_compact;
    end
    
    %% Do png plot
    if do_plots_png
        plot_results_png;
    end
        
end

