% load selected .mat file
data = load(join([path file]));
data = data.hdfdata;

%% Get data into matrix format

%Get start date
start_date = data.ES_hyperspectral_datetag(1);

% Get absolute time
% Assuming that the timetag is given at 1000 hertz
absolute_time_vec = data.LS_hyperspectral_timetag2/1000;

%Convert to relative time, i.e. time from start
origin_time = absolute_time_vec(1);
start_time = origin_time;

relative_time_vec = zeros(size(absolute_time_vec,1),1);
for ii = 1:length(relative_time_vec)
    
    % Hot fix for time weirdness in mat files
    % skips 40 seconds every 80 seconds
    % not needed in .dat files
    if ii == 1
        continue;
    elseif (absolute_time_vec(ii) - absolute_time_vec(ii-1)) > 1
        abnormal_diff = absolute_time_vec(ii) - absolute_time_vec(ii-1);
        origin_time = origin_time + abnormal_diff;
    end    
    
    % Get relative time
    relative_time_vec(ii) = absolute_time_vec(ii) - origin_time;
end

% Get ES
ES_label = str2num(cell2mat(data.ES_hyperspectral_fields));
ES_table = data.ES_hyperspectral_data;

% Get LS
LS_label = str2num(cell2mat(data.LS_hyperspectral_fields));
LS_table = data.LS_hyperspectral_data;

% Get Tilt
Tilt_label = ["tilt_1", "tilt_2"];

Tilt_table = [data.ABS_TILT_data, data.PRES_data];